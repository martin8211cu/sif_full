<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Grupo Nacion GN</title>
	<link rel="stylesheet" type="text/css" href="style.css">
<script type='text/javascript'>
	function popUp(url) {
	sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=500,height=450');
	self.name = "mainWin";
	}
</script>
<!---
	este include tan raro esta porque no servia un script con src=login.js.
	MS IE 6.0.3790.0
	/danim
--->
<style type="text/css">
<!--
.style1 {font-weight: bold}
.style2 {
	font-size: 18px;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #999999;
}
.style3 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<<cfoutput>script</cfoutput> type='text/javascript'>
<cfinclude template="login.js">
</script>
</head>
<body bgcolor="#ffffff" marginheight="0" marginwidth="0" leftmargin="0" rightmargin="0">
<table width="100%" align="center">
<tr align="center">
<td align="center">
	<table width="94%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	  <tr>
		<!--- <td width="50%" background="images/bg.gif"><img src="images/px1.gif" width="1" height="1" alt="" border="0"></td>
		<td valign="bottom" background="images/bg_left.gif">&nbsp;</td>
		--->
		<td valign="top"> 
			<table border="0" cellpadding="0" cellspacing="0" width="780" height="109">
				<tr>
					<td background="images/top.jpg"> <div align="left">&nbsp;&nbsp;&nbsp;<span class="style2">
					<!---<cfoutput>#Request.Translate('login_company','Company name Here')#</cfoutput>--->
					</span></div></td>
				</tr>
			</table>
			<table width="782" border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td width="822" height="35" background="images/fon04.gif"><span class="style3"><!---<a href="http://www.nacion.com">
				  <img src="images/but01.gif" width="88" height="35" border="0"></a>---></span></td>
				</tr>
				<tr>
				  <td><img src="images/main01.jpg" width="239" height="191"><img src="images/main02.jpg" width="271" height="191"><img src="images/main03.jpg" width="215" height="191"><img src="images/main04.jpg" width="56" height="191"></td>
				</tr>
			</table>
	<table border="0" cellpadding="0" cellspacing="0" width="780">
	<tr valign="top">
		<td width="455">
				<p><img src="images/temp01.jpg" width="153" height="135" alt="" border="0" hspace="10" align="left"><strong>Sistema
				  de Recursos Humanos</strong></p>
			  <p align="justify">Toda organizaci&oacute;n se relaciona con un entorno cambiante,
				la capacidad de identificar los cambios que afectan su negocio y
				la forma de adecuarse exitosamente es la inteligencia de la empresa. </p>
			  <p align="justify">A partir de la inteligencia, la organizaci&oacute;n crece, evoluciona
				y encuentra el &eacute;xito. La inteligencia reside en la gente,
			  gente comprometida, motivada que trabaja y piensa en conjunto. </p></td>
		<td colspan="2" nowrap align="center">
		  <cfinclude template="login-form2.cfm">
	    </td>
		</tr>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" width="780" height="47" background="images/fon02.gif">
	<tr>
		<td>
	<table border="0" cellpadding="0" cellspacing="0" width="90%" background="" align="center">
	<tr>
		<td><p align="right">(C) SOIN, Soluciones Integrales S.A. 2003 </p>
	      <p align="right" class="menu02">&nbsp;
	        </p></td>
		</tr>
	</table>
		</td>
	</tr>
	</table>
		</td>
		<!--- <td valign="bottom" background="images/bg_right.gif"><img src="images/bg_right.gif" alt="" width="17" height="16" border="0"></td>
		<td width="50%" background="images/bg.gif"><img src="images/px1.gif" width="1" height="1" alt="" border="0"></td> --->
	</tr>
	</table>
</td>
</tr>
</table>
<map name="Map">
  <area shape="rect" coords="15,4,135,13" href="#">
  <area shape="rect" coords="15,16,80,26" href="#">
</map>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>
</body>
</html>
