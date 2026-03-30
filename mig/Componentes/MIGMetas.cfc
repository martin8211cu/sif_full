<cfcomponent>
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="CodFuente" 		type="numeric" required="yes">
		<cfargument name="MIGMid" 			type="numeric" required="yes">
		<cfargument name="Pfecha" 			type="date" required="yes">
		<cfargument name="Meta" 			type="any" required="yes">
		<cfargument name="Metaadicional" 	type="any" required="yes">
		<cfargument name="Dactiva" 			type="numeric" required="yes">
		<cfargument name="Periodo" 			type="any" required="yes">
		<cfargument name="Periodo_Tipo" 	type="any" required="yes">
		<cfargument name="Peso" 	type="string" required="no" default="0">
			<cfquery datasource="#session.dsn#" name="insert">
					insert into MIGMetas
					(
						CodFuente,
						MIGMid,
						Pfecha,
						Meta,
						Metaadicional,
						Dactiva,
						BMusucodigo,
						FechaAlta,
						Ecodigo,
						CEcodigo,
						Periodo,
						Periodo_Tipo,
						Peso
					)
					values(
						1,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MIGMid#">,
						<cfqueryparam cfsqltype="cf_sql_date"    value="#LSparseDateTime(arguments.Pfecha)#">,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#arguments.Meta#">,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#arguments.Metaadicional#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,						
						#session.usucodigo#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						#session.Ecodigo#,
						#session.CEcodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Periodo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Periodo_Tipo#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Peso#">
					) 
					<cf_dbidentity1 datasource="#session.DSN#" name="insert">
				</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="LvarMIGMetaid">
			<cfset varReturn=#LvarMIGMetaid#>	
			<cfreturn #varReturn#>
	</cffunction>	
	<cffunction access="public" name="Cambio">
		<cfargument name="MIGMetaid" 		type="numeric" required="yes">
		<cfargument name="Pfecha" 			type="date" required="yes">
		<cfargument name="Meta" 			type="any" required="yes">
		<cfargument name="Metaadicional" 	type="any" required="yes">
		<cfargument name="Dactiva" 			type="numeric" required="yes">
		<cfargument name="Peso" 			type="string" required="no" default="0">
		
		<cfquery name="Actualiza" datasource="#session.dsn#">
			update MIGMetas
				set 
				Pfecha=<cfqueryparam cfsqltype="cf_sql_date"    value="#LSparseDateTime(arguments.Pfecha)#">,
				Meta=<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Meta#">,
				Metaadicional=<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Metaadicional#">,
				Dactiva=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Dactiva#">,
				Peso=<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Peso#">,
				BMusucodigo=#session.usucodigo#
			where MIGMetaid=#arguments.MIGMetaid#		
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>
	
	<cffunction access="public" name="Baja">
		<cfargument name="MIGMetaid" type="numeric" required="yes">
		<cfquery datasource="#session.dsn#">
			update MIGMetas
				set 
				Dactiva=0,
				BMusucodigo=#session.usucodigo#
			where MIGMetaid=#arguments.MIGMetaid#		
			and Ecodigo=#session.Ecodigo#
		</cfquery>
	</cffunction>

</cfcomponent>