<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Recordatorio de citas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {
	font-size: 10px;
	font-family: "Times New Roman", Times, serif;
}
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-weight: bold;
	font-size: 14;
}
.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
.style8 {font-size: 14}
-->
</style>
</head>

<body>
<!---
<cfdump var="#cgi#">
<cfdump var="#session#">
<cfdump var="#GetHTTPRequestData().headers#">
--->
<cfparam name="hostname" default="localhost">
<cfparam name="_password" default="">
<cfparam name="_incluir_login" type="boolean" default="yes">

<cfoutput>
<table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
  <tr bgcolor="##999999">
    <td colspan="2" height="8"></td>
  </tr>
  <tr bgcolor="##003399">
    <td colspan="2" height="24"></td>
  </tr>
  <tr bgcolor="##999999">
    <td colspan="2"> <strong>Recordatorio de una cita registrada en su agenda </strong></td>
  </tr>
  <tr>
    <td width="70">&nbsp;</td>
    <td width="476">&nbsp;</td>
  </tr>
  <tr>
    <td><span class="style2">De</span></td>
    <td><cfoutput><span class="style7"> Agenda</span></cfoutput></td>
  </tr>
  <tr>
    <td><span class="style7"><strong>Para</strong></span></td>
    <td>
	  <span class="style7">
	<cfoutput> #_user_datos_personales.nombre# #_user_datos_personales.apellido1# #_user_datos_personales.apellido2#</cfoutput>
	  </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style8"></span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7"> Usted tiene una cita est&aacute; a punto de comenzar.</span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style8"></span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7">Se ha creado una cita en su agenda, registrando su correo como referencia. </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7">Datos sobre la cita registrada: </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><table width="441" border="0">
      <tr>
        <td valign="top" class="style7"><strong>Asunto:</strong></td>
        <td valign="top" class="style7">&nbsp;</td>
        <td colspan="2" valign="top" class="style7">#NotificarQuery.texto#</td>
        </tr>
        <tr>
          <td width="104" valign="top" class="style7"><strong>Inicia:</strong></td>
          <td width="21" valign="top" class="style7">&nbsp;</td>
          <td width="94" valign="top" class="style7">#LSDateFormat(NotificarQuery.inicio,'DD/MM/YYYY')# </td>
        <td width="204" valign="top" class="style7">#LSTimeFormat(NotificarQuery.inicio,'HH:MM')#</td>
        </tr>
        <tr>
          <td valign="top" class="style7"><strong>Termina:</strong></td>
          <td valign="top" class="style7">&nbsp;</td>
          <td valign="top" class="style7">#LSDateFormat(NotificarQuery.final,'DD/MM/YYYY')# </td>
        <td valign="top" class="style7">#LSTimeFormat(NotificarQuery.final,'HH:MM')#</td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style8"></span></td>
  </tr>
</table>
<br>

<br>
<br>
<br>
</cfoutput>
</body>
</html>
