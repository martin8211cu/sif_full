<!---<cfset regresar = "/cfmx/sif/cp/MenuCP.cfm"> 
--->
<cf_templateheader title="Amortizaci&oacute;n de Documentos">
	<cfinclude template="../../sif/portlets/pNavegacionCP.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Consulta de Documentos">
			<cfinclude template="amortizacionSeleccion.cfm"> 
		<cf_web_portlet_end>
<cf_templatefooter>