<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte_de_procesamiento_de_marcas"
	Default="Reporte de procesamiento de marcas"
	returnvariable="LB_Reporte_de_procesamiento_de_marcas"/>
<cfinclude template="RevMarcas-ProcesarTranslate.cfm">
<cf_htmlReportsHeaders 
	irA="RevMarcas-ProcesarReporte-PopUpQuery.cfm"
	FileName="Reporte_de_procesamiento_de_marcas.xls"
	title="#LB_Reporte_de_procesamiento_de_marcas#"
	back=false
	close=true>
<!--- <cf_templatecss> --->
<cfinclude template="RevMarcas-ProcesarReporte-PopUpQuery.cfm">
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
	<cfoutput>
	<tr><td colspan="12">
	<cf_EncReporte
		Titulo        ="#LB_Reporte_de_procesamiento_de_marcas#" 
		MostrarPagina ="false">
	</td></tr>
	<tr>
		<td nowrap align="left" class="tituloListas"><strong>#LB_Empleado#</strong>&nbsp;</td>
		<td nowrap align="center" class="tituloListas"><strong>#LB_FDesde#</strong>&nbsp;</td>
		<td nowrap align="center" class="tituloListas"><strong>#LB_FHasta#</strong>&nbsp;</td>
		<td nowrap align="left" class="tituloListas"><strong>#LB_Jornada#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_HT#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_HO#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_HL#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_HR#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_HN#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_HEA#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_HEB#</strong>&nbsp;</td>
		<td nowrap align="right" class="tituloListas"><strong>#LB_MFeriado#</strong>&nbsp;</td>
	</tr>
	</cfoutput>
	<cfoutput query="rsLista">
		<tr class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap align="left">#rsLista.Empleado#</td>
			<td nowrap align="center">#LSDateFormat(rsLista.CAMfdesde,'dd/mm/yyyy')#</td>
			<td nowrap align="center">#LSDateFormat(rsLista.CAMfhasta,'dd/mm/yyyy')#</td>
			<td nowrap align="left">#rsLista.Jornada#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsLista.HT,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsLista.HO,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsLista.HL,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsLista.HR,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsLista.HN,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsLista.HEA,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsLista.HEB,'none')#</td>
			<td nowrap align="right">#LSCurrencyFormat(rsLista.MFeriado,'none')#</td>
		</tr>
	</cfoutput>
	<cfif rsLista.recordcount gt 0>
		<tr><td colspan="12" align="center"><strong><cf_translate key="LB_Fin_del_reporte">--Fin del reporte--</cf_translate></strong></td></tr>
	<cfelse>
		<tr><td colspan="12" align="center"><strong><cf_translate key="LB_No_se_encontraron_registros">--No se encontraron registros--</cf_translate></strong></td></tr>
	</cfif>
</table>