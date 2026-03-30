<html>
<head>
<meta http-equiv="Content-Language" content="en-us">

<title>LOGIN</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
</head>
<body bgcolor="#7D99BC">


<!-- ImageReady Slices (pagelogin.psd) -->
<table borderColor="#EEEEEE" table height="100%" cellSpacing="0" cellPadding="0" width="603" border="1" align="center"><td height="142">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="5">
			<map name="FPMap1">
            <area href="index.cfm" shape="rect" coords="169, 2, 290, 46">
            <area href="product.html" shape="rect" coords="296, 2, 399, 49">
            <area href="ser.html" shape="rect" coords="413, 0, 492, 38">
            <area href="evento.html" shape="rect" coords="507, 0, 590, 36">
            <area href="socio.html" shape="rect" coords="613, 0, 698, 37">
            <area href="pagelogin.cfm" shape="rect" coords="719, 0, 796, 38">
            </map>
			<img src="images9/pagelogin_01.jpg" usemap="#FPMap1" border="0" width="800" height="93" /></td>
	</tr>
	<tr>
		<td colspan="5">
			<img src="images/pagelogin_02.jpg" alt="" width="800" height="32" /></td>
	</tr>
	<tr>
		<td colspan="3">
			<img src="images/pagelogin_03.jpg" alt="" width="279" height="24" /></td>
		<td rowspan="2" bgcolor="#C8E3F4">
			<p align="center">
            <img border="0" src="images/logo%20copy.gif" width="138" height="99">
<cfparam name="url.errormsg" default="0">
<cfparam name="url.uri" default="">
<form name="login" onsubmit="return validarLogin(this);" action="<cfoutput>#url.uri#</cfoutput>" method="post" >
  <table cellpadding="0" cellspacing="0" >
    <!--DWLayoutTable-->
    <tr> 
      <td valign="top" class="g"><table border="0" cellpadding="0" cellspacing="0" align="center" >
          <!--DWLayoutTable-->
		  <cfif url.errormsg neq 0>
          <tr>
            <td colspan="2" align="left" valign="top" ><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#FF0000"><b>&nbsp;</b></font></div></td>
          </tr>
          <tr>
            <td colspan="2" align="left" valign="top" ><p>&nbsp;</p>              </td>
          </tr></cfif>
<cfif Len(session.sitio.CEcodigo) EQ 0>
          <tr>
            <td width="115" align="left" valign="top" >
              <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#00000">&nbsp;<b>Empresa</b></font>
			  </td>
            <td align=left valign=top><!--DWLayoutEmptyCell-->&nbsp;</td>
          </tr>
          <tr>
            <td align="center" valign="top" ><font face="verdana, helvetica, arial" size="2" color="#ffffff">
              <input type="text" name="j_empresa" size="14" tabindex="1" onfocus="this.select()" >
            </font></td>
            <td align=left valign=top><!--DWLayoutEmptyCell-->&nbsp;</td>
          </tr>
</cfif>
          <tr> 
            <td width="115" align="left" valign="top" >  <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#00000">&nbsp;<b>Usuario</b></font></td>
            <td width="120" align="left" valign="top" > </td>
          </tr>
          <tr> 
            <td align="center" valign="top" ><font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
              <input type="text" name="j_username" size="14" tabindex="2" onfocus="this.select()" >
              </font></td>
            <td align="center" valign="top"> </td>
          </tr>
          <tr>
            <td align="left" valign="top" > <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#00000">&nbsp;<b><font size="2">Contrase&ntilde;a</font></b></font> </td>
            <td align=left valign=top><!--DWLayoutEmptyCell-->&nbsp;</td>
          </tr>
          <tr>
            <td align="center" valign="top" ><font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
              <input type="password" name="j_password" size="14" tabindex="3" onfocus="this.select()" >
              </font> </td>
            <td align=left valign=top><!--DWLayoutEmptyCell-->&nbsp;</td>
          </tr>
          <tr> 
            <td align=left valign=top colspan="2"> <div align="center"><font size="1"> 
                <font face="Verdana, Arial, Helvetica, sans-serif"> 
                <input type="checkbox" id="recordar" name="recordar" value="checkbox" tabindex="4">
                <font color="#000000"><label for="recordar">Recordar mi usuario en este computador</label></font></font></font></div></td>
          </tr>
          <tr> 
            <td height="11"></td>
            <td></td>
          </tr>
          <tr> 
            <td colspan="2" align="center" valign="top"><input type="submit" name="Submit" value="Conectarse" tabindex="5"></td>
          </tr>
      </table></td>
    </tr>
    <tr> 
      <td></td>
    </tr>
    <tr>
      <td align="center" valign="top" class="g"><font face="Verdana" size="2"><a href="/cfmx/home/public/login-ayuda.html">&iquest;Necesita 
        ayuda para ingresar?</a><u><br> </u> <a href="/cfmx/home/public/recordar.cfm">&iexcl;Olvid&eacute; 
        mi contrase&ntilde;a!</a></font></td>
    </tr>
    <tr>
      <td></td>
    </tr>
  </table>
</form>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
            </script>
<!--webbot bot="HTMLMarkup" endspan --></td>
		<td rowspan="3">
			<img src="images/pagelogin_05.jpg" alt="" width="270" height="475" /></td>
	</tr>
	<tr>
		<td rowspan="2">
			<img src="images/pagelogin_06.jpg" alt="" width="23" height="451" /></td>
		<td>
			<img src="images/pagelogin_07.jpg" alt="" width="175" height="382" /></td>
		<td rowspan="2">
			<img src="images/pagelogin_08.jpg" alt="" width="81" height="451" /></td>
	</tr>
	<tr>
		<td>
			<img src="images/pagelogin_09.jpg" alt="" width="175" height="69" /></td>
		<td>
			<img src="images/pagelogin_10.jpg" alt="" width="251" height="69" /></td>
	</tr>
</table>
  </table>
<!-- End ImageReady Slices -->

</body>
</html>

