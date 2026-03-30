	<cfset request.autogestion=1>

<!--- ver quien soy, y si soy jefe de algun centro funcional --->

	<cfset soy_jefe = false>

	<cfinvoke component="home.Componentes.Seguridad" returnvariable="datosemp"
		method="getUsuarioByCod" tabla="DatosEmpleado" 
		usucodigo="#session.Usucodigo#" ecodigo="#session.EcodigoSDC#"
		/>
	<cfif datosemp.RecordCount and Len(datosemp.llave)>
		<cfquery datasource="#session.dsn#" name="ver_si_es_jefe">
			select lt.DEid, p.CFid, cf.CFid as CFid_subordinado
			from LineaTiempo lt
				join RHPlazas p
					on p.RHPid = lt.RHPid
					and p.Ecodigo = lt.Ecodigo
				left join CFuncional cf
					on cf.RHPid = p.RHPid
					and cf.Ecodigo = p.Ecodigo
			where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta
			  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosemp.llave#">
		</cfquery>
		<cfif Len(ver_si_es_jefe.CFid_subordinado)>
			<cfset soy_jefe = true>
		</cfif>
	</cfif>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    key="LB_RecursosHumanos"
    default="Recursos Humanos"
    xmlfile="/rh/generales.xml"
    returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

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

<cf_web_portlet_start border="true" titulo="Matrícula Administrativa" skin="#Session.Preferences.Skin#">
<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0><cfset form.sel = url.sel></cfif>
		<cfif isdefined("url.RHRCid") and len(trim(url.RHRCid)) gt 0><cfset form.RHRCid = url.RHRCid></cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0><cfset form.DEid = url.DEid></cfif>
		<cfif isdefined("url.modo") and len(trim(url.modo)) gt 0><cfset form.modo = url.modo></cfif>
		<cfif isdefined("url.Nuevo") and len(trim(url.Nuevo)) gt 0><cfset form.Nuevo = url.Nuevo></cfif>
		<cfparam name="form.sel" default="1" type="numeric">
		<cfif (form.sel gt 0) and (isdefined("form.Nuevo") or (isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0))>
			<cfset Regresar  = "/cfmx/rh/evaluaciondes/operacion/index.cfm">
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
					<cfset Lvar_Solicitud = true>
					<cfinclude template="../matricula/index_header.cfm">
					<cfswitch expression="#sel#">
						<cfcase value="1"><cfinclude template="../matricula/index_form.cfm"></cfcase>
						<cfcase value="2"><cfinclude template="../matricula/registro_criterios_empleados.cfm"></cfcase>
						<cfcase value="3"><cfinclude template="../matricula/registro_criterios_empleados_lista.cfm"></cfcase>
					</cfswitch>
				</td>
				<td>&nbsp;</td>
				<td valign="top" align="center">
					<cfif soy_jefe>
					<cfinclude template="index_pasos.cfm">
					</cfif>
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
			<cfset Regresar  = "/cfmx/rh/capacitacion/operacion/matricula/index.cfm">
			<cfinclude template="../matricula/index_filtro.cfm"><br>
			<cfset filtro = " and a.Usucodigosol = #session.Usucodigo# and a.RHRCestado in (0,10) " & filtro>
			<cfif Len(datosemp.llave)>
				<cfset filtro = " and a.DEidsol = #NumberFormat(datosemp.llave,'0')# " & filtro>
			</cfif>
			<cfinclude template="../matricula/index_lista.cfm">
		</cfif>
<cf_web_portlet_end>
<cf_templatefooter>