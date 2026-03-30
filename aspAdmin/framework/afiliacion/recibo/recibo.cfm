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
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Env&iacute;o de Contrase&ntilde;as">
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" -->
		<cfinclude template="../../portlets/pNavegacion2.cfm"> 
		<script language="JavaScript1.4" type="text/javascript" src="recibo.js"></script>
		<script language="javascript1.4" type="text/javascript" src="../../../js/utilesMonto.js"></script>
		<script language="javascript1.4" type="text/javascript">
			function allValidNumbers(){
				<cfloop from="0" to="15" index="n">
					<cfset contrato = 'document.contratos.contrato_' & n & '.value'>
					if (!esEntero(<cfoutput>#contrato#</cfoutput>)) {
						alert('Error! El valor todos los contratos debe ser un número entero.');
						return false;
					}
				</cfloop>
				return true;
			}
			function isValidNumber(obj) {
				if (esEntero(obj.value)){
					return true;
				}
				obj.value = "";
				obj.focus();
				alert('Error! El valor de este campo debe ser un número entero.');
				return false;
			}
			function esEntero(aVALOR)
			{
				var NUMEROS="0123456789"
				var CARACTER=""
				var VALOR = aVALOR.toString();
				
				for (var i=0; i<VALOR.length; i++)
					{	
					CARACTER =VALOR.substring(i,i+1);
					if (NUMEROS.indexOf(CARACTER)<0) {
						return false;
						} 
					}
				return true;
			}
		</script>
		<form action="recibo_confirm.cfm" method="post" name="contratos" id="contratos" onSubmit="allValidNumbers(); return confirmar(this)">
		<table width="75%" cellpadding="0" cellspacing="0" align="center" >
			<tr><td class="listaCorte" colspan="3" align="center">Capturar correo electr&oacute;nico y/o usuario existente</td></tr>
			<tr>
				<td class="listaPar" align="center">Contrato</td>
				<td class="listaPar" align="center">Correo electr&oacute;nico</td>
				<td class="listaPar" align="center">Asignar a usuario actual</td>
			</tr>
			<cfloop from="0" to="15" index="n">
				<cfset contrato = 'contrato_' & n>
				<cfset email = 'email_' & n>
				<cfset login = 'login_' & n>
				<cfset visibilidad = "">
				<cfset tr = 'row_' & n>
				<cfset evento = 'lineBlur()'>
				
				<cfif n lt 3>
					<cfset estilo = "">
				<cfelse>
					<cfset estilo = "display:none">
				</cfif>
				<cfoutput>
				<tr id="#tr#" style="#estilo#">
					<td align="left"><input type="text" style="width:100%" size="30" maxlength="10" name="#contrato#" onChange="#evento#" onBlur="#evento#; isValidNumber(this)" ></td>
					<td align="center"><input type="text" style="width:100%" size="50" maxlength="50" name="#email#" onChange="#evento#" onBlur="#evento#; isValidEmail(this)"></td>
					<td align="right"><input type="text"  style="width:100%" size="30" maxlength="15" name="#login#" onChange="#evento#" onBlur="#evento#"  ></td>
				</tr>
				</cfoutput>
			</cfloop>
			<tr>
			<td colspan="3">
				En este proceso se generar&aacute; una contrase&ntilde;a aleatoria, que le
				  ser&aacute; enviada al usuario por correo electr&oacute;nico para que complete
				  su afiliaci&oacute;n al portal. En este proceso el usuario podr&aacute; seleccionar
				  un login definitivo, o bien utilizar uno que ya posea.<br>
				  En caso de que capture un usuario actual (existente), el login
				  temporal se desactivar&aacute; y el usuario existente recibir&aacute; los
				  roles del usuario actual</td>
			</tr>
			<tr>
				<td colspan="3" align="center">
					<input type="submit" name="btnVerificar" value="Verificar" />
					<input type="reset" name="btnActualizar"  value="Restablecer" />
					<input name="buscar" type="hidden" value="6" />
				</td>
			</tr>
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