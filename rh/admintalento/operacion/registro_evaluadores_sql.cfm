<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ElEvaluadorYaFueAsignado" 
	default="El evaluador ya fue asignado con ese tipo" returnvariable="MSG_ElEvaluadorYaFueAsignado"/>
<cfset params = '&sel=3&RHRSid=#form.RHRSid#'>
<cfif isdefined("form.btnAgregar")><!---Agregar evaluador---->
	<!---Verificar ke no este ya asociado ---->	
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select DEid
		from RHEvaluadores
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and RHEVtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHEVtipo#">
	</cfquery>
	<cfif rsVerifica.RecordCount EQ 0>
		<cfquery datasource="#session.DSN#">
			insert into RHEvaluadores (Ecodigo, RHEid, DEid, RHEVtipo, BMUsucodigo, BMfechaalta)
			values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHEVtipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,					
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					)
		</cfquery>
	<cfelse>
		<cfthrow message="#MSG_ElEvaluadorYaFueAsignado#">	
	</cfif>
<cfelseif isdefined("form.Borrar") and isdefined("form.RHEVid") and len(trim(form.RHEVid))><!---Eliminar evaluador---->
	<!---Antes de eliminar el evaluador verificar que NO se hayan generado instancias----->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select 1
		from RHDRelacionSeguimiento
		where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
	</cfquery>
	<cfif rsVerifica.RecordCount EQ 0>
		<cfquery datasource="#session.DSN#">
			delete from RHEvaluadores
			where RHEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEVid#">
		</cfquery>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoSePuedeEliminarElEvaluadorPuesYaSeHanGeneradoEvaluaciones" 
			default="No se puede eliminar el evaluador pues ya se han generado evaluaciones" returnvariable="MSG_NoSePuedeEliminar"/>
		<cfthrow message="#MSG_NoSePuedeEliminar#">
	</cfif>
</cfif>
<cfoutput>
	<cflocation url="registro_evaluacion.cfm?#params#">
</cfoutput>