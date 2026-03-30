<cfcomponent output="no">
<cffunction name="sumar" access="remote" returntype="numeric">
	<cfargument name="a" type="numeric" required="yes">
	<cfargument name="b" type="numeric" required="yes">
    
    <cfreturn a+b>

</cffunction>
</cfcomponent>