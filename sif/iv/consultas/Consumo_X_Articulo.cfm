<cfquery name="rsDepartamentos" datasource="#session.DSN#">
	select Dcodigo, Ddescripcion
	from Departamentos
	where Ecodigo= #session.Ecodigo#
	order by Dcodigo
</cfquery>

<cf_templateheader title="	Consumo por Art&iacute;culo">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Consumo por Art&iacute;culo'>
			<cfoutput>
				<form style="margin:0;" action="Consumo_X_Articulo_main.cfm" name="consulta" method="post">
					<table width="90%" border="0" cellpadding="0" cellspacing="1" align="center">
						<tr><td colspan="5">&nbsp;</td></tr>
						<tr>
							<td colspan="1" align="right" nowrap width="100%">Art&iacute;culo Inicial:&nbsp;</td>
							<td>
								<cf_sifarticulos form="consulta" frame="fri" id="AidIni" name="AcodigoIni" desc="AdescripcionIni" tabindex="1">
							</td>
							<td align="right" nowrap>Art&iacute;culo Final:&nbsp;</td>
							<td>
								<cf_sifarticulos form="consulta" frame="frf" id="AidFin" name="AcodigoFin" desc="AdescripcionFin" tabindex="1">
							</td>
						</tr>
						<tr>
							<td colspan="1" width="1%" nowrap align="right">Fecha Desde:&nbsp;</td>
							<td width="1%" nowrap><cf_sifcalendario tabindex="1" name="FechaDes" form="consulta"></td>
							<td width="1%" nowrap align="right">Fecha Hasta:&nbsp;</td>
							<td nowrap><cf_sifcalendario tabindex="1" name="FechaHas" form="consulta"></td>
						</tr>
						<tr>
							<td width="30%" class="fileLabel"><strong>Centro Funcional</strong></td>
							<td>
								<cf_conlis
								campos="CFid2, CFcodigo2, CFdescripcion2"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								valuesArray=""
								tabla="CFuncional"
								columnas="CFid as CFid2, CFcodigo as CFcodigo2, CFdescripcion as CFdescripcion2"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigo2, CFdescripcion2"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFid2, CFcodigo2, CFdescripcion2"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1"
								form="consulta">							
							</td>
						</tr>						
						<tr>
							<td colspan="1" width="1%" align="right" nowrap>Documento:&nbsp;</td>
							<td nowrap colspan="3">
								<input type="text" id="ERdocumento" name="ERdocumento" maxlength="20"  tabindex="1"
								<cfif isdefined("form.ERdocumento") and len(trim(form.ERdocumento)) and form.ERdocumento GT 0>
									value="#form.ERdocumento#"
								</cfif>
								 />
							</td>
						</tr>	
						<tr><td colspan="5">&nbsp;</td></tr>
						<tr><td colspan="5" align="center"><input type="submit" name="Consultar" value="Consultar" tabindex="1"></td></tr>
						<tr><td colspan="5">&nbsp;</td></tr>
					</table>
				</form>
			</cfoutput>
		<cf_web_portlet_end>	
	<cf_templatefooter>
<cf_qforms form="consulta">
<script language="javascript" type="text/javascript">
	document.consulta.AcodigoIni.focus();
	objForm.AidIni.required = 'true';
	objForm.AidIni.description = 'Artículo Inicial';
	objForm.AidFin.required = 'true';
	objForm.AidFin.description = 'Artículo Final';
</script>