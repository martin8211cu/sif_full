<!--- 
	Creado por: Oscar Bonilla
		Fecha: 4-NOV-2009
		Motivo: Emisión de Transferencias de Fondos
				Impresión de Instrucciones de Pago y
				Generación de Transferencias Electrónicas
--->
<cf_dbfunction name="OP_concat" returnvariable="_cat">
<cfif isdefined("form.TESTDid") or isdefined("url.btnNuevo")>
	<cfset Modo = "ALTA">
<cfelse>
	<cfset Modo = "CAMBIO">
</cfif>

<cf_navegacion name="TESTLid">

<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
	text-align:center;
}
-->
</style>
<BR>
<cfif MODO EQ "ALTA">
	<cfoutput>
	<form name="form1" method="post" action="TEF_sql.cfm">
		<input type="hidden" name="TEF" value="#GvarTEF.TEF#">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="style1" colspan="4">
					#GvarTEF.Lote#
				</td>
			</tr>
			<tr>
				<td width="5%">&nbsp;</td>
				<td width="20%">&nbsp;</td>
				<td width="70%">&nbsp;</td>
				<td width="5%">&nbsp;</td>
			</tr>		  
			<tr>
				<td>&nbsp;</td>
			</tr>		  
			<tr>
				<td>&nbsp;</td>
				<td valign="top">
					Cuenta Bancaria de Pago:
				</td>
				<td valign="top">
					<cf_cboTESCBid Dcompleja="true" Dcompuesto="yes" cboTESMPcodigo="TESMPcodigo" tabindex="1">
				</td>
			</tr>		  
			<tr>
				<td>&nbsp;</td>
			</tr>		  
			<tr>
				<td>&nbsp;</td>
				<td valign="top">
					Medio de Pago:
				</td>
				<td valign="top">
					<cf_cboTESMPcodigo SoloTipo="#GvarTEF.TESTMPtipo#" tabindex="1">
					<script language="javascript">
						sbCambiaTESCBid(document.getElementById("CBid"),'TESMPcodigo','');
					</script>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>  
			<cfif isdefined('Impresion')>
			<tr>
				<td colspan="2">&nbsp;</td>
				<td>
					<strong>Órdenes de Pago 'En Emision' a Incluir en el nuevo #GvarTEF.Lote#</strong>
					<fieldset>
					<input type="radio" value="1" name="chkTipo" checked tabindex="1">
					Órdenes de Pago asignadas a la Cuenta Bancaria y al Medio de Pago<BR>
					<table style=" float:inherit">
						<tr>
								
							<td>
								<input type="radio" style="visibility:hidden">
							</td>
							<td>
								Fecha de Pago:
							</td>
							<td>
								desde
							</td>
							<td>
								<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1">
							</td>
							<td>
								&nbsp;-&nbsp;
							</td>
							<td>
								hasta
							</td>
							<td>
								<cf_sifcalendario form="form1" value="" name="fechaHasta" tabindex="1">
							</td>
						</tr>
					</table>							
					<!---
					<input type="radio" value="2" name="chkTipo" tabindex="1">
					Incluir todas las Órdenes de Pago asignadas a la Cuenta Bancaria sin Medio de Pago asignado<BR>
					--->
					<input type="radio" value="3" name="chkTipo" tabindex="1">
					Seleccionar manualmente las Órdenes de Pago<BR>
					</fieldset>
				</td>
				<td width="100">&nbsp;</td>
			</tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td colspan="3" align="center">
					<input name="btnCrear" type="submit" value="Crear Nuevo Lote" onClick="return sbCrear();" tabindex="1">
					<input type="button" value="Ir a Lista <cfif isdefined('Impresion')>de Lotes</cfif>" tabindex="1"
					onClick="location.href='#GvarTEF.TEF#.cfm'">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>  
		</table>
	</form>
	<script language="javascript">
		function sbCrear()
		{
			if (document.form1.CBid.value == "")
			{
				alert("Debe escoger una Cuenta Bancaria de Pago para crear el lote");
				document.form1.CBid.focus();
				return false;
			}
			if (document.form1.TESMPcodigo.value == "")
			{
				alert("Debe escoger un Medio de Pago para crear el lote");
				document.form1.TESMPcodigo.focus();
				return false;
			}
			return true;
		}
	</script>
	</cfoutput>
