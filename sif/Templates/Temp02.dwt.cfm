<html>
<head>
	<title>SIF</title>
	<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="Pragma" content="no-cache">	
	<meta http-equiv="Content-Language" content="en-us">
	<!-- TemplateBeginEditable name="head" -->
	<style type="text/css">
	<!--
	.style1 {
		color: #006699;
		font-weight: bold;
	}
	.style8 {color: #003399; font-size: 12px;}
	.style9 {color: #003399}
	.style10 {
		color: #626262;
		font-size: 12px;
	}
	.style13 {font-size: 14px}
	.style14 {
		color: #003399;
		font-family: Arial;
		font-size: 14px;
		font-style: normal;
		font-weight: lighter;
	}
	.style16 {color: #0033FF}
	.style18 {
		color: #660066;
		font-size: 10px;
		font-weight: bold;
	}
	.style47 {color: #FFFFFF; font-weight: bold; }
	.style59 {
		color: #003399;
		font-weight: bold;
		font-size: 10px;
		font-family: Verdana, Arial, Helvetica, sans-serif;
	}
	.style60 {font-family: Verdana, Arial, Helvetica, sans-serif; color: #003399;}
	-->
	</style>
	
	<!-- TemplateEndEditable -->	
</head>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<body>
<div align="center">
  <center>
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="800" id="AutoNumber1" height="1">
    <tr>
      <td width="150" valign="top" height="150" colspan="3"><embed width="980" height="150" src="flashheader3.swf"></td>
    </tr>
	
	<tr>
      <td width="150" valign="top" height="1">
		  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="116%" id="AutoNumber2">
			<tr>
			  <td width="100%" background="images/top1.jpg">
			  <p style="margin-top: 3; margin-bottom: 0"><b>
			  <font face="Verdana" size="2" color="#FFFFFF">Misi&oacute;n</font></b></td>
			</tr>
			<tr>
			  <td width="100%" background="/cfmx/sif/logout/login02/images/fondo_rombos9.gif"><p class="paragraph style14"><span class="style59">Proveer a nuestros Clientes de Innovaci&oacute;n e Infraestructura tecnol&oacute;gica para apoyar decididamente su desarrollo empresarial.</span></p>
				<p><img border="0" src="images/bottom1.jpg" width="180" height="24"></p></td>
			</tr>
		  </table>
	  
	  <!--- por aquí va el menú --->
	  <!--- <cfoutput>CGI.SCRIPT_NAME=#CGI.SCRIPT_NAME# #FindNoCase("/logout",CGI.SCRIPT_NAME)#</cfoutput> --->
	  <cfif FindNoCase("/logout/login02/",CGI.SCRIPT_NAME) EQ 0>
	 	<cfinclude template="/sif/menu.cfm">
	  </cfif>
      </td>
	  
	  <td valign="top">
	  
	  <table>
	  	<tr>
			<td width="100%">
				<!-- TemplateBeginEditable name="Titulo" --> 
				  <table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr class="area"> 
					  <td width="220" rowspan="2" valign="middle">
						  <cfif isdefined("Session.Ecodigo")>
							<cfinclude template="/sif/portlets/pEmpresas2.cfm">
						  </cfif>
					  </td>
					  <td width="50%"> 
						<div align="center"><span class="superTitulo"><font size="5">Descripcion</font></span></div>
					  </td>
					</tr>
					<tr class="area"> 
					  <td width="50%" valign="bottom" nowrap> 
						<cfinclude template="/sif/af/jsMenuAF.cfm">
					  </td>
					</tr>
					<tr> 
					  <td></td>
					  <td></td>
					</tr>				
				  </table>
				  <cfinclude template="/sif/logout/login02/pubica2.cfm">
			  <!-- TemplateEndEditable -->																				
			</td>
			<td rowspan="2" valign="top">
			   <!-- TemplateBeginEditable name="Ubica"-->			   		
					<cfif FindNoCase("/login02/index.cfm",CGI.SCRIPT_NAME) NEQ 0>						
						
						<cfif isDefined("Session.Usucodigo") and Session.Usucodigo is 0>
							<img border="0" src="images/bottom1.jpg" width="216" height="24">	
							<cfinclude template="/sif/logout/login02/login-form2.cfm">					
						</cfif>
											
					  <table background="/cfmx/sif/logout/login02/images/rightbar.jpg" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber9" height="18">
						<tr>
						  <td width="1%" background="/cfmx/sif/logout/login02/images/midbar3.jpg" height="21">
						  <p style="margin-left: 5"><b>
						  <font size="2" face="Verdana" color="#FFFFFF">Noticias:</font></b></td>
						</tr>
					  </table>
					  
					  <table background="/cfmx/sif/logout/login02/images/fondo3.gif" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber10">
						<tr>
						  <td><p class="style8">05/11/2003<br>
			  El nuevo sitio web de SOIN ya est&aacute; en L&iacute;nea, visite <a href="http://www.soin.net">www.soin.net.</a> </p></td>
						</tr>
					  </table>          
					  <img border="0" src="/cfmx/sif/logout/login02/images/bottom2.jpg" width="216" height="23">
					  <div align="center"><span class="style10">
					  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="200" height="100" align="middle">
						<param name="movie" value="LineasNegocio.swf">
						<param name="quality" value="high">
						<param name="BGCOLOR" value="#FFFFFF">
						<embed src="LineasNegocio.swf" width="200" height="100" align="middle" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" bgcolor="#FFFFFF"></embed>
					  </object>
					  </span></div>					  
					</cfif> 
				<!-- TemplateEndEditable -->			  			   			
			</td>
		</tr>
		
		<tr>
			<td valign="top">
				<!-- TemplateBeginEditable name="Titulo2"-->											
				<!-- TemplateEndEditable -->		  
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

    <tr>
      <td valign="top" height="19" colspan="3">
          <p align="center" class="style9"><font size="1" face="Verdana">
		  <a href="/cfmx/sif/logout/login02/index.cfm" style="text-decoration: none">Inicio</a>&nbsp;&nbsp; |&nbsp;&nbsp;
          <a href="/cfmx/sif/logout/login02/nosotros.cfm" style="text-decoration: none"> Qui&eacute;nes Somos </a>&nbsp;&nbsp; |&nbsp;&nbsp;
		  <a href="/cfmx/sif/logout/login02/productos.cfm" style="text-decoration: none">Productos</a>&nbsp;&nbsp; |&nbsp;&nbsp;
		  <a href="/cfmx/sif/logout/login02/capacitacion.cfm" style="text-decoration: none">Capacitaci&oacute;n</a>&nbsp;&nbsp; |&nbsp;&nbsp; 
		  <a href="/cfmx/sif/index/servicios.cfm" style="text-decoration: none">Servicios</a>&nbsp;&nbsp; |&nbsp;&nbsp; 
          <a href="/cfmx/sif/logout/login02/soporte.cfm" style="text-decoration: none">Soporte</a>&nbsp; |&nbsp;&nbsp; 
          <a href="/cfmx/sif/logout/login02/contactenos.cfm" style="text-decoration: none">Contactenos</a></font></td>
    </tr>
    <tr>
      <td valign="top" height="19" colspan="3">
      <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber13">
        <tr>
          <td width="100%" bgcolor="#626262">
          <p align="center"><font size="1" face="Verdana" color="#FFFFFF">(C)SOIN, Soluciones Integrales S.A. 2003 </font>
          <font face="Verdana" color="#FFFFFF" size="4">&nbsp; </font></td>
        </tr>
      </table>
      </td>
    </tr>
  </table>
  </center>
</div>
</body>
</html>
