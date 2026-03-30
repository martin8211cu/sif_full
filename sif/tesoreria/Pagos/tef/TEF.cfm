<!--- 
	Creado por: Oscar Bonilla
		Fecha: 4-NOV-2009
		Motivo: Emisión de Transferencias de Fondos
				Impresión de Instrucciones de Pago y
				Generación de Transferencias Electrónicas
--->

<cfif isdefined('url.btnNuevo')>
	<cfset form.btnNuevo = url.btnNuevo>
</cfif>

<cf_templateheader title="Emisión de Órdenes de Pago">
	<cf_navegacion name="btnNuevo">
	<cfset titulo = #GvarTEF.Proceso#>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cf_navegacion name="TESTLid">
		<cf_navegacion name="CBid">
		<cfset form.Impresion =1>
		<cfif isdefined("form.btnNuevo") OR isdefined("form.TESTLid") and form.TESTLid NEQ "">
			<cfinclude template="TEF_form.cfm">
		<cfelse>
			<cfinclude template="TEF_lista.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>	


