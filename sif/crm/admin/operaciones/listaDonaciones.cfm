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

						<cfset filtro = "">
						<cfif isdefined("btnFiltrar") >
							<cfif len(trim(form.fCRMEid)) gt 0>
								<cfset filtro = " and  a.CRMEid = #form.fCRMEid#" >
							</cfif>
							<cfif len(trim(form.fCRMEDdescripcion)) gt 0>
								<cfset filtro = " and upper(CRMEDdescripcion) like upper('%#form.fCRMEDdescripcion#%')" >
							</cfif>
							<cfif len(trim(form.fCRMEDfecha)) gt 0>
								<cfset filtro = " and convert(varchar, CRMEDfecha, 112) = convert(varchar,convert(datetime, '#form.fCRMEDfecha#', 103),112)">
							</cfif>
						</cfif>

						<cf_web_portlet titulo="Lista de Donaciones" border="true" skin="#session.Preferences.Skin#">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr><td colspan="2"><cfinclude template="/sif/crm/portlets/pNavegacion.cfm"></td></tr>
								<tr>
									<td colspan="2">
  										<form style="margin:0;" name="filtro" method="post">
											<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
												<tr>
													<td>Entidad</td>
													<td>Descripción</td>
													<td>Fecha</td>
												</tr>
												<tr>
													<td><cf_crmEntidad form="filtro" conexion="crm" size="60" crmeid="fCRMEid" crmnombre="fCRMnombre"></td>
													<td><input name="fCRMEDdescripcion" size="60" maxlength="255" value="" onFocus="javascript:this.select();"></td>
													<td><cf_sifcalendario form="filtro" name="fCRMEDfecha" value=""></td>
													<td><input type="submit" name="btnFiltrar" value="Filtrar"></td>
												</tr>
											</table>
										</form>
										
										<cfinvoke 
											component="sif.crm.Componentes.pListas"
											method="pListaCRM"
											returnvariable="pListaCRMRet">
											<cfinvokeargument name="tabla" value="CRMEDonacion a, CRMEntidad b"/>
											<cfinvokeargument name="columnas" value="a.CRMEDid, a.CRMEDdescripcion, a.CRMEDfecha, a.CRMEid, b.CRMEnombre + ' ' +  coalesce(b.CRMEapellido1,'') + ' ' + coalesce(b.CRMEapellido2,'') as CRMEnombre"/>
											<cfinvokeargument name="desplegar" value="CRMEnombre, CRMEDdescripcion, CRMEDfecha "/>
											<cfinvokeargument name="etiquetas" value="Entidad, Descripción, Fecha"/>
											<cfinvokeargument name="formatos" value="S,S,D"/>
											<cfinvokeargument name="filtro" value="a.CEcodigo=#session.CEcodigo# and a.Ecodigo=#session.Ecodigo# and a.CRMEid=b.CRMEid #filtro# order by CRMEDdescripcion"/>
											<cfinvokeargument name="align" value="left,left,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="irA" value="Donaciones.cfm"/>
											<cfinvokeargument name="Conexion" value="#session.DSN#"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<!---<cfinvokeargument name="Cortes" value="CRMEnombre"/>--->
											<cfinvokeargument name="Botones" value="Nuevo"/>
										</cfinvoke>
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