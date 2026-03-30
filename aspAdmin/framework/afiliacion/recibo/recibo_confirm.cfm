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
		<form action="recibo_apply.cfm" method="post">
			<table border="0" align="center" width="75%" cellpadding="2" cellspacing="0">
			<tr>
				<td class="listaCorte">No. Contrato</td>
				<td class="listaCorte">Correo electr&oacute;nico</td>
				<td class="listaCorte">Nombre</td>
				<td class="listaCorte">Login temporal</td>
				<td class="listaCorte">Asociar con usuario actual</td>
			</tr>
			<cfset tablerownum = 0>
			<cfset hayalgo=false>
			<!---<cftry>--->
			<cfloop from="0" to="15" index="n">
				<cfset contrato="contrato_" & n>
				<cfset email="email_" & n>
				<cfset login="login_" & n>
				<cfif len(trim(evaluate('form.' & contrato))) gt 0 and len(trim(evaluate('form.' & email))) gt 0>
					<cfset tablerownum=tablerownum+1>
					<cfquery name="data" datasource="SDC">
						select u.Papellido1 + ' ' + u.Papellido2 + ', ' + u.Pnombre as nombre,
							up.id as contrato, u.Usulogin as login, u.TIcodigo, u.Pid
						from Usuario u, UsuarioPermiso up
						where up.id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate('form.' & contrato)#">
						  and u.Usucodigo = up.Usucodigo
						  and u.Ulocalizacion = up.Ulocalizacion
						  and up.activo = 1
						  and u.activo = 1
						  and u.Usutemporal = 1
					</cfquery>
					
					<cfquery name="udata" datasource="SDC">
						select u.Papellido1 + ' ' + u.Papellido2 + ', ' + u.Pnombre as nombre,
							u.Usulogin as login, u.TIcodigo, u.Pid
						from Usuario u
						where u.Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('form.' & login)#">
						  and u.activo = 1
						  and u.Usutemporal = 0
					</cfquery>
					
					<cfset rowstyle="listaNon">
					<cfif tablerownum mod 2>
						<cfset rowstyle="listaPar">
					</cfif>
					
					<cfoutput>
						<cfif data.RecordCount eq 0>
							<tr class="#rowstyle#">
							  <td><em>#evaluate('form.' & contrato)#</em></td>
							  <td colspan="4"><em style="color:red">Este contrato no existe o no est&aacute; bajo su responsabilidad</em></td>
							</tr>
						<cfelseif udata.RecordCount eq 0 and len(trim(evaluate('form.' & login)))>
							<tr class="#rowstyle#">
							  <td><em>#evaluate('form.' & contrato)#</em></td>
							  <td colspan="4"><em style="color:red">El login #evaluate('form.' & login)# no existe</em></td>
							</tr>
						<cfelseif udata.Recordcount gt 0 and (udata.Pid neq data.Pid or udata.TIcodigo neq data.TIcodigo)>
							<tr class="#rowstyle#">
							  <td><em>#evaluate('form.' & contrato)#</em></td>
							  <td colspan="4"><em style="color:red">El login #evaluate('form.' & login)#
								suministrado no corresponde a la misma persona que el contrato #evaluate('form.' & contrato)#.
								Los n&uacute;meros de identificaci&oacute;n son
								#data.TIcodigo# #data.Pid# y
								#udata.TIcodigo# #udata.Pid#, respectivamente.
							  </em></td>
							</tr>
						<cfelse>
							<cfset hayalgo=true>
							<tr class="#rowstyle#">
							  <td>#data.contrato#
								<input type="hidden" name="#contrato#" value="#evaluate('form.' & contrato)#">
								<input type="hidden" name="#email#"    value="#evaluate('form.' & email)#">
								<input type="hidden" name="#login#"    value="#evaluate('form.' & login)#">
							  </td>
							  <td>#evaluate('form.' & email)#</td>
							  <td>#data.nombre#&nbsp;</td>
							  <td>#data.login#&nbsp;</td>
							  <td>#evaluate('form.' & login)#
							  <cfif udata.Recordcount gt 0> #udata.nombre# </cfif>
							  &nbsp;</td>
							</tr>
						</cfif>
					</cfoutput>
				</cfif>
			</cfloop>
			<!---<cfcatch>
				<cfinclude template="../../../errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>
			</cftry>--->
			<tr><td colspan="5">En este proceso se generar&aacute; una contrase&ntilde;a aleatoria, que le
							  ser&aacute; enviada al usuario por correo electr&oacute;nico para que complete
							  su afiliaci&oacute;n al portal. En este proceso el usuario podr&aacute; seleccionar
							  un login definitivo, o bien utilizar uno que ya posea.<br>
							  En caso de que capture un usuario actual (existente), el login
							  temporal se desactivar&aacute; y el usuario existente recibir&aacute; los
							  roles del usuario actual</td></tr>
			<tr><td colspan="5" align="center">
			<cfif hayalgo>
				<input type="submit" value="Confirmar">&nbsp;
			</cfif>
			<input type="button" value="Regresar" onClick="history.go(-1)"></td></tr>
			</table>
		</form>
	<!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		</cf_web_portlet>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>