<!--- 
	Modificado por: Rodolfo Jimenez Jara
	Fecha de modificacion: 15 de Junio del 2005
	Motivo: Borrar Parametros despues de la demo.
 --->	
<cfquery datasource="#demo.DSN#">
	delete Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete Departamentos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete Bancos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete RHJornadas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete DRegimenVacaciones
	where RVid in ( select RVid from RegimenVacaciones where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> )
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete RegimenVacaciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete RHFeriados 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete RHNiveles
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete RHDCatalogosGenerales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete RHECatalogosGenerales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete RHConfigReportePuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>








