<cfif Not IsDefined('session.pdm')>
	<cfset session.pdm = StructNew()>
	<cfset session.pdm.file = "Workflow.pdm">
	<cfset session.pdm.path = "/sif/Basura/gen" >
	<cfset session.pdm.app  = "sdc" >
</cfif>