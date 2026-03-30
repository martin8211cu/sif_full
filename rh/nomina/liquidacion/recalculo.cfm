<cf_templateheader title="Recalculo de Liquidaciones">

<cf_web_portlet_start border="true" titulo="Recalculo de Liquidaciones" skin="#Session.Preferences.Skin#">

<cfif isdefined ('url.DEid') and len(trim(url.DEid)) gt 0 and not isdefined('form.DEid')>
	<cfset form.DEid=url.DEid>
</cfif>
<cfif isdefined('form.DEid') and len(trim(form.DEid)) gt 0>
	<cfinclude template="recalculo-form.cfm">
<cfelse>
	<cfinclude template="recalculo-lista.cfm">
</cfif>
  <cf_web_portlet_end>
<cf_templatefooter>




