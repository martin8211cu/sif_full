<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>SoyCristiano.net</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="html/text.css" type="text/css">
<link href="STYLE07.CSS" rel="stylesheet" type="text/css">
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="975" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr class="trblue">
    <td height="15" colspan="3"><img src="images/spacer.gif" width="1" height="15"></td>
  </tr>
  <tr> 
    <td width="255"  background="images/layoutlogin.gif" colspan="0">      <div align="right">        
          <table width="100%" border="0">
            <tr>
					  <td valign="top" background="images/layoutlogin.gif" width="230" class="etiqwhite">
                <cfif FindNoCase("/login.cfm",CGI.SCRIPT_NAME) EQ 0>
                  <cfif isDefined("Session.Usucodigo") and Session.Usucodigo is 0>
                    <cfinclude template="/plantillas/iglesias07/login-form2.cfm">
                  </cfif>
				 <cfelse> <div align="center"><span class="etiqwhite16">Usuario <br> o Password incorrectos</font></div>
                </cfif>			  </td>
            </tr>
			<tr><td background="images/layoutlogin.gif"><cfinclude template="/plantillas/iglesias07/pUbica.cfm"></td>
			
          </table>
    </div>	 </td>
    <td width="725" height="100" align="right"><div align="left"><a href="/cfmx/plantillas/iglesias07/index.cfm"><img  src="images/titulo.gif" width="725" height="100" border="0"></a></div></td>
  </tr>
              <tr> 
                <td colspan="3"><TABLE width="980" BORDER=0 CELLPADDING=0 CELLSPACING=0 bgcolor="#FFFFFF">
                  <!--DWLayoutTable-->
                  <TR>
                    <TD colspan="2"  valign="top" >
					<table width="255" border="0" align="left" cellpadding="0" cellspacing="0" bordercolor="#111111" id="AutoNumber1" style="border-collapse: collapse">
					  <tr>
                        <td valign="top" background="images/layout_18.gif"><div align="center"></div></td>
				      </tr>
					  <tr>
                        <td valign="top" background="images/layout_18.gif">$$LEFT OPTIONAL$$</td>
				      </tr>
					  <tr>
                        <td valign="top" background="images/layout_18.gif">
                          <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td height="75" colspan="4" align="center" valign="middle" class="style77"><img src="images/Emisoras.gif" width="250" height="30"></td>
                            </tr>
                            <tr>
                              <td align="center" valign="middle" class="style77">&nbsp;</td>
                              <td height="75" align="center" valign="middle" class="style77"><a href="http://205.160.32.134:8000/listen.pls"><img src="images/Radio1.bmp" width="85" height="55" border="1"></a></td>
                              <td class="style77"><p>&nbsp;</p></td>
                              <td class="style77">Cristianos de Bucaramanga (Colombia). (<a href="http://205.160.32.134:8000/listen.pls">escuchar</a>) </td>
                            </tr>
                            <tr>
                              <td height="1%" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                              <td align="center" valign="middle" class="style77">&nbsp;</td>
                              <td height="75" align="center" valign="middle" class="style77"><a href="http://200.81.192.232:2004/listen.pls"><img src="images/Radio1.bmp" width="85" height="55" border="1"></a></td>
                              <td class="style77"><p>&nbsp;</p></td>
                              <td class="style77">Radio Maranata<br>
                                (Argentina) (<a href="http://200.81.192.232:2004/listen.pls">escuchar</a>)     </td>
                            </tr>
                            <tr>
                              <td height="1%" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                              <td align="center" valign="middle" class="style77">&nbsp;</td>
                              <td height="75" align="center" valign="middle" class="style77"><a href="mms://216.66.58.34/CristoTVMinistries"><img src="images/Radio1.bmp" width="85" height="55" border="1"></a></td>
                              <td class="style77"><p>&nbsp;</p></td>
                              <td class="style77"><p>Cristo TV (<a href="mms://216.66.58.34/CristoTVMinistries">ver</a>) </p>                              </td>
                            </tr>
                            <tr>
                              <td height="1%" colspan="4">&nbsp;</td>
                            </tr>
                            <tr>
                              <td width="10%" align="center" valign="middle" class="style77">&nbsp;</td>
                              <td height="75" align="center" valign="middle" class="style77"><a href="mms://209.215.78.31/pastor"><img src="images/Radio1.bmp" width="85" height="55" border="1"></a></td>
                              <td width="5%" class="style77"><p>&nbsp;</p></td>
                              <td class="style77">Radio Alerta (<a href="mms://209.215.78.31/pastor">ver</a>) </td>
                            </tr>
                            <tr>
                              <td height="1%" colspan="4">&nbsp;</td>
                            </tr>
                        </table>						</td>
				      </tr>
					  <tr><td background="images/layout_18.gif" height="1%" colspan="2"><hr align="center" size="1" color="#000000" ></td></tr>
					  <tr>
                        <td valign="top" background="images/layout_18.gif">
						<form name="form1" method="post" action="">
						  <div align="center">
						  <table width="80%"  border="0" cellspacing="0" cellpadding="0">
						    <tr>
						  	  <td width="5%">&nbsp;</td>
							  <td class="etiqblack">Subscribase para recibir diaramente la Palabra de Dios</td>
						    </tr>
						    <tr>
						  	  <td width="5%">&nbsp;</td>
							  <td>&nbsp;</td>
						    </tr>
						    <tr>
							  <td width="5%">&nbsp;</td>
							  <td class="style77">Si su interes es recibir los mensajes diarios, debe escribir su correo electronico y luego presionar el bot&oacute;n de Subscribirse</td>
						    </tr>
						  						    <tr>
						  	  <td width="5%">&nbsp;</td>
							  <td>&nbsp;</td>
						    </tr>
						  </table>
						  <table width="80%"  border="0" align="center" cellpadding="1" cellspacing="0">
						    <tr>
							  <td colspan="2"><div align="center"><strong>Subscr&iacute;bete</strong></div></td>
						    </tr>
						    <tr>
							  <td width="28%">e-mail</td><td width="72%">
							    <input name="email" type="text" id="email">
							  </td>
						    </tr>
						    <tr>
							  <td colspan="2">
							    <div align="center">
								  <input type="submit" name="Submit" value="Subscribirse">
							    </div></td>
						    </tr>
						  </table>
					      </div>
						</form>
						</td>
				      </tr>
                      <tr>
                        <td>&nbsp;</td>
                      </tr>
                    </table>                   
					</TD>
                    <TD width="725"  align="right" valign="top">
                      <table border="0" cellpadding="5" cellspacing="0"  bordercolor="#111111" id="AutoNumber3" width="100%">
                        <tr>
                          <TD valign="top">
                            <div align="center" class="etiqblack">$$TITLE$$</div>
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
  <tr class="trblue"> 
    <td height="20" colspan="3"><div align="center"><strong><font size="1" face="Verdana" color="#FFFFFF">Copyright (C) 2004, Soluciones Integrales S.A., All rights reserved.</font></strong></div></td>
  </tr>
  <tr>
    <td height="3" colspan="3" bgcolor="#000000"><img src="html/images/spacer.gif" width="1" height="3"></td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
</html>
