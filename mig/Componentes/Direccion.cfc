<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGDcodigo" type="string" required="yes">
		<cfargument name="MIGDnombre" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGDireccion
					(
						CodFuente,
						MIGDcodigo,
						MIGDnombre,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGDcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGDnombre#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGDid">
			<cfset varReturn=#LvarMIGDid#>	
			<cfreturn #varReturn#>
	</cffunction>
	
	<cffunction access="public" name="AgregaSub_Direccion">
		<cfargument name="MIGSDid" type="numeric" required="yes">
		<cfargument name="MIGDid" type="numeric" required="yes">
		<cfargument name="MIGSDcodigo" type="string" required="yes">
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGSDireccion
				set 
				MIGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGDid#">,
				BMusucodigo=#session.usucodigo#
			where MIGSDid=#arguments.MIGSDid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGDnombre" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGDid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGDireccion
				set 
				MIGDnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGDnombre#">,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
				BMusucodigo=#session.usucodigo#
			where MIGDid=#arguments.MIGDid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGDid" type="numeric" required="yes">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select a.MIGSDcodigo,a.MIGSDid,b.MIGDid,b.MIGDcodigo
			from MIGSDireccion a
				inner join MIGDireccion b
					on a.MIGDid=b.MIGDid
			where a.Ecodigo=#session.Ecodigo#
			and b.MIGDid=#arguments.MIGDid#
		</cfquery>

		<cfif rsValida.recordCount EQ 0>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGDireccion
				where MIGDid=#arguments.MIGDid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		<cfelse>
			<cfthrow type="toUser" message="La Direccion #rsValida.MIGDcodigo# no puede ser eliminada ya que tiene asociaciones con una Sub Dirección.">
		</cfif>
	</cffunction>

</cfcomponent>