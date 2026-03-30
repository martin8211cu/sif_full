<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="AutorizacionNomina"
	Default="Autorizaci&oacute;n de N&oacute;mina"
	XmlFile="/rh/generales.xml"
	returnvariable="AutorizacionNomina"/>	
	
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="#AutorizacionNomina#">	              
					<cfinclude template="/rh/portlets/pNavegacionPago.cfm">	              
					<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td nowrap align="center">&nbsp;</td></tr>
						<tr>
							<td nowrap align="left" class="fileLabel">
								&nbsp;<cf_translate  key="LB_SeleccioneElRegistroDeNominaAlQueDeseaRegistrarLaInformacionDePago">Seleccione el Registro de Nómina al que desea Registrar la Información de Pago:</cf_translate>
							</td>
						</tr>
						<tr><td nowrap align="center">&nbsp;</td></tr>
						<tr>
							<td align="center">
								<cfset Form.ERNestado = "3,4">
								<cfset Form.ERNcapturado = "False">
								<cfset Form.ERNfverifica = "True">
								<cfset Form.PermiteFiltro = "True">
								<cfset Form.Botones = "Finalizar">
								<cfset Form.irA = "PNomina.cfm">
								<cfinclude template="formLPNomina.cfm">
							</td>
						</tr>
					</table>	             
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	