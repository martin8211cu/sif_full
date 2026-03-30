<!--- BORRADO --->
<!--- 1. Tipos de Nomina --->
<cfquery datasource="#demo.DSN#">
	Delete DiasTiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<!--- 2. CalendarioPagos --->
<cfquery datasource="#demo.DSN#">
	Delete CalendarioPagos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>

<!--- 3. Tipos de Nomina --->
<!--- 3.1 RCalculoNomina --->
<cfquery datasource="#demo.DSN#">
	delete RCalculoNomina where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>
<!--- 3.2 Tipos Nomina --->
<cfquery datasource="#demo.DSN#">
	Delete TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete ConceptosTipoAccion
	where CIid in ( select CIid from CIncidentes where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> )
</cfquery>

<!--- 4. Detalle de Incidentes --->
<cfquery datasource="#demo.DSN#">
	Delete CIncidentesD
	where CIid in 
		(
			Select CIid
			from CIncidentes
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
		)
</cfquery>

<!--- 5. Encabezado de Incidentes --->
<cfquery datasource="#demo.DSN#">
	Delete CIncidentes
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>

<!--- 6. Conceptos de Tipos de Accion --->
<cfquery datasource="#demo.DSN#">
	Delete ConceptosTipoAccion
	where RHTid in 
		(
			Select RHTid
			from RHTipoAccion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
		)
</cfquery>

<!--- 7. Tipos de Accion --->
<cfquery datasource="#demo.DSN#">
	Delete RHTipoAccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>

<!--- 8. Detalle de Cargas Obrero-Patronales --->
<cfquery datasource="#demo.DSN#">
	Delete DCargas
	where ECid in 
		(
			Select ECid
			from ECargas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
		)
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>

 <!--- 9. Encabezado de Cargas Obrero-Patronales --->
<cfquery datasource="#demo.DSN#">
	Delete ECargas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>

<!--- 10. Socios de Negocios --->
<cfquery datasource="#demo.DSN#">
	Delete SNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>

<!--- 11. Estado de Socios de Negocios --->
<cfquery datasource="#demo.DSN#">
	Delete EstadoSNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>

<!--- 12. Tipos de Deduccion --->
<cfquery datasource="#demo.DSN#">
	Delete FDeduccion
	where TDid in ( select TDid from TDeduccion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> )
</cfquery>

<!--- 13. Tipos de Deduccion --->
<cfquery datasource="#demo.DSN#">
	Delete TDeduccion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#"> 
</cfquery>