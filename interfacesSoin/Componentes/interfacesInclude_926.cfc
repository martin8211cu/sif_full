<cfcomponent>
	<cffunction name="fnInclude" access="public" returntype="struct" output="no">
		<cfargument name="CFM" 	type="string" required="yes">
		<cfargument name="var" 	type="struct" required="yes">

		<cfset sbSetVariables (Arguments.var)>
		<cfinclude template="#Arguments.CFM#">

		<cfreturn variables>
	</cffunction>

	<cffunction  name="sbSetVariables" access="private" returntype="void" output="no">
		<cfargument name="var" type="struct">
		<cfset var item = "">
		<cfloop collection="#Arguments.var#" item="item">
			<cfif ucase(left(item,4)) EQ "GVAR">
				<cfset variables[item] = Arguments.var[item]>
			</cfif>
		</cfloop>
	</cffunction>
</cfcomponent>
