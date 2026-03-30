<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cf_translate key="RHAutogestion">RH - Autogesti&oacute;n</cf_translate>
	</cf_templatearea>
	
	<cf_templatearea name="body">

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
	  <cfset Session.Params.ModoDespliegue = 0>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">		                    <cfif not isdefined("Form.DEid") and not isdefined("Url.DEid")>
	  		<cfquery name="rsGetEmpleado" datasource="asp">
				select rtrim(llave) as DEid
				from UsuarioReferencia
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
				and STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
			</cfquery>
	  		<!---
			<cfquery datasource="#Session.DSN#" name="rsGetEmpleado">
				select convert(varchar, a.DEid) as DEid
				from asp..UsuarioReferencia p, DatosEmpleado a, NTipoIdentificacion b, Monedas c
				where p.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
				and p.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
				and convert(numeric, p.llave) = a.DEid
				and a.NTIcodigo = b.NTIcodigo
				and a.Mcodigo = c.Mcodigo
			</cfquery>
			--->
			<cfif rsGetEmpleado.recordCount EQ 1>
				<cfset Form.DEid = rsGetEmpleado.DEid>
			</cfif>
	                </cfif>
                  <cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	  	  <cfset form.DEid = url.DEid >
	                </cfif>	  
                  <cfif isdefined("url.o") and not isdefined("form.o")>
	  	  <cfset form.o = url.o >
	                </cfif>	  
                  <cfif isdefined("url.sel") and not isdefined("form.sel")>
	  	  <cfset form.sel = url.sel >
	                </cfif>	  
                  <cfif isdefined("url.regresar") and not isdefined("form.regresar")>
	  	  <cfset form.regresar = url.regresar >
	                </cfif>	  
                   <cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_HistoricoDeCambiosSalariales"
					Default="Hist&oacute;rico de Cambios Salariales"
					returnvariable="LB_HistoricoDeCambiosSalariales"/> 
				  <cf_web_portlet_start titulo="#LB_HistoricoDeCambiosSalariales#">
		  	<table width="100%" border="0" cellpadding="0" cellspacing="0">

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
					<cfset regresar = "/cfmx/rh/autogestion/plantilla/menu.cfm">
				</cfif>					
				<!---<cfinclude template="/rh/portlets/pNavegacion.cfm">--->

		    </table>
			<!---<cfinclude template="lineaTiempoForm.cfm">--->

			<cfif isdefined("form.DEid")>
				<cfset vparams = "&DEid=" & form.DEid>
				<cf_rhreporte principal="#regresar#" datos="/rh/expediente/consultas/lineaTiempoForm.cfm" objetosform="false" paramsuri="#vparams#">
			<cfelse>
				<cf_translate key="LB_LosDatosDeSuHistoricoDeCambiosSalarialesNoEstaDisponible">Los datos de su hist&oacute;rico de cambios salariales no est&aacute; disponible</cf_translate>
			</cfif>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>