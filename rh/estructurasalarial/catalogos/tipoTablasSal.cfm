<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Titulo" default="Registro de Tablas Salariales" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_EvaluaciondelDesempeno" default="Evaluaci&oacute;n del Desempeño" returnvariable="LB_EvaluaciondelDesempeno" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke key="MSG_CrearVigencia" default="La fecha ingresada ya esta asociada a una vigencia existente. Desea reemplazarla?" returnvariable="MSG_CrearVigencia" component="sif.Componentes.Translate" method="Translate"/>			
<!--- FIN VARIABLES DE TRADUCCION --->
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
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
                  	<cf_web_portlet_start border="true"  skin="#Session.Preferences.Skin#">
						<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0><cfset form.sel = url.sel></cfif>
						<cfif isdefined('url.RHTTid') and not isdefined('form.RHTTid') and LEN(TRIM(url.RHTTid))><cfset form.RHTTid = url.RHTTid></cfif>
						<cfif isdefined('url.RHVTid') and not isdefined('form.RHVTid') and LEN(TRIM(url.RHVTid))><cfset form.RHVTid = url.RHVTid></cfif>
						<cfif isdefined('form.RHTTid') and LEN(TRIM(form.RHTTid))><cfset form.modo= 'CAMBIO'></cfif>
						<cfif isdefined('form.SelL') and LEN(TRIM(form.SelL)) and (not isdefined('form.sel')or LEN(TRIM(form.Sel)) EQ 0)><cfset form.sel= form.SelL></cfif>
						<cfparam name="form.sel" default="1" type="numeric">
						<cfif (form.sel gt 0) and (isdefined("form.BTNNuevo") or isdefined("form.BTNNew")  or (isdefined("form.RHTTid") and len(trim(form.RHTTid)) gt 0))>
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td width="2%" rowspan="3">&nbsp;</td>
								<td width="74%">&nbsp;</td>
								<td width="2%">&nbsp;</td>
								<td width="20%">&nbsp;</td>
								<td width="2%" rowspan="3">&nbsp;</td>
							  </tr>
							  <tr>
								<td valign="top" align="center">
                                   <!--- <cf_dump var="#Form#"> --->

                                    <cfinclude template="tipoTablasSal_Encab.cfm">
 									<cfswitch expression="#sel#">						
										<cfcase value="1"><cfinclude template="tipoTablasSalForm.cfm"></cfcase>
										<cfcase value="2"><cfinclude template="Vigencias.cfm"></cfcase>
										<cfcase value="3"><cfinclude template="Incremento.cfm"></cfcase>
										<cfcase value="4"><cfinclude template="AplicarTabla.cfm"></cfcase>
									</cfswitch> 
								</td>
								<td>&nbsp;</td>
								<td valign="top" align="center">
									<cfinclude template="tipoTablasSal-pasos.cfm">
									<cfif isdefined("EVAL_RIGHT")>
									<br><cfoutput>#EVAL_RIGHT#</cfoutput>
									</cfif>
								</td>
							  </tr>
							  <tr>
								<td>&nbsp;</td>
							  </tr>
							</table>
						<cfelse> 
							<cfinclude template="tipoTablasSal-lista.cfm">
						</cfif>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>
