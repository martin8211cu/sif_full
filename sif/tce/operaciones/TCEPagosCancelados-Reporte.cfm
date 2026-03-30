<cfif modo EQ "CAMBIO"  >
	<cfif isdefined("Form.CBPTCid")>	
		<cfquery name="rsForm" datasource="#Session.DSN#">
			select
			 p.CBPTCdescripcion
			,p.CBPTCfecha 
			,p.CBid
			,p.TESMPcodigo
            ,p.TESBid
            ,p.TESTPid
            ,p.CBPTCtipocambio
            ,p.CBPTCestatus
			from CBEPagoTCE p
				inner join CuentasBancos cb
					on cb.CBid = p.CBid
				inner join Bancos b
					on b.Bid = cb.Bid
			where p.CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
		</cfquery>
        
        <cfquery name="rsDetalle" datasource="#Session.DSN#">
            select count (1) as totalD
            from CBDPagoTCEdetalle cbd
                inner join CuentasBancos cb
                on cb.CBid = cbd.CBid
                inner join Monedas m
                on m.Mcodigo = cb.Mcodigo
            where CBPTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
        </cfquery>
        
        <cfquery name="rsBancos" datasource="#Session.DSN#">
            select
            b.Bid
            from TESbeneficiario bb
                inner join Bancos b
                    on b.Bid = bb.Bid
            where bb.TESBid = #rsForm.TESBid#
        </cfquery>
    </cfif>
</cfif>	
<cfquery name="rsCDestino" datasource="#Session.DSN#">
	select 	TESTPid,
			TESid,
			TESTPcuenta as TESTPcuentab, 
			Mnombre,
            a.TESBid, 
			coalesce(a.Bid,0) as Bid,
			a.Miso4217
	from TEStransferenciaP a
		left join Pais p
			on p.Ppais = a.Ppais
		inner join Monedas m
			on m.Miso4217 = a.Miso4217
			and m.Ecodigo = #session.Ecodigo#
	where TESTPestado < 2
    and coalesce(TESBid,0) <> 0  
    <cfif modo EQ "CAMBIO" and #rsDetalle.totalD# gt 0>
    	and a.TESBid = #rsForm.TESBid# 
    	and a.Miso4217 = (Select Miso4217
    					from TEStransferenciaP
                        where TESTPid = #rsForm.TESTPid#
    					)
    </cfif>
</cfquery>
<cfquery name="rsEmisoresTCE" datasource="#session.DSN#">
	select b.Bid, bb.TESBid, b.Bdescripcion
	  from TESbeneficiario bb
		inner join Bancos b 
			on b.Bid = bb.Bid
	  where b.Ecodigo = #session.Ecodigo#
		and (
			select count(1)
			  from CuentasBancos
			 where Bid = b.Bid
			   and CBesTCE = 1
			) > 0
      <cfif modo EQ "CAMBIO" and #rsDetalle.totalD# gt 0>
      	and bb.TESBid = #rsForm.TESBid#
      </cfif>
</cfquery>


<cf_templateheader title="Pagos de Tarjetas de Credito Cancelados">
	<cf_web_portlet_start _start titulo="Pagos emitidos como Cancelados">

		<cf_navegacion name="Usucodigo" default="" navegacion="">

		<table width="100%" align="center" border="0">
			<tr>
				<td valign="top" align="center" width="50%">
					
					<table width="100%" cellpadding="2" cellspacing="0" border="0">
				
<!---==============================--->
<!---DESCRIPCION & FECHA--->
<!---==============================--->
						<tr>
							<!---Descripción--->
							<td><b>Descripci&oacute;n:</b></td>
							<td width="60%">
								
								<input type="text" name="Descripcion" id="Descripcion" size="60" maxlength="255" tabindex="-1"
									value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.CBPTCdescripcion#</cfoutput></cfif>" alt="La Descripci&oacute;n" readonly="yes" >
									  
							</td>
							<!---Fecha--->
							<td width="15%"><b>Fecha Solicitada:</b></td>
							<td>
								<cfoutput>
									<cfif modo EQ "CAMBIO">
										<cfset fechaSolicitada = "#LSDateFormat(rsForm.CBPTCfecha,'DD/MM/YYYY')#">
										<input type="text" name="fechaSolicitada" value="#LSDateFormat(rsForm.CBPTCfecha,'DD/MM/YYYY')#" readonly="yes"/>
									</cfif>
								</cfoutput>
							</td>	
						</tr>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
					</table>
					
				</td>
			</tr>
			
