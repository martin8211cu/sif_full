<cfquery datasource="#demo.DSN#">
	delete from RHMateriasGrupo where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHGrupoMaterias where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHAreaGrupoMat where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHHabilidadesMaterias where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete  from RHConocimientosMaterias where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete  from RHMateriasGrupo where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHEmpleadoCurso where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHEducacionEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHCompetenciasEmpleado where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHExperienciaEmpleado  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHProgramacionCursos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete  from RHCursos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete  from RHOfertaAcademica where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHMateria where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHInstitucionesA where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHAreasCapacitacion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from GradoAcademico where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHEmpleadosPlan where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHPlanSucesion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

<cfquery datasource="#demo.DSN#">
	delete from RHTipoCurso where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#demo.Ecodigo#">
</cfquery>

