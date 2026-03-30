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
						<cf_web_portlet titulo="Relaciones Permitidas" border="true" skin="#Session.Preferences.Skin#">
							<!--- Consultas --->
							<cfquery name="rsTiposRelaciones" datasource="#session.DSN#">
								select 	convert(varchar,CRMTRid) as CRMTRid,
									CRMTRdescripcion
								from CRMTipoRelacion
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							</cfquery>
							
							<cfquery name="rsTiposEntidad" datasource="#session.DSN#">
								select 	convert(varchar,CRMTEid) as CRMTEid,
										CRMTEdesc
								from CRMTipoEntidad
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
								order by CRMTEdesc
							</cfquery>								  
						
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr><td colspan="3"><cfinclude template="/sif/crm/portlets/pNavegacion.cfm"></td></tr>
								<tr>
								  <td valign="top">
								  
							<!--- FILTRO --->
									<form name="formFiltroRelacionEntidad" method="post" action="relacionesPermit.cfm" style="margin: 0;">
										<cfif isdefined('form.CRMREid') and form.CRMREid NEQ ''>
											<input type="hidden" name="CRMREid" value="#form.CRMREid#">
											<input type="hidden" name="modo" value="CAMBIO">
										</cfif>
										
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
										  <tr>
											<td><strong>Tipo de Entidad 1</strong></td>
											<td><strong>Tipo de Relaci&oacute;n</strong></td>
										  </tr>
										  <tr>
											<td>
												<select name="CRMTEid1_filtro" id="CRMTEid1_filtro">
													<option value="-1" <cfif isdefined('form.CRMTEid1_filtro') and form.CRMTEid1_filtro EQ '-1'> selected</cfif>>-- TODOS --</option>												
													<cfoutput query="rsTiposEntidad">
														<option value="#rsTiposEntidad.CRMTEid#" <cfif isdefined('form.CRMTEid1_filtro') and form.CRMTEid1_filtro EQ rsTiposEntidad.CRMTEid> selected</cfif>>#rsTiposEntidad.CRMTEdesc#</option>
													</cfoutput>
												</select>																					
											</td>
											<td>
												<select name="CRMTRid_filtro" id="CRMTRid_filtro">
													<option value="-1" <cfif isdefined('form.CRMTRid_filtro') and form.CRMTRid_filtro EQ '-1'> selected</cfif>>-- TODOS --</option>
													
													<cfoutput query="rsTiposRelaciones">
													  <option value="#rsTiposRelaciones.CRMTRid#" <cfif isdefined('form.CRMTRid_filtro') and form.CRMTRid_filtro EQ rsTiposRelaciones.CRMTRid> selected</cfif>>#rsTiposRelaciones.CRMTRdescripcion#</option>
													</cfoutput>
											  	</select>
											</td>
										  </tr>
										  <tr>
										    <td><strong>Tipo de Entidad 2</strong></td>
										    <td rowspan="2" valign="middle" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
									        </td>
									      </tr>
										  <tr>
										    <td>
												<select name="CRMTEid2_filtro" id="CRMTEid2_filtro">
													<option value="-1" <cfif isdefined('form.CRMTEid2_filtro') and form.CRMTEid2_filtro EQ '-1'> selected</cfif>>-- TODOS --</option>												
													<cfoutput query="rsTiposEntidad">
														<option value="#rsTiposEntidad.CRMTEid#" <cfif isdefined('form.CRMTEid2_filtro') and form.CRMTEid2_filtro EQ rsTiposEntidad.CRMTEid> selected</cfif>>#rsTiposEntidad.CRMTEdesc#</option>
													</cfoutput>
												</select>											
											</td>
									      </tr>
										</table>
									</form>
								  </td>
								  <td width="2%" rowspan="2" valign="top">&nbsp;</td>
								  <td width="49%" rowspan="2" valign="top">
									  <cfinclude template="formRelacionesPermit.cfm"> 
								  </td>
							  	</tr>							
								<tr>
									<td width="49%" valign="top">					
									<!--- Para el filtro de la lista --->
										<cfif (isdefined("Url.CRMTEid1_filtro")) and (not isDefined("Form.CRMTEid1_filtro")) and Url.CRMTEid1_filtro NEQ '' and Url.CRMTEid1_filtro NEQ '-1'>
											<cfparam name="Form.CRMTEid1_filtro" default="#Url.CRMTEid1_filtro#">
										</cfif>
										<cfif (isdefined("Url.CRMTEid2_filtro")) and (not isDefined("Form.CRMTEid2_filtro")) and Url.CRMTEid2_filtro NEQ '-1' and Url.CRMTEid2_filtro NEQ ''>
											<cfparam name="Form.CRMTEid2_filtro" default="#Url.CRMTEid2_filtro#">
										</cfif>
										<cfif (isdefined("Url.CRMTRid_filtro")) and (not isDefined("Form.CRMTRid_filtro")) and Url.CRMTRid_filtro NEQ '-1' and Url.CRMTRid_filtro NEQ ''>
											<cfparam name="Form.CRMTRid_filtro" default="#Url.CRMTRid_filtro#">
										</cfif>										

										<cfset filtro = "">
										<cfset navegacion = "">
										<cfset navegacionSel = "">										
										<cfif isdefined("Form.CRMTEid1_filtro") and Len(Trim(Form.CRMTEid1_filtro)) NEQ 0 and Form.CRMTEid1_filtro NEQ '-1'>
											<cfset filtro = filtro & " and CRMTEid1 = " & #Form.CRMTEid1_filtro#>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMTEid1_filtro=" & Form.CRMTEid1_filtro>
											<cfset navegacionSel = navegacionSel & ",CRMTEid1_filtro=" & Form.CRMTEid1_filtro>											
										</cfif>
										
										<cfif isdefined("Form.CRMTEid2_filtro") and Len(Trim(Form.CRMTEid2_filtro)) NEQ 0 and Form.CRMTEid2_filtro NEQ '-1'>
											<cfset filtro = filtro & " and CRMTEid2 = " & #Form.CRMTEid2_filtro#>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMTEid2_filtro=" & Form.CRMTEid2_filtro>
											<cfset navegacionSel = navegacionSel & ",CRMTEid2_filtro=" & Form.CRMTEid2_filtro>
										</cfif>

										<cfif isdefined("Form.CRMTRid_filtro") and Len(Trim(Form.CRMTRid_filtro)) NEQ 0 and Form.CRMTRid_filtro NEQ '-1'>
											<cfset filtro = filtro & " and rp.CRMTRid = " & #Form.CRMTRid_filtro#>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMTRid_filtro=" & Form.CRMTRid_filtro>
											<cfset navegacionSel = navegacionSel & ",CRMTRid_filtro=" & Form.CRMTRid_filtro>											
										</cfif>

									
										<cfinvoke 
										 component="sif.crm.Componentes.pListas"
										 method="pListaCRM"
										 returnvariable="pListaCRMRet">
											<cfinvokeargument name="tabla" value="
													CRMRelacionesPermitidas rp,
													CRMTipoRelacion tr,
													CRMTipoEntidad te1,
													CRMTipoEntidad te2"/>
											<cfinvokeargument name="columnas" value="
													te1.CRMTEdesc as CRMTEdesc1,
													CRMRPdescripcion1,
													te2.CRMTEdesc as CRMTEdesc2,
													CRMRPdescripcion2,
													rp.CRMTRid,
													CRMTEid1,
													CRMTEid2 #navegacionSel#"/>
											<cfinvokeargument name="desplegar" value="
													CRMTEdesc1,
													CRMRPdescripcion1,
													CRMTEdesc2,
													CRMRPdescripcion2
											"/>
											<cfinvokeargument name="etiquetas" value="
													Tipo Entidad 1,
													Relaci&oacute;n 1,
													Tipo Entidad 2,
													Relaci&oacute;n 2
											"/>
											<cfinvokeargument name="formatos" value=""/>
											<cfinvokeargument name="filtro" value="
													rp.Ecodigo=#session.Ecodigo#
													and rp.CEcodigo=#session.CEcodigo#
													and rp.Ecodigo=tr.Ecodigo
													and rp.CEcodigo=tr.CEcodigo
													and rp.CRMTRid=tr.CRMTRid
													and tr.Ecodigo=te1.Ecodigo
													and tr.CEcodigo=te1.CEcodigo
													and rp.CRMTEid1=te1.CRMTEid
													and rp.CRMTEid2=te2.CRMTEid 
													#filtro#"/>
											<cfinvokeargument name="align" value="left,left,left,left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="Conexion" value="#session.DSN#"/>	
											<cfinvokeargument name="irA" value="relacionesPermit.cfm"/>
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