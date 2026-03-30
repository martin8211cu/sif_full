<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGPercodigo" type="string" required="yes">
		<cfargument name="MIGPerdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGPerspectiva
					(
						CodFuente,
						MIGPercodigo,
						MIGPerdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- Metricas ts_rversion,--->
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGPercodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGPerdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGPerid">
			<cfset varReturn=#LvarMIGPerid#>	
			<cfreturn #varReturn#>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGPerdescripcion" type="string" required="yes">
		<cfargument name="MIGPerid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGPerspectiva
				set 
				MIGPerdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGPerdescripcion#">,
				BMusucodigo=#session.usucodigo#
			where MIGPerid=#arguments.MIGPerid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGPerid" type="numeric" required="yes">
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGPerspectiva
				where MIGPerid=#arguments.MIGPerid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
	</cffunction>

</cfcomponent>