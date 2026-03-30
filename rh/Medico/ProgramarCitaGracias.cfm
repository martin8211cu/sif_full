<cfparam name="url.DEid">
<cfparam name="url.empresa">
<cfparam name="url.cita">

<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
</cfinvoke>


<cfquery datasource="#session.dsn#" name="empleado">
	select de.DEidentificacion as cedula,  {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,
		e.EcodigoSDC
	from DatosEmpleado de
		join Empresas e
			on de.Ecodigo = e.Ecodigo
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.empresa#">
	  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
</cfquery>

<cfif empleado.RecordCount is 0>
	<cf_errorCode	code="51914" msg="El empleado no existe">
</cfif>

<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />

<cfset emp_ref = sec.getUsuarioByRef(url.DEid, empleado.EcodigoSDC, 'DatosEmpleado' )>

<cfif emp_ref.RecordCount is 0>
	<cf_errorCode	code="51915" msg="El empleado @errorDat_1@/@errorDat_2@ no está relacionado como usuario"
					errorDat_1="#empleado.EcodigoSDC#"
					errorDat_2="#url.DEid#"
	>
</cfif>

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgenda = ComponenteAgenda.AgendaDeUsuario(emp_ref.Usucodigo)>
<cfset info = ComponenteAgenda.InfoCita(CodigoAgenda, url.cita)>

<cf_template>
<cf_templatearea name="body">

<cf_web_portlet_start titulo="Mi agenda">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cfoutput>
  <div class="tituloListas">Cita m&eacute;dica realizada</div>
  <br></cfoutput>
  
<cfoutput>
<form name="form1" method="get" action="Consultorio.cfm">
<input type="hidden" name="fecha" value="#LSDateFormat(info.fecha,'DD/MM/YYYY')#">
<table border="0">
  <tr valign="top">
    <td>Asunto</td>
    <td># (info.texto)#</td>
  </tr>
  <tr valign="top">
    <td width="132">Fecha</td>
    <td width="296">#DateFormat(info.fecha,'DD/MM/YYYY')#</td>
  </tr>
  <tr valign="top">
    <td>Inicio</td>
    <td>#TimeFormat(info.inicio,'HH:MM')#</td>
  </tr>
  <tr valign="top">
    <td>Final</td>
    <td>#TimeFormat(info.final,'HH:MM')#</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr valign="top">
    <td>&nbsp;</td>
    <td>
		  <cf_boton texto="&nbsp;&nbsp;Listo&nbsp;&nbsp;" index="1" 
					estilo="2" size="200" funcion="document.form1.submit();"></td>
  </tr>
</table>

</form></cfoutput>
<cf_web_portlet_end>
</cf_templatearea>
</cf_template>
