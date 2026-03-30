<cfcomponent>
	<cffunction name="getCPcodigo" access="public" returntype="string">
		<cfargument name="Pais" type="string" required="yes">
        <cfquery name="rsCodigoPais" datasource="asp">
            select CPcodigo
            from CPais
            where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pais#">
        </cfquery>        
		<cfif rsCodigoPais.RecordCount eq 0>
        	<cfset codigo_pais = '00000'>
        <cfelse>
        	<cfset codigo_pais = Mid(NumberFormat(trim(rsCodigoPais.CPcodigo),'00000'),1,5) >
        </cfif>
		<cfreturn codigo_pais>
	</cffunction>
</cfcomponent>





