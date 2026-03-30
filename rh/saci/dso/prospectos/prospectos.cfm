<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="#nav__SPdescripcion#">

		<cfif isdefined("url.r")>
			<cfinclude template="prospectos-result.cfm">
		<cfelse>
			<cfinclude template="prospectos-form.cfm">
		</cfif>

	<cf_web_portlet_end> 
	
<cf_templatefooter>
