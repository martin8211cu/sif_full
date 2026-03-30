<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>$$TITLE$$</title>
	<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta http-equiv="Pragma" content="no-cache">	
	<meta http-equiv="Content-Language" content="en-us">
<link href="style.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {
	font-size: 12px;
	font-weight: bold;
}
.style3 {font-size: 12px}
.style64 {
	color: #000000;
	font-size: 12px;
	font-weight: bold;
	font-style: italic;
}
.style66 {color: #666666; font-size: 12px; font-weight: bold; }
.style67 {font-size: 12px; font-weight: bold; color: #FFFFFF; }
.style68 {
	color: #695E3C;
	font-weight: bold;
	font-size: 16px;
}
-->
</style>
<script type="text/javascript" language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
</HEAD>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<!-- ImageReady Slices (layout.psd) --><!-- chinaz.com -->
<TABLE width="929" BORDER=0 CELLPADDING=0 CELLSPACING=0><!--DWLayoutTable-->
	<TR>
	    <TD colspan="3" valign="baseline" bgcolor="black"><IMG SRC="images/AD.gif" ALT="" width="145" height="20"></TD>
    </TR>
	<TR>
	    <TD colspan="3" valign="baseline" bgcolor="#CC9900">&nbsp;</TD>
    </TR>
	<TR>
		
    <TD width="4" rowspan="2"  bgcolor="#FFFAE8" valign="baseline" class="style68"><!--DWLayoutEmptyCell-->&nbsp; </TD>
	    
    <TD colspan="2"   valign="baseline" bgcolor="#FFFAE8" class="style68"><!--DWLayoutEmptyCell-->&nbsp;</TD>
    </TR>
	<TR>
	  
    <TD width="176"   valign="middle" class="style68"><cfoutput>#iif(len(trim(session.enombre)) gt 0,DE(session.enombre),DE(session.cenombre))#</cfoutput></TD>
      <td width="669" valign="bottom"><table border="0">
        <tr>
          <TD width="86" background="images/tab.gif">
            <div align="center" class="style2 style1"><span class="style1"><a href="index.cfm">Inicio</a></span></div></TD>
          <TD width="86" background="images/tab.gif">
            <div align="center"><span class="style67"><a href="principios.cfm" title="Verdades fundamentales" class="style2">Doctrina</a></span></div></TD>
          <TD width="86" background="images/tab.gif">
            <div align="center">
              <p class="style67"><a href="palabradiaria.cfm">Escuela Bíblica</a></p>
          </div></TD>
          <TD width="86" background="images/tab.gif">
            <div align="center"><span class="style67"><a href="biblia.cfm">La Biblia</a> </span></div></TD>
          <TD width="86" background="images/tab.gif">
            <div align="center"><span class="style3"><a href="misiones.cfm" class="style2">Misiones</a></span></div></TD>
        </tr>
      </table></td>
  </TR>
	<TR>
	  <TD colspan="2" valign="middle" background="images/layout_10.gif" class="style1"><!--DWLayoutEmptyCell-->&nbsp;</TD>
	  <TD background="images/layout_10.gif">		  <div align="right"><cfoutput>#LSDateFormat(Now(),'MMM DD, YYYY')#</cfoutput></div></TD>
	</TR>
	<TR>
		<TD colspan="2" >
			<IMG SRC="images/layout_11.gif" WIDTH=260 HEIGHT=76 ALT=""></TD>
	  <TD valign="top" background="images/layout_12.gif">
		<table width="100%" border="0">
			<tr>
				<td width="419">
					<cfif FindNoCase("/login.cfm",CGI.SCRIPT_NAME) EQ 0>												
						<cfif isDefined("Session.Usucodigo") and Session.Usucodigo is 0>
							<cfinclude template="login-form2.cfm">
						</cfif>
					</cfif>
					<cfinclude template="pUbica.cfm">
				</td>
				<td width="210">
					<p align="right"><span class="style64">&quot;Cree en el Se&ntilde;or Jesucristo, y ser&aacute;s salvo, t&uacute; y tu casa.&quot;</span></p>
					<p align="right"><span class="style66">(Hechos 16:31)</span></p>
				</td>
			</tr>
		</table>
	  </TD>
	</TR>
	<TR>
		<TD colspan="2"  valign="top" >

<table width="260" border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" id="AutoNumber1" style="border-collapse: collapse">
              <tr>
                <td background="images/layout_17.gif">&nbsp;</td>
                <td valign="top" background="images/layout_18.gif">                  <h2 class="style3">Horario de Servicios </h2>
                  <table cellspacing="1" cellpadding="0">
                    <tr bgcolor="#CC9900">
                      <td colspan="3" align="middle" class="style1 ver11"><strong class="style1">Lunes </strong></td>
                    </tr>
                    <tr>
                      <td width="55" align="right" class="ver11">3:30 PM<br>
      7:00 PM </td>
                      <td></td>
                      <td width="162" class="ver11">Cultos de oraci&oacute;n </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                    <tr>
                      <td colspan="3" align="middle" bgcolor="#CC9900" class="style1"><strong>Martes </strong></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">3:00 PM </td>
                      <td></td>
                      <td class="ver11">Culto de la sociedad de se&ntilde;oras </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                    <tr bgcolor="#CC9900">
                      <td colspan="3" align="middle" class="style1 ver11"><strong>Mi&eacute;rcoles</strong></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">7:00 PM </td>
                      <td width="3"></td>
                      <td class="ver11">Estudio b&iacute;blico </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                    <tr bgcolor="#CC9900">
                      <td colspan="3" align="middle" class="style1 ver11"><strong>Jueves </strong></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">7:00 PM </td>
                      <td width="3"></td>
                      <td class="ver11">Oraci&oacute;n por las misiones </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                    <tr bgcolor="#CC9900">
                      <td colspan="3" align="middle" class="ver11"><span class="style1"><strong>S&aacute;bado </strong></span></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">4:30 PM </td>
                      <td width="3"></td>
                      <td class="ver11">Reuni&oacute;n de j&oacute;venes </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                    <tr bgcolor="#CC9900">
                      <td colspan="3" align="middle" class="style1"><strong>Domingo </strong></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">9:00 AM </td>
                      <td width="3"></td>
                      <td class="ver11">Escuela b&iacute;blica dominical </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right"><div align="left">10:15 AM </div></td>
                      <td width="3"></td>
                      <td class="ver11">Servicio de adoraci&oacute;n </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">3:30 PM </td>
                      <td width="3"></td>
                      <td class="ver11">Culto evangel&iacute;stico </td>
                    </tr>
                </table></td>
                <td background="images/layout_19.gif">&nbsp;</td>
              </tr>
              <tr>
                <td background="images/layout_17.gif">
			<IMG SRC="images/layout_17.gif" WIDTH=17 HEIGHT=225 ALT=""></td>
                <td valign="top" background="images/layout_18.gif">
					<cfinclude template="pActividades.cfm">

                <IMG SRC="images/layout_18.gif" WIDTH=227 HEIGHT=3 ALT=""><br>            <br>            <br></td>
                <td background="images/layout_19.gif">
			<IMG SRC="images/layout_19.gif" WIDTH=15 HEIGHT=225 ALT=""></td>
              </tr>
              <tr>
                <td colspan="3">
			<IMG SRC="images/layout_22.gif" WIDTH=260 HEIGHT=28 ALT=""></td>
        </tr>
          </table>		
		
        <p></TD>
    <TD  align="left" valign="top">
    <table border="0" cellpadding="5" cellspacing="0"  bordercolor="#111111" id="AutoNumber3" width="100%">
<tr><TD width="139" rowspan="2" valign="top">$$LEFT OPTIONAL$$</TD>
  <TD valign="top">
    <div align="center" class="style68">$$TITLE$$</div>
    <div align="left"> $$HEADER OPTIONAL$$</div></TD>
</tr>		
      <tr>
        <td width="510" valign="top">$$BODY$$</td>
        </tr>
    </table>
    
    </TD>
  <tr>
        <td colspan="3" ><hr>
          <div align="center">Copyright (C) 2003, Soluciones Integrales S.A., All rights reserved
  .        </div></td>
  </tr>
</TABLE>
<!-- End ImageReady Slices -->
</BODY>
</HTML>