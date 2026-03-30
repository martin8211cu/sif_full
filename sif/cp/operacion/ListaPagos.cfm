<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_LstPagos = t.Translate('TIT_LstPagos','Lista de Pagos sin Aplicar')>
<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_LstPagos#'>		
			<cfinclude template="formListaPagos.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>