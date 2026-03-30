<cf_navegacion name="CPPid">
<cfparam name="Status" default="2">
<cfparam name="modo" default="ALTA">
<cfif isdefined('form.CPPid') and len(trim(form.CPPid))>
	<cfset modo = 'CAMBIO'>
</cfif>
<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Equilibrio Financiero">
		<cfif isdefined('url.Equilibrio') and isdefined('url.CurrentPage') and len(trim(url.CurrentPage))>
			<cfinclude template="#url.CurrentPage#">
		<cfelse>
			<cfif modo EQ 'ALTA'>
				<cfinclude template="Equilibrio-lista.cfm">
			<cfelse>
				<cfinclude template="Equilibrio-form.cfm">
			</cfif>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>