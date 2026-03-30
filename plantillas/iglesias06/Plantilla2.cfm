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
	color: #006600;
	font-size: 12px;
	font-weight: bold;
	font-style: italic;
}
.style66 {color: #666666; font-size: 12px; font-weight: bold; }
.style67 {font-size: 12px; font-weight: bold; color: #FFFFFF; }
.style68 {
	color: #006633;
	font-weight: bold;
	font-size: 16px;
}
-->
</style>
<script type="text/javascript" language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
</HEAD>
<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>
<!-- ImageReady Slices (layout.psd) --><!-- chinaz.com -->
<TABLE width="1007" BORDER=0 CELLPADDING=0 CELLSPACING=0><!--DWLayoutTable-->
	<TR>
		<TD width="260"   valign="baseline" class="style68"><img src="images/chlocator.gif" width="75" height="75"> <cfoutput>#iif(len(trim(session.enombre)) gt 0,DE(session.enombre),DE(session.cenombre))#</cfoutput></TD>
	  <td valign="bottom"><table border="0"><tr><TD width="86" background="images/tab.gif">			<div align="center" class="style2 style1"><span class="style1"><a href="index.cfm">Inicio</a></span></div></TD>
		<TD width="86" background="images/tab.gif">			<div align="center"><span class="style67"><a href="principios.cfm" title="Principios Bautistas" class="style2">Principios</a></span></div></TD>
		<TD width="86" background="images/tab.gif">			<div align="center">
		  <p class="style67"><a href="palabradiaria.cfm">Palabra de Dios Diaria</a></p>
		  </div></TD>
		<TD width="86" background="images/tab.gif">			<div align="center"><span class="style67"><a href="biblia.cfm">Biblia en L&iacute;nea</a> </span></div></TD>
	  <TD width="86" background="images/tab.gif"> <div align="center"><span class="style3"><a href="misiones.cfm" class="style2">Misiones</a></span></div></TD></tr></table></td>
	</TR>
	<TR>
	  <TD valign="middle" background="images/layout_10.gif" class="style1"><!--DWLayoutEmptyCell-->&nbsp;</TD>
	  <TD background="images/layout_10.gif">		  <div align="right"><cfoutput>#LSDateFormat(Now(),'MMM DD, YYYY')#</cfoutput></div></TD>
	</TR>
	<TR>
		<TD >
			<IMG SRC="images/layout_11.gif" WIDTH=260 HEIGHT=76 ALT=""></TD>
	  <TD valign="top" background="images/layout_12.gif">
	  <table><tr><td>
			  	<cfif FindNoCase("/login06/index.cfm",CGI.SCRIPT_NAME) NEQ 0>												
				    <cfif isDefined("Session.Usucodigo") and Session.Usucodigo is 0>
					    <cfinclude template="login-form2.cfm">
			        </cfif>
				</cfif>
			  <div align="center" class="style68">$$TITLE$$
		
        </div>
		</td><td>
		
		<p align="right"><span class="style64">&quot;Cree en el Se&ntilde;or Jesucristo, y ser&aacute;s salvo, t&uacute; y tu casa.&quot;</span></p>
	    <p align="right"><span class="style66">(Hechos 16:31)</span></p>
		</td></tr></table>
		
	  </TD>
	</TR>
	<TR>
		<TD  valign="top" >

<table width="260" border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" id="AutoNumber1" style="border-collapse: collapse">
              <tr>
                <td background="images/layout_17.gif">&nbsp;</td>
                <td valign="top" background="images/layout_18.gif">                  <h2 class="style3">Horario de Servicios </h2>
                  <table cellspacing="1" cellpadding="0">
                    <tr bgcolor="#0099CC">
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
                      <td colspan="3" align="middle" bgcolor="#0099CC" class="style1"><strong>Martes </strong></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">3:00 PM </td>
                      <td></td>
                      <td class="ver11">Culto de la sociedad de se&ntilde;oras </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                    <tr bgcolor="#0099CC">
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
                    <tr bgcolor="#0099CC">
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
                    <tr bgcolor="#0099CC">
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
                    <tr bgcolor="#0099CC">
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
			<IMG SRC="images/layout_17.gif" WIDTH=18 HEIGHT=227 ALT=""></td>
                <td valign="top" background="images/layout_18.gif">
                  <p>&nbsp;</p>
                  <h2 class="style3">Actividades Especiales de Diciembre </h2>
                  <table cellspacing="1" cellpadding="0">
                    <tr bgcolor="#0099CC">
                      <td colspan="3" align="middle" class="style1 ver11"><strong class="style1">Viernes 19 </strong></td>
                    </tr>
                    <tr>
                      <td width="55" align="right" class="ver11">      7:00 PM </td>
                      <td></td>
                      <td width="162" class="ver11">Cena de Navidad </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                    <tr>
                      <td colspan="3" align="middle" bgcolor="#0099CC" class="style1"><strong>Domingo 21</strong></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">3:00 PM </td>
                      <td></td>
                      <td class="ver11">Programa de Navidad </td>
                    </tr>
                    <tr bgcolor="#0099CC">
                      <td colspan="3" align="middle" class="style1 ver11"><strong>Mi&eacute;rcoles 24</strong></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">8:00 PM </td>
                      <td width="3"></td>
                      <td class="ver11">Servicio de Nochebuena </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                    <tr bgcolor="#0099CC">
                      <td colspan="3" align="middle" class="style1 ver11"><strong>Mi&eacute;rcoles 31</strong></td>
                    </tr>
                    <tr>
                      <td class="ver11" align="right">10:00 PM </td>
                      <td width="3"></td>
                      <td class="ver11">Servicio de A&ntilde;o Nuevo </td>
                    </tr>
                    <tr>
                      <td class="ver11" align="middle" colspan="3"></td>
                    </tr>
                  </table>
                <IMG SRC="images/layout_18.gif" WIDTH=226 HEIGHT=3 ALT=""><br>            <br>            <br></td>
                <td background="images/layout_19.gif">
			<IMG SRC="images/layout_19.gif" WIDTH=16 HEIGHT=227 ALT=""></td>
              </tr>
              <tr>
                <td colspan="3">
			<IMG SRC="images/layout_22.gif" WIDTH=260 HEIGHT=62 ALT=""></td>
        </tr>
          </table>		
		
        <p></TD>
    <TD  align="left" valign="top">
    <table border="0" cellpadding="5" cellspacing="0"  bordercolor="#111111" id="AutoNumber3" width="607">
<tr><TD valign="top"><div align="left">$$HEADER OPTIONAL$$</div></TD></tr>		
      <tr>
        <td width="113" valign="top">$$LEFT OPTIONAL$$</td>
        <td width="469" valign="top">$$BODY$$</td>
        </tr>
    </table>
    
    </TD>
  <tr>
        <td colspan="2" ><hr>
          <div align="center">Copyright (C) 2003, Soluciones Integrales S.A., All rights reserved
  .        </div></td>
  </tr>
</TABLE>
<!-- End ImageReady Slices -->
</BODY>
</HTML>