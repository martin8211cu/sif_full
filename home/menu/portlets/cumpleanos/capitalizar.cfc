<cfcomponent>
	<cffunction name="capitalizar" output="false">
		<cfargument name="s">
		<cfset var r = "">
		
		<cfloop list="#Arguments.s#" index="i" delimiters=" ">
			<cfset r = r & " " & UCase(Mid(i,1,1)) & LCase(Mid(i,2,Len(i)-1))>
		</cfloop>
		<cfreturn r>
	</cffunction>
</cfcomponent>