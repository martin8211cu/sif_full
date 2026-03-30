<!--- VARIALBES DE TRADUCCION --->
<cfsilent>
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_HistoricoDePagosRealizados" Default="Hist&oacute;rico de Pagos Realizados" returnvariable="LB_HistoricoDePagosRealizados" component="sif.Componentes.Translate" method="Translate"/> 
</cfsilent>
<!--- FIN VARIABLES TRADUCCION --->
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
					
					<cf_web_portlet_start titulo="#LB_HistoricoDePagosRealizados#" >
						<script language="JavaScript1.2" type="text/javascript">
							function regresar(){ document.formback.submit()}
						</script>
						<cfoutput>
							<cfif isDefined("Url.Regresar")>
								<form action="<cfif isdefined("session.menues.SMcodigo") and ucase(session.menues.SMcodigo) eq 'AUTO'>/cfmx/rh/expediente/consultas/HistoricoPagos.cfm<cfelse>#Url.Regresar#</cfif>" method="post" name="formback" style="margin:0; ">
									<input name="Tcodigo" type="hidden" value="#Url.Tcodigo#">
									<input name="CPcodigo" type="hidden" value="#Url.CPcodigo#">
									<cfif isdefined("Url.DEid") and not isdefined("form.DEid")>
										<input name="DEid" type="hidden" value="#Url.DEid#">
									</cfif>

									<cfif isdefined("Url.chkIncidencias")>
										<input name="chkIncidencias" type="hidden" value="#Url.chkIncidencias#">
									</cfif>
									<cfif isdefined("Url.chkCargas")>
										<input name="chkCargas" type="hidden" value="#Url.chkCargas#">
									</cfif>
									<cfif isdefined("Url.chkDeducciones")>
										<input name="chkDeducciones" type="hidden" value="#Url.chkDeducciones#">
									</cfif>
									<input name="butFiltrar" type="hidden" value="Filtrar">
								</form>
							<cfelse>
								<cfif isdefined("Url.RCNid") and not isdefined("form.RCNid")>
									<cfparam name="form.RCNid" default="#url.RCNid#">
								</cfif>
								<cfif isdefined("Url.DEid") and not isdefined("form.DEid")>
									<cfparam name="form.DEid" default="#url.DEid#">
								</cfif>
								<form action="<cfif isdefined('form.regresar') and len(trim(form.regresar))>#form.regresar#<cfelse>HistoricoPagos.cfm</cfif> " method="post" name="formback">
									<input name="RCNid" type="hidden" value="#Form.RCNid#">
									<input name="DEid" type="hidden" value="#Form.DEid#">
									<input name="sel" type="hidden" value="1">
								</form>
							</cfif>
						</cfoutput>
						<cfset funcion = "javascript: regresar();">
						<cfif   isdefined('session.modulo') and session.modulo eq "autogestion" >
							<cfset Session.Params.ModoDespliegue = 0 >
						<cfelse>
							<cfset Session.Params.ModoDespliegue = 1 >
						</cfif>	
						<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr valign="top"> 
								<td align="center">
									<cfif isDefined("Url.Regresar")>
										<cfset paramadic = "">
										<cfif isDefined("Url.chkIncidencias")>
											<cfset paramadic = paramadic & "&chkIncidencias=#Url.chkIncidencias#">
										</cfif>
										<cfif isDefined("Url.chkCargas")>
											<cfset paramadic = paramadic & "&chkCargas=#Url.chkCargas#">
										</cfif>
										<cfif isDefined("Url.chkDeducciones")>
											<cfset paramadic = paramadic & "&chkDeducciones=#Url.chkDeducciones#">
										</cfif>
										<cf_rhreporte principal="#funcion#" 
													  datos="/rh/expediente/consultas/HResultadoCalculo-form.cfm" 
													  objetosform="False" 
													  paramsuri="?DEid=#url.DEid#&RCNid=#url.RCNid#
													  &Tcodigo=#url.Tcodigo#&CPcodigo=#url.CPcodigo##paramadic#&Regresar=#url.Regresar#">
									<cfelse>
										<cfif isdefined("Url.Tcodigo") and not isdefined("form.Tcodigo")>
											<cfparam name="form.Tcodigo" default="#url.Tcodigo#">
										</cfif>
										<cf_rhreporte principal="" 
													  datos="/rh/expediente/consultas/HResultadoCalculo-form.cfm" 
													  objetosform="False" 
													  paramsuri="?DEid=#Form.DEid#&RCNid=#form.RCNid#&Tcodigo=#form.Tcodigo#">
									</cfif>
								</td>
							</tr>
						  	<tr valign="top"> 
								<td>&nbsp;</td>
						  	</tr>
							<tr valign="top"> 
							<td>&nbsp;</td>
							</tr>
						</table>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>