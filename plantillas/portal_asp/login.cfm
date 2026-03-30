<HTML>
<HEAD>
<TITLE>LOGIN</TITLE>
<link href="login.css" rel="stylesheet" type="text/css">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1252">
<script type="text/javascript" src="login.js"></script>
</HEAD>
<BODY BGCOLOR=#C8D3F4 LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<!-- ImageReady Slices (login.psd) -->
<table borderColor="#EEEEEE" table height="100%" cellSpacing="0" cellPadding="0" width="603" border="0" align="center"><td height="142">
<TABLE WIDTH=645 BORDER=0 CELLPADDING=0 CELLSPACING=0>
	<TR>
		  <TD COLSPAN=5> 
<map name="FPMap0">
            <area href="index.html" shape="rect" coords="171, 75, 232, 112">
            <area href="productos.html" shape="rect" coords="239, 87, 338, 112">
            <area href="servicios.html" shape="rect" coords="344, 84, 414, 113">
            <area href="socios.html" shape="rect" coords="422, 81, 501, 114">
            <area href="eventos.html" shape="rect" coords="505, 85, 594, 113">
            <area href="../../home/menu/index.cfm" shape="rect" coords="597, 81, 666, 113">
            <area href="contacto.html" shape="rect" coords="669, 92, 765, 115">
            </map>
			<IMG SRC="images/abc_01.jpg" usemap="#FPMap0" border="0" width="775" height="119"></TD>
		<TD width="1">
			<IMG SRC="imageslogin/spacer.gif" WIDTH=1 HEIGHT=123 ALT=""></TD>
	</TR>
	<TR>
		  <TD width="156" ROWSPAN=3 bgcolor="#FFFFFF"> <IMG SRC="imageslogin/login_02.jpg" ALT="" width="156" height="223"></TD>
		  <TD width="40" ROWSPAN=5 valign="top" bgcolor="#FFFFFF"> 
            <p><IMG SRC="imageslogin/login_03_b.jpg" ALT="" width="40" height="350"></p>
</TD>
          <TD width="237" height="43" valign="bottom" bgcolor="#FFFFFF"> <IMG SRC="imageslogin/login_04_b.jpg" ALT="" width="239" height="43"></TD>
		  <TD width="83" ROWSPAN=5 valign="top" bgcolor="#FFFFFF"> 
            <p><IMG SRC="imageslogin/login_05_b.jpg" ALT="" width="45" height="350"></p></TD>
		  <TD width="259" ROWSPAN=2 bgcolor="#FFFFFF"> <IMG SRC="imageslogin/login_06.jpg" ALT="" width="259" height="199"></TD>
		<TD width="1">
			<IMG SRC="imageslogin/spacer.gif" WIDTH=1 HEIGHT=43 ALT=""></TD>
	</TR>
	<TR>
		  <TD ROWSPAN=3 width="237"> 
<p align="center"> <font face="Arial Black"><b>LOGIN</b></font> 
<cfparam name="url.errormsg" default="0"> 
              <cfparam name="url.uri" default="/cfmx/home/menu/index.cfm">
<form name="login" onsubmit="this.j_empresa.value='*';return validarLogin(this);" action="<cfoutput>#url.uri#</cfoutput>" method="post" >
              <table cellpadding="0" cellspacing="0" >
    <!--DWLayoutTable-->
                <tr> 
                  <td valign="top" class="g">
<table border="0" cellpadding="0" cellspacing="0" align="center" height="131" >
                      <!--DWLayoutTable-->
<cfif url.errormsg neq 0>
                      </cfif>
                      <!---
<cfif Len(session.sitio.CEcodigo) EQ 0>
          <tr>
            <td width="115" align="left" valign="top" height="19" >
              <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#00000">&nbsp;<b>Empresa</b></font>
			  </td>
            <td align=left valign=top height="19"><font face="verdana, helvetica, arial" size="2" color="#ffffff">
<cfif Len(session.sitio.CEcodigo) EQ 0>
              <input type="text" name="j_empresa" size="14" tabindex="1" onfocus="this.select()" ></cfif></font></td>
          </tr>
          <tr>
            <td align="center" valign="top" height="17" ><font face="verdana, helvetica, arial" size="2" color="#ffffff">&nbsp;
              </font></td>
            <td align=left valign=top height="17"></td>
          </tr>
