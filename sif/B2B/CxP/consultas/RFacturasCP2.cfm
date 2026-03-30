<cfset regresar = "/cfmx/sif/B2B/CxP/MenuCP.cfm"> 
<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="/sif/portlets/pNavegacionCP.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consulta de Documentos">
			<cfinclude template="RFacturasCP2-Form.cfm"> 
		<cf_web_portlet_end>
<cf_templatefooter>