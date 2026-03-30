<cfif isdefined('url.TESRPTCid') and not isdefined('form.TESRPTCid')>
	<cfparam name="form.TESRPTCid" default="#url.TESRPTCid#">
</cfif>
<cfif isdefined('form.fechaCambio') and len(trim(form.fechaCambio))>
	<cfset mododet = 'CAMBIO'>
<cfelse>
	<cfset mododet = 'ALTA'>
</cfif>


<cfif mododet EQ 'CAMBIO'>
	<cfquery name="rsDetalle" datasource="#session.dsn#">
		select 
				a.TESRPTCfecha as fechaCambio,
				a.TESRPTCietuP,
				a.CFcuentaDB, db.CFformato as CFformatoDB, db.Ccuenta as CcuentaDB,
				a.CFcuentaCR, cr.CFformato as CFformatoCR, cr.Ccuenta as CcuentaCR,
				case a.TESRPTCietu
					when  0 then 'NO'
					when  1 then 'SI'
					end as TESRPTCietu
		from TESRPTCietu a
			left join CFinanciera db
				on db.CFcuenta=a.CFcuentaDB
			left join CFinanciera cr
				on cr.CFcuenta=a.CFcuentaCR
		where a.TESRPTCid=#form.TESRPTCid#
		and a.Ecodigo=#session.Ecodigo#
		and a.TESRPTCfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDatetime(form.fechaCambio)#">
	</cfquery>
</cfif>


		<table align="center" border="0" width="100%">
			<tr >
				<td colspan="6" align="center">
				<fieldset>
					<legend><strong>Impuesto sobre Flujo de Efectivo</strong></legend>
					<table width="100%" border="0">
						<tr>
							<td  align="left" nowrap width="1"><strong>Vigencia&nbsp;a&nbsp;Partir:</strong>
								<cfset fechadoc = DateFormat(Now(),'dd/mm/yyyy')>
								<cfif mododet EQ 'CAMBIO' and isdefined ('rsDetalle.fechaCambio') >
									<cfset fechadoc = DateFormat(rsDetalle.fechaCambio,'dd/mm/yyyy')>
									<cfoutput><input type="hidden" value="#fechadoc#" name="FechaAnte" /></cfoutput>
								</cfif>
							</td>
							<td align="left" nowrap="nowrap" width="1">
								<cf_sifcalendario form="form1" value="#fechadoc#" name="TESRPTCfecha" tabindex="1" readonly="#mododet NEQ "ALTA"#">
								
							</td>
							<td align="left" nowrap="nowrap">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<strong>Afecta Impuesto Flujo Efectivo:</strong>
								<input 	type="checkbox" name="chkIFE" id="chkIFE"  value="1" <cfif mododet NEQ 'ALTA' and rsDetalle.TESRPTCietu EQ 'SI' >checked="checked"</cfif> tabindex="1" 
								onClick="document.getElementById('trImpuesto').style.visibility = this.checked ? 'visible' : 'hidden';">
						  </td>
						</tr>
						<tr id="trImpuesto" <cfif mododet EQ 'ALTA' or len(trim(rsDetalle.TESRPTCietu)) gt 0 and rsDetalle.TESRPTCietu EQ 'NO'>style="visibility:hidden;" </cfif>>
							<td colspan="2" nowrap="nowrap" align="right">&nbsp;</td>
							<td align="right"><cfoutput>
								<table align="left" border="0">
									<tr>
										<td align="right" nowrap><strong>Porcentaje:</strong></td> 
										<td align="left" nowrap="nowrap">
											<cfif mododet NEQ 'ALTA' and isdefined ('rsDetalle.TESRPTCietuP')>
												<cf_inputNumber name="TESRPTCietuP"  value="#rsDetalle.TESRPTCietuP#" enteros="2" decimales="2" negativos="false"><strong>%</strong></td>
											<cfelse>
												<cf_inputNumber name="TESRPTCietuP"  value="" enteros="2" decimales="2" negativos="false"><strong>%</strong>
											</cfif>
									</tr>
									<tr>
										<td nowrap align="right"><strong>Provisión para Gasto por Impuesto (DB):</strong></td>
										<td align="left">
												<cfif modoDet NEQ 'ALTA'>
													<cf_cuentas 
														conexion="#session.DSN#" 
														conlis="S" 
														frame="frame1" 
														auxiliares="N" 
														movimiento="S" 
														form="form1" 

														ccuenta	="CcuentaDB" 
														cfcuenta="CFcuentaDB" 
														cformato="CFformatoDB" 
														query="#rsDetalle#"
													>
												<cfelse>
													<cf_cuentas 
														conexion="#session.DSN#" 
														conlis="S" 
														frame="frame1" 
														auxiliares="N" 
														movimiento="S" 
														form="form1" 

														ccuenta	="CcuentaDB" 
														cfcuenta="CFcuentaDB" 
														cformato="CFformatoDB" 
													>
												</cfif>
										</td>
									</tr>
									<tr>
										<td nowrap align="right"><strong>Provisión para Impuesto por Pagar (CR):</strong></td>
										<td align="left">
												<cfif modoDet NEQ 'ALTA'>
													<cf_cuentas 
														conexion="#session.DSN#" 
														conlis="S" 
														frame="frame1" 
														auxiliares="N" 
														movimiento="S" 
														form="form1" 

														ccuenta	="CcuentaCR" 
														cfcuenta="CFcuentaCR" 
														cformato="CFformatoCR" 
														query="#rsDetalle#"
													>
												<cfelse>
													<cf_cuentas 
														conexion="#session.DSN#" 
														conlis="S" 
														frame="frame1" 
														auxiliares="N" 
														movimiento="S" 
														form="form1" 

														ccuenta	="CcuentaCR" 
														cfcuenta="CFcuentaCR" 
														cformato="CFformatoCR" 
													>
												</cfif>
										</td>
									</tr>
							  </table></cfoutput>
							</td>
							<td colspan="2" nowrap="nowrap" align="right">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3" class="formButtons">
								<cf_botones sufijo='Det' modo='#mododet#'  tabindex="2">
							</td>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
		</table>
	
