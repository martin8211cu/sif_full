<title>informaci&oacute;n de los documentos</title>
<cf_templatecss>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='informaci&oacute;n de los documentos'>
	<cfif isdefined("Url.ID") and len(Url.ID)>
		<cfquery name="rsQuery" datasource="sifinterfaces">
			select ID,
					case TipoCobroPago when 'C' then 'Cuentas Por Cobrar' when 'P' then 'Cuentas Por Pagar' end as TipoCobroPagoL,
					TipoCobroPago,
					'RE' as CodigoTransacion,
					NumeroDocumento,
					CodigoMonedaPago,
					FechaTransaccion,
					MontoPago,
					CodigoBanco,
					CuentaBancaria,
					NumeroSocio,
					TransaccionOrigen,
					case StatusProceso when 11 then 'Esta documento ya fue procesado anteriormente y presento errores. Asegurarse que fueron corregidos antes de aplicar nuevamente' else '' end as Estado
				from IE11 			
			where EcodigoSDC  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#">
			<cfif Url.ID neq -1>
				and ID =#Url.ID#
			 <cfelse>
				and StatusProceso in (1,11) 
			</cfif>
			order by TipoCobroPago			
		</cfquery>
		<cfoutput>
			<cfset llave = "">
			<cfset corte = "">
			<cfloop query="rsQuery">
				<table width="100%" border="0">
					<cfset llave = rsQuery.ID>
					<cfif corte neq rsQuery.TipoCobroPago>
						<tr bgcolor="##CCCCCC">
							<td colspan="4" align="center"><strong>#trim(rsQuery.TipoCobroPagoL)#</strong></td>
						</tr>					
						<cfset corte = rsQuery.TipoCobroPago>
					</cfif>
					<tr>
						<td >&nbsp;</td>
					</tr>
					<tr>
						<td><strong>Transacci&oacute;n</strong></td>
						<td>#rsQuery.CodigoTransacion#</td>
						<td><strong>Documento</strong></td>
						<td>#rsQuery.NumeroDocumento#</td>
					</tr>
					<tr>
						<td><strong>Moneda de Pago</strong></td>
						<td>#rsQuery.CodigoMonedaPago#</td>
						<td><strong>Monto</strong></td>
						<td>#LSNumberFormat(rsQuery.MontoPago,',9')#</td>
					</tr>
					<tr>
						<td><strong>Fecha Documento</strong></td>
						<td>#LSDateformat(rsQuery.FechaTransaccion,'dd/mm/yyyy')#</td>
						<td><strong>No. Socio</strong></td>
						<td>#rsQuery.NumeroSocio#</td>
					</tr>
					<tr>
						<td><strong>Banco</strong></td>
						<td>#rsQuery.CodigoBanco#</td>
						<td><strong>Cuenta Bancaria</strong></td>
						<td>#rsQuery.CuentaBancaria#</td>
					</tr					
					
					 <tr>
						<td colspan="4"  style="color:##FF0000"><b>#trim(rsQuery.Estado)#</b></td>
					</tr>
					
															
					<tr>
						<td colspan="4"><hr></td>
					</tr>
					<cfquery name="rsdetalle" datasource="sifinterfaces">
						select   
							CodigoTransaccion,
							Documento,
							MontoPago,
							MontoPagoDocumento,
							CodigoMonedaDoc
						from ID11
						where ID = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">	
					</cfquery>
					<cfif rsdetalle.recordCount EQ 0>
						<cfquery name="rsdetalle" datasource="sifinterfaces">
							select   
								CodigoTransaccion,
								Documento,
								MontoPago,
								MontoPagoDocumento,
								CodigoMonedaDoc
							from IE11
							where ID = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">	
						</cfquery>					
					</cfif>
					<cfif rsdetalle.recordCount GT 0>
						<tr>
							<td colspan="4">
									<table width="100%" border="0">
										<tr>
											<td><strong>C&oacute;digo Transacci&oacute;n</strong></td>
											<td><strong>Documento</strong></td>
											<td ><strong>Moneda</strong></td>
											<td align="right"><strong>Monto Pago Documento</strong></td>
											<td align="right"><strong>Monto Pago</strong></td>
										</tr>
										<cfset totalMontoPago = 0>
										<cfloop query="rsdetalle">
											<tr>	
												<td>#rsdetalle.CodigoTransaccion#</td>
												<td>#rsdetalle.Documento#</td>
												<td>#rsdetalle.CodigoMonedaDoc#</td>
												<td align="right">#LSNumberFormat(rsdetalle.MontoPagoDocumento,',9')#</td>
												<td align="right">#LSNumberFormat(rsdetalle.MontoPago,',9')#</td>
												<cfset totalMontoPago = totalMontoPago + rsdetalle.MontoPago>
											</tr>
										</cfloop>
										<tr>
											<td  colspan="7"><hr></td>
										</tr>
										<tr>
											<td><strong>total</strong></td>
											<td  colspan="5" align="right">#LSNumberFormat(totalMontoPago,',9')#</td>
										</tr>	
									
									</table>
							</td>
						</tr>
					</cfif>
					<tr  bgcolor="##CCCCCC">
						<td colspan="4">&nbsp;</td>
					</tr>
				</table>
			</cfloop> 
		</cfoutput>
	<cfelse>
		<table width="100%" border="0">
			<tr>
				<td >&nbsp;</td>
			</tr>
			<tr bgcolor="##CCCCCC">
				<td align="center">Debe seleccionar al menos un documento</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
	</cfif>
<cf_web_portlet_end>

