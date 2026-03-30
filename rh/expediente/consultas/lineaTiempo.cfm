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
					<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
						<cfset form.DEid = url.DEid>
					</cfif>
				  <!--- cuando se llamam del expediente --->		          
					<cfif isdefined("url.o") and not isdefined("form.o")>
						<cfset form.o = url.o >
					</cfif>
					<cfif isdefined("url.regresar") and not isdefined("form.regresar")>
						<cfset form.regresar = url.regresar >
					</cfif>
					<cfif isdefined("url.sel") and not isdefined("form.sel")>
						<cfset form.sel = url.sel >
					</cfif>		          <!--- --->
					<cfset vparams = "&sel=1" >
					<cfif isdefined("form.DEid")>
						<cfset vparams = vparams & "&DEid=" & form.DEid>
					</cfif>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_HistoricoDeCambiosSalariales"
					Default="Hist&oacute;rico de Cambios Salariales"
					returnvariable="LB_HistoricoDeCambiosSalariales"/>
					
					<cf_web_portlet_start titulo="#LB_HistoricoDeCambiosSalariales#">
						<cfif isDefined("Form.DEid") and isDefined("Form.Regresar")>
							<cfoutput>
								<form name="Regresar" method="post" action="#Form.Regresar#">
									<input type="hidden" name="DEid" value="#Form.DEid#">
									<input type="hidden" name="o" value="#Form.o#">
									<input type="hidden" name="sel" value="#Form.sel#">
								</form>
							</cfoutput>
							<cfset regresar = "javascript: document.Regresar.submit();">
						<cfelse>
							<cfif Session.Params.ModoDespliegue EQ 1>
								<cfset regresar = "lineaTiempo.cfm">
							<cfelse>
								<cfset regresar = "lineaTiempoEmp.cfm">
							</cfif>
						</cfif>					
						<cfif isdefined("form.DEid")>
							<cf_rhreporte principal="#regresar#" 
										  datos="/rh/expediente/consultas/lineaTiempoForm.cfm" 
										  objetosform="false" 
										  paramsuri="#vparams#">
						<cfelse>
							<cfset regresar = "/cfmx/rh/index.cfm">
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="/rh/expediente/consultas/lineaTiempoForm.cfm">
						</cfif>	
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>