<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
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
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" --> 
	  <!--- Pasa valores del Url al Form --->
	  <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ReporteHistoricoDeNominas"
		Default="Reporte Hist&oacute;rico de N&oacute;minas"
		returnvariable="LB_ReporteHistoricoDeNominas"/>
	  
	  <cf_web_portlet_start titulo="#LB_ReporteHistoricoDeNominas#">
	  		<cfif isdefined("url.CPid")>
				<cfset form.RCNid = url.CPid>	
			</cfif>
			<cfif isDefined("form.CPid") >
				<cfset Form.RCNid = form.CPid>
			</cfif>
			<cfif isDefined("Url.RCNid") and not isDefined("Form.RCNid")>
				<cfset Form.RCNid = Url.RCNid>
			</cfif>
			
			<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
				select Tcodigo, Tdescripcion
				from TiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!--- <cfdump var="#form#">
			<cfabort> --->
			<cfquery name="rsRelacionCalculo" datasource="#Session.DSN#">
				select a.RCNid, 
					   rtrim(a.Tcodigo) as Tcodigo, 
					   a.RCDescripcion, a.RCdesde, a.RChasta,
					   (case a.RCestado 
							when 0 then '<cf_translate  key="LB_Proceso">Proceso</cf_translate>'
							when 1 then '<cf_translate  key="LB_Calculo">Cálculo</cf_translate>'
							when 2 then '<cf_translate  key="LB_Terminado">Terminado</cf_translate>'
							when 3 then '<cf_translate  key="LB_Pagado">Pagado</cf_translate>'
							else ''
					   end) as RCestado,
					   a.Usucodigo, 
					   a.Ulocalizacion, 
					   a.ts_rversion,
					   b.Tdescripcion,
					   b.Mcodigo,
					   c.CPcodigo
				from HRCalculoNomina a, TiposNomina b, CalendarioPagos c
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
				and a.Tcodigo = b.Tcodigo
				and a.RCNid = c.CPid
			</cfquery>
<!--- Pasa algunos valores de la consulta al Form para poder utilizarlos posteriormente --->
<!--  Rodolfo Jiménez Jara, SOIN, Costa Rica, 21 Nov 2003 -->
<cfif rsRelacionCalculo.RecordCount gt 0>
	<cfset Form.RCTcodigo = rsRelacionCalculo.Tcodigo>
	<cfset Form.RCdesde = rsRelacionCalculo.RCdesde>
	<cfset Form.RChasta = rsRelacionCalculo.RChasta>
	<cfset Form.RCestado = rsRelacionCalculo.RCestado>
	<cfset Form.RCMcodigo = rsRelacionCalculo.Mcodigo>
	<cfset Form.RCNid = rsRelacionCalculo.RCNid>
</cfif>
			
			<!--- Reporte --->
		  	<script language="JavaScript1.2" type="text/javascript">
				function regresar(){
					location.href='/cfmx/rh/indexHistoricos.cfm?RCNid=<cfoutput>#Form.RCNid#</cfoutput>';
					
					//document.formback.submit()
				}
			</script>
			<cfoutput>
				<form action="/cfmx/rh/indexHistoricos.cfm" method="get" name="formback">
					<input name="RCNid" type="hidden" value="#Form.RCNid#">
				</form>
			</cfoutput>
			<cfset funcion = "javascript: regresar();">
			<!--- <cf_rhreporte principal="#funcion#"	datos="/rh/nomina/consultas/PConsultaRCalculoHist-form.cfm" paramsuri="?Tcodigo=#url.Tcodigo#&fecha=#url.fecha#&RCNid=#url.RCNid#"> --->
			<!--- <cf_rhreporte principal="#funcion#"	datos="/rh/nomina/consultas/PConsultaRCalculoHist-form.cfm" paramsuri="?Tcodigo=#Form.RCTcodigo#&fecha=#Form.RCdesde#&RCNid=#form.RCNid#"> --->
			<cf_rhreporte principal="#funcion#"	datos="/rh/nomina/consultas/PConsultaRCalculoHist-form.cfm" paramsuri="?fecha=#Form.RCdesde#&RCNid=#form.RCNid#">
			
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->