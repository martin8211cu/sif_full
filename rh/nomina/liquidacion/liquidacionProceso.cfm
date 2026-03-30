<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Confecci&oacute;n de Liquidaci&oacute;n de Personal"
VSgrupo="103"
returnvariable="nombre_proceso"/>

<cfquery name="rsEmpresaMexico" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
			on d.id_direccion = e.id_direccion
			and Ppais = 'MX'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<cfset sufijoE = "">
<cfset sufijo = "">

<cfif rsEmpresaMexico.RecordCount NEQ 0>
<cfset sufijoE = "-MX">
</cfif>

<cfif rsEmpresaMexico.RecordCount NEQ 0 and isdefined('paso') and paso neq 0><!----========= PARA Mexico =========---->
	<cfset sufijo = "-MX">
</cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<!--- <cfsavecontent variable="pNavegacion">
	<!--- <cfinclude template="/rh/portlets/pNavegacion.cfm"> --->
</cfsavecontent> --->

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

	<cfinclude template="liquidacionProceso-update#sufijo#.cfm">
	<cfinclude template="liquidacionProceso-config#sufijoE#.cfm">
	<cfinclude template="liquidacionProceso-getData.cfm">

	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<!--- Columna de Ayuda --->
		<td valign="top" align="center">
			<cfif DLlinea NEQ 0>
				<!--- Empleado --->
				<cfquery name="rsEmpleado" datasource="#Session.DSN#">
					select a.DEid
					from RHLiquidacionPersonal a
					where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
				</cfquery>
				<cfset Form.DEid = rsEmpleado.DEid>
			</cfif>

			<cf_web_portlet_start titulo='#Gdescpasos[Gpaso+1]#'>
				<cfinclude template="liquidacionProceso-header#sufijo#.cfm">
				<cfinclude template="liquidacionProceso-paso#Gpaso##sufijo#.cfm">
			<cf_web_portlet_end>

		</td>
		<!--- Columna de Menú de Pasos y Sección de Ayuda --->
		<td valign="top" width="1%">
			<cfinclude template="liquidacionProceso-progreso#sufijoE#.cfm"><br>
			<cfinclude template="liquidacionProceso-ayuda#sufijo#.cfm">
		</td>
	  </tr>
	</table>
<cf_templatefooter>