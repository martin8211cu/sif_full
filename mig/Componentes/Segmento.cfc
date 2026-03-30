<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGProSegcodigo" type="string" required="yes">
		<cfargument name="MIGProSegdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfquery datasource="#session.dsn#" name="insert">
				insert into MIGProSegmentos
				(
					CodFuente,
					MIGProSegcodigo,
					MIGProSegdescripcion,
					Dactiva,
					BMusucodigo,
					FechaAlta,
					<!--- ts_rversion, --->
					Ecodigo,
					CEcodigo
				)
				values(
					1,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGProSegcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGProSegdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
					#session.usucodigo#,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					#session.CEcodigo#
				) 
				<cf_dbidentity1 datasource="#session.DSN#" name="insert">
			</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGProSegid">
		<cfset varReturn=#LvarMIGProSegid#>	
		<cfreturn #varReturn#>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGProSegdescripcion" type="string" required="yes">
		<cfargument name="MIGProSegid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGProSegmentos
				set 
				MIGProSegdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGProSegdescripcion#">,
				BMusucodigo=#session.usucodigo#
			where MIGProSegid=#arguments.MIGProSegid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGProSegid" type="numeric" required="yes">
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGProSegmentos
				where MIGProSegid=#arguments.MIGProSegid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
	</cffunction>

</cfcomponent>