<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGCuecodigo" type="string" required="yes">
		<cfargument name="MIGCuedescripcion" type="string" required="yes">
		<cfargument name="MIGCuetipo" type="string" required="yes">
		<cfargument name="MIGCuesubtipo" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGCuentas
					(
						CodFuente,
						MIGCuecodigo,
						MIGCuedescripcion,
						MIGCuetipo,
						MIGCuesubtipo,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion,--->
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGCuecodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGCuedescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGCuetipo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGCuesubtipo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,--->
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGCueid">
			<cfset varReturn=#LvarMIGCueid#>	
			<cfreturn #varReturn#>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGCuedescripcion" type="string" required="yes">
		<cfargument name="MIGCuetipo" type="string" required="yes">
		<cfargument name="MIGCuesubtipo" type="string" required="yes">
		<cfargument name="MIGCueid" type="numeric" required="yes">
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGCuentas
				set 
				MIGCuedescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGCuedescripcion#">,
				MIGCuetipo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGCuetipo#">,
				MIGCuesubtipo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGCuesubtipo#">,
				BMusucodigo=#session.usucodigo#,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">
			where MIGCueid=#arguments.MIGCueid#	
			and Ecodigo=#session.Ecodigo#	
		</cfquery>
	</cffunction>
	<cffunction access="public" name="Baja">
		<cfargument name="MIGCueid" type="numeric" required="yes">
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGCuentas
				where MIGCueid=#arguments.MIGCueid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
	</cffunction>

</cfcomponent>