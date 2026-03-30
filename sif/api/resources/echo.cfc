<cfcomponent extends="taffy.core.resource" taffy_uri="/echo">

    <cffunction name="get" access="public" output="false">
        
		<cfset status = 200>
		<cfscript>
			result=StructNew();
		</cfscript>
		
        <cfset result["data"] =  "Response from API">
        
        <cfreturn representationOf(result).withStatus(status) />

	</cffunction>
	
</cfcomponent>
