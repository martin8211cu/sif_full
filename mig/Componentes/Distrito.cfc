<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGArid" type="numeric" required="yes">
		<cfargument name="MIGDicodigo" type="string" required="yes">
		<cfargument name="MIGDidescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGDicodigo) as MIGDicodigo
			from MIGDistrito
			where MIGDicodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGDicodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount EQ 0>		
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGDistrito
					(
						CodFuente,
						MIGDicodigo,
						MIGDidescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->
						MIGArid,
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGDicodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGDidescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGArid#">,
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGDiid">
			<cfset varReturn=#LvarMIGDiid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código de Distrito #rsValida.MIGDicodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGArid" 				type="numeric" required="yes">
		<cfargument name="MIGDidescripcion" 	type="string" required="yes">
		<cfargument name="MIGDiid" 				type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGDistrito
				set 
				MIGDidescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGDidescripcion#">,
				MIGArid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGArid#">,
				BMusucodigo=#session.usucodigo#
			where MIGDiid=#arguments.MIGDiid#		
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGDiid" type="numeric" required="yes">
		<cfquery datasource="#session.dsn#">
			delete from MIGDistrito
			where MIGDiid=#arguments.MIGDiid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>

</cfcomponent>