<cfinclude template="check-empresa.cfm">
<cfparam name="session.locReloj" type="numeric" default="0">
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="css/rh.css" rel="stylesheet" type="text/css">
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

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">

	  <cf_web_portlet_start titulo="Reloj Marcador">
	  
	  <form name="form1" id="form1" method="post" action="index-select.cfm">
	  
	  <table>
	  <tr>
	    <td>Empresa</td>
	    <td><cfoutput>#session.Enombre#</cfoutput></td>
	    </tr>
	  <tr>
	  	<td>Reloj</td>
		<td><input tabindex="1" name="codigo" type="text" value="" onfocus="this.select()" maxlength="10"></td></tr>
	  <tr>
	  	<td>Contrase&ntilde;a</td>
		<td><input tabindex="2" name="passwd" type="password" value="" onfocus="this.select()" maxlength="10"></td></tr>
	  <tr><td colspan="2"><input type="submit" value="Activar"></td></tr>
	  </table>
	  </form>
	  
	  
	  <cf_web_portlet_end>

				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>

<cfset session.RHRid = 0>

<script type="text/javascript">
<!--
	document.form1.codigo.focus();
//-->
</script>