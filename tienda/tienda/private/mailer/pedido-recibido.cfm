<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Informaci&oacute;n sobre el pedido</title>
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
    <td colspan="2"> <strong>Informaci&oacute;n sobre su pedido en #Request.MailArguments.nombre_tienda# </strong> </td>
  </tr>
  <tr>
    <td width="70">&nbsp;</td>
    <td width="476">&nbsp;</td>
  </tr>
  <tr>
    <td><span class="style2">De</span></td>
    <td><cfoutput><span class="style7"> #Request.MailArguments.nombre_tienda# </span></cfoutput></td>
  </tr>
  <tr>
    <td><span class="style7"><strong>Para</strong></span></td>
    <td>
	  <span class="style7">
	<cfoutput> #Request.MailArguments.datos_personales.nombre#
		#Request.MailArguments.datos_personales.apellido1#
		#Request.MailArguments.datos_personales.apellido2#</cfoutput>
	  </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style8"></span></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><span class="style7">Gracias por comprar en #Request.MailArguments.nombre_tienda#. Esperamos que la compra haya sido de su agrado.</span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7"> Hemos recibido un pedido haciendo referencia a esta direcci&oacute;n 
	de correo.  </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7">Su n&uacute;mero de pedido es: #Request.MailArguments.pedido#. </span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7">Para consultar el estado de su pedido,
		haga click en <a href="http://#Request.MailArguments.hostname#/cfmx/tienda/tienda/private/comprar/receipt.cfm?id=#Request.MailArguments.pedido#">#Request.MailArguments.hostname#</a>.</span></td>
  </tr>
  <cfif Len(Trim(Request.MailArguments.tracking_no))>
  <tr>
    <td>&nbsp;</td>
    <td><span class="style7">El n&uacute;mero de gu&iacute;a para <a href="#Request.MailArguments.tracking_url#">#Request.MailArguments.nombre_transportista#</a> es #Request.MailArguments.tracking_no#</span></td>
  </tr></cfif>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style8"></span></td>
  </tr>
  <tr>
    <td><span class="style8"></span></td>
    <td><span class="style7">Si tiene alguna duda, comun&iacute;quese con nosotros a trav&eacute;s de la direcci&oacute;n electr&oacute;nica <a href="mailto:#HTMLEditFormat(Request.MailArguments.correo_clientes)#?Subject=Pedido #Request.MailArguments.pedido#">#HTMLEditFormat(Request.MailArguments.correo_clientes)#</a>. </span></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><span class="style1">Nota: En  #Request.MailArguments.hostname# respetamos su privacidad. <br>
      Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea
	  recibir m&aacute;s informaci&oacute;n de nosotros, haga click
	  <a href="http://#Request.MailArguments.hostname#/cfmx/home/public/optout.cfm?a=#Request.MailArguments.Usucodigo#&amp;b=#Request.MailArguments.CEcodigo#&amp;c=#Request.MailArguments.hostname#&amp;#Hash(Request.MailArguments.Usucodigo & 'please let me out of ' & Request.MailArguments.hostname)#">aqu&iacute;</a>. </span></td>
  </tr>
</table>
</cfoutput>
</body>
</html>
