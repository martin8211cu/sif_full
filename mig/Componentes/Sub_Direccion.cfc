<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGSDcodigo" type="string" required="yes">
		<cfargument name="MIGSDdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGDid" type="numeric" required="yes">
		
		<cfquery name="rsCodigoS" datasource="#session.dsn#">
			select rtrim(MIGSDcodigo) as MIGSDcodigo
			from MIGSDireccion
			where MIGSDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGSDcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsCodigoS.recordCount EQ 0>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGSDireccion
					(
						CodFuente,
						MIGSDcodigo,
						MIGSDdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->
						Ecodigo,
						MIGDid,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGSDcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGSDdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						#session.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGDid#">,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGSDid">
			<cfset varReturn=#LvarMIGSDid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código de la Sub Dirección #rsCodigoS.MIGSDcodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="AgregarGerencia">
		<cfargument name="MIGGid" type="numeric" required="yes">
		<cfargument name="MIGSDid" type="numeric" required="yes">
		<cfargument name="MIGGcodigo" type="string" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGGerencia
				set 
				MIGSDid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGSDid#">,
				BMusucodigo=#session.usucodigo#
			where MIGGid=#arguments.MIGGid#	
			and Ecodigo=#session.Ecodigo#	
		</cfquery>
	</cffunction>
	
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGSDdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGSDid" type="numeric" required="yes">
		<cfargument name="MIGDid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGSDireccion
				set 
				MIGSDdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGSDdescripcion#">,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
				BMusucodigo=#session.usucodigo#,
				MIGDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGDid#">
			where MIGSDid=#arguments.MIGSDid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGSDid" type="numeric" required="yes">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select a.MIGGid,a.MIGGcodigo,b.MIGSDid,b.MIGSDcodigo
			from MIGGerencia a
				inner join MIGSDireccion b
					on a.MIGSDid=b.MIGSDid
			where a.Ecodigo=#session.Ecodigo#
			and b.MIGSDid=#arguments.MIGSDid#
		</cfquery>

		<cfif rsValida.recordCount EQ 0>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGSDireccion
				where MIGSDid=#form.MIGSDid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		<cfelse>
			<cfthrow type="toUser" message="La Sub Dirección #rsValida.MIGSDcodigo# no puede ser eliminada ya que tiene asociaciones con Gerencia.">
		</cfif>
	</cffunction>
</cfcomponent>