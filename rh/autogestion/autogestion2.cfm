<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		RH - Autogesti&oacute;n
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../css/rh.css" rel="stylesheet" type="text/css">
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
	  <cfset Session.Params.ModoDespliegue = 0>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">  		        <cfinclude template="../expediente/consultas/consultas-frame-header.cfm">
					<!-- InstanceBeginEditable name="Mantenimiento" -->
	  <br>
	  <cfset Form.DEid = rsEmpleado.DEid> 
	  <cfinclude template="frame-header.cfm">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="tabContent"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
		</tr>
	  </table>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td class="tabContent">
		  	 <cfif tabChoice eq 1>
			 	<cfinclude template="../expediente/catalogos/datosEmpleado.cfm">
		  	 <cfelseif tabChoice eq 2>
			 	<cfinclude template="../expediente/catalogos/familiares.cfm">
		  	 <cfelseif tabChoice eq 3>
				<cfset Form.sel = 1>
			 	<cfinclude template="../expediente/catalogos/acciones.cfm">
		  	 <cfelseif tabChoice eq 4>
			 	<cfinclude template="cargas.cfm">
		  	 <cfelseif tabChoice eq 5>
			 	<cfinclude template="deducciones.cfm">
		     <cfelse>
			 	 <div align="center">
				 	<b>Este m&oacute;dulo no est&aacute; disponible</b>
				 </div>
			 </cfif>
		  </td>
		</tr>
	  </table>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>