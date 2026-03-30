<cfinclude template="CalificacionEducacion-translate.cfm">
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_templatecss>
	<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->
	</script>
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_nav__SPdescripcion#'>
		<cfif isdefined('url.RHCEDid') and not isdefined('form.RHCEDid')>
			<cfset form.RHCEDid = url.RHCEDid>
		</cfif>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top" align="center">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
					  <tr>
						<td colspan="3">
							<cfinvoke 
								component="rh.Componentes.pListas"
								method="pListaRH"
								mostrar_filtro="true"
								filtrar_automatico="true"
								columnas="RHCEDid,RHCEDNivel,RHCEDPeso" 
								desplegar="RHCEDNivel,RHCEDPeso"
								filtrar_por="RHCEDNivel,RHCEDPeso"
								etiquetas="#LB_Nivel#,#LB_Peso#"
								align="left,center"
								formatos="S,S"
								tabla="RHCalificaEduc"
								filtro="Ecodigo = #session.Ecodigo#"
								ira="CalificacionEducacion.cfm"
								showemptylistmsg="true"
								debug="N"
							/>						
						</td>
					  </tr>
					</table>
				</td>
				<td width="55%" valign="top"><cfinclude template="CalificacionEducacion-form.cfm"></td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
