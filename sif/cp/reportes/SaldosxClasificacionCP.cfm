<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_SalXClas 	= t.Translate('TIT_SalXClas','Saldos&nbsp;por&nbsp;Clasificaci&oacute;n')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_ClasSoc 		= t.Translate('LB_ClasSoc','Clasificaci&oacute;n de Socios')>
<cfset LB_ClasDirSoc 	= t.Translate('LB_ClasDirSoc','Clasificaci&oacute;n de Direcci&oacute;n de Socio')>
<cfset LB_Consulta 		= t.Translate('LB_Consulta','Consulta')>
<cfset LB_Resumido 		= t.Translate('LB_Consulta','Resumido')>
<cfset LB_Detallado 	= t.Translate('LB_Detallado','Detallado por Documento')>
<cfset LB_Clasif 		= t.Translate('LB_Clasif','Clasificación')>
<cfset LB_ClasifSA 		= t.Translate('LB_Clasif','Clasificación')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_SNIni			= t.Translate('LB_SNIni','Socio de Negocios Inicial')>
<cfset LB_SNFin			= t.Translate('LB_SNFin','Socio de Negocios Final')>
<cfset LB_OficIni		= t.Translate('LB_OficIni','Oficina Inicial')>
<cfset LB_OficFin		= t.Translate('LB_OficFin','Oficina Final')>
<cfset LB_Formato 		= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_OrdenPor		= t.Translate('LB_OrdenPor','Ordenar por')>
<cfset LB_Documento		= t.Translate('LB_Documento','Documento')>
<cfset LB_FECHA 		= t.Translate('LB_FECHA','Fecha','/sif/generales.xml')>

<cfoutput>
<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_SalXClas#'>

<form name="form1" method="get" action="SaldosxClasificacionResCP.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>#LB_DatosReporte#</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">#LB_ClasSoc#</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">#LB_ClasDirSoc#</label>
					</td>
				</tr>
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap width="10%"><strong>#LB_Consulta#:&nbsp;</strong>
						<input type="radio" name="tipoResumen" value="1" checked id="tipoResumen1"
							onClick="this.form.action = 'SaldosxClasificacionResCP.cfm';" tabindex="1">
						<label for="tipoResumen1" style="font-style:normal; font-variant:normal;">#LB_Resumido#&nbsp;</label>
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="tipoResumen" value="2"  id="tipoResumen2"
							onClick="this.form.action = 'SaldosxClasificacionDetCP.cfm';" tabindex="1">
							<label for="tipoResumen2" style="font-style:normal; font-variant:normal;">#LB_Detallado#</label>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Clasif#&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
<!--- 				<tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>#LB_ClasifDesde#:&nbsp;</strong></td>
					<td width="10%"><strong>#LB_ClasifHasta#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>

					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr> --->
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_SNIni#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_SNFin#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 Proveedores="SI" tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 Proveedores="SI" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_OficIni#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_OficFin#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifoficinas tabindex="1"></td>
					 <td align="left"><cf_sifoficinas Ocodigo="Ocodigo2" Oficodigo="Oficodigo2" Odescripcion="Odescripcion2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>#LB_Formato#&nbsp;</strong>
						<select name="Formato" id="Formato" tabindex="1">
							<option value="2">PDF</option>
						</select>
					</td>
					<!---================================----->
					<!---<td colspan="3">&nbsp;</td>--->
					<td align="left" width="10%" colspan="3"><strong>#LB_OrdenPor#:&nbsp;</strong>
						<select name="ordenarpor" tabindex="1">
							<option value="D">#LB_Documento#</option>
							<option value="F">#LB_FECHA#</option>
						</select>
					</td>
					<!---================================----->
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
						<cf_botones values="Generar" names="Generar" tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
</form>
<cf_web_portlet_end>
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNCEcodigo.required = true;
	objForm.SNCEcodigo.description="#LB_Clasif#";

	document.form1.SNCEcodigo.focus();
//-->
</script>
<cf_templatefooter>
</cfoutput>