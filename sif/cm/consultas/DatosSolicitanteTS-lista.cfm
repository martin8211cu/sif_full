<cf_templateheader title="Compras - Consulta de Permisos por Solicitante">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Permisos por Solicitante'>
			
			<cfoutput>		
				<form name="form1" method="post" action="DatosSolicitanteTS-lista.cfm" style="margin: 0">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td><cfinclude template="../../portlets/pNavegacionCM.cfm"></td></tr>
						<tr><td><cf_rhimprime datos="/sif/cm/consultas/DatosSolicitanteTS-Imprime.cfm" paramsuri="&CMSid=#form.CMSid#"></td></tr>
						<tr><td><cfinclude template="DatosSolicitanteTS-imprime.cfm"></td></tr>					
					</table>						
				</form>
			</cfoutput>
			
		<cf_web_portlet_end>
	<cf_templatefooter>


	