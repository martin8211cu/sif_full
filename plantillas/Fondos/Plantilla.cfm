<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<!--- <html>
<head>
<title>$$TITLE$$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfset Request.TemplateCSS = true>
<cfoutput><link href="/cfmx#session.sitio.css#" rel="stylesheet" type="text/css"></cfoutput>
</head>
<body> --->

<html>
<head>
<title>$$TITLE$$</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>

</head>
<!--- <script language="javascript1.2" type="text/javascript" src="utiles.js"></script> --->

<body style="margin:0;">
<div id="Layer1" style="position: relative; left: 10; top: 0; width: 231; height: 55; z-index: 0; background-color: #FFFFFF; layer-background-color: #FFFFFF; border: 1px none #000000"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0" background="../../../plantillas/fondos/images/index.jpg" height="55">
<tr>
<td>
	<div id="Layer3" style="position: absolute; left: 35; top: 11; width: 150px; height: 34px; z-index: 0; overflow: hidden; visibility: visible; font-size: 12px; font-weight: bold; font-family: Arial; line-height: 100%">Pantalla Unica</div>
</td>
</tr>
</table>

</div>
<link href="/cfmx/plantillas/login02/login02.css" rel="stylesheet" type="text/css">
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
  <tr >
	<td valign="top" colspan="2" align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				<td align="left" valign="top">
					$$HEADER OPTIONAL$$
				</td>
				</tr>
				<tr>
				<td align="left" valign="top">
					$$BODY$$
				</td>
				</tr>
	  	</table>
	</td>
  </tr>

  <tr>
    <td colspan="2">
		<font size="1" face="Verdana" color="#FFFFFF">(C)SOIN, Soluciones Integrales S.A. 2003 </font>
	</td>
  </tr>
</table>
<iframe id="MANTSESSION" name="MANTSESSION" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
<script language="JavaScript">
var frame = document.getElementById("MANTSESSION");
frame.src = "http://10.7.7.23/servlet/soin.sif.cjc.cjc_MantieneSession";
</script>	
</body>
</html>
