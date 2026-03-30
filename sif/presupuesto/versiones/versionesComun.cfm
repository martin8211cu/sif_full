<cf_templateheader title="Control de Versiones de Presupuesto">
	<cfif isdefined("url.cvid")>
		<cfset form.cvid = url.cvid>
	</cfif>
	<cfif isdefined("form.cvid") and isnumeric(form.cvid)>
		<cfquery name="qry_cv" datasource="#Session.dsn#">
			select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, CVestado, ts_rversion
			from CVersion
			where Ecodigo = #session.ecodigo#
			and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
		</cfquery>
	</cfif>
	
	
	<cfif session.versiones.formular EQ "V">
	  <cfset LvarTitulo="Control de Versiones de Formulación de Presupuesto">
	<cfelseif session.versiones.formular EQ "B">
	  <cfset LvarTitulo="Formulación de Version Base de Presupuesto">
	<cfelseif session.versiones.formular EQ "U">
	  <cfset LvarTitulo="Formulación de Version de Usuario de Presupuesto">
	<cfelseif session.versiones.formular EQ "F">
	  <cfset LvarTitulo="Formulación de Version Final de Presupuesto">
	</cfif>
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
	
		<!--- Obtiene la Moneda de la Empresa --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select e.Mcodigo, m.Mnombre
			from Empresas e, Monedas m
			where e.Ecodigo = #session.ecodigo#
			  and m.Ecodigo = e.Ecodigo
			  and m.Mcodigo = e.Mcodigo
		</cfquery>
		<cfif find(",",rsSQL.Mnombre) GT 0>
			<cfset LvarMnombreEmpresa = trim(mid(rsSQL.Mnombre,find(",",rsSQL.Mnombre)+1,100))>
		<cfelse>	
			<cfset LvarMnombreEmpresa = rsSQL.Mnombre>
		</cfif>
		<cfset LvarMcodigoEmpresa = rsSQL.Mcodigo>
		
		<!--- Obtiene el Año y Mes de Auxiliares de la Empresa --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.ecodigo#
			   and Pcodigo = 50
		</cfquery>
		<cfset LvarAuxAno = rsSQL.Pvalor>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #session.ecodigo#
			   and Pcodigo = 60
		</cfquery>
		<cfset LvarAuxMes = rsSQL.Pvalor>
		<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>
	
		<!--- Escoge la pantalla a trabajar --->
		<cfinclude template="versiones_config.cfm">
		<cfswitch expression="#pantalla#">
			<cfcase value="0"><cfinclude template="versiones_lista.cfm"></cfcase>
			<cfcase value="1"><cfinclude template="versiones_form.cfm"><cfif modocambio><cfinclude template="versiones_cmayor.cfm"></cfif></cfcase>
			<cfcase value="2"><cfinclude template="versiones_cpresup.cfm"></cfcase>
			<cfcase value="20"><cfinclude template="versiones_cpresup_nueva.cfm"></cfcase>
			<cfcase value="3"><cfinclude template="versiones_cvftotales.cfm"></cfcase>
			<cfcase value="4"><cfinclude template="versiones_cvfmonedas.cfm"></cfcase>
			<cfcase value="5"><cfinclude template="versiones_cvfmonedas.cfm"></cfcase>
		</cfswitch>
	<cf_web_portlet_end>
<cf_templatefooter>