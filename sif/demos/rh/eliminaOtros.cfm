	<cfquery datasource="#demo.DSN#" >
		delete DFormato where EFid in ( select EFid from EFormato where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> )
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete EFormato where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete RHMetodosCalculo where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete RHParametros where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete RHMontosCategoria where RHVTid in ( select RHVTid from RHVigenciasTabla where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> )
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete RHVigenciasTabla where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete RHCategoriasTipoTabla where RHTTid in ( select RHTTid from RHTTablaSalarial where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> )
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete RHTTablaSalarial where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete ComponentesSalariales where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#" >
		delete RHComponentesAgrupados where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<!----Elimina reclutamiento--->
	<cfquery datasource="#demo.DSN#">
		delete RHExperienciaEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete RHEducacionEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete DatosOferentes where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
