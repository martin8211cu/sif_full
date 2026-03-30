<cfcomponent extends="taffy.core.resource" taffy_uri="/logout">

	<cffunction name="post" access="public" output="false">

		<cftry>
			<cfquery datasource="aspmonitor">
				update mp set cerrada = 1
				from MonProcesos mp
				where CONVERT(VARCHAR(32),HashBytes('MD5', convert(varchar(32),sessionid)),2) = '#arguments.userData.token#'
			</cfquery>
			
			<cfscript>
				return representationOf({}).withStatus(200);
			</cfscript>
		<cfcatch type="any">
			<cfset result = structNew()>
			<cfset result["message"] = "#cfcatch.message#">
			<cfset result["errorcode"] = 99>
			<cfreturn representationOf(result).withStatus(500) />
		</cfcatch>
		</cftry>
	</cffunction>

	
</cfcomponent>
