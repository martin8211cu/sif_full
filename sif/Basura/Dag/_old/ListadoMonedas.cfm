<!---
	ListadoMonedas.cfr expects the query passed into it to contain the following column names:
		Field: Mcodigo               DataType: Long 
		Field: Mnombre               DataType: String 
		Field: Miso4217              DataType: String 
--->

<cfquery name="CFReportDataQuery" datasource="#session.dsn#">
        select Mcodigo, Mnombre, Miso4217
        from Monedas
        where Ecodigo = <cfqueryparam cf_sql_type="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>

<cfreport template="ListadoMonedas.cfr" format="flashpaper" query="CFReportDataQuery"/>