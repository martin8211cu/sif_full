<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" type="numeric" required="yes">
		<cfargument name="MIGGcodigo" type="string" required="yes">
		<cfargument name="MIGGdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGSDid" type="numeric" required="yes">
		
		<cfquery name="rsCodigoGerencia" datasource="#session.dsn#">
			select MIGGcodigo
			from MIGGerencia
			where MIGGcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGGcodigo)#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cfif rsCodigoGerencia.recordCount EQ 0>
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGGerencia
					(
						CodFuente,
						MIGGcodigo,
						MIGGdescripcion,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						<!--- ts_rversion, --->
						Ecodigo,
						MIGSDid,
						CEcodigo
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.MIGGcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGGdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						<!--- <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, --->
						#session.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGSDid#">,
						#session.CEcodigo#
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGGDid">
			<cfset varReturn=#LvarMIGGDid#>	
			<cfreturn #varReturn#>
		<cfelse>
			<cfthrow type="toUser" message="El Código de la Gerencia #rsCodigoGerencia.MIGGcodigo# ya existe en Sistema.">
		</cfif>
		</cffunction>
		
		<cffunction access="public" name="AgregarDepartamentos" >
			<cfargument name="MIGGid" type="numeric" required="yes">
			<cfargument name="Dcodigo" type="numeric" required="yes">
			<cfargument name="Deptocodigo" type="string" required="yes">
			<cfquery name="Actualiza" datasource="#session.dsn#">
				update Departamentos
					set 
					MIGGid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGGid#">,
					BMusucodigo=#session.usucodigo#
				where Dcodigo=#arguments.Dcodigo#
				and Ecodigo=#session.Ecodigo#		
			</cfquery>
	</cffunction>
	
	
	<cffunction access="public" name="Cambio" >
		<cfargument name="MIGGdescripcion" type="string" required="yes">
		<cfargument name="Dactiva" type="numeric" required="yes">
		<cfargument name="MIGSDid" type="numeric" required="yes">
		<cfargument name="MIGGid" type="numeric" required="yes">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGGerencia
				set 
				MIGGdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MIGGdescripcion#">,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
				BMusucodigo=#session.usucodigo#,
				MIGSDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGSDid#">
			where MIGGid=#arguments.MIGGid#
			and Ecodigo=#session.Ecodigo#		
		</cfquery>
	</cffunction>
	

	<cffunction access="public" name="Baja">
		<cfargument name="MIGGid" type="numeric" required="yes">
		<cfquery name="rsValida" datasource="#session.dsn#">
			select a.Dcodigo,a.Deptocodigo,b.MIGGid,b.MIGGcodigo
			from Departamentos a
				inner join MIGGerencia b
					on a.MIGGid=b.MIGGid
			where a.Ecodigo=#session.Ecodigo#
			and b.MIGGid=#arguments.MIGGid#
		</cfquery>

		<cfif rsValida.recordCount EQ 0>
			<cfquery name="Elimiar" datasource="#session.dsn#">
				delete from MIGGerencia
				where MIGGid=#arguments.MIGGid#
				and Ecodigo=#session.Ecodigo#
			</cfquery>
		<cfelse>
			<cfthrow type="toUser" message="La Gerencia #rsValida.MIGGcodigo# no puede ser eliminada ya que tiene asociaciones con Departamentos.">
		</cfif>
	</cffunction>
</cfcomponent>