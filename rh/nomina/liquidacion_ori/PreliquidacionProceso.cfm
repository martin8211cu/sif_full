<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Confecci&oacute;n de Pre - Liquidaci&oacute;n de Personal"
VSgrupo="103"
returnvariable="nombre_proceso"/>

<cfif isdefined('form.Aprobar') and paso EQ 5>
	<cfset params = 'RHPLPid=#form.RHPLPid#'>
	<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		<cfset params = params & '&DEid=#form.DEid#'>
	</cfif> 
        <cflocation url="/cfmx/rh/nomina/liquidacion/liquidacionPreBoleta.cfm?#params#" addtoken="yes">
<!---		<cfinclude template="/rh/nomina/liquidacion/liquidacionPreBoletaMX-form.cfm">--->
</cfif>

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
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

	<cfinclude template="PreliquidacionProceso-update#sufijo#.cfm">
	<cfinclude template="PreliquidacionProceso-config#sufijoE#.cfm">
	<cfinclude template="PreliquidacionProceso-getData.cfm">

	<cfif len(Gpaso) EQ 0>
	    <cfset sufijo = "">
		<cfset Gpaso = 0>
    </cfif>
<!---

ljimenez

RHPLPid: <cfdump var="#RHPLPid#"><br>
Gpaso: <cfdump var="#Gpaso#"><br>
Sufijo: <cfdump var="#sufijo#"><br>
sufijoE: <cfdump var="#sufijoE#"><br>
fuente llamado <cfdump var="PreliquidacionProceso-paso#Gpaso##sufijo#.cfm"><br>
--->
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<!--- Columna de Ayuda --->
		<td valign="top" align="center">
			<cfif RHPLPid NEQ 0>
				<!--- Empleado --->
				<cfquery name="rsEmpleado" datasource="#Session.DSN#">
					select a.DEid
					from RHPreLiquidacionPersonal a
					where a.RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
				</cfquery>
				<cfset Form.DEid = rsEmpleado.DEid>
			</cfif>
            <cf_web_portlet_start titulo='#Gdescpasos[1]#'>
				<cfinclude template="PreliquidacionProceso-header#sufijo#.cfm">
                <cfif Gpaso EQ 0 or len(Gpaso) EQ 0>
	                <cfinclude template="PreLiquidacion-form.cfm">
                </cfif>
				<cfinclude template="PreliquidacionProceso-paso#Gpaso##sufijo#.cfm">
			<cf_web_portlet_end>
		</td>
		<!--- Columna de Menú de Pasos y Sección de Ayuda --->

        <td valign="top" width="1%">
			<cfinclude template="PreliquidacionProceso-progreso#sufijoE#.cfm"><br>
			<cfinclude template="liquidacionProceso-ayuda#sufijo#.cfm">
		</td>
	  </tr>
	</table>
<cf_templatefooter>