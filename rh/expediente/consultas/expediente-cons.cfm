<cfquery name="rsDEid" datasource="#session.dsn#">
   select llave from UsuarioReferencia where Usucodigo = #session.usucodigo# and STabla = 'DatosEmpleado'
</cfquery>
<cfif rsDEid.recordcount gt 0 and  len(trim(#rsDEid.llave#))>
 <cfset form.DEid = #rsDEid.llave#>
</cfif>
<cfquery name="rsUsatest" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Pcodigo = 450
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfquery name="rsModificaDE" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Pcodigo = 560
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ModificarMisDatos"
	Default="Modificar Mis Datos"
	returnvariable="LB_ModificarMisDatos"/>

<cfset navBarItems = ArrayNew(1)>
<cfset navBarItems[1] = LB_ModificarMisDatos>

<cfset navBarLinks = ArrayNew(1)>
<cfset navBarLinks[1] = "javascript: editData();">

<cfset navBarStatusText = ArrayNew(1)>
<cfset navBarStatusText[1] = "">

<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<script language="JavaScript" type="text/JavaScript">
	<!--
		function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);

		function editData() {
			location.href = "/cfmx/rh/autogestion/autogestion.cfm";
		}
	//-->
	</script>
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cfset Session.modulo = 'autogestion' >
	<cfinclude template="tabNames.cfm">
	<cfinclude template="consultas-frame-header.cfm">

	<cf_templatearea name="title">
		<cf_translate key="LB_RHAutogestion">RH - Autogesti&oacute;n</cf_translate>
	</cf_templatearea>

	<cf_templatearea name="body">
	    <!--- <cfinclude template="/rh/portlets/pNavegacion.cfm"> --->
		<table width="100%"  border="0">
			<tr>
				<td align="right">
					<cfinclude template="iconOptions.cfm">
				</td>
			</tr>
			<tr>
				<td valign="top">
					<cfif tabChoice eq 1>
						<cfif isdefined("Form.dvacemp")>
							<cfinclude template="expediente-detalleVacaciones.cfm">
						<cfelse>
							<cfinclude template="expediente-all.cfm">
						</cfif>
					<cfelseif tabChoice eq 2>
                    	<cfinclude template="expediente-direccion.cfm">
					<cfelseif tabChoice eq 3>
						<cfinclude template="expediente-general.cfm">
					<cfelseif tabChoice eq 4>
						<cfinclude template="expediente-familiar.cfm">
					<cfelseif tabChoice eq 5>
						<cfinclude template="expediente-laboral.cfm">
					<cfelseif tabChoice eq 6>
						<cfinclude template="expediente-cargas.cfm">
					<cfelseif tabChoice eq 7>
						<cfinclude template="expediente-deducciones.cfm">
					<cfelseif tabChoice eq 8>
						<div align="center"><b>
						<cf_translate key="MSG_EsteModuloNoEstaDisponible">Este m&oacute;dulo no est&aacute; disponible</cf_translate></b></div>
					<cfelseif tabChoice eq 10 and tabAccess[10]>
						<cfinclude template="expediente-frbenzinger.cfm">
					<cfelseif tabChoice eq 11 and tabAccess[11]>
						<cfinclude template="comparativo-benziger.cfm">
					<cfelseif tabChoice eq 12 and tabAccess[12]>
						<cfinclude template="expediente-beneficios.cfm">
					<cfelse>
						<div align="center"><b><cf_translate key="MSG_EsteModuloNoEstaDisponible">Este m&oacute;dulo no est&aacute; disponible</cf_translate></b></div>
					</cfif>
				</td>
			</tr>
		</table>
	</cf_templatearea>
</cf_template>