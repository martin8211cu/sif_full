<!--- Creado  por Gustavo Fonseca H.
		Fecha: 13-5-2005.
		Motivo: Nuevo reporte de Antigüedad de Saldos por Clasificación para CxP
--->
<cf_templateheader title="SIF - Cuentas por Pagar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_DatosRep	= t.Translate('LB_DatosRep','Datos del Reporte','FiscalProveedores.xml')>
<cfset LB_ClasifSocios = t.Translate('LB_ClasifSocios','Clasificaci&oacute;n de Socios')>
<cfset LB_ClasifDirSocios = t.Translate('LB_ClasifDirSocios','Clasificaci&oacute;n de Direcci&oacute;n de Socio')>
<cfset LB_Resumido = t.Translate('LB_Resumido','Resumido')>
<cfset LB_Detallado = t.Translate('LB_Detallado','Detallado por Documento')>
<cfset LB_Consulta = t.Translate('LB_Consulta','Consulta')>
<cfset LB_Clasificacion = t.Translate('LB_Clasificacion','Clasificaci&oacute;n')>
<cfset LB_ClasificacionSA = t.Translate('LB_ClasificacionSA','Clasificación')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_SocioNegocioI = t.Translate('LB_SocioNegocioI','Socio de Negocios Inicial')>
<cfset LB_SocioNegocioF = t.Translate('LB_SocioNegocioF','Socio de Negocios Final')>
<cfset LB_OficinaInicial = t.Translate('LB_OficinaInicial','Oficina Inicial')>
<cfset LB_OficinaFinal = t.Translate('LB_OficinaFinal','Oficina Final')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_Titulo = t.Translate('LB_Titulo','Antig&uuml;edad&nbsp;Saldos&nbsp;por&nbsp;Clasificaci&oacute;n')>

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
<form name="form1" method="get" action="AntiguedadSaldosClasificacionResCP.cfm">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>#LB_DatosRep#</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">#LB_ClasifSocios#</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">#LB_ClasifDirSocios#</label>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap width="10%"><strong>#LB_Consulta#:&nbsp;</strong>
						<input type="radio" tabindex="1" name="tipoResumen" value="1" checked id="TipoResumen1"
							onClick="this.form.action = 'AntiguedadSaldosClasificacionResCP.cfm';">
							<label for="TipoResumen1"  style="font-style:normal; font-variant:normal;">#LB_Resumido#</label>
						&nbsp;&nbsp;&nbsp;
						<input type="radio" tabindex="1" name="tipoResumen" value="2" id="TipoResumen2"
							onClick="this.form.action = 'AntiguedadSaldosClasificacionDetCP.cfm';">
							<label for="TipoResumen2"  style="font-style:normal; font-variant:normal;">#LB_Detallado#</label>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Clasificacion#</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<!--- <tr>
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
					<td nowrap align="left" width="10%"><strong>#LB_SocioNegocioI#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_SocioNegocioF#:&nbsp;</strong></td>
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
					<td nowrap align="left" width="10%"><strong>#LB_OficinaInicial#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_OficinaFinal#:&nbsp;</strong></td>
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
					<td nowrap align="left" width="10%"><strong>#LB_Moneda#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_Formato#&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
                    <td align="left"><cf_sifmonedas Todas="S" value="-1" Conlis="S" CrearMoneda="false"></td>
					<td align="left">
					<select name="Formato" id="Formato" tabindex="1">
						<option value="2">PDF</option>
                        <option value="3">EXCEL</option>
					</select>
					</td>
					<td colspan="3">&nbsp;</td>
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
</cfoutput>
</form>
<cfoutput>
<cf_web_portlet_end>
<cf_qforms>
		<cf_qformsRequiredField name="SNCDvalor1" description="#LB_ClasifDesde#">
		<cf_qformsRequiredField name="SNCDvalor2" description="#LB_ClasifHasta#">
        <cf_qformsRequiredField name="SNCEcodigo" description="#LB_ClasificacionSA#">
</cf_qforms>
<cf_templatefooter>
</cfoutput>