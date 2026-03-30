<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGPacodigo" type="string" required="yes">
		<cfargument name="MIGPadescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		
		<cfquery name="rsValida" datasource="#session.dsn#">
			select rtrim(MIGPacodigo) as MIGPacodigo
			from MIGPais
			where MIGPacodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGPacodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfif rsValida.recordCount EQ 0>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGPais
					(
						CodFuente,
						MIGPacodigo,
						MIGPadescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->
						Ecodigo,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGPacodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGPadescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						#session.Ecodigo#,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGPaid">
			<cfset varReturn=#LvarMIGPaid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código de la País #rsValida.MIGPacodigo# ya existe en Sistema.">
		</cfif>
	</cffunction>
	
	<cffunction access="public" name="AgregaRegion">
		<cfargument name="MIGRid" type="numeric" required="yes">
		<cfargument name="MIGPaid" type="numeric" required="yes">
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGRegion
				set 
				MIGPaid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGPaid#">,
				BMusucodigo=#session.usucodigo#
			where MIGRid=#arguments.MIGRid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	
	</cffunction>
	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGPadescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGPaid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGPais
				set 
				MIGPadescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGPadescripcion#">,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
				BMusucodigo=#session.usucodigo#
			where MIGPaid=#arguments.MIGPaid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGPaid" type="numeric" required="yes">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select a.MIGRid,b.MIGPaid,a.MIGRcodigo,b.MIGPacodigo
			from MIGRegion a
				inner join MIGPais b
					on a.MIGPaid=b.MIGPaid
			where b.MIGPaid=#arguments.MIGPaid#
			and a.Ecodigo=#session.Ecodigo#
		</cfquery>

		<cfif rsValida.recordCount EQ 0>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGPais
				where MIGPaid=#arguments.MIGPaid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		<cfelse>
			<cfthrow type="toUser" message="El País #rsValida.MIGPacodigo# no puede ser eliminada ya que tiene asociaciones con Región.">
		</cfif>
	</cffunction>

</cfcomponent>