<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<cfinclude template="portal_control.cfm">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Company Name</title>
<link href="portal.css" rel="stylesheet" type="text/css"></head>
</head>

<body>
<table width="955" border="0" cellpadding="0" cellspacing="0">
  <!--DWLayoutTable-->
  <tr><td width="105"><img src="spacer.gif" width="1" height="1"></td>
    <td width="68"><img src="spacer.gif" width="1" height="1"></td>
    <td width="400"><img src="spacer.gif" width="1" height="1"></td>
    <td width="382"><img src="spacer.gif" width="1" height="1"></td>
    <td ><img src="spacer.gif" width="1" height="1"></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="2" valign="top"><img src="logo.jpg" width="159" height="56"></td>
    <td rowspan="2" align="center"><span class="titulo_sistema_actual"> 
		<cfoutput>
		<cfif Len(Trim(ubicacionSM.SMdescripcion))>
			#HTMLEditFormat(ubicacionSM.SMdescripcion)#
		<cfelseif Len(Trim(ubicacionSS.SSdescripcion))>
			#HTMLEditFormat(ubicacionSS.SSdescripcion)#
		</cfif>
		</cfoutput></span></td>
    <td rowspan="2" align="right" valign="bottom">
	<cfinclude template="../../home/menu/portal_top.cfm"></td>
    <td height="36"   align="right" valign="bottom"><!--DWLayoutEmptyCell-->&nbsp;</td>
  </tr>
  <tr>
    <td height="27" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td height="25" colspan="4" valign="top">
	
		<cfinclude template="../../home/menu/portal_tabs.cfm">
</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td height="173" valign="top" class="menutable">
	
	<cfinclude template="../../home/menu/portal_left.cfm">
	</td>
    <td colspan="4" rowspan="2" valign="top">
	$$BODY$$
	</td>
  </tr>
  <tr>
    <td height="96" valign="top" class="menutable"><p>&nbsp;</p>      <p>&nbsp;</p>      <p>&nbsp;</p></td>
  </tr>
  <tr>
    <td height="1"></td>
    <td></td>
    <td></td>
    <td colspan="2"></td>
  </tr>
</table>
</body>
</html>
