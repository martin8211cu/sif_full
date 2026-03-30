<cfcomponent displayname="Authorization" output="false">
    <cfset variables.dsn = "minisif">
    <cfset variables.ecodigo = 2>

    <cffunction name="ValidateApiKey" access="public" output="false">
        <cfset sreturn =  structNew()>
        <cfset var headers = getHttpRequestData().headers>
        <cfif NOT structKeyExists(headers, "x-api-key")>
            <cfthrow message="Unauthorized">
        </cfif>

        <cfset var token = trim(headers['x-api-key'])>

        <cfif token NEQ "full-web-cred-20251001">
            <cfthrow message="Forbidden">
        </cfif>

    </cffunction>
</cfcomponent>