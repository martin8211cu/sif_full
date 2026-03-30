<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><cf_translate key="LB_NotificacionTitulo">Notificaci&oacute;n del Sistema</cf_translate></title>
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
      <td colspan="2"> <strong><cf_translate key="LB_NotificacionTitulo">Notificaci&oacute;n del Sistema</cf_translate> #session.Enombre# </strong> </td>
    </tr>
    <tr>
      <td width="70">&nbsp;</td>
      <td width="476">&nbsp;</td>
    </tr>
    <tr>
      <td><span class="style2"><cf_translate key="LB_De">De</cf_translate></span></td>
      <td><span class="style7"> #Session.Enombre# </span></td>
    </tr>
    <tr>
      <td><span class="style7"><strong><cf_translate key="LB_Para">Para</cf_translate></strong></span></td>

      <cfif not IsDefined("Request.MailArguments.Transition")>
		  <td> <span class="style7"> #Request.MailArguments.datos_personales.nombre# #Request.MailArguments.datos_personales.apellido1# #Request.MailArguments.datos_personales.apellido2# </span></td>
	  <cfelse>
		  <td> <span class="style7"> #Request.MailArguments.datos_personales#</span></td>
	  </cfif>

    </tr>
    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style8"></span></td>
    </tr>
    <tr>
		<td><span class="style8"></span></td>
		<td>
			<table>
				<tr>
					<td class="style7">
						#Request.MailArguments.info#
					</td>
				</tr>
				<tr>
					<td class="style7">
						<cf_translate key="LB_IngreseA">Ingrese a</cf_translate> <a href='http://#session.sitio.host##Request.MailArguments.url#'> <cf_translate key="LB_AprobacionTramites">Ver notificaci&oacute;n</cf_translate></a>
					</td>
		        </tr>
			</table>
		</td>
	</tr>
    <tr>
      <td><span class="style8"></span></td>
      <td><span class="style8"></span></td>
    </tr>
   <!--- <tr>
      <td>&nbsp;</td>
      <td>
	  	<span class="style1">
		<cf_translate key="LB_NotaEn">Nota: En</cf_translate> #Request.MailArguments.hostname# <cf_translate key="LB_RespetemosSuPrivaciadad">respetamos su privacidad</cf_translate>. <br>
      	<cf_translate key="LB_SiUstedConsideraQueEsteCorreoLeLlegoPorEquivocacionOSiNoDeseaRecibirMasInformacionDeNosotrosHagaClick">Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n,
		o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click </cf_translate>
		<a href="http://#Request.MailArguments.hostname#/cfmx/home/public/optout.cfm?a=#Request.MailArguments.Usucodigo#&amp;b=#Request.MailArguments.CEcodigo#&amp;c=#Request.MailArguments.hostname#&amp;#Hash(Request.MailArguments.Usucodigo & 'please let me out of ' & Request.MailArguments.hostname)#"><cf_translate key="LB_Aqui">aqu&iacute;</cf_translate></a>. </span></td>
    </tr>--->
  </table>
</cfoutput>
</body>
</html>
