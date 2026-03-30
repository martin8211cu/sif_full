<cfinclude template="CalificacionExperiencia-translate.cfm">
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
		<cfif isdefined('url.RHCEid') and not isdefined('form.RHCEid')>
			<cfset form.RHCEid = url.RHCEid>
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
								columnas="RHCEid,RHCErequisito,RHCELimiteInf,RHCELimiteSup" 
								desplegar="RHCErequisito,RHCELimiteInf,RHCELimiteSup"
								filtrar_por="RHCErequisito,RHCELimiteInf,RHCELimiteSup"
								etiquetas="#LB_RequisitoDelPuesto#,#LB_LimiteInferior#,#LB_LimiteSuperior#"
								align="left,center,center"
								formatos="S,S,S"
								tabla="RHCalificacionExp"
								filtro="Ecodigo = #session.Ecodigo#"
								ira="CalificacionExperiencia.cfm"
								showemptylistmsg="true"
								debug="N"
							/>						
						</td>
					  </tr>
					</table>
				</td>
				<td width="55%" valign="top"><cfinclude template="CalificacionExperiencia-form.cfm"></td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
