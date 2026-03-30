<cfset LvarUrl = "">
<cfif isdefined("Url")>
	<cfloop collection="#url#" item="i">
		<cfif findnocase("|#i#|", "|CFID|CFTOKEN|JSESSIONID|") EQ 0>
			<cfset LvarUrl = LvarUrl & "&" & i & "=" & StructFind(url, i)>
		</cfif>
	</cfloop>
	<cfif LvarUrl NEQ "">
		<cfset LvarUrl = "?" & mid(LvarUrl,2,255)>
	</cfif>
</cfif>
<cflocation url="/cfmx/home/menu/modulo.cfm#LvarUrl#">
