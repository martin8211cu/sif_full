<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfinclude  template="aftfHojasCoteo-common.cfm">
		<cfif (isdefined("form.AFTFid_hoja") and len(trim(form.AFTFid_hoja)) gt 0 and form.AFTFid_hoja gt 0)or (isdefined("form.btnNuevo")) or (isdefined("form.Nuevo"))>
			<cfinclude template="aftfHojasCoteo-form.cfm">
		<cfelse>
			<cfinclude template="aftfHojasCoteo-lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>