<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">      			    				
			<!---<cfif not isdefined("url.tipo")	>---->
			  <cfset titulo = "">
			  <cfset titulo = 'Indicador de capacitación'>
			  <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
				  <SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
				  <SCRIPT language="JavaScript">
					<!--//
					// specify the path where the "/qforms/" subfolder is located
					qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
					// loads all default libraries
					qFormAPI.include("*");
					//qFormAPI.include("validation");
					//qFormAPI.include("functions", null, "12");
					//-->
				</SCRIPT>
					
			  <cfinclude template="/home/menu/pNavegacion.cfm">
				  <cfoutput>
					<form method="post" name="form1" action="IndCapacitacion.cfm">
						<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td width="45%">
									<table width="100%">
										<tr>
											<td height="173" valign="top">	
												<cf_web_portlet_start border="true" titulo="Indicador de capacitación" skin="info1">
													<div align="justify">
													  <p>En &eacute;ste reporte 
														  se muestra la informaci&oacute;n respecto  a los resultados de 
														  las capacitaciones realizadas a los empleados de un puesto 
														  y centro funcional
														</p>
													</div>
												<cf_web_portlet_end>							  
											 </td>
										</tr>
									</table>  
								</td>
								<td width="55%" valign="top">
									<table width="100%" cellpadding="0" cellspacing="0" align="center">
										<tr>
										  <td>&nbsp;</td>
										  <td align="right"><strong>Puesto:</strong>&nbsp;</td>
										  <td nowrap>
											  <cf_rhpuesto>
										  </td>
										  </tr>
										  <tr><td align="center">&nbsp;</td></tr>
										  <tr>
										  	<td>&nbsp;</td>
											<td align="right"><strong>Centro funcional:</strong>&nbsp;</td>
											<td nowrap><cf_rhcfuncional>
											</td>
										  </tr>
										  <tr><td>&nbsp;</td></tr>
										  <tr><td align="center" colspan="3"><input type="submit" value="Generar" name="Reporte"></td></tr>
									</table>
								</td>																
							</tr>							
						</table>
					</form>
				  </cfoutput>
				<cf_web_portlet_end>				
			</td>	
		</tr>
	</table>	
<cf_templatefooter>