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

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fCRMTEid.value = "";
		document.filtro.fCRMEnombre.value = "";
	}
</script>

						<!--- ------------------------------------------------------------------------------ --->
						<!--- Este query se usa en el form de Entidad, nunca quitarlo!! --->
						<cfquery name="rsTiposEntidad" datasource="#session.DSN#">
							select convert(varchar, CRMTEid) as CRMTEid, CRMTEcodigo, CRMTEdesc  
							from CRMTipoEntidad
							where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by CRMTEcodigo
						</cfquery>
						<!--- ------------------------------------------------------------------------------ --->

						<cf_web_portlet titulo="Entidades" border="true" skin="#Session.Preferences.Skin#">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr><td colspan="2"><cfinclude template="/sif/crm/portlets/pNavegacion.cfm"></td></tr>
								<tr>
									<td valign="top" width="40%">
										<form style="margin:0;" name="filtro" action="Entidad.cfm" method="post">
										<table width="100%" class="areaFiltro">
											<tr>
												<td><b>Tipo de Entidad</b></td>
												<td><b>Descripción</b></td>
											</tr>
											<tr>
												<td>
													<select name="fCRMTEid">
														<option value="">Todos</option>
														<cfoutput query="rsTiposEntidad">
															<option <cfif isdefined("form.fCRMTEid") and form.fCRMTEid eq rsTiposEntidad.CRMTEid >selected</cfif> value="#rsTiposEntidad.CRMTEid#">#rsTiposEntidad.CRMTEcodigo# - #rsTiposEntidad.CRMTEdesc#</option>
														</cfoutput>
													</select> 
												</td>
												<td>
													<input type="text" name="fCRMEnombre" size="40" maxlength="100" value="<cfif isdefined("form.fCRMEnombre")><cfoutput>#form.fCRMEnombre#</cfoutput></cfif>" >
												</td>
												<td align="right"><input type="submit" name="Filtrar" value="Filtrar"></td>
												<td align="right"><input type="button" name="Limpiar" value="Limpiar" onClick="javascript:limpiar();"></td>
											</tr>
										</table>
										</form>

										<cfset filtro = "" >
										<cfif isdefined("form.fCRMTEid") and len(trim(form.fCRMTEid)) gt 0>
											<cfset filtro = " and a.CRMTEid=" & form.fCRMTEid >
										</cfif>

										<cfif isdefined("form.fCRMEnombre") and len(trim(form.fCRMEnombre)) gt 0>
											<cfset filtro = filtro & "  and upper(a.CRMEnombre+' '+ rtrim(coalesce(rtrim(a.CRMEapellido1), '') + ' ' + coalesce(rtrim(a.CRMEapellido2), '')) ) like upper('%" & form.fCRMEnombre &"%')">
										</cfif>

										<cfinvoke 
											component="sif.crm.Componentes.pListas"
											method="pListaCRM"
											returnvariable="pListaCRMRet">
											<cfinvokeargument name="tabla" value="CRMEntidad a, CRMTipoEntidad b"/>
											<cfinvokeargument name="columnas" value="convert(varchar, a.CRMEid) as CRMEid, convert(varchar, a.CRMTEid) as CRMTEid, CRMTEdesc, a.CRMEnombre + ' ' + rtrim(coalesce(rtrim(a.CRMEapellido1), '') + ' ' + coalesce(rtrim(a.CRMEapellido2), '')) as CRMEnombre"/>
											<cfinvokeargument name="desplegar" value="CRMEnombre"/>
											<cfinvokeargument name="etiquetas" value="Descripción"/>
											<cfinvokeargument name="formatos" value="S"/>
											<cfinvokeargument name="filtro" value="a.CEcodigo=#session.CEcodigo# and a.Ecodigo=#session.Ecodigo# #filtro# and a.CRMTEid=b.CRMTEid order by CRMTEdesc, CRMEnombre"/>
											<cfinvokeargument name="align" value="left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="irA" value="Entidad.cfm"/>
											<cfinvokeargument name="Conexion" value="#session.DSN#"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="keys" value="CRMEid"/>
											<cfinvokeargument name="Cortes" value="CRMTEdesc"/>
											<cfinvokeargument name="MaxRows" value="15"/>
										</cfinvoke>
								  </td>
								  <td valign="top" width="60%"><cfinclude template="formEntidad.cfm"></td>
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