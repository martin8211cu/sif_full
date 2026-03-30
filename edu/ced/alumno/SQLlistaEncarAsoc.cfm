<cfset params="tab=#form.tab#&persona=#form.persona#&">

<cfif not isdefined("form.btnNuevo")>
	<cfif isdefined("Form.EncarBajaEEcod") and isdefined("form.EncarBajaEcod") 
		AND LEN(TRIM(form.EncarBajaEEcod)) AND LEN(TRIM(form.EncarBajaEcod))>
		<cfquery name="ABC_EncarAsoc" datasource="#Session.Edu.DSN#">
			delete EncargadoEstudiante
			where EEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EncarBajaEEcod#">
				and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EncarBajaEcod#">
		</cfquery>
		<cflocation url="alumno.cfm?Pagina=#form.Pagina#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#&#params#">
	<cfelse>
		<cfif isdefined('form.Borra') and form.Borra EQ 'no'>
			<cflocation url="alumno.cfm?Pagina=#form.Pagina#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#&#params#">
		<cfelse>
			<cfset params = params & "personaEncar=#form.personaEncar#&">
			<cflocation url="encargados.cfm?Pagina=#form.Pagina#&EcodigoEst=#form.EcodigoEst#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#&#params#">
		</cfif>
	</cfif>
<cfelse> 
	<cflocation url="encargados.cfm?Pagina=#form.Pagina#&EcodigoEst=#form.EcodigoEst#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#&#params#">
</cfif>
	