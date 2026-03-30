<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start border="true" titulo="Movimientos Quick Pass" >
	
		<cfquery name="rsMovimientos" datasource="#session.dsn#">
			select 
				a.QPMovid,   
				a.QPMovCodigo,
				a.QPMovDescripcion,
				a.Ecodigo,                   
				a.BMFecha,                
				a.BMUsucodigo   
			from QPMovimiento a
			where a.Ecodigo = #session.Ecodigo#
			and QPMovid=#form.movimiento#
			order by a.QPMovCodigo
		</cfquery>

	<cfif isdefined("form.QPTidTag") and len(trim(form.QPTidTag))>
		<cfoutput>
			<form action="QPassMovimiento_SQL.cfm" method="post" name="form1"> 
			<table width="100%" align="left" border="0">
				<tr>
					<td align="center">
						<table width="100%" align="left" border="0">
							<tr>
								<td align="right" nowrap><strong>Identificaci&oacute;n:</strong>&nbsp;</td>
								<td align="left" nowrap="nowrap">
								<cfif modo NEQ 'ALTA'>#trim(form.QPcteDocumento)#</cfif>
								</td>
							
								<td align="right" nowrap><strong>Cliente:</strong>&nbsp;</td>
								<td align="left" nowrap="nowrap">
								<cfif modo NEQ 'ALTA'>#form.QPcteNombre#</cfif>
								</td>
							</tr>							
							<tr>
								<td align="right" nowrap><strong>N&uacute;mero de TAG:</strong>&nbsp;</td>
								<td align="left" nowrap="nowrap">
								<cfif modo NEQ 'ALTA'>#form.QPTPAN#</cfif>
								</td>
								
								<td align="right" nowrap><strong>Placa:</strong>&nbsp;</td>
								<td align="left" nowrap="nowrap">
								<cfif modo NEQ 'ALTA'>#form.QPvtaTagPlaca#</cfif>
								</td>								
							</tr>  
								<td align="right" nowrap><strong>Saldo:</strong>&nbsp;</td>
								<td align="left" nowrap="nowrap">
								<cfif modo NEQ 'ALTA' and isdefined('form.QPctaSaldosSaldo')>#LSNumberFormat(form.QPctaSaldosSaldo,",0.00")#<cfelse>0.00</cfif>
								</td>								
							</tr>       							                 				
							<tr>
								<td colspan="6">&nbsp;</td>
							</tr>
                
							<tr>
							<td colspan="4" align="center">
							<fieldset style="width:85%">
								<legend>Causas</legend>
								<table cellspacing="2" border="0">
									<cfset LvarMovimiento = "">
											<cfquery name="rsCausa" datasource="#session.dsn#">
												select
													a.QPCid, 
													a.QPCmonto,
													a.QPCcodigo, 
													a.QPCdescripcion,
													a.QPCMontoVariable 
												from QPCausa a
													inner join QPCausaxMovimiento b
														on a.QPCid = b.QPCid
													inner join QPMovimiento c
														on b.QPMovid = c.QPMovid
												where a.Ecodigo = #session.Ecodigo#
													and c.QPMovid = #form.movimiento#
											</cfquery>
										<tr><td>&nbsp;
											
											</td></tr>
										<tr>
											<td nowrap="nowrap" colspan="2">
												<strong>#rsMovimientos.QPMovDescripcion#</strong>
											</td>
										</tr>
											<cfloop query="rsCausa">
											</tr>
												<td>
												<cfset QPCmonto = 0 >
													<cfif modo neq 'ALTA'>
														<cfset QPCmonto = LSNumberFormat(abs(rsCausa.QPCmonto),"0.00")>
													</cfif>
													<cfif rsCausa.QPCMontoVariable eq 0>
												<cf_inputNumber name="QPCid_#rsCausa.QPCid#" value="#QPCmonto#" enteros="8" decimales="2" comas="false" readonly = "true" negativos="true">
													<cfelse>
												<cf_inputNumber name="QPCid_#rsCausa.QPCid#" value="#QPCmonto#" enteros="8" decimales="2" comas="false" negativos="true">
													</cfif>
													<td nowrap="nowrap">
														&nbsp;#rsCausa.QPCcodigo# - #rsCausa.QPCdescripcion# 
													</td>											
												</tr>	
										</cfloop>
									<tr>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td align="center" colspan="3"><cf_botones values="Aceptar" names="Aceptar"></td>
									</tr>
								</table>
							</fieldset>	
							<tr><td colspan="3"></td></tr>
						</table>				
					<td colspan="3">
						<cfset ts = "">
						<cfif modo NEQ "ALTA">

						<input name="QPMovid" type="hidden"       value="#rsMovimientos.QPMovid#">
						<input type="hidden" name="QPcteid"       value="#form.QPcteid#">
						<input type="hidden" name="QPcteNombre"   value="#form.QPcteNombre#">
						<input type="hidden" name="QPcteDocumento"value="#form.QPcteDocumento#">
						<input type="hidden" name="QPTidTag" 	  value="#form.QPTidTag#">
						<input type="hidden" name="QPctaSaldosid" value="#form.QPctaSaldosid#">
						<input type="hidden" name="QPTPAN"   	  value="#form.QPTPAN#">
						</cfif>
					</td>
				</tr>
			</table>
			</form>
		</cfoutput>
	</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
    <script language="javascript1" type="text/javascript">
		function funcAceptar(){
			if (confirm("Esta seguro de que desea Realizar este movimiento?")) {
				return true;
			}
			return false;
		}
	</script>

