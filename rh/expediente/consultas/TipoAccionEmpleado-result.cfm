

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

<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = Url.DEid>
</cfif>
<cfif isdefined("url.RHTcomportam1") and not isdefined("form.RHTcomportam1")>
	<cfset form.RHTcomportam1 = Url.RHTcomportam1>
</cfif>
	<cfparam name="form.RHTcomportam1" default="0">

<cfif isdefined("url.fechaI") and not isdefined("form.fechaI")>
	<cfset form.fechaI = Url.fechaI>
</cfif>
<cfif isdefined("url.fechaF") and not isdefined("form.fechaF")>
	<cfset form.fechaF = Url.fechaF>
</cfif>

<cfif isdefined("url.DEidentificacion") and not isdefined("form.DEidentificacion")>
	<cfset form.DEidentificacion = Url.DEidentificacion>
</cfif>

<cfif isdefined("url.NTIcodigo") and not isdefined("form.NTIcodigo")>
	<cfset form.NTIcodigo = Url.NTIcodigo>
</cfif>

<cfif isdefined ('url.CaridList') and not isdefined("form.CaridList")>
	<cfset form.CaridList = Url.CaridList>
</cfif>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
	  <cfset vparams = "&sel=1" >
	  <cfif isdefined("form.DEid")>
	  	<cfset vparams = vparams & "&DEid=" & form.DEid>
	  </cfif>
	    <cfif isdefined("form.fechaI")>
			<cfset vparams = vparams & "&fechaI=" & form.fechaI>
		</cfif>
		<cfif isdefined("form.fechaF")>
			<cfset vparams = vparams & "&fechaF=" & form.fechaF>
		</cfif>
	  	<cfset Regresar = '/cfmx/rh/index.cfm'>
		<table width="100%" class="Container"  cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_ConsultaTipoDeAccionPorEmpleado"
						Default="Consulta Tipo de Acci&oacute;n por empleado"
						returnvariable="LB_ConsultaTipoDeAccionPorEmpleado"/>
					<cfif not isdefined("form.irAnube")>
                	<cf_web_portlet_start border="true" titulo="#LB_ConsultaTipoDeAccionPorEmpleado#" skin="#Session.Preferences.Skin#">	
                    </cfif>					
							<cfinclude template="/rh/portlets/pNavegacion.cfm">							
							<cfinclude template="TipoAccionEmpleado-detalle.cfm">	
                    <cfif not isdefined("form.irAnube")>						
				  	<cf_web_portlet_end>
                    </cfif>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>