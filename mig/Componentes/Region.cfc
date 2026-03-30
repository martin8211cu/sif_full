<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGRcodigo" type="string" required="yes">
		<cfargument name="MIGRdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGPaid" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGRcodigo) as MIGRcodigo
			from MIGRegion
			where MIGRcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGRcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount EQ 0>			
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGRegion
					(
						CodFuente,
						MIGRcodigo,
						MIGRdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->
						MIGPaid,
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGRcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGPaid#">,
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGRid">
			<cfset varReturn=#LvarMIGRid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código de la Región #rsValida.MIGRcodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="AgregaArea">
		<cfargument name="MIGArid" type="numeric" required="yes">
		<cfargument name="MIGRid" type="numeric" required="yes">
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGArea
				set 
				MIGRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGRid#">,
				BMusucodigo=#session.usucodigo#
			where MIGArid=#arguments.MIGArid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGRdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGRid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGRegion 
				set 
				MIGRdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGRdescripcion#">,
				MIGPaid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGPaid#">,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
				BMusucodigo=#session.usucodigo#
			where MIGRid=#arguments.MIGRid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGRid" type="numeric" required="yes">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select a.MIGArid,a.MIGArcodigo,b.MIGRid,b.MIGRcodigo
			from MIGArea a
				inner join MIGRegion b
					on a.MIGRid=b.MIGRid
			where b.MIGRid=#arguments.MIGRid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>

		<cfif rsValida.recordCount EQ 0>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGRegion
				where MIGRid=#arguments.MIGRid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		<cfelse>
			<cfthrow type="toUser" message="La Región #rsValida.MIGRcodigo# no puede ser eliminada ya que tiene asociaciones con Área.">
		</cfif>
	</cffunction>

</cfcomponent>