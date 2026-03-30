<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cf_templateheader title="Exportador de Seguridad por Usuario">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Exportar seguridad de usuarios">
		<cfinclude template="exportar_User-form.cfm">
    <cf_web_portlet_end>
<cf_templatefooter>