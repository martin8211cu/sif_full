<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="GECid" 			type="numeric" 	required="no">
		<cfargument name="GECIorigen" 		type="string" 	required="no">
		<cfargument name="GECIdestino" 		type="string" 	required="no">
		<cfargument name="GECIhotel" 		type="string" 	required="no">
		<cfargument name="GECIfsalida" 		type="date" 	required="no">
		<cfargument name="GECIhinicio" 		type="numeric" 	required="no">
		<cfargument name="GECIhfinal" 		type="numeric" 	required="no">
		<cfargument name="GECIlineaAerea" 	type="string" 	required="no">
		<cfargument name="GECInumeroVuelo"	type="string" 	required="no">        
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="#session.usucodigo#">
        
		<cfquery datasource="#session.dsn#">
			insert into GECitinerario (
				GECid,
                GECIorigen,     
                GECIdestino,   
                GECIhotel,
                GECIfsalida,
                GECIhinicio,
                GECIhfinal,
                GECIlineaAerea,
                GECInumeroVuelo,
				BMUsucodigo   
			)
   			values(
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GECid#" null="#arguments.GECid EQ ""#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECIorigen#" null="#arguments.GECIorigen EQ ""#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECIdestino#" null="#arguments.GECIdestino EQ ""#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECIhotel#" null="#arguments.GECIhotel EQ ""#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.GECIfsalida)#" null="#arguments.GECIhotel EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GECIhinicio#" null="#arguments.GECIhinicio EQ ""#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GECIhfinal#" null="#arguments.GECIhfinal EQ ""#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECIlineaAerea#" null="#arguments.GECIlineaAerea EQ ""#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECInumeroVuelo#" null="#arguments.GECInumeroVuelo EQ ""#">,
				#arguments.BMUsucodigo#	
			)
		</cfquery>
			
		<cfquery name="rsSelectId" datasource="#session.dsn#">
			select max(GECIid)as id from GECitinerario
		</cfquery>
		<cfreturn #rsSelectId.id#>
	</cffunction>
	
	<cffunction name="CAMBIO" access="public" returntype="numeric">
	    <cfargument name="GECIid"			type="numeric" 	required="yes">
		<cfargument name="GECid" 			type="numeric" 	required="no">
		<cfargument name="GECIorigen" 		type="string" 	required="no">
		<cfargument name="GECIdestino" 		type="string" 	required="no">
		<cfargument name="GECIhotel" 		type="string" 	required="no">
		<cfargument name="GECIfsalida" 		type="date" 	required="no">
		<cfargument name="GECIhinicio" 		type="numeric" 	required="no">
		<cfargument name="GECIhfinal" 		type="numeric" 	required="no">
		<cfargument name="GECIlineaAerea" 	type="string" 	required="no">
		<cfargument name="GECInumeroVuelo"	type="string" 	required="no">        
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="#session.usucodigo#">

		<cfquery datasource="#session.dsn#">
			update 		GECitinerario
            set 		GECIorigen		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECIorigen#" null="#arguments.GECIorigen EQ ""#">,     
                        GECIdestino		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECIdestino#" null="#arguments.GECIdestino EQ ""#">,   
                        GECIhotel		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECIhotel#" null="#arguments.GECIhotel EQ ""#">,
                        GECIfsalida		= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.GECIfsalida)#" null="#arguments.GECIhotel EQ ""#">,
                        GECIhinicio		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GECIhinicio#" null="#arguments.GECIhinicio EQ ""#">,
                        GECIhfinal		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.GECIhfinal#" null="#arguments.GECIhfinal EQ ""#">,
                        GECIlineaAerea	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECIlineaAerea#" null="#arguments.GECIlineaAerea EQ ""#">,
                        GECInumeroVuelo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.GECInumeroVuelo#" null="#Len(arguments.GECInumeroVuelo) is 0#">, 
                        BMUsucodigo		= #arguments.BMUsucodigo#  
			where GECIid= #arguments.GECIid#
		</cfquery>
		<cfreturn #arguments.GECIid#>
	</cffunction>
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="GECIid" 	type="numeric" required="yes">

		<cfquery datasource="#session.dsn#">
			delete from GECitinerario
			where GECIid=#arguments.GECIid#
		</cfquery>
		<cfreturn #arguments.GECIid#>
	</cffunction>
</cfcomponent>