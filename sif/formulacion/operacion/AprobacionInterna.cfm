<cf_navegacion name="CPPid">
<cfparam name="Status" default="3">
<cfparam name="modo" default="ALTA">
<cfif isdefined('form.CPPid') and len(trim(form.CPPid))>
	<cfset modo = 'CAMBIO'>
</cfif>
<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Aprobación Interna">
		<cfif modo EQ 'ALTA'>
			<cfinclude template="Equilibrio-lista.cfm">
		<cfelse>
			<cfinclude template="Equilibrio-form.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>