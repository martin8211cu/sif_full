	<cfoutput> <strong>getBaseTemplatePath:</strong>#getBaseTemplatePath()#</cfoutput><br />
	<cfoutput> <strong>len:</strong>#len(expandPath("/"))#</cfoutput><br />
<cfset LvarTemplate = mid(getBaseTemplatePath(),len(expandPath("/")),200)>
	<cfoutput> <strong>LvarTemplate:</strong>#LvarTemplate#</cfoutput><br />
    <cfoutput> <strong>replace:</strong>#replace(LvarTemplate,"\","/","ALL")#</cfoutput><br />
<cfset LvarTemplate = '/cfmx' & replace(LvarTemplate,"\","/","ALL")>
	<cfoutput>#LvarTemplate#</cfoutput>