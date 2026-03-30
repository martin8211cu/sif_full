<cfcomponent>
    <cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>

    <cffunction name="insertarPago" access="public" >
		<cfargument name="ACCAid" 		type="numeric" 	required="yes">
        <cfargument name="ACCRPEfecha" 	type="string" 	required="yes">
        <cfargument name="ACCRPEmonto" 	type="numeric" 	required="yes">
        <cfargument name="BMUsucodigo" 	type="string" 	required="no" default="#session.Usucodigo#">
        <cfargument name="DSN" 			type="string" 	required="no" default="#session.DSN#">		
		
        <cfquery datasource="#arguments.DSN#">
			insert into ACCreditosRegistroPagoE(ACCAid, ACCRPEfecha, ACCRPEmonto, BMUsucodigo, BMfecha)
            values( <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.ACCAid#">,
					<cfqueryparam cfsqltype="cf_sql_date" 	 	value="#LSParsedateTime(arguments.ACCRPEfecha)#">,
					<cfqueryparam cfsqltype="cf_sql_money" 	 	value="#Arguments.ACCRPEmonto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.BMUsucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp"  value="#now()#"> )
		</cfquery>
	</cffunction>
    
    <cffunction name="modificarPago" access="public">
		<cfargument name="ACCRPEid"		type="numeric" 	required="yes">
		<cfargument name="ACCAid" 		type="numeric" 	required="yes">
        <cfargument name="ACCRPEfecha" 	type="string" 	required="yes">
        <cfargument name="ACCRPEmonto" 	type="numeric" 	required="yes">
        <cfargument name="DSN" 			type="numeric" 	required="no" default="#session.DSN#">

        <cfquery name="rsupdateDed" datasource="#arguments.DSN#">
			update ACCreditosRegistroPagoE
            set ACCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACCAid#">,
				ACCRPEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(arguments.ACCRPEfecha)#">,
				ACCRPEmonto = <cfqueryparam cfsqltype="cf_sql_money" 	 value="#Arguments.ACCRPEmonto#">
            where ACCRPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACCRPEid#">
		</cfquery>
	</cffunction>
    
    <cffunction name="eliminarPago" access="public" >
		<cfargument name="ACCRPEid" type="string" required="yes">
		<cfargument name="DSN" 		type="string" required="yes">		

        <cfquery datasource="#arguments.DSN#">
			delete from ACCreditosRegistroPagoE
            where ACCRPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACCRPEid#">
		</cfquery>
	</cffunction>
</cfcomponent>