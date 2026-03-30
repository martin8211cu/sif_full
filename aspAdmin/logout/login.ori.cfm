<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>MiGesti&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="login.css" rel="stylesheet" type="text/css">
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
<<cfoutput>script</cfoutput> type='text/javascript'>
<cfinclude template="login.js">
</script>
</head>

<body text="#000000" bgcolor="ffffff">

<table width="567" border="0" align="center" cellpadding="0" cellspacing="0">
  <!--DWLayoutTable-->
  <tr> 
    <td width="318">&nbsp;</td>
    <td width="13">&nbsp;</td>
    <td width="236">&nbsp;</td>
  </tr>
  <tr> 
    <td valign="top" ><table width="100%" border="0" cellpadding="0" cellspacing="0">
        <!--DWLayoutTable-->
        <tr> 
          <td width="318" align="center" valign="middle"><img src="login-migestion.gif" alt="migestion.net" width="210" height="130"></td>
        </tr>
<cfif IsDefined("url.errormsg")>
        <tr> 
          <td height="19" align="center" valign="middle"><font color="#FF0000" size="+1"><strong>No 
            se pudo iniciar la sesi&oacute;n.<br>
            </strong></font><font color="#FF0000">Por favor ingrese su usuario 
            nuevamente.</font></td>
        </tr>
</cfif>
        <tr> 
          <td align="center" valign="middle">
		  <cfinclude template="login-form.cfm" > 
		  </td>
        </tr>
        <tr> 
          <td valign="middle"><font color="#666666" size="-1" face="Geneva, Arial, Helvetica, san-serif, Sylfaen"><strong>migestion.net 
            </strong>es un portal de Servicios digitales al ciudadano, donde en 
            &uacute;nico punto de acceso integra informaci&oacute;n bancaria, 
            comercial, educativa, etc. que el ciudadano necesita cotidianamente 
            en Costa Rica. Y convenientemente ofrece herramientas de alto valor 
            agregado para trabajar con esa informaci&oacute;n.</font></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
      </table></td>
    <td>&nbsp;</td>
    <td align="center" valign="middle">
		<table width="237" border="0" cellpadding="0" cellspacing="0" style="background-image: url(login-cr.gif)">
        <!--DWLayoutTable-->
        <tr> 
          <td align="left" height="297" valign="bottom">
		  <p>
		  <a href="javascript:popUp('https://digitalid.verisign.com/as2/6f9c3fe1a3b3c8402b450dfa2c054233')"><img src="Verisign-Secure-White98x102.gif" width="98"height="102" border="0" alt="Verisign-Secure"></a>
		  </p><p>
      	<img border="0"
          src="valid-html401.gif"
          alt="P&aacute;gina HTML 4.01!" height="31" width="88">
    	</p>
		  </td>
        </tr>
      	</table>
	  </td>
  </tr>
  <tr align="center" valign="middle"> 
    <td colspan="3" valign="top" ><font color="004282" face="Verdana, Arial, Helvetica, sans-serif" size="2">Todos 
      los derechos reservados &copy; 2003 <br>
      <a href="mailto:gestion@soin.co.cr">webmaster</a></font> </td>
  </tr>
</table>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>

</body>
</html>
