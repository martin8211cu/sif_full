	<!--- Borra ALGUNOS parametros de SIF --->
	<cfquery datasource="#demo.DSN#">
		delete Almacen where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery> 
	<cfquery datasource="#demo.DSN#">
		delete Impuestos where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete Clasificaciones where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete Conceptos where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete CFinanciera where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>

	<cfquery datasource="#demo.DSN#">
		delete CPVigencia where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete PCDCatalogoCuenta where Ccuenta in (select Ccuenta from CContables where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> ) 
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete PCDCatalogo where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete CContables where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete CtasMayor where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete CPTransacciones where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete CCTransacciones where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete ConceptoContable where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete BTransacciones where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
	<cfquery datasource="#demo.DSN#">
		delete ConceptoContableE where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
	</cfquery>
