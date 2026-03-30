<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templatecss>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

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
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="VerificacionNomina"
				Default="Verificaci&oacute;n de  N&oacute;mina"
				XmlFile="/rh/generales.xml"
				returnvariable="VerificacionNomina"/>


				<cf_web_portlet_start titulo="#VerificacionNomina#" >
					<!--- <cfinclude template="/rh/portlets/pNavegacionPago.cfm"> --->
					<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td nowrap align="center">&nbsp;</td></tr>
						<tr>
							<td nowrap align="left" class="fileLabel">
								&nbsp;<cf_translate  key="LB_SeleccioneElRegistroDeNominaQueDeseeVerificar">Seleccione el Registro de Nómina que desee Verificar:</cf_translate>
							</td>
						</tr>
						<tr>
							<td nowrap align="center">&nbsp;</td>
						</tr>
						<tr>
							<td align="center">
								<cfset Form.ERNestado = "2">
								<cfset Form.ERNcapturado = "False">
								<cfset Form.ERNfverifica = "False">
								<cfset Form.PermiteFiltro = "True">
								<cfset Form.Botones = "Marcar_como_Verificada">
								<cfif (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_sin_Banco_Virtual) or (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_con_Banco_Virtual)>
								<cfset Form.Botones = Form.Botones & ",Devolver_a_Sistema_de_Nomina">
								</cfif>
								<cfset Form.irA = "VNomina.cfm">
								<cfinclude template="formLVNomina.cfm">
							</td>
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>
		</tr>
	</table>
<cf_templatefooter>