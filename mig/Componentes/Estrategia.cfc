<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGEstcodigo" type="string" required="yes">
		<cfargument name="MIGEstdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">

		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGEstcodigo) as MIGEstcodigo
			from MIGEstrategia
			where MIGEstcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGEstcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount EQ 0>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGEstrategia
					(
						CodFuente,
						MIGEstcodigo,
						MIGEstdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGEstcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGEstdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGEstid">
			<cfset varReturn=#LvarMIGEstid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código #rsValida.MIGEstcodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGEstdescripcion" type="string" required="yes">
		<cfargument name="MIGEstid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGEstrategia
				set 
				MIGEstdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGEstdescripcion#">,
				BMusucodigo=#session.usucodigo#
			where MIGEstid=#arguments.MIGEstid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGEstid" type="numeric" required="yes">
		<cfquery name="Elimiar" datasource="#session.dsn#">
			delete from MIGEstrategia
			where MIGEstid=#arguments.MIGEstid#
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>

</cfcomponent>