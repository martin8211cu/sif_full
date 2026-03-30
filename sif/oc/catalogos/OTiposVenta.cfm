<cf_templateheader title="Tipos de Venta">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Venta'>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr><td colspan="3">&nbsp;</td></tr>
				<tr> 
					<td width="40%" valign="top" nowrap>
						<fieldset>
						<legend>Lista de Tipos de Venta&nbsp;</legend>
							<table width="90%"  border="0" cellspacing="2" cellpadding="0">
								<tr> 
									<td valign="top" nowrap>
										<cfinvoke 
											component="sif.Componentes.pListas"
											method="pListaRH"
											returnvariable="pListaRet"
												tabla="OCtipoVenta"
												columnas="OCVid,OCVcodigo,OCVdescripcion"
												desplegar="OCVcodigo,OCVdescripcion"
												etiquetas="Código,Descripci&oacute;n"
												formatos="S,S"
												filtro="Ecodigo = #Session.Ecodigo# order by OCVcodigo"
												align="left, left"
												ajustar="N,N"
												checkboxes="N"
												MaxRows="15"
												filtrar_automatico="true"
												mostrar_filtro="true"												
												keys="OCVid"
												irA="OTiposVenta.cfm"
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
						<legend>Mantenimiento de Tipos de venta&nbsp;</legend>
							<table width="90%"  border="0" cellspacing="2" cellpadding="0">
								<tr> 
									<td valign="top" nowrap>
										<cf_navegacion name="OCVid" default="" navegacion="">
										<cfinclude template="formOTiposVenta.cfm">
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

