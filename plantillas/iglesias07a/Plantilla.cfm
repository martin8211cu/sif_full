<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>SoyCristiano.net</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="html/text.css" type="text/css">
<style type="text/css">
<!--
.style75 {font-family: Arial, Helvetica, sans-serif; color: #FFFFFF; font-weight: bold; font-size: 12px; }
.style1 {color: #FFFFFF}
.style3 {font-size: 12px}
.style68 {	color: #FF0000;
	font-weight: bold;
	font-size: 16px;
}
.style65 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; color: #000000;}
.style79 {color: #990000}
.style81 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #996600;
	font-size: 10px;
	font-weight: bold;
}
.style85 {font-size: 10px}
.style86 {font-family: Geneva, Arial, Helvetica, sans-serif}
.style88 {font-size: 10}
.style89 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: 10; }
.style90 {font-family: Geneva, Arial, Helvetica, sans-serif; color: #996600; font-size: 12px; font-weight: bold; }
.style64 {	color: #000000;
	font-size: 12px;
	font-weight: bold;
	font-style: italic;
}
.style66 {color: #666666; font-size: 12px; font-weight: bold; }
.leftmenutitle {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #996600;
	font-size: 10px;
	font-weight: bold;
}
.leftmenuitem {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #996600;
	font-size: 10px;
}
-->
</style>
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="975" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td colspan="3"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#CC9900">
        <tr> 
          <td width="54"><div align="center" class="style75"></div></td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="15" colspan="3" bgcolor="#000000"><img src="images/spacer.gif" width="1" height="15"></td>
  </tr>
  <tr> 
    <td width="255"  background="images/layout_18.gif" colspan="0">      <div align="right">        
          <table width="100%" border="0">
            <tr>
					  <td valign="top" background="images/layout_18.gif" width="230">
                <cfif FindNoCase("/login.cfm",CGI.SCRIPT_NAME) EQ 0>
                  <cfif isDefined("Session.Usucodigo") and Session.Usucodigo is 0>
                    <cfinclude template="/plantillas/iglesias07/login-form2.cfm">
                  </cfif>
                </cfif>                				
			  </td>
            </tr>
			<tr><td background="images/layout_18.gif"><cfinclude template="/plantillas/iglesias07/pUbica.cfm"></td>
			
          </table>
    </div>	</td>
    <td width="725" height="100" align="right"><div align="left"><img  src="images/titulo.gif" width="725" height="100"></div></td>
  </tr>
              <tr> 
                <td colspan="3"><TABLE width="980" BORDER=0 CELLPADDING=0 CELLSPACING=0 bgcolor="#FFFFFF">
                  <!--DWLayoutTable-->
                  <TR>
                    <TD colspan="2"  valign="top" >
					<table width="255" border="0" align="left" cellpadding="0" cellspacing="0" bordercolor="#111111" id="AutoNumber1" style="border-collapse: collapse">
					<tr>
					  <td background="images/layout_17.gif">&nbsp;</td>
					  <td valign="top" background="images/layout_18.gif"><div align="center"><IMG SRC="images/layout_11.gif" WIDTH=219 HEIGHT=76 ALT=""></div></td>
					  <td background="images/layout_19.gif">&nbsp;</td>
					  </tr>
					<tr>
                        <td background="images/layout_17.gif">&nbsp;</td>
                        <td valign="top" background="images/layout_18.gif">$$LEFT OPTIONAL$$</td>
                        <td background="images/layout_19.gif">&nbsp;</td>
					</tr>

                      <tr>
                        <td background="images/layout_17.gif"><IMG SRC="images/layout_17.gif" WIDTH=17 HEIGHT=225 ALT=""></td>
                        <td valign="top" background="images/layout_18.gif">                          <div align="center"><span class="style90">Horario de Servicios </span> </div>                          
                          <table cellspacing="1" cellpadding="0">
                            <tr bgcolor="#CC9900" class="style65">
                              <td colspan="3" align="middle" class="style1 ver11"><strong class="style1">Lunes </strong></td>
                            </tr>
                            <tr class="style81">
                              <td width="55" align="right" class="ver11 style86 style85">3:30 PM<br>
      7:00 PM </td>
                              <td></td>
                              <td width="162" class="ver11 style86 style85">Cultos de oraci&oacute;n </td>
                            </tr>
                            <tr class="style65">
                              <td class="ver11" align="middle" colspan="3"></td>
                            </tr>
                            <tr class="style65">
                              <td colspan="3" align="middle" bgcolor="#CC9900" class="style1"><strong>Martes </strong></td>
                            </tr>
                            <tr class="style90">
                              <td align="right" class="ver11 style86 style85">3:00 PM </td>
                              <td><span class="style85"></span></td>
                              <td class="ver11 style86 style85">Culto de la sociedad de se&ntilde;oras </td>
                            </tr>
                            <tr class="style81">
                              <td class="ver11" align="middle" colspan="3"></td>
                            </tr>
                            <tr bgcolor="#CC9900" class="style81">
                              <td colspan="3" align="middle" class="style1 ver11"><strong>Mi&eacute;rcoles</strong></td>
                            </tr>
                            <tr class="style90">
                              <td align="right" class="ver11 style86 style85">7:00 PM </td>
                              <td width="3"><span class="style85"></span></td>
                              <td class="ver11 style86 style85">Estudio b&iacute;blico </td>
                            </tr>
                            <tr class="style65">
                              <td class="ver11" align="middle" colspan="3"></td>
                            </tr>
                            <tr bgcolor="#CC9900" class="style65">
                              <td colspan="3" align="middle" class="style1 ver11"><strong>Jueves </strong></td>
                            </tr>
                            <tr class="style81">
                              <td align="right" class="ver11 style86 style85">7:00 PM </td>
                              <td width="3"><span class="style85"></span></td>
                              <td class="ver11 style86 style85">Oraci&oacute;n por las misiones </td>
                            </tr>
                            <tr class="style65">
                              <td class="ver11" align="middle" colspan="3"></td>
                            </tr>
                            <tr bgcolor="#CC9900" class="style65">
                              <td colspan="3" align="middle" class="ver11"><span class="style1"><strong>S&aacute;bado </strong></span></td>
                            </tr>
                            <tr class="style81">
                              <td align="right" class="ver11 style86 style85">4:30 PM </td>
                              <td width="3"><span class="style85"></span></td>
                              <td class="ver11 style86 style85">Reuni&oacute;n de j&oacute;venes </td>
                            </tr>
                            <tr class="style65">
                              <td class="ver11" align="middle" colspan="3"></td>
                            </tr>
                            <tr bgcolor="#CC9900" class="style65">
                              <td colspan="3" align="middle" class="style1"><strong>Domingo </strong></td>
                            </tr>
                            <tr class="style81">
                              <td align="right" class="ver11 style86 style88">9:00 AM </td>
                              <td width="3"><span class="style88"></span></td>
                              <td class="ver11 style86 style88">Escuela b&iacute;blica dominical </td>
                            </tr>
                            <tr class="style81">
                              <td class="ver11" align="right"><div align="left" class="style89">10:15 AM </div></td>
                              <td width="3"><span class="style88"></span></td>
                              <td class="ver11 style86 style88">Servicio de adoraci&oacute;n </td>
                            </tr>
                            <tr class="style81">
                              <td align="right" class="ver11 style86 style88">3:30 PM </td>
                              <td width="3"><span class="style88"></span></td>
                              <td class="ver11 style86 style88">Culto evangel&iacute;stico </td>
                            </tr>
                            <tr>
                              <td class="ver11" colspan="3"><cfinclude template="pActividades.cfm"></td>
                            </tr>
                          </table></td>
                        <td background="images/layout_19.gif"><IMG SRC="images/layout_19.gif" WIDTH=15 HEIGHT=225 ALT=""></td>
                      </tr>
                      <tr>
                        <td background="images/layout_17.gif">&nbsp;</td>
                        <td valign="top" background="images/layout_18.gif">&nbsp;</td>
                        <td background="images/layout_19.gif">&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan="3"><div align="left"><IMG SRC="images/layout_22.gif" WIDTH="256" HEIGHT="28" ALT=""> </div></td>
                      </tr>
                    </table>                   
					</TD>
					
					
                    <TD width="725"  align="right" valign="top">
                      <table border="0" cellpadding="5" cellspacing="0"  bordercolor="#111111" id="AutoNumber3" width="100%">
                        <tr>
                          <TD valign="top">
                            <div align="center" class="style90">$$TITLE$$</div>
                            <div align="left"> $$HEADER OPTIONAL$$</div></TD>
                        </tr>
                        <tr>
                          <td width="725" valign="top">$$BODY$$</td>
                        </tr>
                    </table></TD>
                </TABLE></td>
              </tr>
              <tr> 
                <td height="1" colspan="3" bgcolor="#FFFFFF"><img src="html/images/spacer.gif" width="1" height="1"></td>
              </tr>

        <tr><td colspan="3"></tr>

  <tr><td colspan="3"></tr>
  <tr bgcolor="#CC9900"> 
    <td height="20" colspan="3"><div align="center"><strong><font size="1" face="Verdana" color="#FFFFFF">Copyright (C) 2004, Soluciones Integrales S.A., All rights reserved.</font></strong></div></td>
  </tr>
  <tr>
    <td height="3" colspan="3" bgcolor="#000000"><img src="html/images/spacer.gif" width="1" height="3"></td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
</html>
