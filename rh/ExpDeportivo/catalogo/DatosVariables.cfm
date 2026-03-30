<!--- <!--- DE la linea 2 a la  7 es utilizado para agregar la plantilla usara todas la pantallas del sistema  --->
<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		<cf_translate key="LB_Expediente_Deportivo" XmlFile="/rh/ExpDeportivo/generales.xml">Expediente Deportivo</cf_translate>
	</cf_templatearea>
	<cf_templatearea name="body">
<!--- Tag para agregar la hoja de estilos utilizada en la pantañña  --->
<cf_templatecss>
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
	  <cfset Session.cache_empresarial = 0> --->
<!---
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
						<td valign="top" width="1%">
							<script language="JavaScript1.2" type="text/javascript">
								function limpiar(){
									document.filtro.fEDDcodigo.value = "";
									document.filtro.fEDDdescripcion.value   = "";
									
								}
							</script>
							<cfset filtro = " 1=1 ">
							<cfif isdefined("form.fEDDcodigo") and len(trim(form.fEDDcodigo)) gt 0 >
								<cfset filtro = filtro & " and upper(EDDcodigo) like '%#ucase(form.fEDDcodigo)#%' " >
							</cfif>
							<cfif isdefined("form.fEDDdescripcion") and len(trim(form.fEDDdescripcion)) gt 0 >
								<cfset filtro = filtro & " and upper(EDDdescripcion) like '%#ucase(form.fEDDdescripcion)#%' " >
							</cfif>
							
							<cfset filtro = filtro & "order by EDDcodigo">
						</td>	--->
						
			
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Conceptos"
							Default="Conceptos"
							returnvariable="LB_Conceptos"/>

					<cf_templateheader title="#LB_Conceptos#">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top"> 
						<cf_web_portlet_start titulo="#LB_Conceptos#">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">

											</td> 
										
											<!--- AREA DE BUSQUEDA --->
											<td width="50%" valign="top"><cfinclude template="formDatosVariables.cfm"></td>
										<!---</tr>
									</table>
							  </td>
							  <td >&nbsp;</td>
							</tr>--->
							</table> 
						<cf_web_portlet_end>
						
					<!---	  </td>
					  </tr>
					</table>--->
		<cf_templatefooter>