<!---==============================--->
<!---TB CUENTA BANCARIA ORIGEN--->
<!---==============================--->			
			<tr>
				<td height="33%" colspan="8" class="tituloAlterno">Cuenta Bancaria Origen</td>
			</tr>
			<tr>
				<td>
					<table width="100%" cellpadding="2" cellspacing="0">
						 
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
						<tr>
							<td><b>Cuenta de Pago:</b></td>
							<td width="85%">
								<cfif modo eq 'CAMBIO' and not isdefined("form.cambioMP")><cfset cuentaorigen = #rsForm.CBid#></cfif>
								<cf_cboTESCBid name="CBidOri" value="#cuentaorigen#" Dcompuesto="yes" Ccompuesto="yes" none="yes" tabindex="1" disabled="yes">
							</td>
						</tr>
						
						<tr>
							<td><b>Medio de Pago:</b></td>
							<td>
							<!---====Medio de Pago===--->						
								<cfset session.tesoreria.TESMPcodigo = "">		
								<cfif modo eq 'CAMBIO'>
									<cf_cboTESMPcodigo name="TESMPcodigo"  value="#rsForm.TESMPcodigo#" CBidValue="#listFirst(cuentaorigen)#"  NoChks="true" disabled="yes">
								</cfif>
							</td>
						</tr>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
					</table>
				</td>
			</tr>
			
<!---==============================--->
<!---2.TB CUENTA BANCARIA DESTINO--->
<!---==============================--->
			
			<tr>
        	<td height="33%" colspan="8" class="tituloAlterno">Cuenta Bancaria Destino</td>
		</tr>
		<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<!---====Emisor===--->
							<td><b>Emisor:</b></td>
							<td width="50%">
								<select name="Emisor" tabindex="1" disabled="yes">
									<option value="">--- Seleccione un Banco---</option>
									<cfoutput query="rsEmisoresTCE">
										<option value="#rsEmisoresTCE.TESBid#" <cfif modo NEQ "ALTA" and (rsEmisoresTCE.TESBid EQ rsForm.TESBid)>selected</cfif>>#rsEmisoresTCE.Bdescripcion#</option>
									</cfoutput>
								</select>
								
							</td>
							<!---====Tipo de Cambio===--->
							<td><b>Tipo de Cambio:</b></td>
							<td>
								<cfoutput>
									<input 	type="text" name="TESTIDtipoCambioDst" id="TESTIDtipoCambioDst" 
										value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsForm.CBPTCtipocambio, '9.9999')#<cfelse>1.0000</cfif>" 
										size="18" class="Bloqueado" readonly="yes" tabindex="-1"
									>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<!---====Cuenta Destino===--->
							<td><b>Cuenta Destino:</b></td>
	                        <td >					
								<select name="CtaDestino" tabindex="1" disabled="yes">
                                	<cfif modo EQ "CAMBIO" and not isdefined("form.cambioMP")>
                                    	<cfoutput query="rsCDestino">
                                        	<option onclick="cambiar_Banco();" value="#rsCDestino.TESTPid#" <cfif modo NEQ "ALTA" and (rsCDestino.TESTPid EQ rsForm.TESTPid)>selected</cfif>>#rsCDestino.Mnombre# - #rsCDestino.TESTPcuentab#</option>
                                    	</cfoutput>
¿                                    </cfif>
                                </select>
							</td>
                            <td><b>Total a Pagar:</b></td>
							<td>
                            	<cfif modo neq 'ALTA'>
                                <cfquery name="rsTCEsuma" datasource="#Session.DSN#">
                                    select coalesce(sum(CBDPTCmonto),0) as total
                                    from CBDPagoTCEdetalle 
                                    where CBPTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
                                </cfquery> 
                                <cfset totalPag = #rsTCEsuma.total# / #LSNumberFormat(rsForm.CBPTCtipocambio, '9.9999')#>
                                </cfif>
                                <input 	type="text" name="montot" id="montot" 
									value="<cfif modo neq 'ALTA'><cfoutput>#totalPag#</cfoutput><cfelse>0</cfif>" 
									size="18" class="Bloqueado" readonly="yes" tabindex="-1">
                                
							</td>
						</tr>
				</table>
			</td>
		</tr>
			
