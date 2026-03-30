<cfcomponent output="false">
	<cffunction name = "echoString" 			
				returnType = "string" 			
				output = "no" 			
				access = "remote">
		<cfargument name = "input" type = "string">
		<cfreturn #arguments.input#>
	</cffunction>
</cfcomponent>
