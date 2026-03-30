<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TituloPreparacionDeLiquidaciones" default = "Preparaci&oacute;n de Liquidaciones de Empleados" returnvariable="LB_TituloPreparacionDeLiquidaciones" xmlfile = "LiquidacionAnticipos_ini.xml">

<cf_templateheader title="#LB_TituloPreparacionDeLiquidaciones#">
	<cf_navegacion name="GELid" navegacion="">
	<cf_web_portlet_start border="true" titulo="#LB_TituloPreparacionDeLiquidaciones#" skin="#Session.Preferences.Skin#">
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
			<tr>
				<td valign="top">
					<cf_navegacion name="Anti">
					<cfinclude template="TESid_Ecodigo.cfm">
					<cfif isdefined ('url.band')>
						<cflocation url="#LvarSAporEmpleadoCFM#">
					</cfif>
					<cfif find("E",LvarSAporEmpleadoSQL) AND isdefined ('url.Aprobar') and isdefined ('URL.FormaPago')>
						<cfif URL.FormaPago EQ 0>
							<cfinclude template="LiquidacionAnticiposTesoreria.cfm">
						<cfelse>
							<cfinclude template="LiquidacionesAnticiposCajaChica.cfm">
						</cfif>
					<cfelseif isdefined ('url.Anti')>
						<cfinclude template="ListaAnticipos.cfm">
					<cfelseif isdefined('form.viaticos') and form.viaticos eq 1 and isdefined('form.GELid') and len(trim(form.GELid)) and isdefined('form.GEAid') and len(trim(form.GEAid))>
						<cflocation url="LiquidacionAnticiposViaticos_form.cfm?GEAid=#form.GEAid#&GELid=#form.GELid#">
					<cfelseif (isdefined('form.GELid') and len(trim(form.GELid))) OR (isdefined('form.Nuevo')) or isdefined(('url.GELid'))OR (isdefined('url.Nuevo') or isdefined ('url.GEAid'))>
						<cfinclude template="LiquidacionAnticipos_form.cfm"> <!--- aqui--->
					<cfelse>
						<cfinclude template="LiquidacionAnticipos_Listas.cfm">
					</cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>


