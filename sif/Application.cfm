<cfinclude template="/Application.cfm"><cfsetting enablecfoutputonly="yes">

<!--- Si la empresa no ha sido parametrizada, direcciona al Wizard de ConfiguraciÃ³n --->
<cfif isdefined("session.Ecodigo") and session.Ecodigo neq 0 and session.DSN NEQ 'asp' and session.DSN NEQ 'sdc2' and StructKeyExists(Application.dsinfo, session.dsn) >
	<cfquery name="rsConfig" datasource="#session.DSN#" debug="no">
		select Pvalor 
		from Parametros
		where Ecodigo = #session.Ecodigo#
		and Pcodigo=5
	</cfquery>
	<cfset usaWizard = true >
	
	<!---<cfquery name="rsWizard" datasource="#session.DSN#" debug="no">
		select Pvalor 
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=2
	</cfquery>
	<cfif rsWizard.RecordCount gt 0 and trim(rsWizard.Pvalor) eq 0 >
		<cfset usaWizard = false >
	</cfif>--->

	<!--- Parametros de Educacion
	<cfinclude template="/educ/admin/defaults.cfm">
	--->

	<cfif rsConfig.RecordCount eq 0 and usaWizard >
		<cflocation url="/cfmx/sif/ad/config/wizBienvenida.cfm">
	<cfelseif isdefined("rsConfig.Pvalor") and rsConfig.Pvalor eq 'N' and usaWizard >	
		<cflocation url="/cfmx/sif/ad/config/wizBienvenida.cfm">
	</cfif>

	<!--- Pone el valor de la variable session.traducir [esto no puede hacerse en el componente, pues da conflictos de base de datos] --->
	<cfif not isdefined("session.traducir")>
		<!--- Usar funcionalidad de traduccion, parametro 17 de RHParametros --->
		<cfquery name="rsTraducir" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = #session.Ecodigo#
			and Pcodigo = 17
		</cfquery>
		<cfif rsTraducir.Pvalor eq 0 >
			<cfset session.traducir = false >
		<cfelse>	
			<cfset session.traducir = true >
		</cfif>
	</cfif>


	<!--- Parametros de Compras --->
	<cfinclude template="/sif/cm/admin/defaults.cfm">

</cfif>

<cfinclude template="/sif/Utiles/SIFfunciones.cfm">
<cfsetting enablecfoutputonly="no">