<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGOEcodigo" type="string" required="yes">
		<cfargument name="MIGOEdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGOEcodigo) as MIGOEcodigo
			from MIGOEstrategico
			where MIGOEcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGOEcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount eq 0>		
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGOEstrategico
					(
						CodFuente,
						MIGOEcodigo,
						MIGOEdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGOEcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGOEdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGOEid">
			<cfset varReturn=#LvarMIGOEid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código de #rsValida.MIGOEcodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGOEdescripcion" type="string" required="yes">
		<cfargument name="MIGOEid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGOEstrategico
				set 
				MIGOEdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGOEdescripcion#">,
				BMusucodigo=#session.usucodigo#
			where MIGOEid=#arguments.MIGOEid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGOEid" type="numeric" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			delete from MIGOEstrategico
			where MIGOEid=#arguments.MIGOEid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>

</cfcomponent>