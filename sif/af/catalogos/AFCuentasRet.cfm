<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Motivos de Retiro de Activos'>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr> 
					<td width="40%" valign="top" nowrap>
						<fieldset>
						<legend>Lista de Motivos de Retiros&nbsp;</legend>
							<table width="90%"  border="0" cellspacing="2" cellpadding="0">
								<tr> 
									<td valign="top" nowrap>
										<cfinvoke 
											component="sif.Componentes.pListas"
											method="pListaRH"
											returnvariable="pListaRet"
												tabla="AFRetiroCuentas"
												columnas="AFRmotivo, AFRdescripcion, AFResventa"
												desplegar="AFRmotivo, AFRdescripcion, AFResventa"
												etiquetas="Motivo, Descripci&oacute;n, Es Venta"
												formatos="S,S,U"
												filtro="Ecodigo = #Session.Ecodigo# order by AFRmotivo"
												align="left, left, center"
												ajustar="N,N,N"
												checkboxes="N"
												MaxRows="15"
												filtrar_automatico="true"
												mostrar_filtro="true"												
												keys="AFRmotivo"
												irA="AFCuentasRet.cfm"
												showEmptyListMsg="true">
										</cfinvoke>
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
					<td width="5%" valign="top" nowrap>&nbsp;</td>
					<td width="55%" valign="top" nowrap>
						<fieldset>
						<legend>Mantenimiento de Motivos de Retiros&nbsp;</legend>
							<table width="90%"  border="0" cellspacing="2" cellpadding="0">
								<tr> 
									<td valign="top" nowrap>
										<cfinclude template="formAFCuentasRet.cfm">
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr><td colspan="3">&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>