<cfcomponent>
	<cffunction name="fnGetStackTrace" access="public" returntype="string">
		<cfargument name="LprmError">
	
		<cfset TemplateRoot = Replace(ExpandPath(""), "\", "/",'all')>
		<cfset LvarStackTrace = "<strong>ERROR DE EJECUCION:</strong> (Type: #LprmError.Type#)<BR>#LprmError.Message#<BR>">
		<cfif trim(LprmError.Detail) NEQ "">
			<cfset LvarStackTrace = LvarStackTrace & "#LprmError.Detail#<BR>">
		</cfif>
		<cfif IsDefined("LprmError.TagContext") and IsArray(LprmError.TagContext) and ArrayLen(LprmError.TagContext) NEQ 0>
			<cfset LvarStackTrace = LvarStackTrace & "<strong>Template Stack Trace</strong>:<br>">
			<cfloop from="1" to="#ArrayLen(LprmError.TagContext)#" index="i">
				<cfset TagContextTemplate = LprmError.TagContext[i].Template>
				<cfset TagContextTemplate = Replace(TagContextTemplate, "\", "/", 'all')>
				<cfset TagContextTemplate = ReplaceNoCase(TagContextTemplate, TemplateRoot, "")>
				<cfset LvarStackTrace = LvarStackTrace & " at " & 
					TagContextTemplate & ":" &
					LprmError.TagContext[i].Line>
					<cfset LvarTagContextI = LprmError.TagContext[i]>
					<cfif isdefined('LvarTagContextI.ID')>
						<cfset LvarStackTrace = LvarStackTrace  & " (" & LprmError.TagContext[i].ID & ")">
					</cfif>
				<cfset LvarStackTrace = LvarStackTrace & "<br>" >
			</cfloop>
		</cfif>
		<cfreturn LvarStackTrace>
	</cffunction>
</cfcomponent>