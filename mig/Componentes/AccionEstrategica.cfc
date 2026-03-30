<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGAEcodigo" type="string" required="yes">
		<cfargument name="MIGAEdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">

		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGAEcodigo) as MIGAEcodigo
			from MIGAccion
			where MIGAEcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGAEcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount EQ 0>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGAccion
					(
						CodFuente,
						MIGAEcodigo,
						MIGAEdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGAEcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGAEdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGAEid">
			<cfset varReturn=#LvarMIGAEid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código #rsValida.MIGAEcodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGAEdescripcion" type="string" required="yes">
		<cfargument name="MIGAEid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGAccion
				set 
				MIGAEdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGAEdescripcion#">,
				BMusucodigo=#session.usucodigo#
			where MIGAEid=#arguments.MIGAEid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGAEid" type="numeric" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			delete from MIGAccion
			where MIGAEid=#arguments.MIGAEid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>

</cfcomponent>