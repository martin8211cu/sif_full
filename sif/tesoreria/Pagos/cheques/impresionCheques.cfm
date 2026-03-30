<cfif isdefined('url.btnNuevo')>
	<cfset form.btnNuevo = url.btnNuevo>
</cfif>

<cf_templateheader title="Emisión de Órdenes de Pago">
	<cf_navegacion name="btnNuevo">
	<cfset titulo = 'Emisión de Órdenes de Pago - Impresion de Cheques'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cf_navegacion name="TESCFLid">
		<cf_navegacion name="CBid">
		
		<cfset form.Impresion =1>
		<cfif isdefined("form.btnNuevo") OR isdefined("form.TESCFLid") and form.TESCFLid NEQ "">
			<cfinclude template="impresionCheques_form.cfm">
		<cfelse>
			<cfinclude template="impresionCheques_lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>	


