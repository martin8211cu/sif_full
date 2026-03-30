<!----1. Elimina RHValoresPuesto (valores del puesto) ---->
<cfquery datasource="#demo.DSN#">
	delete  from RHValoresPuesto where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<!----2. Elimina RHDescriptivoPuesto (Descripciones del puesto)---->
<cfquery datasource="#demo.DSN#">
	delete  from RHDescriptivoPuesto where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<!----3. Elimina RHHabilidadesPuesto (Habilidades del puesto)---->
<cfquery datasource="#demo.DSN#">
	delete  from RHHabilidadesPuesto where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>
<!----4. Elimina RHConocimientosPuesto (Conocimientos del puesto)---->
<cfquery datasource="#demo.DSN#">
	delete from RHConocimientosPuesto where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<!----5. Elimina RHPuestosCategoria --->
<cfquery datasource="#demo.DSN#">
	delete RHPuestosCategoria where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<!----6. Elimina RHPuestos (Puesto)---->
<cfquery datasource="#demo.DSN#">
	delete from RHPuestos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<!----7. Elimina RHTPuestos (Tipos de puesto)---->
<cfquery datasource="#demo.DSN#">
	delete  from RHTPuestos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<!----8. Elimina RHPuestosExternos (Puestos externos)---->
<cfquery datasource="#demo.DSN#">
	delete  from RHPuestosExternos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<!---9. Elimina etiquetas --->
<cfquery datasource="#demo.DSN#">
	delete from RHEtiquetasEmpresa where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<!---10. Elimina Materias --->
<cfquery datasource="#demo.DSN#">
	delete from Materia where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>