<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfinclude template="ReporteTransportesOC-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>

