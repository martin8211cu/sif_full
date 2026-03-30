<!--- <cf_dump var="#form#">--->

<!--- JMRV. 12/08/2014. --->
	
<cf_templateheader title="Contrato a cancelar"> 
<cfinclude template="/sif/Utiles/sifConcat.cfm">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfset titulo = 'Contrato a cancelar'>
  <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">

		<cfinclude template="cancelacionContratos_muestraContrato.cfm">
	
  <cf_web_portlet_end>
<cf_templatefooter>



	


