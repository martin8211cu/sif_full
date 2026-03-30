<!--- Ventas por Direccion --->
<table border="1" cellpadding="0" cellspacing="2" width="400">
	<tr>
		<td colspan="3" align="center"><strong>Detalle de Ventas</strong></td>
	</tr>
	<tr>
		<td align="left" width="25%"><strong>C&oacute;digo</strong></td>
		<td align="left" width="60%"><strong>Nombre</strong></td>
		<td align="right" width="20%"><strong>Monto</strong></td>
	</tr>
	<cfoutput query="rsVentasDireccion">
		<tr>
			<td align="left"> <a href="analisisSocioHM.cfm?SNcodigo=#url.SNcodigo#&id_direccionFact=#id_direccionFact#"> #SNDcodigo#</td>
			<td align="left">#Nombre#</td>
			<td align="right">#lsNumberFormat(total,',9.00')#</td>
		</tr>
	</cfoutput>
</table>
