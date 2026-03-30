<cf_navegacion name="NUEVO">
<cf_navegacion name="ERDid">

<cfparam name="MODO" 	   			default="ALTA">
<cfparam name="form.ERDid" 			default="">
<cfparam name="rsEReport.ERDcodigo" default="">
<cfparam name="rsEReport.ERDdesc" 	default="">
<cfparam name="rsEReport.ERDbody" 	default="">


<cfif LEN(TRIM(FORM.ERDid))>
	<cfquery name="rsEReport" datasource="#session.dsn#" >
		select * 
		 from EReportDinamic 
		where Ecodigo = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#session.Ecodigo#">
		  and ERDid   = <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" 	value="#FORM.ERDid#">
	</cfquery>	
	<cfset MODO = "CAMBIO">
</cfif>

<cf_templateheader title="Reportes Dinámicos">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Creación de Reportes Dinámicos">    
		<form name="form1" id="form1" method="post" action="ReportDinamic-sql.cfm" >
			<cfif MODO EQ "ALTA" and not isdefined('form.NUEVO')>
					<cfinclude template="ReportDinamic-lista.cfm">	
			<cfelse>
					<cfinclude template="ReportDinamic-form.cfm">
				<cfif not isdefined('form.NUEVO')>
					<cfinclude template="ReportDinamic-Det.cfm">
				</cfif>
			</cfif>
		</form>
		<cfif MODO EQ 'CAMBIO'>
			<cf_qforms>
				<cf_qformsRequiredField name="ERDcodigo" 	 description="Codigo">
				<cf_qformsRequiredField name="ERDdesc" 		 description="Descripción">
				<cf_qformsRequiredField name="ERDmodulo" 	 description="Modulo">
				<cf_qformsRequiredField name="ERDbody" 	 	 description="Cuerpo del Reporte">
			</cf_qforms>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>	