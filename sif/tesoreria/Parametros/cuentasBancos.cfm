<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cf_templateheader title="Cuentas Bancarias de Pago">
	<cf_web_portlet_start titulo="Cuentas Bancarias de Pago">
		<cfinclude template="cuentasBancos_form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>	


