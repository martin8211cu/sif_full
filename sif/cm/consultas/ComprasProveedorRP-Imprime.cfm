<cf_templateheader title="Compras - Compras por Proveedor (Montos)">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Compras por Proveedor (Montos)'>
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td nowrap>
						<cf_rhimprime datos="/sif/cm/consultas/ComprasProveedorRP-Reporte.cfm" paramsuri="">
					</td>
				</tr> 
				<tr>
					<td nowrap>
						<cfinclude template="ComprasProveedorRP-Reporte.cfm"> 
					</td>
				</tr>
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td align="center" nowrap>
						<input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='ComprasProveedorRP.cfm'" >
					</td>
				</tr>
				<tr><td nowrap>&nbsp;</td></tr>
			</table> 
		<cf_web_portlet_end>
	<cf_templatefooter>
