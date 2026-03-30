<cf_templateheader title="Punto de Venta">
	<cf_templatecss>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Anulaci&oacute;n de Anticipos de Cliente">

		<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery name="rsDocumento" datasource="#session.DSN#">
			select F.Oficodigo #_Cat# ' - ' #_Cat# F.Odescripcion  as descOficina,
				E.FAM01CODD,
				E.FAM01CODD #_Cat# ' - ' #_Cat# E.FAM01DES	as descripcioncaja,
				C.CDCtipo as tipoidentif,	
				C.CDCidentificacion	#_Cat# ' - ' #_Cat# C.CDCnombre	as nombreCliente,
				G.Miso4217 #_Cat# ' - ' #_Cat# G.Mnombre as descripcionmoneda,
				D.Mcodigo,
				D.FAX01FEC as fechafactura,
				D.FAX01TIP as tipofactura, 
				D.FAX01NTR as Transaccion,
				D.FAX01NTE,
				D.Mcodigo,
				case when D.FAX01TIP in ('1','4') then ( select sum(FAX04TOT) 
											 from FAX004 fd 
											where fd.FAM01COD = D.FAM01COD 
											  and fd.FAX01NTR = D.FAX01NTR) 
					else D.FAX01TOT end as subtotal,
			D.FAX01MDT as MontoDes,
			D.FAX01MIT as MontoImpu,
			D.FAX01TOT as Total, 
			A.SNnumero,
			A.SNid,
			A.SNcodigo
			
			from FAX001 D
			
			inner join FAM001 E
			on D.FAM01COD = E.FAM01COD
			and D.Ecodigo = E.Ecodigo 
			
			inner join ClientesDetallistasCorp C
			on C.CDCcodigo = D.CDCcodigo
			
			inner join  FACSnegocios B
			on B.CDCcodigo = C.CDCcodigo
			
			inner join SNegocios A
			on A.Ecodigo = B.Ecodigo 
			and  A.SNcodigo = B.SNcodigo
			
			inner join  Oficinas F
			on F.Ocodigo = D.Ocodigo
			and F.Ecodigo = D.Ecodigo 
			
			inner join Monedas G
			on G.Mcodigo = D.Mcodigo
			and G.Ecodigo = D.Ecodigo 
			
			where D.FAX01NTR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FAX01NTR#">
			  and D.Ecodigo = #session.Ecodigo#
		</cfquery>

			<cfoutput>
			<table width="99%" align="center" cellpadding="0" cellspacing="0">
				<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				<cfif isdefined("url.FAM01COD") and len(trim(url.FAM01COD))>
					<cfquery name="caja" datasource="#session.DSN#">
						select FAM01COD, FAM01DES
						from FAM001
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and FAM01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAM01COD#">
					</cfquery>
					<tr><td align="center"><font size="2">Anulaci&oacute;n de Transacciones</font></td></tr>
					<tr><td align="center">Caja: <cfoutput>#trim(caja.FAM01COD)# - #caja.FAM01DES#</cfoutput></td></tr>
					<tr><td align="center">Transacci&oacute;n: <cfoutput>#url.FAX01NTR#</cfoutput></td></tr>
					<tr><td>
						<table width="100%" border="0" cellspacing="0" cellpadding="2">
							<tr>
								<td width="50%" valign="top">
									<cf_web_portlet_start border="true" titulo="Origenes de la factura" skin="info1">
										<table width="100%" border="0" cellspacing="0" cellpadding="2">
											<tr>
												<td><strong>Oficina:</strong></td>
												<td><input name="descOficina" type="text" size="50"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.descOficina#</cfif>"></td>
											</tr>
											<tr>
												<td>
													<strong>Caja:</strong>
												</td>
												<td>
													<input name="descripcioncaja" type="text" size="50"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.descripcioncaja#</cfif>">
												</td>
											</tr>
											<tr>
												<td><strong>Cliente:</strong></td>
												<td>
													<input name="nombreCliente" type="text" size="50"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.nombreCliente#</cfif>">
												</td>
											</tr>
											<tr>
												<td><strong>Moneda:</strong></td>
												<td>													
													<input name="descripcionmoneda" type="text" size="50"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#rsDocumento.descripcionmoneda#</cfif>">
												</td>
											</tr>
										</table>
									<cf_web_portlet_end>		
								</td>
								<td width="50%" valign="top">
									<cf_web_portlet_start border="true" titulo="Montos de la factura" skin="info1">
										<table width="100%" border="0" cellspacing="0" cellpadding="2">
											<tr>
												<td align="right"><strong>Subtotal:</strong></td>
												<td ><input name="subtotal" type="text" align="right" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.subtotal,',9.00')#</cfif>"></td>
											</tr>
											<tr>
												<td align="right">
													<strong>Descuento:</strong>
												</td>
												<td >
													<input name="MontoDes" type="text"  align="right" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.MontoDes,',9.00')#</cfif>">
												</td>
											</tr>
											<tr>
												<td align="right"><strong>Impuesto:</strong></td>
												<td ><input name="MontoImpu" type="text" align="right" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.MontoImpu,',9.00')#</cfif>"></td>
											</tr>
											<tr>
												<td align="right"><strong>Neto:</strong></td>
												<td ><input name="Total" type="text"  align="right" size="25"   readonly="true"  class="cajasinborde" tabindex="-1" value="<cfif isdefined('rsDocumento') and rsDocumento.recordCount GT 0>#LSNumberFormat(rsDocumento.Total,',9.00')#</cfif>"></td>
											</tr>
										</table>
									<cf_web_portlet_end>	
								</td>
							</tr>
						</table>
					</td></tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr><td>
					<form name="form1" action="anulacion-sql.cfm" method="post">
					<input type="hidden" name="FAM01COD" value="#url.FAM01COD#" >
					<input type="hidden" name="FAX01NTR" value="#url.FAX01NTR#" >
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td align="center"><input type="submit" name="Anular" value="Anular" onClick="return confirm('Desea anular la Transacción?');"></td>
						</tr>
					</table>
					</form>
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			</cfoutput>
		<cf_web_portlet_end>
<cf_templatefooter>
