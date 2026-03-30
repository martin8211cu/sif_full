<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"><!---
OJO: no poner como:
      <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
porque se vería mal el diseño de algunos formularios (eg. socio negocios)
en internet explorer 6.0
--->
<!--- Indica si esta accesando desde el portal o los sistemas 
	De momento solo aqui esta definida
	Puedes tener los valores: sistema, portal
---><cfparam name="session.origen" default="sistema"> 
<cfset session.sitio.skinlist = 'soinasp01_azul.css,Azul cielo;soinasp01_verde.css,Verde esmeralda;soinasp01_gris.css,Gris;soinasp01_naranja.css,Naranja;soinasp01_rosa.css,Rosa'>
<html>
<head>
<title>$$TITLE$$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfset Request.TemplateCSS = true>
<cfoutput><link href="/cfmx#session.sitio.css#" rel="stylesheet" type="text/css"></cfoutput>
</head>
<body>
<cfset request.mlm_part1 = true>
<table border="0" width="980" align="center" cellpadding="0" cellspacing="0"><tr><td>
<cfinclude template="header.cfm">
</td></tr>
<!--- <tr><td><cfinclude template="/home/menu/portlets/menu-content-layers.cfm"></td></tr> --->
<!--- <tr><td><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr> --->
<tr><td><cfinclude template="/home/menu/portal_control.cfm"></td></tr>
</table>
<table border="0" width="980" align="center" cellpadding="0" cellspacing="0"><tr><td>
$$BODY$$
</td></tr></table>
<!--- <cfinclude template="/home/menu/portlets/menu-content-layers.cfm"> --->
</body>
</html>