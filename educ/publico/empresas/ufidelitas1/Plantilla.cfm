<cffunction name="fnBoton" output="true">
	<cfargument name="i" type="numeric">
	<cfargument name="pTitulo" type="string">
	<cfargument name="pUri" type="string">
		<cfoutput>
					<td id="but0#i#" 
						align="center" valign="middle" class="clsBoton"
						width="102" height="44"
						background="/cfmx/home/public/imagen.cfm?f=/educ/publico/empresas/ufidelitas/images/boton1.gif"
						onMouseOut= "javascript:this.background=LvarBoton1.src;"
						onMouseOver="javascript:this.background=LvarBoton2.src;"
						onMouseDown="javascript:this.background=LvarBoton3.src;"
						onClick="document.location.href='#pUri#'">
						#pTitulo#
 					</td>
		</cfoutput>
</cffunction>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>$$TITLE$$</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Content-Language" content="en-us">
<link type="text/css" rel="stylesheet" href="../ufidelitas/style.css" >
<script language="javascript">
	document.stm31Right = 1;
	var LvarBoton1 = new Image();
	LvarBoton1.src="/cfmx/home/public/imagen.cfm?f=/educ/publico/empresas/ufidelitas/images/boton1.gif";
	var LvarBoton2 = new Image();
	LvarBoton2.src="/cfmx/home/public/imagen.cfm?f=/educ/publico/empresas/ufidelitas/images/boton2.gif";
	var LvarBoton3 = new Image();
	LvarBoton3.src="/cfmx/home/public/imagen.cfm?f=/educ/publico/empresas/ufidelitas/images/boton3.gif";
</script>
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

	.clsBoton {
		color: #FFFFFF;
		font-family: Times New Roman, Times, serif;
		font-size: 18px;
		font-weight:bold;
		cursor:pointer;
		background-repeat:no-repeat;
	}
	-->
	</style>
<link type="text/css" rel="stylesheet" href="../ufidelitas/style.css" >
<script type="text/javascript" language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
</head>
<body style="margin:0;">
<table height="100%" width="100%">
	<tr>
		<td width="190" align="center" valign="top" style="width:190px; background-repeat:no-repeat " background="../ufidelitas/images/Bg1.jpg" >&nbsp;
		  <div style="width:190px; "></div>
		  <table>
		  	<tr>
				<td width="102" height="120" align="center" valign="middle" 
				</td>
			</tr>
		  	<tr>
				<cfset fnBoton (1,"Principal","/cfmx/educ/publico/empresas/ufidelitas/home.cfm")>
			</tr>
			<tr><td width="10"></td></tr>
		  	<tr>
				<cfset fnBoton (2,"Bienvenida","/cfmx/educ/publico/empresas/ufidelitas/ufidelitas.cfm")>
			</tr>
			<tr><td width="10"></td></tr>
		  	<tr>
				<cfset fnBoton (3,"¿Quienes somos?","/cfmx/educ/publico/empresas/ufidelitas/ufidelitas1.cfm")>
			</tr>
			<tr><td width="10"></td></tr>
		  	<tr>
				<cfset fnBoton (4,"Carreras","/cfmx/educ/publico/oferta/oferta.cfm")>
			</tr>
			<tr><td width="10"></td></tr>
		  	<tr>
				<cfset fnBoton (5,"Inicio Sistema","/cfmx/home/menu/index.cfm")>
			</tr>
			<tr><td width="10"></td></tr>
		  </table>
		</td>
		<td width="500" valign="top">
			<table>
				<tr>
					<td height="25">
						<font color="#200D81" size="5"><strong>$$HEADER OPTIONAL$$</strong></font>
					</td>
				</tr>
				<tr>
					<td width="500">
						$$BODY$$
					</td>
				</tr>
			</table>
		</td>
		<td>
		</td>
		<td width="100" valign="top" align="right">
			<table>
				<tr>
					<td width="200" align="right" >
						<cfset LvarPubicaClass="left">
						<cfinclude template="../../comun/pubica.cfm">
					</td>
				</tr>
				<tr>
					<td width="100" align="right">
						$$LEFT OPTIONAL$$
					</td>
				</tr>
			</table>
		  <p></p>
		  $$RIGHT OPTIONAL$$
		</td>
	</tr>
    <tr>
      <td valign="top" height="19" colspan="3">
          <p align="center" class="style9"><font size="1" face="Verdana">
		  <a href="//www.soin.net/cfmx/plantillas/login02/index.cfm" style="text-decoration: none">Soin Home</a>&nbsp;&nbsp; |&nbsp;&nbsp;
          <a href="//www.soin.net/cfmx/plantillas/login02/nosotros.cfm" style="text-decoration: none"> Qui&eacute;nes Somos </a>&nbsp;&nbsp; |&nbsp;&nbsp;
		  <a href="//www.soin.net/cfmx/plantillas/login02/productos.cfm" style="text-decoration: none">Productos</a>&nbsp;&nbsp; |&nbsp;&nbsp;
		  <a href="//www.soin.net/cfmx/plantillas/login02/capacitacion.cfm" style="text-decoration: none">Capacitaci&oacute;n</a>&nbsp;&nbsp; |&nbsp;&nbsp; 
		  <a href="//www.soin.net/cfmx/home/menu/" style="text-decoration: none">Servicios</a>&nbsp;&nbsp; |&nbsp;&nbsp; 
          <a href="//www.soin.net/cfmx/plantillas/login02/soporte.cfm" style="text-decoration: none">Soporte</a>&nbsp; |&nbsp;&nbsp; 
          <a href="//www.soin.net/cfmx/plantillas/login02/contactenos.cfm" style="text-decoration: none">Contactenos</a></font></td>
    </tr>
    <tr>
      <td valign="top" height="19" colspan="3" bgcolor="#626262" align="center">
		<font size="1" face="Verdana" color="#FFFFFF">&copy; SOIN, Soluciones Integrales S.A. 2003-2004 </font>
      </td>
    </tr>
</table>
</body>
</html>
