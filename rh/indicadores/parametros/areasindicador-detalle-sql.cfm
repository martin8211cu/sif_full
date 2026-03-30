<cfif isdefined("form.ALTA")>
	<cfquery name="rs_path" datasource="#session.DSN#">
		select CFpath as path
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif isdefined("form.incluirdependencias")><!---Si incluye dependencias busca todos los cf's "hijos" del cfuncional seleccionado en el conlis y los inserta---->
		<cfquery name="rsCfuncionales" datasource="#session.DSN#">
			select cf.CFid
			from CFuncional cf
			where cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and cf.CFpath like '#rs_path.path#%'
		</cfquery>
		<cfloop query="rsCfuncionales">
			<cfset ejecutar = funcInsertaDetalle(form.AreaEid,rsCfuncionales.CFid)>
		</cfloop>
	<cfelse><!---No incluye dependencias (Hace una sola insercion)---->
		<cfset ejecutar = funcInsertaDetalle(form.AreaEid,form.CFid)>
	</cfif>	
	<!---===============================================================================--->
	<!--- Funcion que inserta centros funcionales en el detalle ---->
	<!---===============================================================================--->
	<cffunction name="funcInsertaDetalle" output="true">
		<cfargument name="AreaEid" type="numeric" required="yes">
		<cfargument name="CFid" type="numeric" required="yes">
		<!---Verificar existencia del cfuncional--->
		<cfquery name="rsExisteCF" datasource="#session.DSN#">
			select 1 
			from AreaIndDetalle
			where AreaEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AreaEid#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">
		</cfquery>
		<cfif rsExisteCF.RecordCount EQ 0>
			<cfquery datasource="#session.DSN#">
				insert into AreaIndDetalle(AreaEid, CFid, Ecodigo, BMUsucodigo, BMfecha)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.AreaEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						)
			</cfquery>
		<cfelse>
			<cfinvoke component="sif.Componentes.Translate" Key="MS_ElCentroFuncionalYaEstaAsignadoEnElArea" Default="El centro funcional ya fue asignado en el area" returnvariable="MS_CFasignado" method="Translate"/>
			<cfthrow message="#MS_CFasignado#">
		</cfif>
	</cffunction>
<cfelseif isdefined("form.AreaDid") and len(trim(form.AreaDid))>
	<cfquery datasource="#session.DSN#">
		delete from AreaIndDetalle
		where AreaDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AreaDid#">
	</cfquery>
</cfif>
<cflocation url="areasindicador.cfm?AreaEid=#form.AreaEid#">