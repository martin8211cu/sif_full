<cfquery name="rsCanceladas" datasource="#session.DSN#">
	select a.Ddocumento,
		   a.fecha,
		   coalesce(sum(precio_linea),0) as Monto
	from VentaE a
		   left outer join VentaD b
		      on a.VentaID = b.VentaID
	where a.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
		and estado = 100
	group by a.Ddocumento, a.fecha
</cfquery>

<cfquery name="rsMtoFacturasCanceladas" dbtype="query">
	select sum(rsCanceladas.Monto) as MtoFacturas
	from rsCanceladas
</cfquery>

<cfoutput>
	<table width="90%" align="center"  border="0" cellspacing="0" cellpadding="1">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<fieldset><legend><strong>Facturas Canceladas</strong></legend>
					<table width="90%" align="center"  border="0" cellspacing="0" cellpadding="1">
						<tr class="titulolistas">
							<td valign="top" nowrap><strong>&nbsp;N°. Factura</strong></td>
							<td valign="top" nowrap><strong>&nbsp;Fecha</strong></td>
							<td valign="top" nowrap align="right"><strong>&nbsp;Monto Factura</strong></td>
						</tr>
						
						<cfif rsCanceladas.RecordCount GT 0>
							<cfloop query="rsCanceladas">
								<tr class="<cfif rsCanceladas.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
									<td width="5%" nowrap>&nbsp;#rsCanceladas.Ddocumento#</td> 
									<td width="10%" nowrap>&nbsp;#LSDateFormat(rsCanceladas.fecha,'dd/mm/yyy')#</td>
									<td align="right" width="30%" nowrap>&nbsp;#LSCurrencyFormat(rsCanceladas.Monto,'none')#</td>
								</tr>
							</cfloop>
								
							<tr><td>&nbsp;</td></tr>
							<tr class="titulolistas">
								<td align="right" colspan="2"><strong>Monto Total:&nbsp;</strong></td>
								<td align="right"><strong>#LSCurrencyFormat(rsMtoFacturasCanceladas.MtoFacturas,'none')#</strong></td>
							</tr>
						<cfelse>
							<tr><td align="center" colspan="3"><strong>--- El Cliente no tiene Facturas Canceladas. ---</strong></td></tr>
							<tr><td>&nbsp;</td></tr>
						</cfif>

					</table> 
				</fieldset>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfoutput>



