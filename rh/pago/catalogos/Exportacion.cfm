<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
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
					<cfset navegacion = "">                  
					<cfif isdefined("Url.Bid") and not isdefined("Form.Bid")>
	  					<cfparam name="Form.Bid" default="#Url.Bid#">
	                </cfif>
                  	<cfif isdefined("Url.EIid") and not isdefined("Form.EIid")>
						<cfparam name="Form.EIid" default="#Url.EIid#">
	                </cfif>
                  	<cfif isdefined("Form.Bid") and Len(Trim(Form.Bid)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Bid=" & Form.Bid>
	                </cfif>
                  	<cfif isdefined("Form.EIid") and Len(Trim(Form.EIid)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EIid=" & Form.EIid>
	                </cfif>
                  	<cfif isdefined("Form.Bid") and len(trim(Form.Bid)) gt 0>
						<cfquery name="rsFORM" datasource="#Session.DSN#">
							select a.Bid, a.EIid, RHEdescripcion, b.Bdescripcion as Banco, a.ts_rversion
							from RHExportaciones a, Bancos b
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
							  and a.EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
							  and a.Bid = b.Bid
						</cfquery>
					</cfif>
					<cfif isdefined("Form.Bid") and len(trim(Form.Bid)) gt 0>
						<cfset LB_Exportacion_de_Cheques = rsFORM.RHEdescripcion>
					<cfelse>						
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Exportacion_de_Cheques"
							Default="Exportación de Cheques"	
							returnvariable="LB_Exportacion_de_Cheques"/>					
	                </cfif>
					<cf_web_portlet_start border="true" titulo="#LB_Exportacion_de_Cheques#" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacionPago.cfm">
						<!---<cfset form.CamposAdicionales = "" >
						<cfif isdefined("Form.Bid") and len(trim(Form.Bid)) gt 0>
							<cfset Form.CamposAdicionales = Form.CamposAdicionales & ",Bid=" & form.Bid>
						</cfif>
						<cfif isdefined("Form.EIid") and len(trim(Form.EIid)) gt 0>
							<cfset Form.CamposAdicionales = Form.CamposAdicionales & ",EIid=" & form.EIid>
						</cfif>
						<cfset Form.ERNestado = "4">
						<cfset Form.ERNcapturado = "False">
						<cfset Form.ERNfverifica = "True">
						<cfset Form.PermiteFiltro = "True">
						<cfset Form.Botones = "None">---->
						<cfset Form.irA = "/cfmx/rh/pago/catalogos/Exportar.cfm">
						<!----<cfinclude template="lista-Exportacion.cfm">----->
						<cfinclude template="listaNomina-Exportacion.cfm">
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>	