<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGArcodigo" type="string" required="yes">
		<cfargument name="MIGArdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGRid" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGArcodigo) as MIGArcodigo
			from MIGArea
			where MIGArcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGArcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount EQ 0>			
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGArea
					(
						CodFuente,
						MIGArcodigo,
						MIGArdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->
						MIGRid,
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGArcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGArdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGRid#">,
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGArid">
			<cfset varReturn=#LvarMIGArid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código del Área #rsValida.MIGArcodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="AgregaDistrito">
		<cfargument name="MIGArid" type="numeric" required="yes">
		<cfargument name="MIGDiid" type="numeric" required="yes">
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGDistrito
				set 
				MIGArid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGArid#">,
				BMusucodigo=#session.usucodigo#
			where MIGDiid=#arguments.MIGDiid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGArdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGArid" type="numeric" required="yes">
		<cfargument name="MIGRid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGArea
				set 
				MIGArdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGArdescripcion#">,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
				BMusucodigo=#session.usucodigo#,
				MIGRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGRid#">
			where MIGArid=#arguments.MIGArid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGArid" type="numeric" required="yes">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select a.MIGArid,a.MIGDicodigo,a.MIGDiid,b.MIGArid,b.MIGArcodigo
			from MIGDistrito a
				inner join MIGArea b
					on a.MIGArid=b.MIGArid
			where b.MIGArid=#arguments.MIGArid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>

		<cfif rsValida.recordCount EQ 0>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGArea
				where MIGArid=#arguments.MIGArid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		<cfelse>
			<cfthrow type="toUser" message="La Área #rsValida.MIGArcodigo# no puede ser eliminada ya que tiene asociaciones con Distritos.">
		</cfif>
	</cffunction>

</cfcomponent>