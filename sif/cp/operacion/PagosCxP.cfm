<cfif isdefined("Url.pageNum_rsLista") and not isdefined("Form.pageNum_rsLista")>
	<cfparam name="Form.pageNum_rsLista" default="#Url.pageNum_rsLista#">
</cfif>
<cfif isdefined("Url.Fecha") and not isdefined("Form.Fecha")>
	<cfparam name="Form.Fecha" default="#Url.Fecha#">
</cfif>
<cfif isdefined("Url.Transaccion") and not isdefined("Form.Transaccion")>
	<cfparam name="Form.Transaccion" default="#Url.Transaccion#">
</cfif>
<cfif isdefined("Url.Usuario") and not isdefined("Form.Usuario")>
	<cfparam name="Form.Usuario" default="#Url.Usuario#">
</cfif>
<cfif isdefined("Url.Moneda") and not isdefined("Form.Moneda")>
	<cfparam name="Form.Moneda" default="#Url.Moneda#">
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 	= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_RegPagos	= t.Translate('TIT_RegPagos','Registro de Pagos Manuales')>
		
<cfset MSG_NosehaDefelConcContOri 	= t.Translate('MSG_NosehaDefelConcContOri','No se ha definido el Concepto Contable para el Origen','/sif/cp/operacion/PagosCxP.xml')>
<cfset MSG_ElConcCont 	= t.Translate('MSG_ElConcCont','El Concepto Contable','/sif/cp/operacion/PagosCxP.xml')>
<cfset MSG_noexisteenCia 	= t.Translate('MSG_noexisteenCia','no existe para esta compañía.','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_Periodo  = t.Translate('LB_Periodo','Periodo','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_Origen  = t.Translate('LB_Origen','Origen','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_Referencia  = t.Translate('LB_Referencia','Referencia','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_Lin = t.Translate('LB_Lin','Lin','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_CtaCont 	= t.Translate('LB_CtaCont','Cuenta Contable','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_RefDocto 	= t.Translate('LB_RefDocto','Ref-Documento','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_CFuncional = t.Translate('LB_CFuncional','C. Funcional','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_MontoExtr 	= t.Translate('LB_MontoExtr','Monto Extranjero','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_TpoCambio	= t.Translate('LB_TpoCambio','Tipo Cambio','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_MontoLocal 	= t.Translate('LB_MontoLocal','Monto Local','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_BALMONLOC	= t.Translate('LB_BALMONLOC','BALANCE EN MONEDA LOCAL','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_BALMONEXT	= t.Translate('LB_BALMONEXT','BALANCE EN MONEDA EXTRANJERA','/sif/cp/operacion/PagosCxP.xml')>
<cfset LB_BALMONEXTOFI	= t.Translate('LB_BALMONEXTOFI','BALANCE EN MONEDA EXTRANJERA POR OFICINA','/sif/cp/operacion/PagosCxP.xml')>

<cf_templateheader title="#LB_TituloH#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_RegPagos#'>
		<cfinclude template="formPagosCxP.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>