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
			
		<cfif isdefined("url.CPid") and not isdefined("form.CPid")>
			<cfset form.CPid = url.CPid >
		</cfif>
		<cfif isdefined("url.DEidentificacion") and not isdefined("form.DEidentificacion")>
			<cfset form.DEidentificacion = url.DEidentificacion >
		</cfif>		
		<cfif isdefined("url.CFid") and not isdefined("form.CFid")>
			<cfset form.CFid = url.CFid >
		</cfif>
		<cfif isdefined("url.fNombre") and not isdefined("form.fNombre") >
			<cfset form.fNombre = url.fNombre >
		</cfif>
		<cfif isdefined("url.fDApellido1") and not isdefined("form.fDApellido1") >
			<cfset form.fDApellido1 = url.fDApellido1 >
		</cfif>
		<cfif isdefined("url.fDApellido2") and not isdefined("form.fDApellido2") >
			<cfset form.fDApellido2 = url.fDApellido2 >
		</cfif>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_HistoricoDeBoletasDePago"
						Default="Hist&oacute;rico de Boletas de Pagos"
						returnvariable="LB_HistoricoDeBoletasDePago"/> 				
				
					<cf_web_portlet_start titulo="#LB_HistoricoDeBoletasDePago#">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
							<tr><td>
								<cfif isdefined("form.CPid") and len(trim(form.CPid))>
									<cfinclude template="HBoletasPagoConsulta.cfm">
								<cfelse>
									<cfinclude template="HBoletasPago-filtro.cfm">
								</cfif>
							</td></tr>
						</table>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>