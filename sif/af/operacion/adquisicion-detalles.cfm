<cfif not (isdefined("form.EAcpidtrans")
 and isdefined("form.EAcpdoc"))>
	<cflocation	addtoken="no" url="Adquisicion.cfm">
</cfif>
<cfquery name="rsDetalleDocCxP" datasource="#Session.DSN#">
	select a.*, b.*, c.SNnombre, d.CPTdescripcion, e.Mnombre
	from EDocumentosCP a, DDocumentosCP b, SNegocios c, CPTransacciones d, Monedas e
	where a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		and a.CPTcodigo = <cfqueryparam value="#form.EAcpidtrans#" cfsqltype="cf_sql_char">
		and a.Ddocumento = <cfqueryparam value="#form.EAcpdoc#" cfsqltype="cf_sql_char">
		and a.Ecodigo = b.Ecodigo 
		and a.Ddocumento = b.Ddocumento 
		and a.CPTcodigo = b.CPTcodigo
		and a.SNcodigo = c.SNcodigo
		and a.Ecodigo = c.Ecodigo
		and a.Ecodigo = d.Ecodigo
		and a.CPTcodigo = d.CPTcodigo
		and a.Mcodigo = e.Mcodigo
</cfquery>

<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<cf_templateheader title="Activos Fijos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Detalle del Documento de Cuentas por Pagar'>
					<cfif rsDetalleDocCxP.RecordCount lte 0>
						<table width="100%" border="0" cellpadding="2" cellspacig="0">
							<tr>
								<td align="center"><strong>No existen detalles para este documento!</strong></td>
							</tr>
							<tr>
							<td align="center">
								<cf_botones exclude="Alta,Limpiar" regresar="../operacion/adquisicion-lista#LvarPar#.cfm" tabindex="1">
							</td>
							</tr>
						</table>
					<cfelse>
						<cfquery name="rsSums" dbtype="query" >
							select sum(DDtotallin) as SubTotal from rsDetalleDocCxP
						</cfquery>	
						<cfoutput>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									 <td width="3%">&nbsp;</td>
									 <td width="6%"><div align="right"><strong>Documento:</strong></div></td>
									 <td width="36%">#rsDetalleDocCxP.Ddocumento#</td>
									 <td width="27%"><div align="right"><strong>Transacci&oacute;n:</strong></div></td>
									 <td width="28%">#rsDetalleDocCxP.CPTdescripcion#</td>
								 </tr>
								 <tr> 
									 <td width="3%">&nbsp;</td>
									 <td><div align="right"><strong>Proveedor:</strong></div></td>
									 <td>#rsDetalleDocCxP.SNnombre#</td>
									 <td><div align="right"><strong>Fecha:</strong></div></td>
									 <td>#LSDateFormat(rsDetalleDocCxP.Dfecha,"dd-mm-yyyy")#</td>
								 </tr>
								 <tr> 
									 <td>&nbsp;</td>
									 <td><div align="right"><strong>Moneda:</strong></div></td>
									 <td>#rsDetalleDocCxP.Mnombre#</td>
									 <td>&nbsp;</td>
									 <td>&nbsp;</td>
								 </tr>
								<tr> 
									 <td colspan="2">&nbsp;</td>
									 <td>&nbsp;</td>
									 <td>&nbsp;</td>
									 <td>&nbsp;</td>
								</tr>
							<tr>
							<td colspan="5">
								<table width="100%" border="0" cellpadding="2" cellspacing="0">
									<tr> 
										<td width="10%" class="listaPar"><div align="center"><strong>Cantidad</strong></div></td>
										<td width="10%" class="listaPar" nowrap><div align="center"><strong>C&oacute;digo Item</strong></div></td>
										<td width="40%" class="listaPar"><div align="left"><strong>Descripci&oacute;n</strong></div></td>
										<td width="15%" class="listaPar"><div align="right"><strong>Precio Unitario</strong></div></td>
										<td width="15%" class="listaPar"><div align="right"><strong>Total L&iacute;nea</strong></div></td>
									</tr>
									<cfloop query="rsDetalleDocCxP"> 
										<tr> 
											<cfif rsDetalleDocCxP.DDlinea NEQ form.EAcplinea>
											<td><div align="center">#rsDetalleDocCxP.DDcantidad#</div></td>
											<td><div align="center">#rsDetalleDocCxP.DDcoditem#</div></td>
											<td>#rsDetalleDocCxP.DDescripcion#</td>
											<td><div align="right">#LSNumberFormat(rsDetalleDocCxP.DDpreciou,"___,__9.99")#</div></td>
											<td><div align="right">#LSNumberFormat(rsDetalleDocCxP.DDtotallin,"___,__9.99")#</div></td>
											<cfelse>
											<td><div align="center"><font color="##FF0000"><strong>#rsDetalleDocCxP.DDcantidad#</strong></font></div></td>
											<td><div align="center"><font color="##FF0000"><strong>#rsDetalleDocCxP.DDcoditem#</strong></font></div></td>
											<td><font color="##FF0000"><strong>#rsDetalleDocCxP.DDescripcion#</strong></font></td>
											<td><div align="right"><font color="##FF0000"><strong>#LSNumberFormat(rsDetalleDocCxP.DDpreciou,"___,__9.99")#</strong></font></div></td>
											<td><div align="right"><font color="##FF0000"><strong>#LSNumberFormat(rsDetalleDocCxP.DDtotallin,"___,__9.99")#</strong></font></div></td>
											</cfif>
										</tr>
									</cfloop>
								</table>
							</td>
							</tr>
							<tr>
							<td colspan="5">
							<table width="25%" border="0" align="right" cellpadding="2" cellspacing="0">
								<tr> 
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								<tr> 
									<td width="42%"><strong>Subtotal:</strong></td>
									<td width="58%"><div align="right">#LSNumberFormat(rsSums.SubTotal,"___,__9.99")#</div></td>
								</tr>
								<tr> 
									<td><strong>Impuesto:</strong></td>
									<td><div align="right">#LSNumberFormat(rsDetalleDocCxP.Dtotal - rsSums.SubTotal,"___,__9.99")#</div></td>
								</tr>
								<tr> 
									<td><strong>Total:</strong></td>
									<td><div align="right">#LSNumberFormat(rsDetalleDocCxP.Dtotal,"___,__9.99")#</div></td>
								</tr>
							</table>
							</td>
							</tr>
							<tr>
							<td colspan="5">
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr> 
									<td align="center">
										<cf_botones exclude="Alta,Limpiar" regresar="../operacion/adquisicion-lista#LvarPar#.cfm" tabindex="1">
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
							</td>
							</tr>
							</table>
						</cfoutput>
					</cfif>
				<cf_web_portlet_end>
	<cf_templatefooter>