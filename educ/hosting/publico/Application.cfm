<cfinclude template="/Application.cfm">
<!--- <cfdump var="#session#"> --->
<cfif Len(session.sitio.cliente_empresarial) IS 0 and Not IsDefined("url.invalid")>
	<cfinclude template="invalid/index.cfm"><cfabort>
	<cflocation url="invalid/?invalid=21579786erjEireuE4E">
</cfif>
<cfinclude template="ApplicationPublic.cfm">
