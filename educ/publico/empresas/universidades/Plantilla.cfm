<cffunction name="fnBoton" output="true">
	<cfargument name="i" type="numeric">
	<cfargument name="pTitulo" type="string">
	<cfargument name="pUri" type="string">
		<cfoutput>
					<td id="but0#i#" 
						align="center" valign="middle" class="clsBoton"
						width="102" height="44"
						background="/cfmx/home/public/imagen.cfm?f=/educ/publico/empresas/universidades/images/boton1.gif"
						onMouseOut= "javascript:this.background=LvarBoton1.src;"
						onMouseOver="javascript:this.background=LvarBoton2.src;"
						onMouseDown="javascript:this.background=LvarBoton3.src;"
						onClick="document.location.href='#pUri#'">
						#pTitulo#
 					</td>
		</cfoutput>
</cffunction>
<cfset session.menues.PonerCuadro = False>
<cfset session.menues.PonerUsuario = False>
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
<script language="javascript">
	var LvarBoton1 = new Image();
	LvarBoton1.src="/cfmx/home/public/imagen.cfm?f=/educ/publico/empresas/universidades/images/boton1.gif";
	var LvarBoton2 = new Image();
	LvarBoton2.src="/cfmx/home/public/imagen.cfm?f=/educ/publico/empresas/universidades/images/boton2.gif";
	var LvarBoton3 = new Image();
	LvarBoton3.src="/cfmx/home/public/imagen.cfm?f=/educ/publico/empresas/universidades/images/boton3.gif";
</script>
<style type="text/css">
	<!--
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
<link type="text/css" rel="stylesheet" href="style.css" >
<script type="text/javascript" language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
</head>
<body style="margin:0;">
<table height="100%" width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr bgcolor="#FFCC66" height="130" align="center">
		<td colspan="5" style="color:#611314">
			<img src="images/titulo.gif"
		</td>
	</tr>
	<tr bgcolor="#FFCC66">
		<td width="150" align="center" valign="top">
			$$LEFT OPTIONAL$$
		</td>
		<td style="width:10px">&nbsp;</td>
		<td width="670" valign="top" bgcolor="#FFFFFF" style="border:1px solid #611314">
			<table>
				<tr>
					<td height="25">
						<font color="#611314" size="5"><strong>$$HEADER OPTIONAL$$</strong></font>
					</td>
				</tr>
				<tr>
					<td width="670">
						$$BODY$$
					</td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
		<td width="100" valign="top" align="right">
			<table>
				<tr>
					<td width="200" align="left" >
						<cfset LvarPubicaClass="left">
						<cfinclude template="../../comun/pubica.cfm">
					</td>
				</tr>
			</table>
		  <p></p>
		  $$RIGHT OPTIONAL$$
		</td>
	</tr>
    <tr bgcolor="#FFCC66">
      <td colspan="5">&nbsp;</td>
	</tr>
    <tr>
      <td valign="top" height="19" colspan="5">
          <p align="center" style="color: #003399"><font size="1" face="Verdana">
		  <a href="//www.soin.net/cfmx/plantillas/login02/index.cfm" style="text-decoration: none">Soin Home</a>&nbsp;&nbsp; |&nbsp;&nbsp;
          <a href="//www.soin.net/cfmx/plantillas/login02/nosotros.cfm" style="text-decoration: none"> Qui&eacute;nes Somos </a>&nbsp;&nbsp; |&nbsp;&nbsp;
		  <a href="//www.soin.net/cfmx/plantillas/login02/productos.cfm" style="text-decoration: none">Productos</a>&nbsp;&nbsp; |&nbsp;&nbsp;
		  <a href="//www.soin.net/cfmx/plantillas/login02/capacitacion.cfm" style="text-decoration: none">Capacitaci&oacute;n</a>&nbsp;&nbsp; |&nbsp;&nbsp; 
		  <a href="//www.soin.net/cfmx/home/menu/" style="text-decoration: none">Servicios</a>&nbsp;&nbsp; |&nbsp;&nbsp; 
          <a href="//www.soin.net/cfmx/plantillas/login02/soporte.cfm" style="text-decoration: none">Soporte</a>&nbsp; |&nbsp;&nbsp; 
          <a href="//www.soin.net/cfmx/plantillas/login02/contactenos.cfm" style="text-decoration: none">Contactenos</a></font></td>
    </tr>
    <tr>
      <td valign="top" height="19" colspan="5" bgcolor="#626262" align="center">
		<font size="1" face="Verdana" color="#FFFFFF">&copy; SOIN, Soluciones Integrales S.A. 2003-2004 </font>
      </td>
    </tr>
</table>
</body>
</html>
