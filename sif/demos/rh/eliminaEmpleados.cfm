<!--- 1. LineaTiempo --->
<cfquery datasource="#demo.DSN#">
	delete DLineaTiempo where LTid in ( select LTid from LineaTiempo where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete LineaTiempo where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >
</cfquery>

<!--- 2. DatosLaborales --->
<cfquery datasource="#demo.DSN#">
	delete DDLaboralesEmpleado where DLlinea in (select DLlinea from DLaboralesEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >)
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete DDConceptosEmpleado where DLlinea in (select DLlinea from DLaboralesEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >)
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete DLaboralesEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >
</cfquery>

<!--- 5. DeduccionesEmpleado --->
<cfquery datasource="#demo.DSN#">
	delete DeduccionesCalculo where Did in ( select Did from DeduccionesEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete DeduccionesEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >
</cfquery>

<!--- 6. CargasEmpleado --->
<cfquery datasource="#demo.DSN#">
	delete CargasCalculo where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete CargasEmpleado where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>

<!--- 7. RHAnotaciones --->
<cfquery datasource="#demo.DSN#">
	delete RHAnotaciones where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>	

<!--- 8. FEmpleado --->
<cfquery datasource="#demo.DSN#">
	delete FEmpleado where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>	

<!--- 9. RolEmpleadoSNegocios --->
<cfquery datasource="#demo.DSN#">
	delete RolEmpleadoSNegocios 
	where 
		DEid in ( 
					select DEid 
					from DatosEmpleado 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >
				)
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >
</cfquery>

<!----10. IncidenciasCalculo ---->
<cfquery datasource="#demo.DSN#">
	delete IncidenciasCalculo where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>

<!----11. IncidenciasCalculo ---->
<cfquery datasource="#demo.DSN#">
	delete PagosEmpleado where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>

<!----12. SalarioEmpleado ---->
<cfquery datasource="#demo.DSN#">
	delete SalarioEmpleado where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>

<!----13. DVacacionesEmpleado ---->
<cfquery datasource="#demo.DSN#">
	delete DVacacionesEmpleado where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>

<!----14. EVacacionesEmpleado ---->
<cfquery datasource="#demo.DSN#">
	delete EVacacionesEmpleado where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>

<!----15. Incidencias ---->
<cfquery datasource="#demo.DSN#">
	delete Incidencias where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>

<!----16. RHAcciones ---->
<cfquery datasource="#demo.DSN#">
	delete RHDAcciones where RHAlinea in ( select RHAlinea from RHAcciones where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >)
</cfquery>
<cfquery datasource="#demo.DSN#">
	delete RHAcciones where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" >
</cfquery>

<!--- 17. RHImagenEmpleado --->
<cfquery datasource="#demo.DSN#">
	delete RHImagenEmpleado where DEid in ( select DEid from DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#" > )
</cfquery>

<!----18. DatosEmpleado---->
<cfquery datasource="#demo.DSN#">
	delete DatosEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

