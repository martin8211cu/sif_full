<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cf_templateheader title="Exportar Seguridad de Mascaras de Cuentas de Usuarios">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Exportar Seguridad de Mascaras de Cuentas de Usuarios">
		<cfinclude template="exportar_SMaskUser-form.cfm">
    <cf_web_portlet_end> 
<cf_templatefooter>
