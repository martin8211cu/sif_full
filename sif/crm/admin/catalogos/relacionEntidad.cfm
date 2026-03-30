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
						<cf_web_portlet titulo="Relaciones por Entidad" border="true">
							<cfquery name="rsTiposRelaciones" datasource="#session.DSN#">
								select 	convert(varchar,CRMTRid) as CRMTRid,
									CRMTRdescripcion
								from CRMTipoRelacion
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							</cfquery>
						
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr><td colspan="3"><cfinclude template="/sif/crm/portlets/pNavegacion.cfm"></td></tr>								<tr>
								  <td valign="top">
							<!--- FILTRO --->
									<form name="formFiltroRelacionEntidad" method="post" action="relacionEntidad.cfm" style="margin: 0;">
										<cfif isdefined('form.CRMREid') and form.CRMREid NEQ ''>
											<!---  <input type="hidden" name="CRMREid" value="#form.CRMREid#">
											<input type="hidden" name="modo" value="CAMBIO">--->
										</cfif>
										
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
										  <tr>
											<td><strong>Entidad 1</strong></td>
											<td><strong>Tipo de Relaci&oacute;n</strong></td>
										  </tr>
										  <tr>
											<td>
												<cfif isdefined('form.CRMEid1_filtro') and form.CRMEid1_filtro NEQ '' and isdefined('form.CRMnombre1_filtro') and form.CRMnombre1_filtro NEQ ''>
													<cfquery name="filtro_rsEnt_1" datasource="#session.DSN#">
														select 	CRMEid = #form.CRMEid1_filtro#,
																CRMEnombre = '#form.CRMnombre1_filtro#',
																CRMEapellido1 = '',
																CRMEapellido2 = ''				
													</cfquery>
													<cfif isdefined('filtro_rsEnt_1') and filtro_rsEnt_1.recordCount GT 0>
														<cf_crmEntidad 
															crmeid="CRMEid1_filtro" 
															crmnombre="CRMnombre1_filtro" 
															conexion="#session.DSN#" 
															form="formFiltroRelacionEntidad"
															size="50"
															query="#filtro_rsEnt_1#">				
													</cfif>
												<cfelse>
													<cf_crmEntidad 
														crmeid="CRMEid1_filtro" 
														crmnombre="CRMnombre1_filtro" 
														conexion="#session.DSN#" 
														form="formFiltroRelacionEntidad"
														size="50">			
												</cfif>										
											</td>
											<td>
												<select name="CRMTRid_filtro" id="CRMTRid_filtro">
													<option value="-1" <cfif isdefined('form.CRMTRid_filtro') and form.CRMTRid_filtro EQ '-1'> selected</cfif>>-- TODOS --</option>																									
													
													<cfloop query="rsTiposRElaciones">
													  <option value="<cfoutput>#rsTiposRelaciones.CRMTRid#</cfoutput>" <cfif isdefined('form.CRMTRid_filtro') and form.CRMTRid_filtro EQ rsTiposRelaciones.CRMTRid> selected</cfif>><cfoutput>#rsTiposRelaciones.CRMTRdescripcion#</cfoutput></option>
													</cfloop>
											  	</select>
											 </td>
										  </tr>
										  <tr>
										    <td><strong>Entidad 2</strong></td>
										    <td rowspan="2" align="center" valign="middle"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
                                              <input name="btnLimpiar" type="reset" id="btnLimpiar" value="Limpiar" onClick="javascript: limpia(this);"></td>
									      </tr>
										  <tr>
										    <td>
												<cfif isdefined('form.CRMEid2_filtro') and form.CRMEid2_filtro NEQ '' and isdefined('form.CRMnombre2_filtro') and form.CRMnombre2_filtro NEQ ''>
													<cfquery name="filtro_rsEnt_2" datasource="#session.DSN#">
														select 	CRMEid = #form.CRMEid2_filtro#,
																CRMEnombre = '#form.CRMnombre2_filtro#',
																CRMEapellido1 = '',
																CRMEapellido2 = ''				
													</cfquery>
													<cfif isdefined('filtro_rsEnt_2') and filtro_rsEnt_2.recordCount GT 0>
														<cf_crmEntidad 
															crmeid="CRMEid2_filtro" 
															crmnombre="CRMnombre2_filtro" 
															conexion="#session.DSN#" 
															form="formFiltroRelacionEntidad"
															size="50"
															query="#filtro_rsEnt_2#">				
													</cfif>
												<cfelse>
													<cf_crmEntidad 
														crmeid="CRMEid2_filtro" 
														crmnombre="CRMnombre2_filtro" 
														conexion="#session.DSN#" 
														form="formFiltroRelacionEntidad"
														size="50">			
												</cfif>											
											</td>
										  </tr>										  
										</table>
									</form>
									
									</td>
								  <td width="7%" rowspan="2">&nbsp;</td>
								  <td width="48%" rowspan="2" valign="top">
									  <cfinclude template="formRelacionEntidad.cfm"> 
								  </td>
							  </tr>								
								<tr>
									<td width="45%" valign="top">					
									<!--- Para el filtro de la lista --->
										<cfif (isdefined("Url.CRMEid1_filtro")) and (not isDefined("Form.CRMEid1_filtro")) and Url.CRMEid1_filtro NEQ ''>
											<cfparam name="Form.CRMEid1_filtro" default="#Url.CRMEid1_filtro#">
										</cfif>
										<cfif (isdefined("Url.CRMEid2_filtro")) and (not isDefined("Form.CRMEid2_filtro")) and Url.CRMEid2_filtro NEQ '-1' and Url.CRMEid2_filtro NEQ ''>
											<cfparam name="Form.CRMEid2_filtro" default="#Url.CRMEid2_filtro#">
										</cfif>
										<cfif (isdefined("Url.CRMTRid_filtro")) and (not isDefined("Form.CRMTRid_filtro")) and Url.CRMTRid_filtro NEQ '-1' and Url.CRMTRid_filtro NEQ ''>
											<cfparam name="Form.CRMTRid_filtro" default="#Url.CRMTRid_filtro#">
										</cfif>										
		
										<cfset filtro = "">
										<cfset navegacion = "">
										<cfset navegacionSel = "">
										<cfif isdefined("Form.CRMEid1_filtro") and Len(Trim(Form.CRMEid1_filtro)) NEQ 0>
											<cfset filtro = filtro & " and re.CRMEid1=" & #Form.CRMEid1_filtro#>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMEid1_filtro=" & Form.CRMEid1_filtro>
											<cfset navegacionSel = navegacionSel & ",CRMEid1_filtro=" & Form.CRMEid1_filtro>											
										</cfif>
										
										<cfif isdefined("Form.CRMEid2_filtro") and Len(Trim(Form.CRMEid2_filtro)) NEQ 0>
											<cfset filtro = filtro & " and re.CRMEid2=" & #Form.CRMEid2_filtro#>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMEid2_filtro=" & Form.CRMEid2_filtro>
											<cfset navegacionSel = navegacionSel & ",CRMEid2_filtro=" & Form.CRMEid2_filtro>
										</cfif>

										<cfif isdefined("Form.CRMTRid_filtro") and Len(Trim(Form.CRMTRid_filtro)) NEQ 0 and Form.CRMTRid_filtro NEQ '-1'>
											<cfset filtro = filtro & " and re.CRMTRid=" & #Form.CRMTRid_filtro#>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMTRid_filtro=" & Form.CRMTRid_filtro>
											<cfset navegacionSel = navegacionSel & ",CRMTRid_filtro=" & Form.CRMTRid_filtro>											
										</cfif>									
									
										<cfinvoke 
										 component="sif.crm.Componentes.pListas"
										 method="pListaCRM"
										 returnvariable="pListaCRMRet">
											<cfinvokeargument name="tabla" value="
												CRMRelacionEntidad re,
												CRMEntidad e1,
												CRMEntidad e2,
												CRMTipoRelacion tr																						
											"/>
											<cfinvokeargument name="columnas" value="
												CRMREid as CRMREid2,
												convert(varchar,re.CRMREid) as CRMREid,
												case
													when datalength(e1.CRMEnombre + ' ' + e1.CRMEapellido1 + ' '  + e1.CRMEapellido2) > 20 then (substring((e1.CRMEnombre + ' ' + e1.CRMEapellido1 + ' '  + e1.CRMEapellido2),1,20) + '...') 
													else (e1.CRMEnombre + ' ' + e1.CRMEapellido1 + ' '  + e1.CRMEapellido2)
												end nombreEnt_1,		
												case
													when datalength(e2.CRMEnombre + ' ' + e2.CRMEapellido1 + ' '  + e2.CRMEapellido2) > 20 then (substring((e2.CRMEnombre + ' ' + e2.CRMEapellido1 + ' '  + e2.CRMEapellido2),1,20) + '...') 
													else (e2.CRMEnombre + ' ' + e2.CRMEapellido1 + ' '  + e2.CRMEapellido2)
												end nombreEnt_2,
												CRMTRdescripcion #navegacionSel#"/>
											<cfinvokeargument name="desplegar" value="nombreEnt_1,CRMTRdescripcion,nombreEnt_2"/>
											<cfinvokeargument name="etiquetas" value="Entidad 1, Tipo de Relacion, Entidad 2"/>
											<cfinvokeargument name="formatos" value=""/>
											<cfinvokeargument name="filtro" value="
													re.Ecodigo=#session.Ecodigo#
													and re.CEcodigo=#session.CEcodigo#
													and re.Ecodigo=e1.Ecodigo
													and re.CEcodigo=e1.CEcodigo
													and re.CRMEid1=e1.CRMEid
													and re.CRMEid2=e2.CRMEid
													and e1.Ecodigo=e2.Ecodigo
													and e1.CEcodigo=e2.CEcodigo
													and e2.Ecodigo=tr.Ecodigo
													and e2.CEcodigo=tr.CEcodigo
													and re.CRMTRid=tr.CRMTRid #filtro#
												order by CRMREid2"/>
											<cfinvokeargument name="align" value="left,left,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="Conexion" value="#session.DSN#"/>	
											<cfinvokeargument name="navegacion" value="#navegacion#"/>											
											<cfinvokeargument name="irA" value="relacionEntidad.cfm"/>
											<cfinvokeargument name="debug" value="N"/>
										</cfinvoke>
									</td>
								</tr>
							</table>
							<script language="JavaScript" type="text/javascript">
								function limpia(obj){
									obj.form.CRMEid1_filtro.value = "";
									obj.form.CRMnombre1_filtro.value = "";
									obj.form.CRMEid2_filtro.value = "";
									obj.form.CRMnombre2_filtro.value = "";
									obj.form.CRMTRid_filtro.value = "-1";
									<cfif isdefined('filtro') and filtro NEQ ''>
										obj.form.submit();									
									</cfif>
								}
							</script>				
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