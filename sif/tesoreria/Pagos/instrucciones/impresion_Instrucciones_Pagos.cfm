<!--- 
	Creado por: Gustavo Fonseca H.
		Fecha: 28-6-2005
		Motivo: Mantenimiento de Instrucciones de Pago. 
--->

<cfif isdefined('url.btnNuevo')>
	<cfset form.btnNuevo = url.btnNuevo>
</cfif>

<cf_templateheader title="Emisión de Órdenes de Pago">
	<cf_navegacion name="btnNuevo">
	<cfset titulo = 'Emisión de Órdenes de Pago - Impresión de Instrucciones de Pago'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cf_navegacion name="TESTLid">
		<cf_navegacion name="CBid">
		<cfset form.Impresion =1>
		<cfif isdefined("form.btnNuevo") OR isdefined("form.TESTLid") and form.TESTLid NEQ "">
			<cfinclude template="impresion_Instrucciones_Pagos_form.cfm">
		<cfelse>
			<cfinclude template="impresion_Instrucciones_Pagos_lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>	


