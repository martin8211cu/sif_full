<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuCRM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>CRM</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<cf_templatecss>
<link href="/cfmx/sif/crm/css/CRM.css" rel="stylesheet" type="text/css">
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
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr> 
					<td width="154" rowspan="2" align="center" valign="top">
						<img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62">
					</td>
					<td valign="top" style="padding-left: 5; padding-bottom: 5;"> 
					  <cfinclude template="../../../Utiles/params.cfm">
					  <cfset Session.Params.ModoDespliegue = 1>
					  <!-- InstanceBeginEditable name="Ubica" --> 
					  <cfinclude template="../../../portlets/pubica.cfm">
					  <!-- InstanceEndEditable --> </td>
				  </tr>
				  <tr> 
					<td valign="top">
					  <table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr class="area"> 
						  <td width="220" rowspan="2" valign="middle">
							<cfinclude template="../../portlets/pEmpresas2.cfm">
						  </td>
						  <td width="50%"> 
							<div align="center"><span class="superTitulo"><font size="5"> <!-- InstanceBeginEditable name="Titulo" --> 
							  CRM<!-- InstanceEndEditable --> </font></span></div></td>
						</tr>
						<tr class="area"> 
						  <td width="50%" valign="bottom" nowrap> 
						  <!-- InstanceBeginEditable name="MenuJS" --> 
						  <cfinclude template="/sif/crm/jsMenuCRM.cfm">
						  <!-- InstanceEndEditable -->	
						  </td>
						</tr>
						<tr> 
						  <td></td>
						  <td></td>
						</tr>
					  </table>
						</td>
				  </tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr> 
					<td width="84" valign="top" nowrap>
					  <cfinclude template="/sif/menu.cfm">
					</td>
					<td width="1">&nbsp;</td>
					<td valign="top"> 
					  <!-- InstanceBeginEditable name="Mantenimiento" --> 
						<style type="text/css">
						#printerIframe {
						  position: absolute;
						  width: 0px; height: 0px;
						  border-style: none;
						  /* visibility: hidden; */
						}
						</style>
						<script type="text/javascript">
						function printURL (url) {
						  if (window.print && window.frames && window.frames.printerIframe) {
							var html = '';
							html += '<html>';
							html += '<body onload="parent.printFrame(window.frames.urlToPrint);">';
							html += '<iframe name="urlToPrint" src="' + url + '"><\/iframe>';
							html += '<\/body><\/html>';
							var ifd = window.frames.printerIframe.document;
							ifd.open();
							ifd.write(html);
							ifd.close();
						  }
						  else {
//								if (confirm('To print a page with this browser we need to open a window with the page. Do you want to continue?')) {
									var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
									var html = '';
									html += '<html>';
									html += '<frameset rows="100%, *" ' 
										 +  'onload="opener.printFrame(window.urlToPrint);">';
									html += '<frame name="urlToPrint" src="' + url + '" \/>';
									html += '<frame src="about:blank" \/>';
									html += '<\/frameset><\/html>';
									win.document.open();
									win.document.write(html);
									win.document.close();
//							}
						  }
						}
						
						function printFrame (frame) {
						  if (frame.print) {
							frame.focus();
							frame.print();
							frame.src = "about:blank"
						  }
						}
						
						</script>					  
						<cf_web_portlet titulo="Donaciones por Entidad" border="true" skin="#session.preferences.skin#">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2">
										<table width="100%" border="0" cellspacing="0" cellpadding="0">
										  <tr>
											<td><table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#DFDFDF">
											  <tr align="left">
												<td nowrap><a href="/cfmx/sif/crm/index.cfm">CRM</a></td>
												<td>|</td>
												<td><a href="javascript:history.back();">Regresar</a></td>
												<cfoutput>
												
												  <td align="right" width="100%">
													  <cfset Param = 	"?CRMEid_filtro=" & #form.CRMEid_filtro# 																		
																& "&btnConsultar=" & #form.btnConsultar#>																																					

														<cfif isdefined('form.fechaini_filtro') and form.fechaini_filtro NEQ ''>
															  <cfset Param = Param &  "&fechaini_filtro=" & #form.fechaini_filtro#>
														</cfif>																		
														<cfif isdefined('form.fechafin_filtro') and form.fechafin_filtro NEQ ''>
															  <cfset Param = Param &  "&fechafin_filtro=" & #form.fechafin_filtro#>
														</cfif>																		
													<a href="javascript:printURL('repDonacionesEntidadImpr.cfm#Param#');">
														Imprimir
													</a>
												  </td>
											  </cfoutput> </tr>
											</table></td>
										  </tr>
										  <tr>
											<td>
												<cfinclude template="repDonacionesEntidad.cfm">
											</td>
										  </tr>
										</table>								
									</td>
								</tr>
							</table>
						</cf_web_portlet>
					  <!-- InstanceEndEditable --> 
					  </td>
				  </tr>
				</table>
			</td>
		</tr>
	</table>

</body>
<!-- InstanceEnd --></html>