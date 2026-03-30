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
	  <cfset vparams = "&sel=1" >
	  <cfif isdefined("url.RHTcomportam") and not isdefined("form.RHTcomportam")>
	  	<cfset form.RHTcomportam = url.RHTcomportam>
	  </cfif>
	   <cfif isdefined("url.fechaI") and not isdefined("form.fechaI")>
	  	<cfset form.fechaI = url.fechaI>
	  </cfif>
	   <cfif isdefined("url.fechaF") and not isdefined("form.fechaF")>
	  	<cfset form.fechaF = url.fechaF>
	  </cfif>	  
	  <cfif isdefined("form.RHTcomportam")>
	  	<cfset vparams = vparams & "&RHTcomportam=" & form.RHTcomportam>
	  </cfif>
	    <cfif isdefined("form.fechaI")>
			<cfset vparams = vparams & "&fechaI=" & form.fechaI>
		</cfif>
		<cfif isdefined("form.fechaF")>
			<cfset vparams = vparams & "&fechaF=" & form.fechaF>
		</cfif>		
		
	  <cfset Regresar = '/cfmx/rh/index.cfm'>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_TipoAccionPorEmpresa"
						Default="Tipo Acci&oacute;n por Empresa"
						returnvariable="LB_TipoAccionPorEmpresa"/>				
                	<cf_web_portlet_start border="true" titulo="#LB_TipoAccionPorEmpresa#" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<cfif isdefined("form.RHTcomportam")>							
							<cf_rhimprime datos="/rh/expediente/consultas/TipoAccionEmpresa-detalle.cfm" paramsuri="#vparams#">
						</cfif>
						<cfinclude template="TipoAccionEmpresa-detalle.cfm">
				  	<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>