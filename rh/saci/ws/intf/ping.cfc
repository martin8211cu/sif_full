<cfcomponent>
	<cffunction name="ping" returntype="string" access="remote">
		<cfargument name="s" type="string" required="yes">
		<cfreturn '#s#-#session.usuario#'>
	</cffunction>
</cfcomponent>