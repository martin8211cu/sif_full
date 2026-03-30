<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->


<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/portlets.css" rel="stylesheet" type="text/css">
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
	
     <!---  
	 
	 Invalidado provisionalmente
	 
	 <cfinclude template="../portlets/pubica.cfm"> --->
	 
      <!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle">
		  </td>
          <td width="50%"> 
            <div align="center"></div>
            <div align="center"><span class="superTitulo"><font size="5"><cfoutput></cfoutput></font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
           </td>
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
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='&nbsp;'>
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" -->
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td width="24%">&nbsp;</td>
		<td colspan="3">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td width="8%" bgcolor="#003366" ><font color="#FFFFFF"><img src="/cfmx/sif/imagenes/Stop01_T.gif" width="25" height="25"><span class="titulo"></span></font></td>
		<td width="49%" bgcolor="#003366" ><div align="left"><font color="#FFFFFF">&nbsp;<strong><font size="3">Mensaje</font></strong></font></div></td>
		<td width="15%">&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td width="1%" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder"><div align="right">&nbsp;</div></td>
		<td valign="top" bgcolor="#F5F5F5" class="contenido-rborder">
			<br>
				<font color="#FF3300" size="2">
					<cfif isdefined('url.errMsg')>
						<cfoutput>#URLDecode(url.errMsg)#</cfoutput><br>
					<cfelseif isdefined("url.errDet")>
						<cfoutput>#url.errDet#</cfoutput>
					<cfelseif isdefined("cfcatch.Detail")>
						<cfif isdefined("session.debug") and session.debug eq true >
							<cfoutput>#cfcatch.Detail#</cfoutput>
						<cfelse>
							<cfif isdefined('cfcatch.NativeErrorCode') and cfcatch.NativeErrorCode eq 547 >
								El registro no puede ser eliminado, pues posee dependecias con otros datos.
							<cfelseif isdefined('cfcatch.NativeErrorCode') and cfcatch.NativeErrorCode eq 2601 >
								El registro que desea insertar ya existe.
							<cfelse>
								<cfif len(trim(cfcatch.Detail))>
									<cfoutput>#cfcatch.Detail#</cfoutput>
								<cfelse>
									<cfoutput>#cfcatch.Message#</cfoutput>
								</cfif>
							</cfif>
						</cfif>	
					</cfif>

				</font>
			<br>&nbsp;
		</td>
		<td>&nbsp;</td>
	</tr>
	
	<tr> 
		<td>&nbsp;</td>
		<td valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lborder">&nbsp;</td>
		<td valign="top" bgcolor="#F5F5F5" class="contenido-rborder">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	
	<tr> 
		<td>&nbsp;</td>
		<td colspan="2" valign="top" nowrap bgcolor="#F5F5F5" class="contenido-lrborder">
			<div align="center">
				<cfif isdefined("Regresar") and len(trim(Regresar))>
					<input type="button" name="Button" value="Regresar" onClick="javascript:location.href='<cfoutput>#Regresar#</cfoutput>'">
				<cfelse>
					<input type="button" name="Button" value="Regresar" onClick="javascript:history.back()">
				</cfif>
			</div>
		</td>
		<td>&nbsp;</td>
	</tr>

	<tr>
		<td>&nbsp;</td>
		<td colspan="2" align="center" valign="middle" nowrap bgcolor="#F5F5F5" class="contenido-lbrborder">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td colspan="2" align="center" valign="middle" nowrap ><div align="center">&nbsp;</div></td>
		<td>&nbsp;</td>
	</tr>

	<tr> 
		<td>&nbsp;</td>
		<td colspan="2" align="center" valign="middle" nowrap ><div align="center">&nbsp;</div></td>
		<td>&nbsp;</td>
	</tr>

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