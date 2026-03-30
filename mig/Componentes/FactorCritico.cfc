<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGFCcodigo" type="string" required="yes">
		<cfargument name="MIGFCdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGFCcodigo) as MIGFCcodigo
			from MIGFCritico
			where MIGFCcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGFCcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount eq 0>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGFCritico
					(
						CodFuente,
						MIGFCcodigo,
						MIGFCdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion,--->
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGFCcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGFCdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,--->
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGFCid">
			<cfset varReturn=#LvarMIGFCid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código #rsValida.MIGFCcodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGFCdescripcion" type="string" required="yes">
		<cfargument name="MIGFCid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGFCritico
				set 
				MIGFCdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGFCdescripcion#">,
				BMusucodigo=#session.usucodigo#
			where MIGFCid=#arguments.MIGFCid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGFCid" type="numeric" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			delete from MIGFCritico
			where MIGFCid=#arguments.MIGFCid#
		</cfquery>
	</cffunction>

</cfcomponent>