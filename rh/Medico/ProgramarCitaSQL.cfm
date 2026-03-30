
<cfparam name="form.DEid">
<cfparam name="form.empresa">



<cfparam name="form.fecha" default="#DateFormat(Now(), 'DD/MM/YYYY')#">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', form.fecha) is 0>
	<cfset form.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
</cfif>

<cfquery datasource="#session.dsn#" name="empleado">
	select de.DEidentificacion as cedula,  {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,
		e.EcodigoSDC
	from DatosEmpleado de
		join Empresas e
			on de.Ecodigo = e.Ecodigo
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.empresa#">
	  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfif empleado.RecordCount is 0>
	<cf_errorCode	code="51914" msg="El empleado no existe">
</cfif>

<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />

<cfset emp_ref = sec.getUsuarioByRef(form.DEid, empleado.EcodigoSDC, 'DatosEmpleado' )>

<cfif emp_ref.RecordCount is 0>
	<cf_errorCode	code="51915" msg="El empleado @errorDat_1@/@errorDat_2@ no está relacionado como usuario"
					errorDat_1="#empleado.EcodigoSDC#"
					errorDat_2="#form.DEid#"
	>
</cfif>

<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgendaPersonal = ComponenteAgenda.AgendaDeUsuario(emp_ref.Usucodigo)>
<cfset CitasParaHoy = ComponenteAgenda.ListarCitas(CodigoAgendaPersonal, LSParseDateTime(form.fecha))>
<cfset Disponible = ComponenteAgenda.TiempoLibre(form.agenda, 
					LSParseDateTime(form.fecha)).Fragment(30).getQuery()>

<cfif ListLen(form.cita) Neq 2>
	<cf_errorCode	code="51916" msg="Ha seleccionado un horario inválido">
</cfif>

<cfset desde=ListGetAt(form.cita,1)>
<cfset hasta=ListGetAt(form.cita,2)>
<cfif Len(desde) is 3><cfset desde='0'&desde></cfif>
<cfif Len(hasta) is 3><cfset hasta='0'&hasta></cfif>
<cfset fecha=LSParseDateTime(form.fecha)>
<cfset desde=CreateDateTime(Year(fecha), Month(fecha), Day(fecha), Val(Mid(desde,1,2)), Val(Mid(desde,3,2)),0)>
<cfset hasta=CreateDateTime(Year(fecha), Month(fecha), Day(fecha), Val(Mid(hasta,1,2)), Val(Mid(hasta,3,2)),0)>

<cfif desde LT Now()>
	<cfset form.desde = desde><cfset form.now = now()>
	<cf_errorCode	code="51917" msg="No es posible programar una cita hacia atrás">
</cfif>

<cftransaction>
	<cfset cita = ComponenteAgenda.NuevaCita (
		form.agenda & "," & CodigoAgendaPersonal,
		CodigoAgendaPersonal, form.agenda & "," & CodigoAgendaPersonal,
		desde, hasta, "Cita medica " & empleado.nombre & "<br>" &
			 empleado.cedula,
		"", "rh:cita-medica", #empleado.EcodigoSDC# & ',' & #form.DEid#)>

	<!---Enviar correo--->
	<cfset CodigoAgenda = ComponenteAgenda.AgendaDeUsuario(emp_ref.Usucodigo)>
	<cfset info = ComponenteAgenda.InfoCita(CodigoAgenda, cita)>

	<cfquery name="remitente" datasource="asp">
		select Pvalor
		from <cf_dbdatabase datasource="#session.dsn#" table="RHParametros">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.empresa#">
		and Pcodigo = 190
	</cfquery>
	
	<cfquery name="destinatario" datasource="asp">
		select DEemail,
		{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
		from <cf_dbdatabase datasource="#session.dsn#" table="DatosEmpleado">
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
		
</cftransaction>

<cfset cuerpo =  '
	<table align=center cellspacing=0 style="border:thin;border-color:gray;border-style:solid;">
	<tr >
    	<td colspan=2>&nbsp;</td>
  	</tr>
  	<tr >
    	<td colspan=2>&nbsp;</td>
  	</tr>
  	<tr valign="top" bgcolor=lightblue>
    	<td>Asunto</td>
    	<td>Cita para #destinatario.nombre#</td>
  	</tr>
  	<tr >
    	<td colspan=2>&nbsp;</td>
  	</tr>
  	<tr style="background-color:999999">
    	<td colspan=2>Usted tiene una cita en el Consultorio Médico el día:</td>
  	</tr>
  	<tr style="background-color:CCCCCC">
    	<td width="132">Fecha</td>
    	<td width="296">#DateFormat(info.fecha,'DD/MM/YYYY')#</td>
  	</tr>
  	<tr valign="top">
    	<td>Inicio:</td>
    	<td>#TimeFormat(info.inicio,'HH:MM')#</td>
  	</tr>
  	<tr valign="top">
    	<td>Fin:</td>
    	<td>#TimeFormat(info.final,'HH:MM')#</td>
  	</tr>
  	<tr valign="top">
    	<td>&nbsp;</td>
    	<td>&nbsp;</td>
  	</tr>
	</table>'>

		<cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#remitente.Pvalor#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#destinatario.DEemail#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Cita Médica">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuerpo#">, 1)
		</cfquery>


<!---Fin de correo--->
<cfif !isDefined("LvarErpMobile")><!--- siempre y cuando no venga del app----->
	<cflocation url="ProgramarCitaGracias.cfm?cita=#cita#&usuario=#emp_ref.Usucodigo#&empresa=#form.empresa#&DEid=#form.DEid#">	
</cfif>
	