<!---==============================--->
<!---3.BOTONES--->
<!---==============================--->
		
		<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
                        <td align="center">
                            <input type="button" value="Ir a Lista" onClick="location.href='TCEPagosCancelados.cfm'" tabindex="1">
                        </td>	
                    </tr>
				</table>
			</td>
		</tr>
		

		<tr><td>&nbsp;</td>
        <cfif modo eq "CAMBIO">
        <tr>
				<!---==============================--->
                <!---3.DETALLE DEL DOCUMENTO--->
                <!---==============================--->
			<td height="33%" colspan="8" class="tituloAlterno">Detalle Del Documento</td>
		</tr>
		<tr>
        	
			<td>
				<table width="100%" cellpadding="2" cellspacing="0">
					<!---TB DETALLE--->
					<tr>
						<td>
							</table>
									<cfquery name="rsTCEdetalle" datasource="#Session.DSN#">
										select cbd.CBDPTCid, cb.CBdescripcion, cb.CBid, m.Mnombre, (CBDPTCmonto/CBDPTCtipocambio) as monto,CBDPTCmonto, CBDPTCtipocambio
										from CBDPagoTCEdetalle cbd
										inner join CuentasBancos cb
										on cb.CBid = cbd.CBid
										inner join Monedas m
										on m.Mcodigo = cb.Mcodigo
										where 
										CBPTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
									</cfquery>  
							
							   <cfset totalDet = 0>            
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>&nbsp;</tr>
								<tr class="subTitulo">
									<td >&nbsp;</td> 
									<td bgcolor="E2E2E2" ><strong>&nbsp;Estado Cuenta&nbsp;</strong></td> 
									<td bgcolor="E2E2E2" ><strong>Moneda&nbsp;</strong></td>
									<td bgcolor="E2E2E2" align="center"><strong>Monto&nbsp;</strong></td>
									<td bgcolor="E2E2E2" align="center"><strong>Tipo Cambio&nbsp;</strong></td>
									<td bgcolor="E2E2E2" align="center"><strong>Monto Moneda de Pago&nbsp;</strong></td>
									<td bgcolor="E2E2E2" >&nbsp;</td>
									<td >&nbsp;</td>
								</tr>
								<cfif rsTCEdetalle.RecordCount gt 0>							
									<cfoutput query="rsTCEdetalle"> 
										<tr <cfif rsTCEdetalle.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td bgcolor="F7F9FA">&nbsp;</td> 
											<td>#rsTCEdetalle.CBdescripcion#</td>
											<td >#rsTCEdetalle.Mnombre#</td>
											<td align="center">#LSCurrencyFormat(rsTCEdetalle.monto,'none')#</td>
											<td align="center">#rsTCEdetalle.CBDPTCtipocambio#</td>
											<td align="center">#LSCurrencyFormat(rsTCEdetalle.CBDPTCmonto,'none')#</td>
											<td bgcolor="F7F9FA">&nbsp;</td>
										</tr>
										<cfset totalDet = totalDet + #rsTCEdetalle.CBDPTCmonto# >
								  </cfoutput>
									<tr>
										<td>&nbsp;</td> 
										<td>&nbsp;</td> 
										<td>&nbsp;</td> 
										<td>&nbsp;</td> 
										<td align="center"><strong>TOTAL:&nbsp;</strong></td>
										<td align="center"><cfoutput>#LSCurrencyFormat(totalDet,'none')#</cfoutput></td>
									</tr>
								<cfelse>
									<tr>
										<td align="center" colspan="8">--- No se encontraron datos ----</td>
									</tr>
								</cfif>
							</table>
						</td>
					</tr>
				</cfif>
		</table>
	<cf_web_portlet_start _end>
<cf_templatefooter>