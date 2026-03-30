

<cfcomponent>

	<cffunction name="genDispersion" returntype="bool" output="no">
		<cfargument name="OP_IDs" required="yes">
		<cfargument name="Value" required="yes">
		<cfargument name="Delimiters" required="no" default=",">
		<cfset count = 0>
		<cfloop list="#Arguments.List#" index="Item" delimiters="#Arguments.Delimiters#">
			<cfset count = count + 1>
			<cfif trim(lcase(Item)) eq trim(lcase(Arguments.Value))>
				<cfreturn count>
			</cfif>
		</cfloop>
		<cfreturn 0>
	</cffunction>

</cfcomponent>
