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
				<td valign="top">  		        
				<cfinclude template="../expediente/consultas/consultas-frame-header.cfm">
	  <cfset Form.DEid = rsEmpleado.DEid> 
	  <cfinclude template="frame-header.cfm">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
		</tr>
	  </table>
	  
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td>
		  <cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8,9,10', form.tab) )>
				<cfset form.tab = 1 >
		  </cfif>
		  <cfset tabChoice = form.tab>
		  <br>
		  <cf_tabs width="100%">
			 <cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
				<cfif tabChoice eq 1>
					<cfinclude template="../expediente/catalogos/datosEmpleado.cfm">
				</cfif>
			 </cf_tab>
			 <cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
				<cfif tabChoice eq 2 >
					<cfinclude template="../expediente/catalogos/familiares.cfm">
				</cfif>
			 </cf_tab>
			 <cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
				<cfif tabChoice eq 3 >
					<cfinclude template="../expediente/catalogos/acciones.cfm">
				</cfif>
			 </cf_tab>
		     <cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
				<cfif tabChoice eq 4 >
					<cfinclude template="cargas.cfm">
				</cfif>
			</cf_tab>
			<cf_tab text=#tabNames[5]# selected="#tabChoice eq 5#">
				<cfif tabChoice eq 5 >
					<cfinclude template="deducciones.cfm">
				<cfelse>
					<div align="center">
				 		<b>Este m&oacute;dulo no est&aacute; disponible</b>
					 </div>
				</cfif>
			 </cf_tab>
			</cf_tabs>	
			
			
			<script language="javascript" type="text/javascript">
			function tab_set_current (n){
				location.href='autogestion.cfm?o='+escape(n)+'&tab='+escape(n);
			}	
			</script>
									
		  </td> 
		</tr>
	  </table>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>