<cfelse>
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select	TESTLid,
				tl.CBid,
				case TESTLestado
					when 0 then '<strong>En preparacion</strong>'
					when 1 then '<strong>En #GvarTEF.Accion#</strong>'
					when 2 then '<strong>No Emitido</strong>'
					when 3 then '<strong>Emitido</strong>'
				end as Estado,
				Edescripcion as empPago,
				Bdescripcion as bcoPago,
				Mnombre 	 as monPago, Miso4217,
				CBcodigo,
				tl.TESMPcodigo,
				TESMPdescripcion,
				TESTLfecha,

				tl.TESTMPtipo,
				mp.TESTMPtipo, mp.TESTGid,
				(case when mp.TESTGid is null then fi.FMT01DES else tg.TESTGdescripcion end) as Formato,
				mp.TESTGtipoConfirma,
				case mp.TESTGcodigoTipo
					when 0 then
						case mp.TESTGtipoCtas
							when 0 then 'Cuentas Nacionales: Cualquier cuenta de cualquier Banco'
							when 1 then 'Cuentas Nacionales: Sólo Cuentas Propias del Mismo Banco de Pago'
							when 2 then 'Cuentas Nacionales: Sólo Cuentas Interbancarias de otros Bancos'
							when 3 then 'Cuentas Nacionales: Sólo Cuentas Interbancarias de cualquier Banco'
							when 4 then 'Cuentas Nacionales: Ctas propias del mismo Bco e Interbancarias de otros'
						end
					when 1 then 'Cuentas ABA'
					when 2 then 'Cuentas SWIFT'
					when 3 then 'Cuentas IBAN'
					else 'Otro tipo de cuenta'
				end as tipoCuenta,
				case mp.TESTGtipoConfirma
					when 1 then 'Una única confirmación por Lote'
					when 2 then 'Una confirmación por Orden de Pago'
				end as tipoConfirma,
				coalesce (fm.FMT01DES, '(No enviar eMail al Beneficiario)') as FormatoEmail,

				mp.FMT01COD, fi.FMT01tipfmt, fi.FMT01TXT, fm.FMT01TXT as FMT01TXTemail,

				tl.TESTLestado,

				TESTLreferencia,
				TESTLreferenciaComision,
				TESTLtotalDebitado,
				TESTLtotalComision,
				TESTLcantidad,
				TESTLdatos,
				TESTLmsg
		from TEStransferenciasL tl
			inner join TEScuentasBancos tcb
				inner join CuentasBancos cb
					inner join Monedas m
						 on m.Mcodigo 	= cb.Mcodigo
						and m.Ecodigo  	= cb.Ecodigo
					inner join Bancos b
						 on b.Ecodigo 	= cb.Ecodigo
						and b.Bid  		= cb.Bid
					inner join Empresas e
						on e.Ecodigo	= cb.Ecodigo
					 on cb.CBid=tcb.CBid
				 on tcb.TESid	= tl.TESid
				and tcb.CBid	= tl.CBid
				and tcb.TESCBactiva = 1
			inner join TESmedioPago mp
				<!--- Formato Generación TEF --->
				left join TEStransferenciaG tg 
					on tg.TESTGid = mp.TESTGid
				<!--- Formato Impresion TEF --->
				left join FMT001 fi
					on fi.FMT01COD = mp.FMT01COD
				<!--- Formato Impresion eMail --->
				left join FMT001 fm
					on fm.FMT01COD = mp.FMT01CODemail
				 on mp.TESid		= tl.TESid
				and mp.CBid			= tl.CBid
				and mp.TESMPcodigo 	= tl.TESMPcodigo
		where tl.TESid=#session.Tesoreria.TESid#	
		  and TESTLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
			<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
				and TESTLfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
			</cfif>

			<cfif isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
				and tl.CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
			<cfelse>
				<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
					and tcb.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
				</cfif>						
				<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
					and tcb.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
				</cfif>							
			</cfif>		
	</cfquery>
	<cfif rsForm.TESTMPtipo NEQ #GvarTEF.TESTMPtipo#> <!--- Verifica Tipo de Lote --->
		<cfthrow message="Se esta tratando de Procesar un Lote que no es un #GvarTEF.Lote#">
	</cfif>

	<cfquery datasource="#session.dsn#" name="rsOPs">
		select count(1) as cantidad, sum(round(op.TESOPtotalPago,2)) as total, count(distinct TESTDreferencia) as conReferencia
		  from TESordenPago op
			left join TEStransferenciasD td
				 on td.TESid 	= op.TESid
				and td.TESOPid 	= op.TESOPid
				and td.TESTLid	= op.TESTLid
				and td.TESTDestado <> 3
		 where op.TESid		= #session.Tesoreria.TESid#
		   and op.CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
		   and op.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">	
		   and op.TESTLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESTLid#">	
	</cfquery>
	<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td class="style1" colspan="4">
		#GvarTEF.Lote#
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td valign="top">
		<form name="form1" method="post" action="TEF_sql.cfm">
			<input type="hidden" name="TEF" value="#GvarTEF.TEF#">
			<table width="100%">
			<tr>
				<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td valign="top" nowrap>
								Numero Lote:
							</td>
							<td>&nbsp;</td>
							<td valign="top" width="60%">
								<strong>#rsForm.TESTLid#</strong>
								<input type="hidden" name="TESTLid" value="#rsForm.TESTLid#" tabindex="-1">
							</td>
						</tr>		  
						<tr>
							<td valign="top" nowrap>
								Estado del Lote:
							</td>
							<td>&nbsp;</td>
							<td valign="top">
								<strong>#rsForm.Estado#</strong>
							</td>
						</tr>		  
						<tr>
							<td valign="top" nowrap>
								Empresa de Pago:
							</td>
							<td>&nbsp;</td>
							<td valign="top">
								<strong>#rsForm.empPago#</strong>
							</td>
						</tr>		  
						<tr>
							<td valign="top" nowrap>
								Banco de Pago:
							</td>
							<td>&nbsp;</td>
							<td valign="top">
								<strong>#rsForm.bcoPago#</strong>
							</td>
						</tr>		  
						<tr>
							<td valign="top" nowrap>
								Cuenta Bancaria de Pago:
							</td>
							<td>&nbsp;</td>
							<td valign="top">
								<strong>#rsForm.CBcodigo#</strong>
							</td>
						</tr>		  
						<tr>
							<td valign="top" nowrap>
								Moneda de Pago:
							</td>
							<td>&nbsp;</td>
							<td valign="top">
								<strong>#rsForm.monPago#</strong>
							</td>
						</tr>		  
						<tr>
							<td valign="top" nowrap>
								Medio de Pago:
							</td>
							<td>&nbsp;</td>
							<td valign="top">
								<strong>#rsForm.TESMPcodigo#</strong>
								<br>
								<strong>#rsForm.TESMPdescripcion#</strong>
							</td>
						</tr>
						<tr>
							<td valign="top" nowrap>
								Fecha de lote:
							</td>
							<td>&nbsp;</td>
							<td valign="top">
								<cfset fechaLote = LSDateFormat(Now(),'dd/mm/yyyy')>
								<cfif Modo NEQ 'ALTA'>
									<cfset fechaLote = LSDateFormat(rsForm.TESTLfecha,'dd/mm/yyyy') >
								</cfif>
								<cf_sifcalendario form="form1" value="#fechaLote#" name="TESTLfecha" tabindex="1">
									
							</td>
						</tr>
					<cfif GvarTEF.TEF EQ "TRE">
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select TESTGdato, TESTGvalor
							  from TEStransferenciaG2
							 where TESTGid = #rsForm.TESTGid#
							   and Ecodigo = #session.Ecodigo#
							   and TESTGtipo = 'L'
							 order by TESTGsec
						</cfquery>
						<cfset LvarTESTGdatos = valueList(rsSQL.TESTGdato)>
						<cfset LvarTESTGvalores = valueList(rsSQL.TESTGvalor)>
						<cfif LvarTESTGdatos NEQ "">
							<tr>
								<td valign="top" nowrap>
									Datos para Generación:
								</td>
								<td>&nbsp;</td>
								<td><input type="hidden" name="TESTLdatos"></td>
							</tr>
							<cfloop query="rsSQL">
							<tr>
								<td valign="top" align="right">#rsSQL.TESTGdato#:&nbsp;&nbsp;</td>
								<td></td>
								<cfif rsForm.TESTLestado EQ "0">
									<td valign="top"><input type="text" name="TESTLdatos" size="20" value="#rsSQL.TESTGvalor#"></td>
								<cfelse>
									<td valign="top">
									#listGetAt(rsForm.TESTLdatos,rsSQL.currentRow)#
									</td>
								</cfif>
							</tr>								
							</cfloop>
						</cfif>
					</cfif>
						<tr>
							<td align="right" nowrap>
								<strong>Cantidad Total de OPs en Lote:&nbsp;</strong>
							</td>
							<td>&nbsp;</td>
							<td valign="top">
								<strong>#rsOPs.cantidad#</strong>
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Monto Total de OPs en Lote:&nbsp;</strong>
							</td>
							<td>&nbsp;</td>
							<td>
								<strong>#rsForm.Miso4217#&nbsp;#NumberFormat(rsOPs.total,",9.99")#</strong>
							</td>
						</tr>
					</table>
				</td>
					<td>&nbsp;</td>
				<cfif rsForm.TESTLestado EQ "0">
					<td valign="top" width="490">
						<cf_tabs width="475px">
								<cf_tab text="Parámetros" id=2>
									<strong>Parámetros de #GvarTEF.Accion#</strong>
									<div style="width:475px; border:1px solid;">
										<table>
											<tr>
												<td>&nbsp;</td>
												<td><strong>Formato #GvarTEF.Accion#:</strong></td>
												<td>#rsForm.Formato#</td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td>&nbsp;</td>
												<td><strong>Tipo de Cuentas:</strong></td>
												<td>#rsForm.tipoCuenta#</td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td>&nbsp;</td>
												<td><strong>Tipo de Confirmación:</strong></td>
												<td>#rsForm.tipoConfirma#</td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td>&nbsp;</td>
												<td><strong>Formato eMail:</strong></td>
												<td>#rsForm.FormatoEmail#</td>
												<td>&nbsp;</td>
											</tr>
										</table>
									</div>
								</cf_tab>
							<cfif GvarTEF.TEF EQ "TRI">
								<cf_tab text="Formato TRI" id=1>
									<strong>Formato Carta de la Instrucción al Banco</strong>
									<div style="width:475px; border:1px solid;">
										#rsForm.FMT01TXT#
									</div>
								</cf_tab>
							</cfif>
							<cfif #rsForm.FMT01TXTemail# NEQ "">
								<cf_tab text="Formato eMail" id=3>
									<strong>Formato Carta del eMail al Beneficiario</strong>
									<div style="width:475px; border:1px solid;">
										#rsForm.FMT01TXTemail#**
									</div>
								</cf_tab>
							</cfif>
						</cf_tabs>
					</td>
			<cfelseif rsForm.TESTLestado EQ "2">
				<cfparam name="url.tipoConfirmacion" default="0">
				<td valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td nowrap="nowrap">
								<strong>No.Referencia de Confirmación:</strong>
								<cfif rsForm.TESTGtipoConfirma NEQ 1>
									<select name="tipoConfirmacion" onchange="this.form.TESTLreferencia.disabled = (this.value == 'M');">
										<option value="M"<cfif url.tipoConfirmacion EQ "M"> selected</cfif>>Manual por OP</option>
										<option value="A"<cfif url.tipoConfirmacion EQ "A"> selected</cfif>>Automática (Ref - Sec)</option>
										<option value="S"<cfif url.tipoConfirmacion EQ "S"> selected</cfif>>Consecutivo (Secuencia)</option>
									</select>
								</cfif>
							</td>
							<td align="right">
								<input type="hidden" name="TESTGtipoConfirma" value="#rsForm.TESTGtipoConfirma#">	
								<input type="text" name="TESTLreferencia" size="29" width="30" 
									<cfif rsForm.TESTGtipoConfirma NEQ 1>
										disabled
										onFocus="this.value=qf(this); this.select();" 
										onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
										onChange="fm(this,0);"
									</cfif>
										value="#rsForm.TESTLreferencia#"
								>
							</td>
						</tr>
						<tr>
							<td nowrap="nowrap">
								<strong>No.Referencia Comisión:</strong>
							</td>
							<td align="right">
								<input type="text" name="TESTLreferenciaComision" size="29" width="30" 
										value="#rsForm.TESTLreferenciaComision#"
								>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>
								<strong>Cantidad Transferencias confirmadas:</strong>
							</td>
							<td align="right">
								<cf_inputNumber name="TESTLcantidad"  value="#rsForm.TESTLcantidad#" enteros="15" decimales="0" negativos="false" comas="yes">
							</td>
						</tr>
						<tr>
							<td>
								<strong>Monto Total Debitado:</strong>
							</td>
							<td align="right">
								<strong>#rsForm.Miso4217#</strong>
								<cf_inputNumber name="TESTLtotalDebitado"  value="#rsForm.TESTLtotalDebitado#" enteros="15" decimales="2" negativos="false" comas="yes">
							</td>
						</tr>
						<tr>
							<td>
								<strong>Monto Total Comisiones:</strong>
							</td>
							<td align="right">
								<strong>#rsForm.Miso4217#</strong>
								<cf_inputNumber name="TESTLtotalComision"  value="#rsForm.TESTLtotalComision#" enteros="15" decimales="2" negativos="false" comas="yes">
							</td>
						</tr>
						<tr><td></td></tr>
					</table>
				</td>
			</cfif>
			</tr>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	mp.TESMPcodigo, 
						case tl.TESTMPtipo
							when 1 then 'Cheque'
							when 2 then 'Transferencia Impresa'
							when 3 then 'Transferencia Electrónica'
							when 4 then 'Transferencia Manual'
						end as tipoLote
				  from TEStransferenciasL tl
					inner join TESmedioPago mp
						 on mp.TESid		= tl.TESid
						and mp.CBid			= tl.CBid
						and mp.TESMPcodigo 	= tl.TESMPcodigo
				 where tl.TESid			= #session.Tesoreria.TESid#
				   and tl.TESTLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">
				   and (
							mp.TESTMPtipo <> tl.TESTMPtipo
						)
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<tr>
					<td align="center" colspan="3">
						<strong><font color="##FF0000">
							El Medio de Pago '#trim(rsSQL.TESMPcodigo)#' no es '#rsSQL.tipoLote#'
						</font></strong>
					</td>
				</tr>
				<tr>
					<td align="center" colspan="3">
					<input type="submit" name="btnEliminar" value="Eliminar Lote" onClick="if (!confirm('¿Desea eliminar este Lote de #GvarTEF.Accion#?')) return false;" tabindex="1">
					</td>
				</tr>
				</table>
				<cfabort>
			</cfif>
			
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	op.TESOPid as ID, op.TESOPnumero, op.TESOPbeneficiario, 
						'<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir la Orden de Pago de este Lote de #GvarTEF.Accion#?")) return false; location.href="TEF_sql.cfm?TEF=#GvarTEF.TEF#&btnExcluirOP=1&TESTLid=#form.TESTLid#&TESOPid=' #_Cat#
						<cf_dbfunction name="to_Char" args="op.TESOPid">
						#_Cat# '";''>' as Borrar
						,ip.TESTPbanco #_cat# ' - ' #_cat# ip.Miso4217 #_cat# ' - ' #_cat# ip.TESTPcodigo #_cat#  case when ip.TESTPtipoCtaPropia = 1 then ' (PROPIA)' else '' end as ctaD
						,
						'<font color="##FF0000" style="font-weight:bolder">' #_cat#
						case
							when mp.TESid <> tl.TESid OR mp.CBid <> tl.CBid OR mp.TESMPcodigo <> tl.TESMPcodigo then
								 <!--- Otro medio de pago --->
								'Otro Medio de Pago: '  #_cat# rtrim(mp.TESMPcodigo)
							when ip.Miso4217 <> op.Miso4217Pago then
								<!--- No es Misma Moneda --->
								'Cta.Destino de otra moneda'
							when mp.TESTGcodigoTipo <> ip.TESTPcodigoTipo then
								<!--- No es Mismo TESTGcodigoTipo --->
								'Cta.Destino Tipo ' #_cat# 
									case ip.TESTPcodigoTipo
										when 0 then 'Nacional'
										when 1 then 'ABA'
										when 2 then 'SWIFT'
										when 3 then 'IBAN'
										else 'Especial'
									end
							when mp.TESTGcodigoTipo = 0 then
								case
									when ip.Bid is null then
										<!--- No hay banco --->
										'Cta.Destino sin Banco'
									when mp.TESTGtipoCtas = 0 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0) then
										'Cta.Destino propia de otro banco'
									when mp.TESTGtipoCtas = 1 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid) then
										'Cta.Destino no es propia del banco de pago'
									when mp.TESTGtipoCtas = 2 and NOT (ip.TESTPtipoCtaPropia = 0) then
										'Cta.Destino no es interbancaria'
									when mp.TESTGtipoCtas = 2 and NOT (ip.Bid <> cb.Bid) then
										'Cta.Destino no es de otros bancos'
									when mp.TESTGtipoCtas = 3 and NOT (ip.TESTPtipoCtaPropia = 0) then
										'Cta.Destino no es interbancaria'
									when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 1 and ip.Bid <> cb.Bid) then
										'Cuenta Destino es propia de otro banco'
									when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 0 and ip.Bid = cb.Bid) then
										'Cuenta Destino no es propia del banco de pago'
								end
						end #_cat# '</font>' as error
				  from TESordenPago op 
					inner join TEStransferenciasL tl on tl.TESTLid = op.TESTLid 
					left join TEStransferenciaP ip on ip.TESTPid = op.TESTPid 
					inner join TESmedioPago mp 
						inner join CuentasBancos cb on cb.CBid = mp.CBid 
					on mp.TESid = op.TESid and mp.CBid = op.CBidPago and mp.TESMPcodigo = op.TESMPcodigo 
				 where op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
				   and op.TESid = #session.Tesoreria.TESid#
				   and 
						case
							when mp.TESid <> tl.TESid OR mp.CBid <> tl.CBid OR mp.TESMPcodigo <> tl.TESMPcodigo then
								<!--- Otro medio de pago --->
								1
							when ip.Miso4217 <> op.Miso4217Pago then
								<!--- No es Misma Moneda --->
								2
							when mp.TESTGcodigoTipo <> ip.TESTPcodigoTipo then
								<!--- No es Mismo TESTGcodigoTipo --->
								3
							when mp.TESTGcodigoTipo = 0 then
								case
									when ip.Bid is null then
										4
									when mp.TESTGtipoCtas = 0 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0) then
										5
									when mp.TESTGtipoCtas = 1 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid) then
										6
									when mp.TESTGtipoCtas = 2 and NOT (ip.TESTPtipoCtaPropia = 0) then
										7
									when mp.TESTGtipoCtas = 2 and NOT (ip.Bid <> cb.Bid) then
										8
									when mp.TESTGtipoCtas = 3 and NOT (ip.TESTPtipoCtaPropia = 0) then
										9
									when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 1 and ip.Bid <> cb.Bid) then
										10
									when mp.TESTGtipoCtas = 4 and (ip.TESTPtipoCtaPropia = 0 and ip.Bid = cb.Bid) then
										11
								end
						end > 0 
				order by op.TESOPnumero
			</cfquery>
			<cfif rsSQL.recordCount NEQ 0>
				<tr>
					<td align="center" colspan="3">
						<strong><font color="##FF0000">
							Ordenes de Pago que no pueden ser procesadas en el Lote
						</font></strong>
					</td>
				</tr>
				<tr>
					<td align="center" colspan="3">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#rsSQL#"
							desplegar="Borrar,TESOPnumero, TESOPbeneficiario, ctaD, error"
							etiquetas=" ,N° Orden, Beneficiario, Cta.Destino, Inconsistencia"
							formatos="S,S,S,S,S"
							ajustar="N,S,S,S,S"
							align="center,left,left,left,left"
							maxRows="15"
							showLink="no"
							incluyeForm="no"
							showEmptyListMsg="yes"
							keys="ID"
							navegacion="#navegacion#"
						/>		
					</td>
				</tr>
				</table>
				<cfabort>
			</cfif>
			<cf_dbfunction name="to_char" args="op.TESOPid" returnvariable= "LvarTESOPid">
			<cfif isdefined("url.btnSeleccionarOP")>
				<cfquery name="lista" datasource="#session.dsn#">
					SELECT 
						case
							when ip.Miso4217 <> op.Miso4217Pago then
								<!--- No es Misma Moneda --->
								'<img src="/cfmx/sif/imagenes/checked_none.gif" onclick="alert(''Diferente moneda'');"></img>'
							when mp.TESTGcodigoTipo <> ip.TESTPcodigoTipo then
								<!--- No es Mismo TESTGcodigoTipo --->
								'<img src="/cfmx/sif/imagenes/checked_none.gif" onclick="alert(''Diferente tipo de Cuenta'');"></img>'
							when mp.TESTGcodigoTipo <> 0 then
								'<input type="checkbox" name="chk" value="' #_CAT# #preservesinglequotes(LvarTESOPid)# #_CAT# '" onclick="javascript:  void(0);" style="border:none; background-color:inherit;">'
							when mp.TESTGcodigoTipo = 0 then
								case
									when ip.Bid is null then
										<!--- No hay banco --->
										'<img src="/cfmx/sif/imagenes/checked_none.gif" onclick="alert(''Falta asignar Banco'');"></img>'
									when mp.TESTGtipoCtas = 0 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0) then
										'<img src="/cfmx/sif/imagenes/checked_none.gif" onclick="alert(''Cuenta Propia de Otro Banco'');"></img>'
									when mp.TESTGtipoCtas = 1 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid) then
										'<img src="/cfmx/sif/imagenes/checked_none.gif" onclick="alert(''Sólo Cuentas Propias del mismo Banco'');"></img>'
									when mp.TESTGtipoCtas = 2 and NOT (ip.TESTPtipoCtaPropia = 0 and ip.Bid <> cb.Bid) then
										'<img src="/cfmx/sif/imagenes/checked_none.gif" onclick="alert(''Sólo Cuentas de otros Bancos'');"></img>'
									when mp.TESTGtipoCtas = 3 and NOT (ip.TESTPtipoCtaPropia = 0) then
										'<img src="/cfmx/sif/imagenes/checked_none.gif" onclick="alert(''Sólo Cuentas Interbancarias'');"></img>'
									when mp.TESTGtipoCtas = 4 and NOT (ip.TESTPtipoCtaPropia = 1 and ip.Bid = cb.Bid OR TESTPtipoCtaPropia = 0 and ip.Bid <> cb.Bid) then
										'<img src="/cfmx/sif/imagenes/checked_none.gif" onclick="alert(''Sólo Cuentas propias del mismo banco o Interbancarias de otros bancos'');"></img>'
									else
										'<input type="checkbox" name="chk" value="' #_CAT# #preservesinglequotes(LvarTESOPid)# #_CAT# '" onclick="javascript:  void(0);" style="border:none; background-color:inherit;">'
								end
						end as chk,
						op.TESOPid as ID, op.TESOPnumero, op.TESOPbeneficiario, op.Miso4217Pago, op.TESOPtotalPago
						,ip.TESTPbanco #_cat# ': ' #_cat# ip.TESTPcodigo #_cat#  case when ip.TESTPtipoCtaPropia = 1 then ' (PROPIA)' else '' end as ctaD
					 FROM TESordenPago op
						inner join TESmedioPago mp
							inner join CuentasBancos cb
								on cb.CBid = mp.CBid
							 on mp.TESid		= op.TESid
							and mp.CBid			= op.CBidPago
							and mp.TESMPcodigo 	= op.TESMPcodigo
						inner join TEStransferenciaP ip
							 on ip.TESTPid	= op.TESTPid
					 where op.TESid			= #session.Tesoreria.TESid#
					   and op.CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
					   and op.TESCFLid		IS null
					   and op.TESTLid		IS null
					   and op.TESOPestado	= 11
					   and op.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
					order by TESOPnumero
				</cfquery>
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td align="center" colspan="3">
						<strong>Lista de Ordenes de Pago enviadas a Emisión sin Lote de #GvarTEF.Accion# Asignadas</strong>
						<cfset key = 'TESOPid'>
					</td>
				</tr>  
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td colspan="3" align="center" nowrap>
					
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							checkboxes="N"
							desplegar="chk, TESOPnumero, TESOPbeneficiario, ctaD, Miso4217Pago, TESOPtotalPago"
							etiquetas=" ,N° Orden, Beneficiario, Cta.Destino, Moneda<BR>Pago, Monto<BR>Pago"
							formatos="S,S,S,S,S,M"
							ajustar="S,S,S,S,S,S"
							align="center,left,left,left,right,right"
							maxRows="15"
							showLink="no"
							incluyeForm="no"
							showEmptyListMsg="yes"
							keys="ID"
							navegacion="#navegacion#"
						/>		
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td colspan="3" align="center" nowrap>
						<input type="submit" name="btnSeleccionarOP" value="Seleccionar" tabindex="1">
					</td>
				</tr>
			<cfelseif rsForm.TESTLestado EQ "0">
				<!--- EN PREPARACION --->
				<cfif rsOPs.cantidad GT 0>
					<tr>
						<td>
							<input type="hidden" name="CBid" value="#rsForm.CBid#" tabindex="-1">
							<input type="hidden" name="TESMPcodigo" value="#rsForm.TESMPcodigo#" tabindex="-1">
							<input type="hidden" name="TESTDmsgAnulacion" id="TESTDmsgAnulacion" value="" tabindex="-1">
						</td>
					</tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td colspan="3" align="center" nowrap>
						<cfif rsOPs.cantidad GT 0>
							<input name="btnGenerar" type="submit" value="#GvarTEF.Accion2#" tabindex="1" onclick="return fnVerificaGenerar();">
							<cfif isdefined('LvarTESTGdatos')>
								<script language="javascript">
									function fnVerificaGenerar()
									{
										<cfif LvarTESTGdatos EQ "">
											return true;
										<cfelse>
											<cfloop from="1" to="#listLen(LvarTESTGdatos)#" index="i">
												if (document.form1.TESTLdatos[#i#].value == "")
												{
													alert("#listGetAt(LvarTESTGdatos,i)# no debe quedar en blanco");
													document.form1.TESTLdatos[#i#].focus()
													return false;
												}
											</cfloop>
											return true;
										</cfif>
									}
									
								</script>
							</cfif>
						</cfif>
						<input type="button" name="btnSeleccionarOP" value="Seleccionar Ordenes" onClick="location.href='#GvarTEF.TEF#.cfm?btnSeleccionarOP=1&TESTLid=#form.TESTLid#'" tabindex="1">
						<input type="submit" name="btnEliminar" value="Eliminar Lote" onClick="if (!confirm('¿Desea eliminar este Lote de #GvarTEF.Accion#?')) return false;" tabindex="1">
						<input type="button" value="Ir a Lista de Lotes" onClick="location.href='#GvarTEF.TEF#.cfm'" tabindex="1">
						<input type="submit" name="btnModificar" id="btnModificar" value="Modificar" <!---onClick="if (!confirm('¿Desea eliminar este Lote de #GvarTEF.Accion#?')) return false;"---> tabindex="1">
					</td>
				</tr>
				<cfquery name="lista" datasource="#session.dsn#">
					SELECT TESOPid as ID, TESOPnumero, TESOPbeneficiario, Miso4217Pago, TESOPtotalPago,
						'<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir la Orden de Pago de este Lote de #GvarTEF.Accion#?")) return false; location.href="TEF_sql.cfm?TEF=#GvarTEF.TEF#&btnExcluirOP=1&TESTLid=#form.TESTLid#&TESOPid=' #_Cat#
						<cf_dbfunction name="to_Char" args="TESOPid">
						#_Cat# '";''>' as Borrar
						,ip.TESTPbanco #_cat# ': ' #_cat# ip.TESTPcodigo #_cat#  case when ip.TESTPtipoCtaPropia = 1 then ' (PROPIA)' else '' end as ctaD
					 FROM TESordenPago op
						inner join TEStransferenciaP ip
							 on ip.TESTPid	= op.TESTPid
					where op.TESid	   = #session.Tesoreria.TESid#	
					  and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
					order by op.TESOPnumero
				</cfquery>
				<cfset key = 'TESOPid'>
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td colspan="3" align="center" nowrap>
					
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							desplegar="Borrar,TESOPnumero, TESOPbeneficiario, ctaD, TESOPtotalPago"
							etiquetas=" ,N° Orden, Beneficiario, Cta.Destino, Monto<BR>#replace(rsForm.monPago,",","")#"
							formatos="S,S,S,S,M"
							ajustar="N,S,S,S,S"
							align="center,left,left,left,right"
							maxRows="15"
							showLink="no"
							incluyeForm="no"
							showEmptyListMsg="yes"
							keys="ID"
							navegacion="#navegacion#"
						/>		
					</td>
				</tr>
			<cfelseif rsForm.TESTLestado EQ "1">
				<!--- EN IMPRESION/GENERACION: N/A --->
			<cfelse>
				<!--- DESPUES DE LA IMPRESION/GENERACION (no emitido) O REIMPRESION/REGENERACION YA EMITIDOS--->
				<cfif isdefined("url.Imprima")>
					<cf_popup
						url="/cfmx/sif/Utiles/cfreportesCarta.cfm?Ecodigo=#Session.Ecodigo#&FMT01COD=#rsform.FMT01COD#&Conexion=#Session.DSN#&TESid=#session.tesoreria.TESid#&CBid=#rsform.CBid#&TESTLid=#form.TESTLid#&TESMPcodigo=#rsform.TESMPcodigo#"
						link="Reporte de Factura"
						boton="false" width="800" height="600" left="0" top="0" resize="yes" ejecutar="true"
						scrollbars="yes"
					>
				<cfelseif isdefined("url.Genere")>
					<iframe src="TEF_sql.cfm?TEF=#GvarTEF.TEF#&OP=Genere&Genere=#url.Genere#&TESTLid=#form.TESTLid#" style="display:none">
					</iframe>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="3" align="center">
						<input type="hidden" name="TESTDmsgAnulacion" id="TESTDmsgAnulacion" value="">
					<cfset LvarPointer = "cursor:pointer">
					<cfif rsForm.TESTLestado EQ "2">
						<cfif rsForm.TESTLmsg EQ "OK">
							<strong><font color="##0000FF">El Resultado en el Banco corresponde con los datos registrados: Se puede emitir los Pagos.</font></strong>
							</td></tr><td align="center" colspan="3">
							<input type="submit" name="btnEmitir" value="Emitir Pagos"> 
							<input type="submit" name="btnVolver" value="Volver a Verificación"> 
							<cfset LvarPointer = "">
						<cfelseif trim(rsForm.TESTLmsg) EQ "">
							<strong><font color="##0000FF">Debe registrar y verificar el Resultado de las Transferencias en el Banco</font></strong>
							</td></tr><td align="center" colspan="3">
							<input type="submit" name="btnVerificar" value="Verificar" onclick="return sbVerificar();">
							<input type="submit" name="btnReGenerar" 	value="Re#GvarTEF.Accion2#">
						<cfelse>
							<strong><font color="##FF0000">#rsForm.TESTLmsg#</font></strong>
							</td></tr><td align="center" colspan="3">
							<input type="submit" name="btnVerificar" value="Verificar" onclick="return sbVerificar();">
							<input type="submit" name="btnReGenerar" 	value="Re#GvarTEF.Accion2#">
						</cfif>
						<input type="submit" name="btnCancelar" 	value="Volver a Preparación">
						<script language="javascript">
							function sbVerificar()
							{
								var LvarMSG = "";
								if (document.form1.TESTLtotalComision.value == "")
								{
									LvarMSG = "- Monto Comisión no puede quedar en blanco\n" + LvarMSG;
									document.form1.TESTLtotalComision.focus();
								}
								if (document.form1.TESTLtotalDebitado.value == "0.00" || document.form1.TESTLtotalDebitado.value == "")
								{
									LvarMSG = "- Monto Debitado no puede quedar en blanco\n" + LvarMSG;
									document.form1.TESTLtotalDebitado.focus();
								}
								if (document.form1.TESTLcantidad.value == "" || document.form1.TESTLcantidad.value == "0")
								{
									LvarMSG = "- Cantidad TRs Confirmadas no puede quedar en blanco\n" + LvarMSG;
									document.form1.TESTLcantidad.focus();
								}
							<cfif rsForm.TESTGtipoConfirma NEQ 1>
								if (document.form1.tipoConfirmacion.value == "M" && document.form1.TESTLreferenciaComision.value == "")
								{
									LvarMSG = "- Referencia para Comisión no puede quedar en blanco\n" + LvarMSG;
									document.form1.TESTLreferenciaComision.focus();
								}
							</cfif>
								if (!document.form1.TESTLreferencia.disabled && (document.form1.TESTLreferencia.value == "" || document.form1.TESTLreferencia.value == "0"))
								{
									LvarMSG = "- Referencia de Confirmación no puede quedar en blanco\n" + LvarMSG;
									document.form1.TESTLreferencia.focus();
								}

								if (LvarMSG != "")
								{
									alert("Se encontraron los siguientes Errores:\n" + LvarMSG);
									return false;
								}
								
								document.form1.TESTLreferencia.disabled = false;
								return true;
							}
						</script>
					</cfif>
						<input type="button" value="Ir a Lista de Lotes" onClick="location.href='#GvarTEF.TEF#.cfm'">
					</td>
				</tr>
				<tr>
					<td colspan="3" align="center" nowrap>
						<BR>
						<cfquery name="lista" datasource="#session.dsn#">
							SELECT op.TESOPid as ID, op.TESOPnumero, op.TESOPbeneficiario, op.Miso4217Pago, op.TESOPtotalPago,
								case when td.TESTDestado = 3 then
									'<img src="/cfmx/sif/imagenes/unchecked.gif" onClick="javascript:sbUncheck(this, ' #_cat# <cf_dbfunction name="to_Char" args="td.TESTDid"> #_cat# ');" style="#LvarPointer#">'
									else
									'<img src="/cfmx/sif/imagenes/checked.gif" onClick="javascript:sbUncheck(this, ' #_cat# <cf_dbfunction name="to_Char" args="td.TESTDid"> #_cat# ');" style="#LvarPointer#">'
								end as Borrar,
								'<input type="text" size="25" name="TESTDreferencia_' #_Cat# <cf_dbfunction name="to_Char" args="td.TESTDid"> #_Cat# '" value="' #_Cat# td.TESTDreferencia #_Cat# '" <cfif rsForm.TESTGtipoConfirma EQ 1>disabled style="text-align:right;border:none;"</cfif> style="text-align:right;">'
								as REFERENCIA
								,ip.TESTPbanco #_cat# ': ' #_cat# ip.TESTPcodigo #_cat#  case when ip.TESTPtipoCtaPropia = 1 then ' (PROPIA)' else '' end as ctaD
							 FROM TESordenPago op
								inner join TEStransferenciaP ip
									 on ip.TESTPid	= op.TESTPid
							 	inner join TEStransferenciasD td
									 on td.TESid 	= op.TESid
									and td.TESOPid 	= op.TESOPid
									and td.TESTLid	= op.TESTLid
							where op.TESid	   = #session.Tesoreria.TESid#	
							  and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
							order by op.TESOPnumero
						</cfquery>
						<script language="javascript">
							function sbUncheck(obj, id)
							{
							<cfif rsForm.TESTLmsg NEQ "OK">
								obj.src = "TEF_sql.cfm?TEF=#GvarTEF.TEF#&OP=NCHK&TESTDid=" + id + "&ts=" + Math.random();
							</cfif>
							}
						</script>
						<cfset key = 'TESOPid'>
							<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#lista#"
								desplegar="Borrar, TESOPnumero, TESOPbeneficiario, ctaD, TESOPtotalPago, REFERENCIA"
								etiquetas="CONF,N° Orden, Beneficiario, Cta.Destino, Monto<BR>#replace(rsForm.monPago,",","")#, No.Referencia"
								formatos="S,S,S,S,M,S"
								ajustar="S,S,S,S,S,N"
								align="left,center,left,left,left,right"
								maxRows="15"
								showLink="no"
								incluyeForm="no"
								showEmptyListMsg="yes"
								keys="ID"
								navegacion="#navegacion#"
							/>		
					</td>
				</tr>
			</cfif>
				<tr><td>&nbsp;</td></tr>  
			</table>
		</form>
	</td>
  </tr>
</table>
	</cfoutput>
</cfif>