<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElUsuarioYaEstaAsignadoAlGrupo"
	Default="El usuario ya esta asignado al grupo"
	returnvariable="MSG_ElUsuarioYaEstaAsignadoAlGrupo"/>
<!----Agregar un empleado especifico----->
<cfif isdefined("form.btnAgregar")>
	<!---Verificar que no este ya asignado ese usuario al grupo ---->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select 1 
		from RHCMAutorizadoresGrupo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
			and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	</cfquery>
	<cfif rsVerifica.RecordCount NEQ 0>
		<cf_throw message="#MSG_ElUsuarioYaEstaAsignadoAlGrupo#" errorcode="4035">
	<cfelse>
		<cfquery name="insertaEmpleado" datasource="#session.DSN#">
			insert into RHCMAutorizadoresGrupo(Ecodigo, Gid, Usucodigo, BMUsucodigo, BMfechaalta)
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,				
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)			
		</cfquery>
	</cfif>	
<!---Eliminar un autorizador especifico, seleccionado de la lista--->
<cfelseif isdefined("form.AGid") and len(trim(form.AGid))>
	<cfquery datasource="#session.DSN#">
		delete from RHCMAutorizadoresGrupo 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGid#">
			and Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gid#">
	</cfquery>
</cfif>
<cfset params = ''>
<cfif isdefined("form.Gid") and len(trim(form.Gid))>
	<cfset params = params & '&Gid=' & form.Gid>
</cfif>
<cflocation url="Supervisores-tabs.cfm?tab=3#params#">