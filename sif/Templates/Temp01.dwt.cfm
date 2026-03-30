<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>SIF</title>
	<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="Pragma" content="no-cache">
	<!-- TemplateBeginEditable name="head" -->
	<!-- TemplateEndEditable -->
	<cf_templatecss>
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
	<cf_templatecss>	
	<link rel="stylesheet" type="text/css" href="/cfmx/sif/logout/login01/style.css">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">	
</head>

<body leftmargin=0 topmargin=0 marginheight="0" marginwidth="0" bgcolor="#ffffff">

<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
	<tr valign="top">
		<td valign="bottom" background="/cfmx/sif/logout/login01/imagesP1/bg_left.gif"><img src="/cfmx/sif/logout/login01/imagesP1/bg_left.gif" alt="" width="17" height="16" border="0"></td>
		<td>
		
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="107">
				<tr valign="bottom">
					<td></td>
					<td width="100%" background="/cfmx/sif/logout/login01/imagesP1/nubes.jpg">
									
						<table border="0" cellpadding="0" cellspacing="0" >						
						<tr>
							<td colspan="6">
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td>
											<!-- TemplateBeginEditable name="Titulo" --> 
											  <table width="100%" border="0" cellpadding="0" cellspacing="0">
												<tr class="area"> 
												  <td width="220" rowspan="2" valign="middle">
													  <cfif isdefined("Session.Ecodigo")>
														<cfinclude template="/cfmx/sif/portlets/pEmpresas2.cfm">
													  </cfif>
												  </td>
												  <td width="50%" background="/cfmx/sif/logout/login01/imagesP1/nubes.jpg"> 
													<div align="center"><span class="superTitulo"><font size="5">Descripcion</font></span></div>
												  </td>
												</tr>
												<tr class="area"> 
												  <td width="50%" valign="bottom" nowrap> 
													<cfinclude template="/cfmx/sif/af/jsMenuAF.cfm">
												  </td>
												</tr>
												<tr> 
												  <td></td>
												  <td></td>
												</tr>
											  </table>
										  <!-- TemplateEndEditable -->																	
										</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
						
						<cfoutput>
						<tr valign="bottom">
						
							<!--- Esto es para resaltar el tab del link seleccionado, si aplica --->						
							<cfset link = "">
							<cfif Find("index.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("index.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("compania.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("compania.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("productos.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("productos.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("capacitacion.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("capacitacion.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("soporte.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("soporte.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("contactenos.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("contactenos.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>							
							
							<!--- productos --->	
							<cfelseif Find("soin_sif.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("soin_sif.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("rhgestion.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("rhgestion.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("sybase_ep.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("sybase_ep.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("business.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("business.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							
							<!--- links del inicio --->
							<cfelseif Find("noticias.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("noticias.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("eventos.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("eventos.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
							<cfelseif Find("empleos.cfm",CGI.SCRIPT_NAME) GT 0>
								<cfset link = Mid(CGI.SCRIPT_NAME, Find("empleos.cfm",CGI.SCRIPT_NAME),Len(CGI.SCRIPT_NAME))>
								
							</cfif>														
							<!---  ---->
													
							<td>
								<!-- but act -->
								<table border="0" cellpadding="0" cellspacing="0">								
								<tr valign="bottom">
									<cfset add = "">
									<cfset ancho = 10>
									<cfset alto = 30>
									<cfif link EQ "index.cfm" or link EQ "noticias.cfm" or link EQ "eventos.cfm" or link EQ "empleos.cfm">
										<cfset add = "_a">
										<cfset ancho = 9>
										<cfset alto = 37>										
									</cfif>								
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_left#add#.gif" width="#ancho#" height="#alto#" alt="" border="0"></td>
									<td background="/cfmx/sif/logout/login01/imagesP1/b_fon#add#.gif"><p class="menu01"><a href="/cfmx/sif/logout/login01/index.cfm">INICIO</a></p></td>
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_right#add#.gif" width="#ancho#" height="#alto#" alt="" border="0"></td>
								</tr>
								</table>
								<!-- /but act -->
							</td>
							<td>
								<!-- but -->
								<table border="0" cellpadding="0" cellspacing="0">
								<tr valign="bottom">
									<cfset add = "">
									<cfset ancho = 10>
									<cfset alto = 30>
									<cfif link EQ "compania.cfm">
										<cfset add = "_a">
										<cfset ancho = 9>
										<cfset alto = 37>										
									</cfif>																
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_left#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
									<td background="/cfmx/sif/logout/login01/imagesP1/b_fon#add#.gif"><p class="menu01"><a href="/cfmx/sif/logout/login01/public/compania.cfm">COMPAÑÍA</a></p></td>
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_right#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
								</tr>
								</table>
								<!-- /but -->
							</td>
							<td>
								<!-- but -->
								<table border="0" cellpadding="0" cellspacing="0">
								<tr valign="bottom">
									<cfset add = "">
									<cfset ancho = 10>
									<cfset alto = 30>
									<cfif link EQ "productos.cfm" or link EQ "soin_sif.cfm" or link EQ "rhgestion.cfm" or link EQ "sybase_ep.cfm" or link EQ "business.cfm">
										<cfset add = "_a">
										<cfset ancho = 9>
										<cfset alto = 37>										
									</cfif>																								
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_left#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
									<td background="/cfmx/sif/logout/login01/imagesP1/b_fon#add#.gif"><p class="menu01"><a href="/cfmx/sif/logout/login01/public/productos.cfm">PRODUCTOS</a></p></td>
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_right#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
								</tr>
								</table>
								<!-- /but -->
							</td>
							<td>
								<!-- but -->
								<table border="0" cellpadding="0" cellspacing="0">
								<tr valign="bottom">
									<cfset add = "">
									<cfset ancho = 10>
									<cfset alto = 30>
									<cfif link EQ "capacitacion.cfm">
										<cfset add = "_a">
										<cfset ancho = 9>
										<cfset alto = 37>										
									</cfif>																																
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_left#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
									<td background="/cfmx/sif/logout/login01/imagesP1/b_fon#add#.gif"><p class="menu01"><a href="/cfmx/sif/logout/login01/public/capacitacion.cfm">CAPACITACI&Oacute;N</a></p></td>
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_right#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
								</tr>
								</table>
								<!-- /but -->
							</td>
							<td>
								<!-- but -->
								<table border="0" cellpadding="0" cellspacing="0">
								<tr valign="bottom">
									<cfset add = "">
									<cfset ancho = 10>
									<cfset alto = 30>
									<cfif link EQ "soporte.cfm">
										<cfset add = "_a">
										<cfset ancho = 9>
										<cfset alto = 37>										
									</cfif>																																								
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_left#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
									<td background="/cfmx/sif/logout/login01/imagesP1/b_fon#add#.gif"><p class="menu01"><a href="/cfmx/sif/logout/login01/public/soporte.cfm">SOPORTE</a></p></td>
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_right#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
								</tr>
								</table>
								<!-- /but -->
							</td>
							<td>
								<!-- but -->
								<table border="0" cellpadding="0" cellspacing="0">
								<tr valign="bottom">
									<cfset add = "">
									<cfset ancho = 10>
									<cfset alto = 30>
									<cfif link EQ "contactenos.cfm">
										<cfset add = "_a">
										<cfset ancho = 9>
										<cfset alto = 37>										
									</cfif>																																																
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_left#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
									<td background="/cfmx/sif/logout/login01/imagesP1/b_fon#add#.gif"><p class="menu01"><a href="/cfmx/sif/logout/login01/public/contactenos.cfm">CONTACTENOS</a></p></td>
									<td><img src="/cfmx/sif/logout/login01/imagesP1/b_right#add#.gif" alt="" width="#ancho#" height="#alto#" border="0"></td>
								</tr>
								</table>
								<!-- /but -->
							</td>
						</tr>
						</cfoutput>
						</table>
					</td>
				</tr>
			</table>

			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="107">
				<tr valign="top">
					<td bgcolor="#076BA7" width="100" align="center">																					
						<div align="center"><img src="/cfmx/sif/logout/login01/imagesP1/title01.gif" width="183" height="35" alt="" border="0"></div>
					  <!-- TemplateBeginEditable name="Ubica"-->																	
							<cfinclude template="/sif/logout/login01/pubica2.cfm">
					   <!-- TemplateEndEditable -->																													
						<cfif FindNoCase("/login01/login.cfm",CGI.SCRIPT_NAME) EQ 0>
							<cfinclude template="/sif/logout/login01/login-form2.cfm">
						<cfelse>
							<br><br><br><br><br><br><br><br><br>
						</cfif>						
						<div align="center"><img src="/cfmx/sif/logout/login01/imagesP1/title02_b.gif" width="183" height="36" alt="" border="0"></div>
					      <br><br>						  
					    </td>
					<td rowspan="2">
						<div align="center"><img src="/cfmx/sif/logout/login01/imagesP1/top01.gif" width="100%" height="24" alt="" border="0"></div>
						
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td><!-- TemplateBeginEditable name="Titulo2" -->Titulo1<!-- TemplateEndEditable --></td>
								<td>
									<!-- TemplateBeginEditable name="portletMantenimientoInicio"-->											
										<cf_web_portlet border="true" tituloalign="center" titulo="Titulo">																						
									<!-- TemplateEndEditable -->		
									<!-- TemplateBeginEditable name="Mantenimiento2" --> 
									Mantenimiento2
									<!-- TemplateEndEditable -->
									<!-- TemplateBeginEditable name="portletMantenimientoFin"-->	
										</cf_web_portlet>																						
									<!-- TemplateEndEditable -->								
								</td>
							</tr>
						</table>
												
					</td>
				</tr>
				<tr valign="bottom" bgcolor="#076BA7">
					<td><img src="/cfmx/sif/logout/login01/imagesP1/bot_left.gif" width="100%" height="21" alt="" border="0"></td>
				</tr>
			</table>
			<table border="0" bordercolor="#FF0000" cellpadding="0" cellspacing="0" width="100%" height="64" background="/cfmx/sif/logout/login01/imagesP1/fon_bot.gif">
				<tr valign="top">
					<td>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td valign="top" width="300" background="/cfmx/sif/logout/login01/imagesP1/fon_bot.gif"><p class="menu02">Derechos Reservados &copy;2003 www.soin.co.cr</p></td>
								<td valign="top" background="/cfmx/sif/logout/login01/imagesP1/fon_bot_slice.gif">
									<p class="menu02">
									<a href="/cfmx/sif/logout/login01/index.cfm">Inicio</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
									<a href="/cfmx/sif/logout/login01/public/compania.cfm">Acerca de</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
									<a href="/cfmx/sif/logout/login01/public/soporte.cfm">Soporte</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
									<a href="/cfmx/sif/logout/login01/public/contactenos.cfm">Contactos</a>&nbsp;&nbsp;&nbsp;
									</p>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td valign="bottom" background="/cfmx/sif/logout/login01/imagesP1/bg_right.gif"><img src="/cfmx/sif/logout/login01/imagesP1/bg_right.gif" alt="" width="17" height="16" border="0"></td>
	</tr>
</table>

</body>
</html>
