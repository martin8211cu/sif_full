<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
	
		<cfinclude template="prepagos-params.cfm">
		<cfinclude template="prepagosMasivo-form.cfm">
		
	<cf_web_portlet_end>	
<cf_templatefooter>