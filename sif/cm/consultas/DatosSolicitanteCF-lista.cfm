<cf_templateheader title="Compras - Consulta de Datos de Solicitantes">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Datos de Solicitantes'>
			<script language="JavaScript" type="text/JavaScript">
			<!--
			 function funcRegresar() {
				document.form1.action='/cfmx/sif/cm/consultas/DatosSolicitante-lista.cfm';
				document.form1.submit();
			}
			//-->
			</script>
			<cfoutput>
				<form name="form1" method="post" action="DatosSolicitanteCF-lista.cfm" style="margin: 0">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td><cfinclude template="../../portlets/pNavegacionCM.cfm"></td></tr>
						<tr><td><cf_rhimprime datos="/sif/cm/consultas/DatosSolicitanteCF-Imprime.cfm" paramsuri=""></td></tr>
						<tr><td><cfinclude template="DatosSolicitanteCF-Imprime.cfm"></td></tr>	
						<tr><td><cf_botones  tabindex="1" include="Regresar" exclude="Baja,Cambio,Alta,Limpiar"></td></tr>								
					</table>						
				</form>				
			</cfoutput>
			
		<cf_web_portlet_end>
	<cf_templatefooter>

