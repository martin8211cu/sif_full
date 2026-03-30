
<cfset params="tab=#form.tab#&persona=#form.persona#&">
<!--- Para cargar en memoria el codigo del estudiante "Ecodigo" --->
	<cfquery name="rsEcodigo" datasource="#Session.Edu.DSN#">
		Select a.Ecodigo
		from Alumnos a
		inner join Estudiante b
		   on b.persona = a.persona
		  and b.Ecodigo = a.Ecodigo
		where CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  and a.persona	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	</cfquery>	
	<cfif isdefined('rsEcodigo')>
		<cfset form.Ecodigo = rsEcodigo.Ecodigo>
	</cfif>
<cfif isdefined("Form.Agregar") and isdefined("form.Ecodigo") AND #form.Ecodigo# NEQ "" >
	<cfquery name="rsInserEE" datasource="#Session.Edu.DSN#">
	insert EncargadoEstudiante (EEcodigo, CEcodigo, Ecodigo)
	values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">)			
	</cfquery>
</cfif>
<cflocation url="alumno.cfm?Pagina=#form.Pagina#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#&#params#">