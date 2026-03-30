<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="Ecodigo" 		    	type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="RHPCdocumento" 		type="string" 	required="yes">
		<cfargument name="RHPCdescripcion" 		type="string" 	required="yes">
		<cfargument name="RHPCfecha" 			type="date" 	required="yes">
		<cfargument name="Mcodigo" 				type="numeric" 	required="yes">
		<cfargument name="RHPCtipocambio" 		type="numeric" 	required="yes">		
		<cfargument name="RHPCtipo" 			type="numeric" 	required="no">
		<cfargument name="RHPCtotal" 			type="numeric" 	required="no">
		<cfargument name="RHPCfecha_aplica" 	type="date" 	required="no">
		<cfargument name="RHPCfecha_cancela" 	type="date" 	required="no">
		<cfargument name="NAP" 					type="numeric" 	required="no" 		default="-1">
		<cfargument name="NRP" 					type="numeric" 	required="no" 		default="0">
		<cfargument name="IDinterfaz" 			type="numeric" 	required="yes">
		<cfargument name="Conexion" 			type="string"  	required='false' 	default="#session.DSN#">
		
		<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
			insert into RHPlanillaComprometida
				(
				 Ecodigo,		RHPCdocumento,	RHPCdescripcion,
				 RHPCfecha, 	Mcodigo, 		RHPCtipocambio,
				 RHPCtipo,		RHPCtotal, 		RHPCfecha_aplica, 
				 NAP,			NRP,			IDinterfaz
				 )
			values(
				 <cfqueryparam value="#Arguments.Ecodigo#" 									cfsqltype="cf_sql_numeric">,
				 <cfqueryparam value="#Arguments.RHPCdocumento#"							cfsqltype="cf_sql_varchar">,
				 <cfqueryparam value="#Arguments.RHPCdescripcion#"							cfsqltype="cf_sql_varchar">,
				 
				 <cfqueryparam value="#Arguments.RHPCfecha#" 								cfsqltype="cf_sql_date">,
				 <cfqueryparam value="#Arguments.Mcodigo#" 									cfsqltype="cf_sql_numeric">,
				 <cfqueryparam value="#replace(Arguments.RHPCtipocambio,',','','all')#" 	cfsqltype="cf_sql_float">,
				 
				 <cfqueryparam value="#Arguments.RHPCtipo#" 								cfsqltype="cf_sql_numeric">,
				 <cfqueryparam value="#replace(Arguments.RHPCtotal,',','','all')#" 			cfsqltype="cf_sql_money">,
				 <cfqueryparam value="#Arguments.RHPCfecha_aplica#" 						cfsqltype="cf_sql_date">,
				 
			<cfif arguments.NAP GTE 0>
				 <cfqueryparam value="#Arguments.NAP#"  									cfsqltype="cf_sql_numeric">,
				 0,
			<cfelse>
				 -1,
				 <cfqueryparam value="#Arguments.NRP#"  									cfsqltype="cf_sql_numeric">,
			</cfif>
				 <cfqueryparam value="#Arguments.IDinterfaz#" 								cfsqltype="cf_sql_numeric">	
			)
			<cf_dbidentity1 datasource="#Arguments.Conexion#">
		</cfquery>
		<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsert">
		<cfreturn #rsInsert.identity#>
	</cffunction>
		
	<cffunction name="ALTAD" access="public">
		<cfargument name="RHPCid" 			type="numeric" 	required="yes">
		<cfargument name="RHPCDlinea" 		type="numeric" 	required="yes">
		<cfargument name="CFid" 			type="numeric" 	required="yes">
		<cfargument name="RHPCDmonto" 		type="numeric" 	required="yes">
		<cfargument name="CPcuenta" 		type="numeric" 	required="yes">
		<cfargument name="CPNRPDexcesoNeto" type="numeric" 	required="yes">		
		<cfargument name="IDinterfaz" 		type="numeric" 	required="yes">
		<cfargument name="Conexion" 		type="string"  	required='false' default="#session.DSN#">

		<cfquery datasource="#Arguments.Conexion#">
			insert into RHPlanillaComprometidaDet(
				RHPCid,			RHPCDlinea,	CFid, 
				RHPCDmonto, 	CPcuenta, 	CPNRPDexcesoNeto,
				IDinterfaz)
			values(
				<cfqueryparam value="#Arguments.RHPCid#" 										cfsqltype="cf_sql_numeric">,
			  	<cfqueryparam value="#Arguments.RHPCDlinea#" 									cfsqltype="cf_sql_numeric">,
			  	<cfqueryparam value="#Arguments.CFid#" 											cfsqltype="cf_sql_numeric">,
			  	<cf_jdbcquery_param value="#Replace(Arguments.RHPCDmonto,',','','all')#" 		cfsqltype="cf_sql_money" voidnull>,
			  	<cfqueryparam value="#Arguments.CPcuenta#" 										cfsqltype="cf_sql_numeric">,
			 	<cf_jdbcquery_param value="#Replace(Arguments.CPNRPDexcesoNeto,',','','all')#" 	cfsqltype="cf_sql_money" voidnull>,
			 	<cfqueryparam value="#Arguments.IDinterfaz#"									cfsqltype="cf_sql_numeric">
			 )
		</cfquery> 		
	</cffunction>
	
	<cffunction name="CAMBIO" access="public" returntype="numeric">
		<!---<cfargument name="RHPCid" 		  	type="numeric"  required="yes">--->
		<cfargument name="Ecodigo" 		    type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="RHPCdocumento" 	type="string" 	required="yes">
		<cfargument name="RHPCdescripcion" 	type="string" 	required="yes">
		<cfargument name="RHPCfecha" 		type="date" 	required="yes">
		<cfargument name="Mcodigo" 			type="numeric" 	required="yes">
		<cfargument name="RHPCtipocambio" 	type="numeric" 	required="yes">		
		<cfargument name="RHPCtipo" 		type="numeric" 	required="no">
		<cfargument name="RHPCtotal" 		type="numeric" 	required="no">
		<cfargument name="RHPCfecha_cancela" type="date" 	required="no" default="null">
		<cfargument name="NAP" 				type="numeric" 	required="no">
		<cfargument name="NRP" 				type="numeric" 	required="no">
		<cfargument name="IDinterfaz" 		type="numeric" 	required="yes">
		
		<cfquery name="insert" datasource="#arguments.Conexion#" >
			update RHPlanillaComprometida set
			Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_numeric">,
			<!---RHPCdocumento = <cfqueryparam value="#arguments.RHPCdocumento#"	cfsqltype="cf_sql_varchar">,--->
			RHPCdescripcion = <cfqueryparam value="#arguments.RHPCdescripcionl#"	cfsqltype="cf_sql_varchar">, 
			RHPCfecha = <cfqueryparam value="#LSParseDateTime(arguments.RHPCfecha)#" cfsqltype="cf_sql_date">,		
			Mcodigo = <cfqueryparam value="#arguments.Mcodigo#" cfsqltype="cf_sql_numeric">,
			RHPCtipocambio = <cfqueryparam value="#Replace(arguments.RHPCtipocambio,',','','all')#" 	cfsqltype="cf_sql_float">,
			RHPCtipo = <cfqueryparam value="#arguments.RHPCtipo#" cfsqltype="cf_sql_numeric">,
			RHPCtotal = <cfqueryparam value="#Replace(arguments.RHPCtotal,',','','all')#" cfsqltype="cf_sql_money">,
			RHPCfecha_cancela = <cfqueryparam value="#LSParseDateTime(arguments.RHPCfecha_cancela)#" 				cfsqltype="cf_sql_date">,					  	
			 <cfif arguments.NAP GTE 0>
				NAP = <cfqueryparam value="#arguments.NAP#"  cfsqltype="cf_sql_numeric">, NRP = 0		
			 <cfelse>
				NAP = -1, NRP = <cfqueryparam value="#arguments.NRP#"  cfsqltype="cf_sql_numeric">
			 </cfif>
			,IDinterfaz = <cfqueryparam value="#arguments.IDinterfaz#" cfsqltype="cf_sql_numeric">	 
			)
			where RHPCdocumento = <cfqueryparam value="#arguments.RHPCdocumento#"	cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfquery  name = "getRHPCid" datasource="#arguments.Conexion#">
			select RHPCid from RHPlanillaComprometida
			where RHPCdocumento = <cfqueryparam value="#arguments.RHPCdocumento#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfreturn #getRHPCid.RHPCid#>
	</cffunction>
			
</cfcomponent>