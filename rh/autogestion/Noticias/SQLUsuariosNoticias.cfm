<cfinvoke Key="LB_ElCentroFuncionaYaFueAsignadoALaNoticia" Default="El centro funcional ya fue asignado a la noticia" returnvariable="LB_CFuncional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ElPuestoYaFueAsignadoALaNoticia" Default="El puesto ya fue asignado a la noticia" returnvariable="LB_Puesto" component="sif.Componentes.Translate" method="Translate"/>
<!----AGREGAR---->
<cfif isdefined("Form.btnAgregar")>					
	<cfif isdefined("form.CFid") and len(trim(form.CFid))>
		<!---Verificar ke no este asignado el cf---->
		<cfquery name="rsVerificaCF" datasource="#session.DSN#">
			select 1
			from DetUsuariosNoticias
			where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfquery>
		<cfif rsVerificaCF.RecordCount EQ 0>
			<cfquery datasource="#session.DSN#"	>
				insert into DetUsuariosNoticias (IdNoticia, CFid, RHPcodigo, 
												Ecodigo, BMUsucodigo,BMfechaalta)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
						null,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
			</cfquery>
		<cfelse>
			<cf_throw message="#LB_CFuncional#" errorcode="5035">
		</cfif>
	</cfif>
	<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
		<!---Verificar ke no este asignado el puesto---->
		<cfquery name="rsVerificaPuesto" datasource="#session.DSN#">
			select 1
			from DetUsuariosNoticias
			where IdNoticia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">
				and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.RHPcodigo)#">
		</cfquery>
		<cfif rsVerificaPuesto.RecordCount EQ 0>	
			<cfquery datasource="#session.DSN#"	>
				insert into DetUsuariosNoticias (IdNoticia, CFid, RHPcodigo, 
												Ecodigo, BMUsucodigo,BMfechaalta)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdNoticia#">,
						null,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						)
			</cfquery>
		<cfelse>
			<cf_throw message="#LB_Puesto#" errorcode="5040">
		</cfif>
	</cfif>
<!----ELIMINAR---->
<cfelseif IsDefined("form.Borrar")>
	<cfquery datasource="#session.dsn#">
		delete from DetUsuariosNoticias
		where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
	</cfquery>
</cfif>
<cfoutput>
<cfset param = '?Tab=2'>
<cfif isdefined("form.IdNoticia") and len(trim(form.IdNoticia))>
	<cfset param = param & "&IdNoticia=#form.IdNoticia#">
</cfif>
<cflocation url="TabsNoticiasAutogestion.cfm#param#">
</cfoutput>
