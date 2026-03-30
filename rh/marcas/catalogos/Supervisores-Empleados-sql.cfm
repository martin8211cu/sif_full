<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElEmpleadoYaEstaAsignadoAUnGrupo"
	Default="El empleado ya esta asignado a un grupo"
	returnvariable="MSG_ElEmpleadoYaEstaAsignadoAUnGrupo"/>
<!----Agregar un empleado especifico----->
<cfif isdefined("form.btnAgregar")>
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select  1
		from RHCMEmpleadosGrupo a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
	<cfif rsVerifica.RecordCount NEQ 0>
		<cf_throw message="#MSG_ElEmpleadoYaEstaAsignadoAUnGrupo#" errorcode="4015">
	<cfelse>
		<cfquery name="insertaEmpleado" datasource="#session.DSN#">
			insert into	RHCMEmpleadosGrupo (Gid, DEid, Ecodigo, BMUsucodigo, BMfechaalta)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)			
		</cfquery>
	</cfif>
<!----Eliminado masivo ---->
<cfelseif isdefined("form.btnBorrarMasivo")>
	<cfquery datasource="#session.DSN#">
		delete RHCMEmpleadosGrupo 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
	</cfquery>	
<!---Eliminar un empleado especifico, seleccionado de la lista--->
<cfelseif isdefined("form.EGid") and len(trim(form.EGid))>
	<cfquery datasource="#session.DSN#">
		delete RHCMEmpleadosGrupo 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EGid#">
			and Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
	</cfquery>
</cfif>
<cfset params = ''>
<cfif isdefined("form.Gid") and len(trim(form.Gid))>
	<cfset params = params & '&Gid=' & form.Gid>
</cfif>
<cflocation url="Supervisores-tabs.cfm?tab=2#params#">