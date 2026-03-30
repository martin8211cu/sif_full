<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSePuedeEliminarElGrupoPorqueYaTieneEmpleadosYOAutorizadoresAsignados"
	Default="No se puede eliminar el grupo porque ya tiene empleados y/o autorizadores asignados"
	returnvariable="MSG_TieneEmpleadosAutorizadores"/>
	
<cfset modo = "ALTA">
<cfif not isdefined("Form.btnNuevo")>	
	<cfif isdefined("Form.Alta")><!---AGREGAR----->
		<cftransaction>
			<cfquery name="insertaGrupo" datasource="#Session.DSN#">
				insert into RHCMGrupos (Gcodigo, Gdescripcion, Ecodigo, BMUsucodigo, BMfechaalta)
					values (<cfqueryparam value="#form.Gcodigo#" cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insertaGrupo">
		</cftransaction>
		<cfset modo = 'ALTA'>
	<cfelseif isdefined("Form.Cambio")><!---ACTUALIZAR---->
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHCMGrupos"
			redirect="Supervidores-tabs.cfm?tab=1"
			timestamp="#form.ts_rversion#"
			field1="Gid" 
			type1="numeric" 
			value1="#Form.Gid#">

		<cfquery datasource="#Session.DSN#">
			update RHCMGrupos set 
				Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_varchar">, 
				Gdescripcion = <cfqueryparam value="#Form.Gdescripcion#" cfsqltype="cf_sql_varchar">			
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Gid =  <cfqueryparam value="#Form.Gid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo = 'CAMBIO'>
	<cfelseif isdefined("Form.Baja")><!----ELIMINAR---->
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select 1
			from RHCMGrupos a 
			where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and a.Gid = <cfqueryparam value="#form.Gid#" cfsqltype="cf_sql_numeric">
				and exists (select 1 
						from RHCMAutorizadoresGrupo b
						where a.Gid = b.Gid
							and a.Ecodigo = b.Ecodigo)
				and exists (select 1 from RHCMEmpleadosGrupo c
						  where a.Gid = c.Gid
							and a.Ecodigo = c.Ecodigo) 
		</cfquery>
		<cfif rsVerifica.RecordCount NEQ 0>			
			<cf_throw message="#MSG_TieneEmpleadosAutorizadores#" errorcode="4025">
		</cfif>		
		<!---Eliminar los autorizadores de grupo--->
		<cfquery datasource="#session.DSN#">
			delete from RHCMAutorizadoresGrupo
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Gid =  <cfqueryparam value="#Form.Gid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<!---Eliminar los empleados del grupo de grupo--->
		<cfquery datasource="#session.DSN#">
			delete from RHCMEmpleadosGrupo
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Gid =  <cfqueryparam value="#Form.Gid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery  datasource="#Session.DSN#">
			delete from RHCMGrupos
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and Gid =  <cfqueryparam value="#Form.Gid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo = 'ALTA'>
	</cfif>
</cfif>	
<cfoutput>
<cfset params = ''>
<cfif isdefined("modo")>
	<cfset params = "&modo=" & modo>
</cfif>
<cfif modo eq 'CAMBIO' and isdefined("form.Gid") and len(trim(form.Gid))>
	<cfset params = params & '&Gid=' & form.Gid>
<cfelseif isdefined("insertaGrupo.identity") and len(trim(insertaGrupo.identity))>
	<cfset params = params & '&Gid=' & insertaGrupo.identity>
</cfif>
<cflocation url="Supervisores-tabs.cfm?tab=1#params#">
</cfoutput>