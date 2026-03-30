<cfparam name="form.formato" default="flashpaper">
<cfparam name="Regresar" default="../consultas/ReportePuestos.cfm">
<cfif isdefined('url.RHPcodigo') and not isdefined('form.RHPcodigo')>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>
<cfif isdefined('url.formato')>
	<cfset form.formato = url.formato>
</cfif>
<cfif isdefined('url.CFid')>
	<cfset form.CFid = url.CFid>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

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
	function funcRegresar(){
		location.href="<cfoutput>#Regresar#</cfoutput>";
		return false;
	}
	</script>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ReportedePuestos"
		Default="Reporte de Puestos"
		returnvariable="LB_ReportedePuestos"/>
	
	<cf_web_portlet_start border="true" titulo="#LB_ReportedePuestos#" skin="#Session.Preferences.Skin#">

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<form name="form1" action="PuestosReport.cfm" method="port">
			<cfoutput>
			<input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#">
			<input name="Regresar" type="hidden" value="#Regresar#">
			</cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td align="right">
					<cfif isdefined('bandera')>
						&nbsp;
					<cfelse>
					<strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong>
					<select name="formato" tabindex="1" onchange="javascript: document.form1.submit();">
						<option value="FlashPaper" <cfif isdefined('formato') and formato EQ 'FlashPaper'>selected</cfif>>FlashPaper</option>
						<option value="pdf" <cfif isdefined('formato') and formato EQ 'pdf'>selected</cfif>>Adobe PDF</option>
						<option value="HTML" <cfif isdefined('formato') and formato EQ 'HTML'>selected</cfif>>HTML</option>
					</select>
					</cfif>
				</td>
				<td width="15%" align="left">
					<cf_botones values="Regresar" names="Regresar">
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="2">
					<!--- Requiere que esté definido el RHPcodigo--->
			
					<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo)) gt 0>
						<cfset form.RHPcodigo = url.RHPcodigo>
					</cfif>
			
					<cfif not isdefined("form.RHPcodigo") or len(trim(form.RHPcodigo)) eq 0>
						<strong><cf_translate key="LB_DebeSeleccionarUnPuestoMostrarElReporte">Debe seleccionar un puesto mostrar el reporte.</cf_translate></strong>
						<cfabort>
					</cfif>
			
				  	<!--- <cfif isdefined("url.regresar") and len(trim(url.regresar)) gt 0>			
						<cfset regresar = url.Regresar>
						<cfif isdefined("url.o") and len(trim(url.o)) gt 0>
							<cfset regresar = regresar & '&o=' & url.o>
						</cfif>
						<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0>
							<cfset regresar = regresar & '&sel=' & url.sel>
						</cfif>
				  	<cfelseif isdefined("form.regresar") and len(trim(form.regresar)) gt 0>			
						<!---- cgi.CONTEXT_PATH = variable que contiene la dirección en el servidor donde estan los archivos ----->
						<cfset regresar = trim(cgi.CONTEXT_PATH) & trim(form.regresar) >
					<cfelse>		
						<cfset regresar = trim(cgi.CONTEXT_PATH) & "/rh/indexPuestos.cfm">
					</cfif> --->
					
					<!---		
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarStatusText = ArrayNew(1)>
					<cfset navBarItems[1] = "Administración de Puestos">
					<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
					<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfinclude template="formPuestosReport.cfm">
					
					/cfmx/rh/indexPuestos.cfm
					--->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_AdministraciondePuestos"
						Default="Administración de Puestos"
						returnvariable="LB_AdministraciondePuestos"/>
					
					<cfif isdefined('form.CFid') and len(trim(form.CFid))>
						<iframe id="ReporteP" frameborder="0" name="ReporteP" width="950"  height="600" 
								style="visibility:visible;border:none; vertical-align:top" 
								src="../catalogos/formPuestosReport.cfm?RHPcodigo=<cfoutput>#form.RHPcodigo#</cfoutput>&Formato=<cfoutput>#form.formato#</cfoutput>&CFid=<cfoutput>#form.CFid#</cfoutput>"></iframe>
					<cfelse>
						<iframe id="ReporteP" frameborder="0" name="ReporteP" width="950"  height="600" 
								style="visibility:visible;border:none; vertical-align:top" 
								src="../catalogos/formPuestosReport.cfm?RHPcodigo=<cfoutput>#form.RHPcodigo#</cfoutput>&Formato=<cfoutput>#form.formato#</cfoutput>"></iframe>
					</cfif>
					<!--- <cf_rhreporte modulo="Puestos" 
						modulolink="#trim(cgi.CONTEXT_PATH)#/home/menu/modulo.cfm?s=#session.menues.SSCodigo#&m=#session.menues.SMCodigo#" 
						modulodesc="#LB_AdministraciondePuestos#" 
						principal="javascript: location.href = '#regresar#';" 
						datos="/rh/admin/catalogos/formPuestosReport.cfm" 
						paramsuri="&RHPcodigo=#form.RHPcodigo#"> --->

				</td>	
			</tr>
		</table>	
		</form>
    <cf_web_portlet_end>		
<cf_templatefooter>