</cfif>--->
                      <tr> 
                        <td width="115" align="left" valign="top" height="16" > 
                          <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#00000">&nbsp;<b>Email</b></font></td>
                        <td width="120" align="left" valign="top" height="16" > 
                          <font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
                          <input type="hidden" name="j_empresa" value="*" readonly="readonly" autocomplete="off">
                          <input type="text" name="j_username" size="14" tabindex="2" onfocus="this.select()" >
                          </font></td>
                      </tr>
                      <tr> 
                        <td align="center" valign="top" height="22" ><font face="verdana, helvetica, arial" size="2" color="#ffffff">&nbsp; 
                          </font></td>
                        <td align="center" valign="top" height="22"> </td>
                      </tr>
                      <tr> 
                        <td align="left" valign="top" height="19" > <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#00000">&nbsp;<b><font size="2">Contrase&ntilde;a</font></b></font> 
                        </td>
                        <td align=left valign=top height="19"><font face="verdana, helvetica, arial" size="2" color="#ffffff"> 
                          <input type="password" name="j_password" size="14" tabindex="3" onfocus="this.select()" >
                          </font></td>
                      </tr>
                      <tr> 
                        <td align=left valign=top colspan="2" height="20"> <div align="center"><font size="1"> 
                            <font face="Verdana, Arial, Helvetica, sans-serif"> 
                            <input type="checkbox" id="recordar" name="recordar" value="checkbox" tabindex="4">
                            <font color="#000000"> 
                            <label for="recordar">Recordar mi usuario en este 
                            computador</label>
                            </font></font></font></div></td>
                      </tr>
                      <tr>
                        <td colspan="2" align="center" valign="top" height="19"><!--DWLayoutEmptyCell-->&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="2" align="center" valign="top" height="26"><input type="submit" name="Submit" value="Conectarse" tabindex="5"></td>
                      </tr>
                    </table></td>
    </tr>
    <tr> 
      <td></td>
    </tr>
    <tr>
      <td align="center" valign="top" class="g">
	  <br><font face="Verdana">
      <a href="/cfmx/home/public/login-ayuda.html" style="text-decoration: none;color:#333333">
      <font size="2">&iquest;Necesita 
        ayuda para ingresar?</font></a><font size="2"><br> </font> 
      <a href="/cfmx/home/public/recordar.cfm" style="text-decoration: none;color:#333333">
      <font size="2">&iexcl;Olvid&eacute; 
        mi contrase&ntilde;a!</font></a></font></td>
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

<!--webbot bot="HTMLMarkup" endspan --></TD>
		<TD width="1">
			<IMG SRC="imageslogin/spacer.gif" WIDTH=1 HEIGHT=156 ALT=""></TD>
	</TR>
	<TR>
		<TD bgcolor="#FFFFFF" width="259">&nbsp;
			</TD>
		<TD width="1">
			<IMG SRC="imageslogin/spacer.gif" WIDTH=1 HEIGHT=24 ALT=""></TD>
	</TR>
	<TR>
		<TD ROWSPAN=2 width="156" bgcolor="#FFFFFF">&nbsp;
			</TD>
		<TD ROWSPAN=2 bordercolor="#FFFFFF" width="259" bgcolor="#FFFFFF">&nbsp;
			</TD>
		  <TD width="1" height="92">&nbsp;</TD>
	</TR>
	<TR>
		  <TD width="237" height="34" valign="top" bgcolor="#FFFFFF"> <IMG SRC="imageslogin/login_11_b.jpg" ALT="" width="239" height="33"></TD>
		<TD width="1">
			<IMG SRC="imageslogin/spacer.gif" WIDTH=1 HEIGHT=34 ALT=""></TD>
	</TR>
	<TR>
		  <TD COLSPAN=5 align="center"> 
<p align="center" style="color:#666666">Copyright &copy; MiGestion.net 2005. Tel (506) 204-7151 P.O.Box 901-6155. San Jos&eacute;, Costa Rica. </p>
		  </TD>
		<TD width="1">
			<IMG SRC="imageslogin/spacer.gif" WIDTH=1 HEIGHT=66 ALT=""></TD>
	</TR>
</TABLE>
  </table>
<!-- End ImageReady Slices -->






</BODY>
</HTML>