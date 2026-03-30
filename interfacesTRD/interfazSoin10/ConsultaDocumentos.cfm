<title>informaci&oacute;n de los documentos</title>
<cf_templatecss>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='informaci&oacute;n de los documentos'>
	<cfif isdefined("Url.ID") and len(Url.ID)>
		<cfquery name="rsQuery" datasource="sifinterfaces">
			select 
				ID,
				case Modulo when 'CC' then 'Cuentas Por Cobrar' when 'CP' then 'Cuentas Por Pagar' end as ModuloL,
				Modulo,	
				CodigoTransacion,
				Documento,
				CodigoMoneda,
				FechaDocumento,
				CodigoOficina,
				FechaVencimiento,
				NumeroSocio,
				case StatusProceso when 11 then 'Esta documento ya fue procesado anteriormente y presento errores. Asegurarse que fueron corregidos antes de aplicar nuevamente' else '' end as Estado
			from IE10 
			where EcodigoSDC  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#">
			<cfif Url.ID neq -1>
				and ID =#Url.ID#
			<cfelse>
				and StatusProceso in (1,11)  	
			</cfif>
			order by Modulo			
		</cfquery>
		<cfoutput>
			<cfset llave = "">
			<cfset corte = "">
			<cfloop query="rsQuery">
				<table width="100%" border="0">
					<cfset llave = rsQuery.ID>
					<cfif corte neq rsQuery.Modulo >
						<tr bgcolor="##CCCCCC">
							<td colspan="4" align="center"><strong>#trim(rsQuery.ModuloL)#</strong></td>
						</tr>					
						<cfset corte = rsQuery.Modulo>
					</cfif>
					<tr>
						<td >&nbsp;</td>
					</tr>
					<tr>
						<td><strong>Transacci&oacute;n</strong></td>
						<td>#rsQuery.CodigoTransacion#</td>
						<td><strong>Documento</strong></td>
						<td>#rsQuery.Documento#</td>
					</tr>
					<tr>
						<td><strong>Moneda</strong></td>
						<td>#rsQuery.CodigoMoneda#</td>
						<td><strong>Oficina</strong></td>
						<td>#rsQuery.CodigoOficina#</td>
					</tr>
					<tr>
						<td><strong>Fecha Documento</strong></td>
						<td>#LSDateformat(rsQuery.FechaDocumento,'dd/mm/yyyy')#</td>
						<td><strong>Fecha Vencimiento</strong></td>
						<td>#LSDateformat(rsQuery.FechaVencimiento,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td><strong>No. Socio</strong></td>
						<td colspan="3">#rsQuery.NumeroSocio#</td>

					</tr>					
					
					<tr>
						<td colspan="4"  style="color:##FF0000"><b>#trim(rsQuery.Estado)#</b></td>
					</tr>
					
															
					<tr>
						<td colspan="4"><hr></td>
					</tr>
					<cfquery name="rsdetalle" datasource="sifinterfaces">
						select   
							CodigoItem,
							CodigoUnidadMedida,
							PrecioUnitario,
							CantidadTotal,
							ImporteDescuento,
							ImporteImpuesto,
							PrecioTotal
						from ID10
						where ID = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">	
					</cfquery>
					<cfif rsdetalle.recordCount GT 0>
						<tr>
							<td colspan="4">
									<table width="100%" border="0">
										<tr>
											<td><strong>C&oacute;digo</strong></td>
											<td><strong>Unidad de Medida</strong></td>
											<td align="right"><strong>Precio Unitario</strong></td>
											<td align="right"><strong>Cantidad</strong></td>
											<td align="right"><strong>Descuentos</strong></td>
											<td align="right"><strong>Impuestos</strong></td>
											<td align="right"><strong>Total</strong></td>
										</tr>
										<cfset totalfactura = 0>
										<cfloop query="rsdetalle">
											<tr>	
												<td>#rsdetalle.CodigoItem#</td>
												<td>#rsdetalle.CodigoUnidadMedida#</td>
												<td align="right">#LSNumberFormat(rsdetalle.PrecioUnitario,',9')#</td>
												<td align="right">#LSNumberFormat(rsdetalle.CantidadTotal,',9')#</td>
												<td align="right">#LSNumberFormat(rsdetalle.ImporteDescuento,',9')#</td>
												<td align="right">#LSNumberFormat(rsdetalle.ImporteImpuesto,',9')#</td>
												<td align="right">#LSNumberFormat(rsdetalle.PrecioTotal,',9')#</td>
												<cfset totalfactura = totalfactura + rsdetalle.PrecioTotal>
											</tr>
										</cfloop>
										<tr>
											<td  colspan="7"><hr></td>
										</tr>
										<tr>
											<td><strong>total</strong></td>
											<td  colspan="6" align="right">#LSNumberFormat(totalfactura,',9')#</td>
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

