<cfif isdefined("url.desde") and not isdefined("form.desde")>
	<cfset session.modulo = url.desde>
<cfelseif isdefined("form.desde")>
	<cfset session.modulo = form.desde>
<cfelse>	
	<cfset Session.modulo="MB">
</cfif>

<cfif session.modulo eq 'AD'><cfparam default="Administración del Sistema" name="title"><cfelse><cfparam default="Bancos" name="title"></cfif>
<cfparam default="Bancos" name="moduleName">
<cfparam default="/cfmx/sif/mb/MenuMB.cfm" name="moduleRef">
<cfinclude template="/sif/portlets/pHeader.cfm">
<cfset modulo = 'MenuMB.cfm'>
