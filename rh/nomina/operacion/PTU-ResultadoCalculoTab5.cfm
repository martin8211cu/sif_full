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
	<script language="JavaScript1.2" type="text/javascript">function regresar(){document.formback.submit()}</script>
    <cfoutput>
    <form action="PTU.cfm" method="post" name="formback">
        <input name="RCNid" type="hidden" value="#Form.RCNid#">
        <cfif isdefined('form.fSEcalculado')>
            <input name="fSEcalculado" type="hidden" value="0">
        </cfif>
    </form>
    </cfoutput>
    <cfset funcion = "regresar">
    <cfinclude template="/rh/portlets/pNavegacion.cfm">
    <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
      <tr valign="top"> 
        <td>&nbsp;</td>
      </tr>
      <tr valign="top"> 
        <td align="center">
          <cfinclude template="/rh/portlets/pEmpleado.cfm">
        </td>
      </tr>
      <tr valign="top"> 
        <td align="center">
            <cfinclude template="PTU-ResultadoCalculoTab5-form.cfm">
        </td>
      </tr>
      <tr valign="top"> 
        <td>&nbsp;</td>
      </tr>
      <tr valign="top"> 
        <td>&nbsp;</td>
      </tr>
    </table>