	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Solicitud de Plazas">
			<cfset modulo = "pp">
			<cfif isdefined("url.RHSPid") and len(trim(url.RHSPid))>
				<cfset form.RHSPid = url.RHSPid >
			</cfif>							
			<table width="100%" border="0" cellspacing="0">
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr>
				<td valign="top">
				<cfquery name="empleado" datasource="#session.DSN#">
					select coalesce(llave, '0') as DEid 
					from UsuarioReferencia
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					  and STabla = 'DatosEmpleado'
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
				</cfquery>
				<cfif empleado.recordcount gt 0 or session.usulogin eq 'soinrh'>
					<cfif (isdefined('form.RHSPid') and form.RHSPid NEQ '') or (isdefined('form.btnNuevo') and form.btnNuevo NEQ '')>
						<cfinclude template="solicitudPlazas-form.cfm">
					<cfelse>
						<cfinclude template="listaSolicitudPlazas.cfm">
					</cfif>
				<cfelse>
					Esta operación solo puede ser realizada por un colaborador de la Empresa. Proceso Cancelado!!
				</cfif>
				</td>
			  </tr>
			</table>		
		<cf_web_portlet_end>
	<cf_templatefooter>	