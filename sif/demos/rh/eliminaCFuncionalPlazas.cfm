<!---1. Actualiza el campo de la plaza (RHPid) en el centro funcional para poderlo eliminar---->
<cfquery datasource="#demo.DSN#">
	update CFuncional 
	set RHPid = null
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<!----2. Elimina la plaza---->
<cfquery datasource="#demo.DSN#">
	delete from RHPlazas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<!----3. Elimina el centro funcional---->
<cfquery datasource="#demo.DSN#">
	delete from CFuncional 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>		

