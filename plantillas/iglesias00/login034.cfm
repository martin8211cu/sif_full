<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Iniciar sesi&oacute;n</title>
	<link rel="stylesheet" type="text/css" href="style034.css">

<style type="text/css">
td.leftmenutitle {
	color : #FFFFFF;
	margin-top : 1px;
	padding-bottom : 1px;
	margin-bottom : 1px;
	margin-left : 37px;
	margin-right : 10px;
	font-size : 10px;
	text-transform:uppercase;
	text-align:center;
	font-family : Tahoma,Verdana,Arial;
	font-weight: bold;
	background-image:url(/cfmx/plantillas/iglesia/images034/left01.gif);
	background-repeat:no-repeat;
	padding:0;
	height:26;
}
td.leftmenuitem,td.leftmenutext {
	background-image:url(/cfmx/plantillas/iglesia/images034/hr01.gif);
	background-repeat:no-repeat;
	margin:0;
	padding:0;
}
td.leftmenuitem a {
	color : #000;
	margin-top : 0px;
	padding-bottom : 1px;
	margin-bottom : 1px;
	margin-left : 15px;
	margin-right : 0px;
	font-size : 11px;
	font-family : Tahoma,Verdana,Arial;
	list-style-position: inside;
	list-style-image: url(/cfmx/plantillas/iglesia/images034/e02sp.gif);
	display:list-item;
}
</style>
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>

<body leftmargin=0 topmargin=0 marginheight="0" marginwidth="0" bgcolor="#E6E6E6" background="images034/fon.gif" onload="if (form1 && form1.j_username) form1.j_username.focus()">

<table border="0" cellpadding="0" cellspacing="0" width="100%" background="images034/fon_top.gif" height="110">
<tr>
	<td height="110" align="center" valign="top">
      <table border="0" cellpadding="0" cellspacing="0" width="740">
<tr>
	<td width="740" height="68" valign="top">&nbsp;</td>
</tr>
<tr>
	<td>
<table border="0" cellpadding="0" cellspacing="0">
<tr>
	<td><a href="/" target="_top"><img src="images034/bo1.gif" width="83" height="42" alt="" border="0"></a></td>
	<td><a href=""><img src="images034/b02.gif" width="95" height="42" alt="" border="0"></a></td>
	<td><a href=""><img src="images034/b03.gif" width="71" height="42" alt="" border="0"></a></td>
	<td><a href="/cfmx/home/menu/index.cfm"><img src="images034/b04.gif" width="91" height="42" alt="" border="0"></a></td>
	<td><a href=""><img src="images034/b05.gif" width="95" height="42" alt="" border="0"></a></td>
	<td><a href=""><img src="images034/b06.gif" width="107" height="42" alt="" border="0"></a></td>
	<td><a href=""><img src="images034/b07.gif" width="89" height="42" alt="" border="0"></a></td>
	<td><a href=""><img src="images034/b08.gif" width="109" height="42" alt="" border="0"></a></td>
</tr>
</table>
	</td>
</tr>
</table>	</td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="591" align="center">
<tr valign="top">
	<td width="50" rowspan="3">
<br>
    </td>
	<td width="10"><img src="images034/m11.gif" width="1" height="16" alt="" border="0"></td>
	<td><img src="images034/m12.gif" width="579" height="16" alt="" border="0"></td>
	<td width="4"><img src="images034/m13.gif" width="1" height="16" alt="" border="0"></td>
</tr>
<tr>
	<td bgcolor="#979797"><img src="images034/px1.gif" width="1" height="1" alt="" border="0"></td>
	<td bgcolor="#FFFFFF" height="214" valign="top">
<table border="0" cellpadding="0" cellspacing="0" width="95%" align="center" height="25" background="images034/fon_bar01.gif">
<tr>
	<td>
<table border="0" cellpadding="0" cellspacing="0" background="" bgcolor="#FFFFFF">
<tr>
	<td><img src="images034/e03.gif" width="21" height="21" alt="" border="0" align="left"></td>
	<td><p class="bar01" style="color: #DA0008; font-size: 18px; ">Iniciar sesi&oacute;n</p></td>
</tr>
</table>
	</td>
</tr>
</table>
<p class="px5">
	<cfif Len(GetAuthUser()) EQ 0>
<form action="<cfoutput>#url.uri#</cfoutput>" method="post" id="form1">
	<table width="200" border="0">
  <tr>
    <td>Usuario</td>
    <td><input type="Text" name="j_username" size="11"></td>
  </tr>
  <tr>
    <td>Contrase&ntilde;a</td>
    <td><input type="password" name="j_password" size="11"></td>
  </tr>
  <tr>
    <td colspan="2"><input name="image" type="image" src="images034/b_login.gif" alt="" align="absbottom" width="79" height="20" border="0"></td>
    </tr>
</table>
	</form>
<cfelse><cfoutput><p class="px5">Bienvenido, #GetAuthUser()#</p></cfoutput>
</cfif>
</p></td>
	<td bgcolor="#979797"><img src="images034/px1.gif" width="1" height="1" alt="" border="0"></td>
</tr>
<tr>
	<td><img src="images034/m31.gif" width="1" height="16" alt="" border="0"></td>
	<td><img src="images034/m32.gif" width="579" height="16" alt="" border="0"></td>
	<td><img src="images034/m33.gif" width="1" height="16" alt="" border="0"></td>
</tr>
</table><table border="0" cellpadding="0" cellspacing="0" width="740" align="center">
<tr>
	<td><p align="right" style="margin-right: 200px;">Copyright &copy;2003 soin.net</p></td>
</tr>
</table>

</body>
</html>
