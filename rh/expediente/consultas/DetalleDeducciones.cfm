<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
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
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ConsultaDeTransaccionesDeDeduccion"
				Default="Consulta de Transacciones de Deducci&oacute;n"
				returnvariable="LB_ConsultaDeTransaccionesDeDeduccion"/>				  
				  
				  
				  <cf_web_portlet_start titulo="#LB_ConsultaDeTransaccionesDeDeduccion#">
					  <cfset prueba = "prueba" >
					  <cfif session.modulo eq "autogestion" >
						  <cfset Session.Params.ModoDespliegue = 0 >
						<cfelse>
						  <cfset Session.Params.ModoDespliegue = 1 >
					  </cfif>
						
					  <cfset navegacion = '' >
					  <cfif isdefined("url.Did") and not isdefined("form.Did")>
						  <cfset form.Did = url.Did>
					  </cfif>
					  <cfif isdefined("form.Did") and len(trim(form.Did))>
						  <cfset navegacion = "&Did=#form.Did#">
					  </cfif> 
					  <cfif isdefined("url.DEid") and not isdefined("form.DEid")>
						  <cfset form.DEid = url.DEid>
					  </cfif>
					  <cfif isdefined("form.DEid") and len(trim(form.DEid))>
						  <cfset navegacion = navegacion & "&DEid=#form.DEid#">
					  </cfif> 
					  
  					  <cfif isdefined("url.DEid") and not isdefined("form.DEid")>
						  <cfset form.DEid = url.DEid>
					  </cfif>

					  <cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
					      <cfset navegacion = navegacion & "&PageNum_Lista=#url.PageNum_Lista#" >
					  </cfif>

					  <cfoutput>

						<cf_rhreporte principal="javascript:regresar();" datos="/rh/expediente/consultas/formDetalleDeducciones.cfm" paramsuri="#navegacion#">
						
					  </cfoutput>
				  <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>