<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfparam name="form.fecha">
<cfparam name="form.cita" type="numeric">
<cfparam name="form.e" default="1">
<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">

<cfif form.e>
<!--- <cfset ComponenteAgenda.ConfirmarCita(CodigoAgendaMedica, form.cita, false)> --->
	<cfset ComponenteAgenda.EliminarCita(CodigoAgendaMedica, form.cita)>
<cfelse>
	<cfset ComponenteAgenda.RestaurarCita(CodigoAgendaMedica, form.cita)>
	<cfset ComponenteAgenda.ConfirmarCita(CodigoAgendaMedica, form.cita, true)>
</cfif>


<!---Enviar correo--->

		<cfquery name="remitente" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			and Pcodigo = 190
		</cfquery>
		
		<cfquery name="destinatario" datasource="#session.DSN#">
			select DEemail,
			{fn concat({fn concat({fn concat({fn concat(DEnombre , ' ' )}, DEapellido1 )}, ' ' )}, DEapellido2 )} as nombre
			from DatosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>

	   <cfquery name="CitaMedica" datasource="asp">     
			Select inicio, final from ORGCita
			where cita     = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.cita#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.CEcodigo#">
		</cfquery>


       
        
<cfif form.e>
	<cfset mensaje = "La cita que usted tenía, en el Consultorio Médico, fue cancelada.">
    <cfset subject = "Cancelación de Cita Médica día: #form.fecha#  <BR> Inicio:#timeformat(CitaMedica.inicio,'hh:mm tt')# <BR> Fin: #timeformat(CitaMedica.final,'hh:mm tt')#">
	<cfset color = "999999">
<cfelse>
	<cfset mensaje = "La cita, con el Consultorio Médico, ha sido Confirmada.">
    <cfset subject = "Confirmación de Cita Médica día: #form.fecha#  <BR> Inicio:#timeformat(CitaMedica.inicio,'hh:mm tt')# <BR> Fin: #timeformat(CitaMedica.final,'hh:mm tt')#">
	<cfset color = "yellow">
</cfif>


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
			<td>#subject#</td>
		</tr>
		<tr >
			<td colspan=2>&nbsp;</td>
		</tr>
		<tr style="background-color:#color#">
			<td colspan=2>#mensaje#</td>
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
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Agenda Médica">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuerpo#">, 1)
		</cfquery>


<!---Fin de correo--->


<cflocation url="Consultorio.cfm?fecha=#URLEncodedFormat(form.fecha)#">
