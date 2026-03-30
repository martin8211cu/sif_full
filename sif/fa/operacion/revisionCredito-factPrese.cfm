<cfquery name="rsFacturaPresente" datasource="#session.DSN#">
	select 	a.prima,
			a.total_productos,
			b.cantidad, 
			b.precio_contado, 
			b.precio_unitario,
			b.descuento_porcentaje, 
			b.precio_linea,
			b.prima_minima, 
			c.Adescripcion,
			d.FVnombre
	from VentaE a
		inner join VentaD b
			on a.Ecodigo = b.Ecodigo
			and a.VentaID = b.VentaID
		inner join Articulos c
			on b.Ecodigo = c.Ecodigo
			and b.Aid = c.Aid
		inner join FVendedores d
			on a.Ecodigo = d.Ecodigo
			and a.FVid = d.FVid
	where a.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
</cfquery>

<cfquery name="rsMonedas" datasource="#session.DSN#">
	select 	b.Mnombre
	from VentaE a
		inner join Monedas b
			on a.Ecodigo = b.Ecodigo
			and a.moneda = b.Miso4217
	where a.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
</cfquery>


<cfoutput>
<table width="90%" align="center" cellpadding="1" cellspacing="0" border="0">
	<tr><td nowrap colspan="8">&nbsp;</td></tr>
	<tr class="titulolistas">
		<td nowrap align="right"><strong>Vendedor:</strong>&nbsp;</td>
		<td nowrap>#rsFacturaPresente.FVnombre#</td>
		<td nowrap align="right"><strong>Moneda:</strong>&nbsp;</td>
		<td nowrap>#rsMonedas.Mnombre#</td>
		<td nowrap align="right"><strong>Prima</strong>&nbsp;</td>
		<td nowrap>#LSCurrencyFormat(rsFacturaPresente.prima,'none')#</td>
		<td nowrap align="right"><strong>Precio Contado:</strong>&nbsp;</td>
		<td nowrap>#LSCurrencyFormat(rsFacturaPresente.precio_contado,'none')#</td>
	</tr>
	<tr><td nowrap colspan="8"><hr></td></tr>
	<tr>
		<td nowrap colspan="8">
			<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
				<tr class="titulolistas">
					<td nowrap><strong>Cantidad</strong>&nbsp;</td>
					<td nowrap><strong>Art&iacute;culo</strong>&nbsp;</td>
					<td nowrap align="right"><strong>Precio Unitario</strong>&nbsp;</td>
					<td nowrap align="right"><strong>Prima M&iacute;nima</strong>&nbsp;</td>
					<td nowrap align="right"><strong>Descuento</strong>&nbsp;</td>
					<td nowrap align="right"><strong>Total de L&iacute;nea</strong>&nbsp;</td>
				</tr>
				<cfif rsFacturaPresente.RecordCount GT 0>
					<cfloop query="rsFacturaPresente">
						<tr class="<cfif rsFacturaPresente.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
							<td nowrap>&nbsp;&nbsp;#LSCurrencyFormat(rsFacturaPresente.cantidad,'none')#</td>
							<td nowrap>&nbsp;&nbsp;#rsFacturaPresente.Adescripcion#</td>
							<td nowrap align="right">#LsCurrencyFormat(rsFacturaPresente.precio_unitario,'none')#&nbsp;</td>
							<td nowrap align="right">#LsCurrencyFormat(rsFacturaPresente.prima_minima,'none')#&nbsp;</td>
							<td nowrap align="right">#LsCurrencyFormat(rsFacturaPresente.descuento_porcentaje,'none')#&nbsp;</td>
							<td nowrap align="right">#LsCurrencyFormat(rsFacturaPresente.precio_linea,'none')#&nbsp;</td>
						</tr>
					</cfloop>
					<tr><td nowrap colspan="6">&nbsp;</td></tr>
					<tr class="titulolistas">
						<td nowrap colspan="5" align="right"><strong><font size="3">Total de Productos:</font></strong>&nbsp;</td>
						<td nowrap align="right"><strong><font size="3" color="##0000CC">#LScurrencyFormat(rsFacturaPresente.total_productos,'none')#</font></strong></td>
					</tr>
					<tr><td nowrap colspan="6">&nbsp;</td></tr>
				<cfelse>
					<tr><td nowrap colspan="6" align="center"><strong>--- La Factura presente no tienes l&iacute;neas de detalle. ---</strong></td></tr>
					<tr><td nowrap colspan="6">&nbsp;</td></tr>
					<tr class="titulolistas">
						<td nowrap colspan="5" align="right"><strong><font size="2">Total de Productos:</font></strong>&nbsp;</td>
						<td nowrap align="right"><strong><font size="2" color="##0000CC">#LScurrencyFormat(rsFacturaPresente.total_productos,'none')#</font></strong></td>
					</tr>
					<tr><td nowrap colspan="6">&nbsp;</td></tr>
				</cfif>
			</table>
		</td>
	</tr>

</table>
</cfoutput>