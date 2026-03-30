<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><cf_translate key="LB_InformacionSobreTramites">Informaci&oacute;n sobre tr&aacute;mites</cf_translate></title>
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
    <cfquery name="rsPvalor" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Pcodigo = 15500
    </cfquery>

<cfoutput>
  <table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
    <tr bgcolor="##999999">
      <td colspan="2" height="8"></td>
    </tr>
    <tr bgcolor="##003399">
      <td colspan="2" height="24"></td>
    </tr>
    <tr bgcolor="##999999">
      <td colspan="2"> <strong><cf_translate key="LB_InformacionSobreTramiteEn">Informaci&oacute;n sobre tr&aacute;mite en</cf_translate> #session.Enombre# </strong> </td>
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
      <td>&nbsp;</td>
      <td><span class="style7"><cf_translate key="LB_InformacionSobreTramites">Informaci&oacute;n sobre Tr&aacute;mites</cf_translate>.</span></td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <cfif IsDefined("Request.MailArguments.rsHistory")>
		<tr>
			<td><span class="style8"></span></td>
			<td colspan="5">
			<table>
				<tr>
					<td colspan="3" class="style7">
						#Request.MailArguments.info#
					</td>
				</tr>
			<cfloop query="Request.MailArguments.rsHistory">
				<tr>
					<td>&nbsp;&nbsp;</td>
					<td class="style7">
						#Request.MailArguments.rsHistory.ActivityName#
					</td>
					<td class="style7">
						<cfif Request.MailArguments.rsHistory.ActionName EQ "***">
							<strong>
							<cfif Request.MailArguments.isPart>
								<cf_translate key="LB_Se_Le_ha_sido_asignada">Se le ha asignado la Actividad</cf_translate>
							<cfelse>
								<cf_translate key="LB_EnProceso">EN PROCESO</cf_translate>
							</cfif>
							</strong>
						<cfelse>
							#Request.MailArguments.rsHistory.ActionName#
						</cfif>
					</td>
					<td>&nbsp;&nbsp;</td>
				</tr>
			<cfif len(trim(Request.MailArguments.rsHistory.TransitionComments)) NEQ 0>
				<tr>
					<td>&nbsp;&nbsp;</td>
                    <td class="style7">
                        OBSERVACIONES:
					</td>
					<td>
						#Request.MailArguments.rsHistory.TransitionComments#
                    </td>
				</tr>
			</cfif>
			</cfloop>
			<tr>
				<td>&nbsp;&nbsp;</td>
			<cfif Request.MailArguments.isPart>
                <!---se hace la pregunta para saber cual link usar--->
              	<cfif rsPvalor.recordcount and rsPvalor.Pvalor EQ 1>
                    <td colspan="3" class="style7">
					<cf_translate key="LB_IngreseA">Ingrese a</cf_translate> <a href='http://#Request.MailArguments.HOSTNAME#/cfmx/proyecto7/menu.cfm'> <cf_translate key="LB_GestionAutorizaciones">Gestion de Autorizaciones</cf_translate></a> <cf_translate key="LB_ParaRevisarla">para revisarla</cf_translate>.
					</td>
                <cfelse>
              		<td colspan="3" class="style7">
					<cf_translate key="LB_IngreseA">Ingrese a</cf_translate> <a href='http://#Request.MailArguments.HOSTNAME#/cfmx/sif/tr/consultas/aprobacion.cfm?seleccionar_EcodigoSDC=#session.EcodigoSDC#'> <cf_translate key="LB_AprobacionTramites">Aprobación de Trámites</cf_translate></a> <cf_translate key="LB_ParaRevisarla">para revisarla</cf_translate>.
					</td>
               </cfif>
			</cfif>
			</tr>
			</table>
		</td></tr>
    <cfelseif not IsDefined("Request.MailArguments.Transition")>
		<tr>
		  <td><span class="style8"></span></td>
		  <td><span class="style7">
				<cfif Request.MailArguments.isPart>
					<cf_translate key="LB_Le_ha_sido_asignada">Le ha sido asignada</cf_translate> #Request.MailArguments.info#<br>
					<cf_translate key="LB_IngreseA">Ingrese a</cf_translate> <a href='http://#Request.MailArguments.HOSTNAME#/cfmx/sif/tr/consultas/aprobacion.cfm?seleccionar_EcodigoSDC=#session.EcodigoSDC#'> <cf_translate key="LB_TramitesPendientes">Tr&aacute;mites Pendientes</cf_translate></a> <cf_translate key="LB_ParaRevisarla">para revisarla</cf_translate>.
				<cfelse>
					<cfif Request.MailArguments.isFinish>
						<cf_translate key="LB_HaConcluido">Ha concluido</cf_translate>
					<cfelseif Request.MailArguments.isAfter>
						<cf_translate key="LB_Completed">Ha iniciado</cf_translate>
					<cfelse>
						<cf_translate key="LB_NonCompleted">No ha iniciado</cf_translate>
					</cfif>
					<cfif isdefined("Request.MailArguments.info")>#Request.MailArguments.info#</cfif>
					<cfif isdefined("Request.MailArguments.obs")>#Request.MailArguments.obs#<br></cfif>
				</cfif>
		  </span></td>
		</tr>
	<cfelse>
		<tr>
		  <td><span class="style8"></span></td>
		  <td>
		  		<span class="style7">#Request.MailArguments.info#</span><BR>
				<cfif isdefined("arguments.TransitionComments") and len(trim(arguments.TransitionComments))>
		  		<span class="style7">#arguments.TransitionComments#</span>
				</cfif>
		  </td>
		</tr>
	</cfif>

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
