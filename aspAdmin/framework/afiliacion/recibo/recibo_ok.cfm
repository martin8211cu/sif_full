<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenuFM.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->
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
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" --> 
      <cfinclude template="../../../portlets/pubica.cfm">
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><!--- <cfinclude template="../portlets/pEmpresas2.cfm"> ---></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Administraci&oacute;n</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="/aspAdmin/framework/jsMenuFM.cfm" ></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->	
	
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="84" align="left" valign="top" nowrap></td> 
    <td width="3" align="left" valign="top" nowrap></td>
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr>
    <td width="1%" align="left" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td width="3" align="left" valign="top" nowrap></td> 
    <td valign="top" width="100%">
	<!-- InstanceBeginEditable name="portletMantenimientoInicio" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Env&iacute;o de contrase&ntilde;as">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" --> 
	<cfset Regresar = "recibo.cfm">
	<cfinclude template="../../portlets/pNavegacion2.cfm">
	<table border="0" align="center" width="75%" cellpadding="2" cellspacing="0">
		<tr>
		<td class="listaCorte">No. Contrato</td>
		<td class="listaCorte">Correo electr&oacute;nico</td>
		<td class="listaCorte">Nombre</td>
		<td class="listaCorte">Resultado</td>
		</tr>
		<cfset tablerownum=0>
		<cfloop from="0" to="15" index="n">
			<cfset contrato="contrato_"&n>
			<cfset email="email_"&n>
			<cfset login="login_"&n>
			<cfset status="status_"&n>
			<cfif isdefined('form.' & contrato) and isdefined('form.' & email) and len(trim(evaluate('form.'&contrato))) and len(trim(evaluate('form.'&email)))>
				<cfset tablerownum=tablerownum+1>
				<cfquery name="data" datasource="SDC">
					select u.Papellido1 + ' ' + u.Papellido2 + ', ' + u.Pnombre as nombre,
						up.id as contrato, u.Usulogin as login
					from Usuario u, UsuarioPermiso up
					where up.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate('form.'&contrato)#">
					  and u.Usucodigo = up.Usucodigo
					  and u.Ulocalizacion = up.Ulocalizacion
					  and up.activo = 1
					  and u.activo = 1
				</cfquery>
				<cfset rowstyle="listaNon">
				<cfif tablerownum Mod 2 eq 0>
	                <cfset rowstyle="listaPar">
                </cfif>
				<cfif data.Recordcount eq 0>
					<tr class="<cfoutput>#rowstyle#</cfoutput>">
					  <td><em><cfoutput>#evaluate('form.'&contrato)#</cfoutput></em></td>
					  <td colspan="4"><em>Este contrato no existe o no est&aacute; bajo su responsabilidad</em></td>
					</tr>
				<cfelse>
					<cfoutput>
					<tr class="#rowstyle#">
					  <td>#data.contrato#</td>
					  <td>#evaluate('form.' & email)#</td>
					  <td>#data.nombre#</td>
					  <td>#IIf(len(trim(evaluate('form.' & status))), DE(evaluate('form.' & status)), DE("OK"))#</td>
					</tr>
					</cfoutput>
				</cfif>
			</cfif>
		</cfloop>
		<tr><td colspan="5" align="center"><form action="recibo.cfm" style="margin:0"><input type="submit" value="Listo"></form></td></tr>
	</table>
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>