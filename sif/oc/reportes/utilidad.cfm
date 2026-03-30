<cfif IsDefined('form.btnGenerar')>
<!---	<cf_PleaseWait SERVER_NAME="/cfmx/sif/oc/reportes/utilidad.cfm"> --->
	<cfinclude template="utilidad-sql.cfm">
	<cfinclude template="utilidad-report.cfm">
<cfelse>
	<cfsavecontent variable="pNavegacion">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
	</cfsavecontent>
	<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfinclude template="utilidad-form.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>
</cfif>