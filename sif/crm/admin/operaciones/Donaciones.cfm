<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuCRM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>CRM</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
<cf_templatecss>
<link href="/cfmx/sif/crm/css/CRM.css" rel="stylesheet" type="text/css">
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
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr> 
					<td width="154" rowspan="2" align="center" valign="top">
						<img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62">
					</td>
					<td valign="top" style="padding-left: 5; padding-bottom: 5;"> 
					  <cfinclude template="../../../Utiles/params.cfm">
					  <cfset Session.Params.ModoDespliegue = 1>
					  <!-- InstanceBeginEditable name="Ubica" --> 
					  <cfinclude template="../../../portlets/pubica.cfm">
					  <!-- InstanceEndEditable --> </td>
				  </tr>
				  <tr> 
					<td valign="top">
					  <table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr class="area"> 
						  <td width="220" rowspan="2" valign="middle">
							<cfinclude template="../../portlets/pEmpresas2.cfm">
						  </td>
						  <td width="50%"> 
							<div align="center"><span class="superTitulo"><font size="5"> <!-- InstanceBeginEditable name="Titulo" --> 
							  CRM<!-- InstanceEndEditable --> </font></span></div></td>
						</tr>
						<tr class="area"> 
						  <td width="50%" valign="bottom" nowrap> 
						  <!-- InstanceBeginEditable name="MenuJS" --> 
						  <cfinclude template="/sif/crm/jsMenuCRM.cfm">
						  <!-- InstanceEndEditable -->	
						  </td>
						</tr>
						<tr> 
						  <td></td>
						  <td></td>
						</tr>
					  </table>
						</td>
				  </tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr> 
					<td width="84" valign="top" nowrap>
					  <cfinclude template="/sif/menu.cfm">
					</td>
					<td width="1">&nbsp;</td>
					<td valign="top"> 
					  <!-- InstanceBeginEditable name="Mantenimiento" --> 
						<cf_web_portlet titulo="Registro de Donaciones" border="true" skin="#session.Preferences.skin#">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<cfset regresar = "listaDonaciones.cfm" >
								<tr><td colspan="2"><cfinclude template="/sif/crm/portlets/pNavegacion.cfm"></td></tr>
								<tr>
									<td><cfinclude template="formDonaciones.cfm"></td>
								</tr>
								<tr>
									<td>
										<cfif modO neq 'ALTA'>
											<cfinvoke 
												component="sif.crm.Componentes.pListas"
												method="pListaCRM"
												returnvariable="pListaCRMRet">
												<cfinvokeargument name="tabla" value="CRMDDonacion a, CRMEntidad b"/>
												<cfinvokeargument name="columnas" value="convert(varchar, a.CRMDDid) as CRMDDid, convert(varchar, a.CRMEDid) as CRMEDid, convert(varchar, a.CRMEid) as CRMEid, a.CRMDDdescripcion, a.CRMDDtipopago, a.CRMDmonto, CRMEnombre +' '+coalesce(CRMEapellido1,'')+' '+coalesce(CRMEapellido2,'') as CRMnombre"/>
												<cfinvokeargument name="desplegar" value="CRMDDdescripcion,CRMnombre,CRMDmonto"/>
												<cfinvokeargument name="etiquetas" value="Descripción,Entidad,Monto"/>
												<cfinvokeargument name="formatos" value="S,S,M"/>
												<cfinvokeargument name="filtro" value="a.CEcodigo=#session.CEcodigo# and a.Ecodigo=#session.Ecodigo# and a.CRMEDid=#form.CRMEDid# and a.CRMEid=b.CRMEid"/>
												<cfinvokeargument name="align" value="left,left,right"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="irA" value="Donaciones.cfm"/>
												<cfinvokeargument name="Conexion" value="#session.DSN#"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
												<cfinvokeargument name="keys" value="CRMDDid"/>
											</cfinvoke>
										</cfif>
									</td>
								</tr>

							</table>
						</cf_web_portlet>
					  <!-- InstanceEndEditable --> 
					  </td>
				  </tr>
				</table>
			</td>
		</tr>
	</table>

</body>
<!-- InstanceEnd --></html>