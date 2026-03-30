<cfparam name="form.formato" default="flashpaper">

<cfif isdefined('url.formato') and not isdefined('form.formato')>
	<cfset form.formato = url.formato>
</cfif>

<cfif isdefined('url.RHDPPid') and not isdefined('form.RHDPPid')>
	<cfset form.RHDPPid = url.RHDPPid>
</cfif>
<cfif isdefined('url.o') and not isdefined('form.o')>
	<cfset form.o = url.o>
</cfif>
<cfif isdefined('url.sel') and not isdefined('form.sel')>
	<cfset form.sel = url.sel>
</cfif>
<cfif isdefined('url.USUARIO') and not isdefined('form.USUARIO')>
	<cfset form.USUARIO = url.USUARIO>
</cfif>

<cfquery name="rsForm" datasource="#session.DSN#">
	select RHPcodigo
	from RHDescripPuestoP
	where RHDPPid = <cfqueryparam value="#form.RHDPPid#" cfsqltype="cf_sql_numeric">
	and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset form.RHPcodigo = rsForm.RHPcodigo>

<cfset form.formato = 'FlashPaper'>
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
		<cfif form.USUARIO eq 'ASESOR'>
			location.href="PerfilPuesto.cfm?sel=<cfoutput>#form.sel#</cfoutput>&o=<cfoutput>#form.o#</cfoutput>&RHDPPid=<cfoutput>#form.RHDPPid#</cfoutput>&USUARIO=<cfoutput>#form.USUARIO#</cfoutput>";
		<cfelse>
			location.href="ApruebaPerfilPuesto.cfm?sel=<cfoutput>#form.sel#</cfoutput>&o=<cfoutput>#form.o#</cfoutput>&RHDPPid=<cfoutput>#form.RHDPPid#</cfoutput>&USUARIO=<cfoutput>#form.USUARIO#</cfoutput>";
		</cfif>
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
			<input name="RHDPPid" type="hidden" value="#form.RHDPPid#">
			<input name="o" type="hidden" value="#form.o#">
			<input name="sel" type="hidden" value="#form.sel#">
			</cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td align="right">
					&nbsp;
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

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_AdministraciondePuestos"
						Default="Administración de Puestos"
						returnvariable="LB_AdministraciondePuestos"/>
					<iframe id="ReporteP" frameborder="0" name="ReporteP" width="950"  height="600" 
							style="visibility:visible;border:none; vertical-align:top" 
							src="formPuestosReport.cfm?RHPcodigo=<cfoutput>#form.RHPcodigo#</cfoutput>&Formato=<cfoutput>#form.formato#</cfoutput>&sel=<cfoutput>#form.sel#</cfoutput>&o=<cfoutput>#form.o#</cfoutput>&RHDPPid=<cfoutput>#form.RHDPPid#</cfoutput>"></iframe>


				</td>	
			</tr>
		</table>	
		</form>
    <cf_web_portlet_end>		
<cf_templatefooter>