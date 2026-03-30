<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">

<cfif isDefined("url.TESOPid") and not isDefined("form.TESOPid")>
  <cfset form.TESOPid = url.TESOPid>
</cfif> 

<cfif isDefined("Url.imprime") and not isDefined("form.imprime")>
  <cfset form.imprime = Url.imprime>
</cfif>
<cfif isdefined('form.TESOPid') and form.TESOPid NEQ ''>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsReporteTotal" datasource="#session.dsn#">
		select 
				eA.Edescripcion as EmpresaAdm
			, op.TESOPid, op.TESOPnumero, op.TESOPestado
			, op.TESOPfechaPago
			, ep.Edescripcion as EmpresaPago
			, op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as Beneficiario
			, op.TESOPtotalPago
			, mp.Mnombre as MonedaPago, mp.Miso4217 as Miso4217Pago
			, op.TESOPfechaGeneracion
			,{fn concat({fn concat({fn concat({fn concat(dpG.Pnombre , ' ' )}, dpG.Papellido1 )}, ' ' )}, dpG.Papellido2 )} as confeccionadoPor
			,op.TESOPinstruccion
			,op.TESOPobservaciones
			,coalesce(TESEdescripcion, ' ') as TESEdescripcion
			,op.CBidPago
			, case op.TESOPestado					
				when 10  then 'Preparing'

				when 101 then 'Aprobal'
				when 103 then 'Rejected'

				when 11  then 'Printing'
                when 110 then 'Printed'
				when 12  then 'Applied'
				when 13  then 'Voided'
				else 'Status Unknown'					
			end as Estado
			, case op.TESOPestado					
				when 103 then 	'REJECTED:'
				when 13  then 	'VOIDED:'
				else '&nbsp;'					
			end as Motivo1
			, case op.TESOPestado					
				when 103 then 	op.TESOPmsgRechazo
				when 13  then 	op.TESOPmsgRechazo
				else '&nbsp;'					
			end as Motivo2
			, op.TESOPfechaEmision
			,{fn concat({fn concat({fn concat({fn concat(dpE.Pnombre , ' ' )}, dpE.Papellido1 )}, ' ' )}, dpE.Papellido2 )} as emitidoPor
			, op.TESOPfechaCancelacion
			,{fn concat({fn concat({fn concat({fn concat(dpR.Pnombre , ' ' )}, dpR.Papellido1 )}, ' ' )}, dpR.Papellido2 )} as canceladoPor
			, cfBco.CFformato as CFformatoPago

			,b.Bdescripcion
			,cb.CBcodigo
			,case tmp.TESTMPtipo
				when 1 then 'Check'
				when 2 then 'Wire Transfer'
				when 3 then 'Electronic Transfer'
				when 4 then 'Manual Transfer'
				when 5 then 'Credit Card'
			end as TipoDocPago
			
			,sp.TESSPid
			,sp.TESSPnumero
			,eo.Edescripcion as EmpresaOri
			,case sp.TESSPtipoDocumento
				when 0 		then 'Manual'
				when 5 		then 'ManualCF' 
				when 1 		then 'Accounts Payable' 
				when 2 		then 'Advance payment accounts to pay' 
				when 3 		then 'Advance payment accounts To receive' 
				when 4 		then 'Advance POS' 
				when 6 		then 'Antic.GE' 
				when 7 		then 'Liqui.GE' 
				when 8		then 'Fondo.CCh' 
				when 9 		then 'Reint.CCh' 
				when 10		then 'TEF Bcos' 
				when 100 	then 'Interfaz' 
				else 'Another'
			end as TIPO
			,sp.TESSPtotalPagarOri
			,mo.Miso4217 as Miso4217Ori

			,dp.TESDPid
			,dp.TESDPidDocumento
			,cf.CFformato, dp.TESDPdescripcion, dp.TESDPmontoPago
			,tes.TESdescripcion
			,cfn.CFdescripcion, uS.Usulogin as UsuloginS, uA.Usulogin as UsuloginA
			,op.TESOPidDuplicado
			
		from TESordenPago op
			inner join Tesoreria tes
				on tes.TESid = op.TESid
			inner join Empresas eA
				on eA.Ecodigo = #session.Ecodigo#
			left join TESdetallePago dp
				inner join TESsolicitudPago sp
					left join Monedas mo
					  on mo.Mcodigo	= sp.McodigoOri
					 and mo.Ecodigo	= sp.EcodigoOri
					left join Usuario uS
					  on uS.Usucodigo = sp.UsucodigoSolicitud
					left join Usuario uA
					  on uA.Usucodigo = sp.UsucodigoAprobacion
					left join CFuncional cfn
					  on cfn.CFid = sp.CFid
				  on sp.TESid 	= dp.TESid
				 and sp.TESSPid = dp.TESSPid
				inner join Empresas eo
				  on eo.Ecodigo = dp.EcodigoOri
				inner join CFinanciera cf
					 on cf.Ecodigo  = dp.EcodigoOri
					and cf.CFcuenta = dp.CFcuentaDB
					
			  on dp.TESid 	= op.TESid
			 and dp.TESOPid = op.TESOPid

			left join TESendoso ce
				 on ce.TESid = op.TESid
				and ce.TESEcodigo = op.TESEcodigo

			left join Empresas ep
			  on ep.Ecodigo = op.EcodigoPago
			left join Monedas mp
			  on mp.Miso4217	= op.Miso4217Pago
			 and mp.Ecodigo		= op.EcodigoPago

			left join CuentasBancos cb
				inner join Bancos b
					on b.Bid = cb.Bid
				 on cb.CBid	= op.CBidPago
			left join TESmedioPago tmp
				 on tmp.TESid 		= op.TESid
				and tmp.CBid		= op.CBidPago
				and tmp.TESMPcodigo = op.TESMPcodigo
			left join CFinanciera cfBco
				 on cfBco.CFcuenta = 
				 	(
						select min(CFcuenta)
						  from CFinanciera
						 where Ccuenta =
									case when op.Ccuenta is not null 
										then op.Ccuenta
										else cb.Ccuenta
									end
					)
			inner join Usuario uG
				inner join DatosPersonales dpG
					on dpG.datos_personales=uG.datos_personales
				on uG.Usucodigo=op.UsucodigoGenera
		
			left join Usuario uR
				inner join DatosPersonales dpR
					on dpR.datos_personales=uR.datos_personales
				on uR.Usucodigo=op.UsucodigoCancelacion

			left join Usuario uE
				inner join DatosPersonales dpE
					on dpE.datos_personales=uE.datos_personales
				on uE.Usucodigo=op.UsucodigoEmision
		where op.TESid = #session.tesoreria.TESid#
		  and op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#" null="#form.TESOPid EQ ""#">
		order by sp.TESSPnumero
	</cfquery>	
	 <!---<cfdump var="#rsReporteTotal#"> --->

	<cfquery name="rsSQL" dbtype="query">
		select distinct TESSPid from rsReporteTotal
	</cfquery>
	<cfset LvarRecordCount = rsReporteTotal.recordCount + rsSQL.recordCount>
</cfif>

<cfquery name="rsNombreUsuario" datasource="#session.dsn#">
	select Pnombre, Papellido1, Papellido2
	from Usuario u
		inner join DatosPersonales dp
		on dp.datos_personales = u.datos_personales
	where Usulogin = '#rsReporteTotal.UsuloginS#'
	  and CEcodigo = #session.CEcodigo#
</cfquery>

<cfset LvarNombreSolicitante = rsReporteTotal.UsuloginS> 
<cfif rsNombreUsuario.recordcount GT 0>
	<cfset LvarNombreSolicitante = rsNombreUsuario.Pnombre & " " & rsNombreUsuario.Papellido1> 
</cfif>

<cfset LvarMontoPago = LvarObj.fnMontoEnLetras(rsReporteTotal.TESOPtotalPago, 1, 'en')>
<cfset LvarMontoPago = LvarMontoPago & "  #rsReporteTotal.MonedaPago# (#LSNumberFormat(rsReporteTotal.TESOPtotalPago,',9.00')# #rsReporteTotal.Miso4217Pago#s)">

<cfoutput>	
<cfif isdefined('rsReporteTotal') and rsReporteTotal.recordCount GT 0>
	<!--- <cfdocument format="pdf"> --->
	 <style type="text/css">
		<!--
		.style1 {
			font-size: 14px;
			font-weight: bold;
			font-family: Arial, Helvetica, sans-serif;
		}
		.style4 {font-size: 11px}
		.style7 {font-size: 11px; font-weight: bold; }
		.style8 {
			font-family: Arial, Helvetica, sans-serif;;
			font-size: 10px;
		}
		-->
		</style>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="15%">&nbsp;</td>
			<td width="65%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="4" align="center"><span class="style1">PAYMENT INSTRUCTION</span></td>
		</tr>
		<tr>
			<td colspan="4" align="center"><strong>#rsReporteTotal.TESdescripcion#</strong></td>
		</tr>
		<tr>
			<td colspan="2"></td>
			<td nowrap align="left"><strong>Consecutive No:</strong></td>
			<td nowrap align="left"><span class="style1">#rsReporteTotal.TESOPnumero#</span></td>
		</tr>
		<tr>
			<td colspan="2"></td>
			<td nowrap align="left"><strong>Date issued:</strong></td>
			<td nowrap align="left">#LSDateFormat(rsReporteTotal.TESOPfechaGeneracion,'MM/DD/YYYY')#</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td nowrap><strong>Paid to: &nbsp;</strong></td>
			<td colspan="3">#rsReporteTotal.Beneficiario#</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="left"><strong>Amount:</strong></td>
			<td align="left" colspan="3">
			<cfif rsReporteTotal.TESOPtotalPago NEQ "">#LvarMontoPago#</cfif>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td><strong>Date Due:</strong></td>
			<td colspan="3">#DateFormat(rsReporteTotal.TESOPfechaPago,"MM/DD/YYYY")#</td>
		</tr>
  		<tr>
			<td>&nbsp;</td>
		</tr>
		<cfif rsReporteTotal.Bdescripcion NEQ "">
			<tr>
				<td nowrap valign="top"><strong>Bank: </strong></td>
				<td nowrap colspan="3">
					#rsReporteTotal.Bdescripcion#
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</cfif>
		<cfif rsReporteTotal.CBcodigo NEQ "">
			<tr>
				<td nowrap valign="top"><strong>Account:&nbsp;</strong></td>
				<td nowrap colspan="3">
					#rsReporteTotal.CBcodigo#
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</cfif>
		<cfif rsReporteTotal.TipoDocPago NEQ "">
			<tr>
				<td nowrap valign="top" colspan="1" style="width:1%"><strong>Payment by: &nbsp;</strong>&nbsp;</td>
				<td colspan="3">#rsReporteTotal.TipoDocPago#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</cfif>
	
	<cfif rsReporteTotal.Motivo1 NEQ "&nbsp;">
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="4" style="padding-left:100px; padding-right:100px">
				<table width="100%"  border="0" cellspacing="1" cellpadding="1" style="border:solid 1px gray;">
					<tr>
						<td bgcolor="##E4E4E4" style="border-bottom:solid 1px gray; padding-left:2px; padding-right:20px;">
							<strong>#rsReporteTotal.Motivo1#</strong>
						</td>
					</tr>
					<tr>
						<td style="padding-left:20px; padding-right:20px;">
							#rsReporteTotal.Motivo2#
						</td>
					</tr>
					<tr>
						<td style="border-top:solid 1px gray; padding-left:2px; padding-right:2px;">
							<strong>by:&nbsp;</strong>#rsReporteTotal.canceladoPor#
							<cfif rsReporteTotal.TESOPfechaCancelacion NEQ "">
								, #dateFormat(rsReporteTotal.TESOPfechaCancelacion,"MM/DD/YYYY")# #LStimeFormat(rsReporteTotal.TESOPfechaCancelacion)#
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfif>			
	</table>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="caja">
		  <tr>
			<td style="width:100%">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td nowrap bgcolor="##E4E4E4" align="center" style="width:8%; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right: solid 1px gray;"><span class="style7">GL ACCOUNT </span></td>
					<td bgcolor="##E4E4E4" align="center" style="width:68%; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right: solid 1px gray;"><span class="style7">DETAIL</span></td>
					<td bgcolor="##E4E4E4" align="center" style="width:12%; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right: solid 1px gray;"><span class="style7">DEBIT</span></td>
					<td bgcolor="##E4E4E4" align="center" style="width:12%; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;border-right: solid 1px gray;"><span class="style7">CREDIT</span></td>
				  </tr>
				<cfset LvarTESSPid = "">
				<cfset LvarCurrentRow = 1>
				<cfloop query="rsReporteTotal">
					<cfif LvarTESSPid NEQ rsReporteTotal.TESSPid>
						<cfset LvarTESSPid = rsReporteTotal.TESSPid>
						<cfset LvarListaNon = (LvarCurrentRow MOD 2)>
						<cfset LvarCurrentRow = LvarCurrentRow + 1>
					</cfif>						
					<cfif rsReporteTotal.TIPO EQ "Accounts Payable">
						<!--- Datos del encabezado del documento de CxP --->
						<cfset LvarListaNon = (LvarCurrentRow MOD 2)>
						<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
							<td align="left">
								&nbsp;&nbsp;
								<span class="style8">#rsReporteTotal.CFformato#</span>
							</td>
							<td align="left">
								<span class="style8">#rsReporteTotal.TESDPdescripcion#&nbsp;#rsReporteTotal.EmpresaOri#</span>
							</td>
							<cfif rsReporteTotal.TESDPmontoPago EQ "">
								<td nowrap align="right">
									<span class="style8">???</span>&nbsp;&nbsp;
								</td>
								<td align="right" style="border-right: solid 1px gray;">&nbsp;
									
								</td>
							<cfelseif rsReporteTotal.TESDPmontoPago GT 0>
								<td nowrap align="right">
									<span class="style8">#LSNumberFormat(rsReporteTotal.TESDPmontoPago,',9.00')#</span>&nbsp;&nbsp;
								</td>
								<td align="right" style="border-right: solid 1px gray;">&nbsp;
									
								</td>
							<cfelse>
								<td nowrap align="right">&nbsp;</td>
								<td align="right" style="border-right: solid 1px gray;">
									<span class="style8">#LSNumberFormat(Abs(rsReporteTotal.TESDPmontoPago),',9.00')#</span>&nbsp;&nbsp;
								</td>
							</cfif>
						</tr>
					
					
						<!--- Aqui hay que hacer un cfquery y un cfloop para llegar a pintar los datos --->
						<cfif len(trim(rsReporteTotal.TESDPidDocumento))>
							<cfquery name="rsCxP" datasource="#session.DSN#">
								select a.Dtotal as Total
								from HEDocumentosCP a
								where a.IDdocumento = #rsReporteTotal.TESDPidDocumento#
							</cfquery>

							<cfset LvarFactor = 1.00>
							<cfif rsReporteTotal.TESDPmontoPago NEQ rsCxP.Total and rsCxP.Total GT 0>
								<cfset LvarFactor = rsReporteTotal.TESDPmontoPago / rsCxP.Total>
							</cfif>
						
							<cfquery name="rsCxP" datasource="#session.DSN#">
								select 
									1 as orden,
									c.CFformato, 
									c.CFdescripcion as Descripcion,
									sum( round( round(( b.DDtotallin + case when Icreditofiscal = 0 then b.DDtotallin  * (i.Iporcentaje / 100)  else 0 end ) , 2) * #LvarFactor#, 2) ) as SumaLineas
								from HEDocumentosCP a
								 inner join HDDocumentosCP b
								   on b.IDdocumento = a.IDdocumento
								 inner join CFinanciera c
								   on c.Ccuenta = b.Ccuenta
								 inner join Impuestos i
								   on i.Ecodigo = b.Ecodigo
								  and i.Icodigo = b.Icodigo
								where a.IDdocumento = #rsReporteTotal.TESDPidDocumento#
								group by CFformato, CFdescripcion
								
								union

								select 
									2 as orden,
									coalesce(bid.CFformato, bi.CFformato), 
									coalesce(bid.CFdescripcion, bi.CFdescripcion),
									sum( round( (b.DDtotallin * (coalesce(di.DIporcentaje, i.Iporcentaje) /100) ),2) * #LvarFactor# ) as SumaLineas
									
								from  HEDocumentosCP a 
									inner join HDDocumentosCP b
										 inner join Impuestos i
												left outer join DImpuestos di
												   on di.Ecodigo = i.Ecodigo
												  and di.Icodigo = i.Icodigo
												  and di.DIcreditofiscal = 1
												 left outer join CFinanciera bid
												   on di.Ccuenta = bid.Ccuenta
										  on i.Ecodigo = b.Ecodigo
										  and i.Icodigo = b.Icodigo
										  and i.Icreditofiscal = 1

										 inner join CFinanciera bi
												 on i.Ccuenta = bi.Ccuenta
									on b.IDdocumento = a.IDdocumento
								where a.IDdocumento = #rsReporteTotal.TESDPidDocumento#
								
								group by coalesce(bid.CFformato, bi.CFformato), 
										 coalesce(bid.CFdescripcion, bi.CFdescripcion)
								order by orden, CFformato
							</cfquery>
						</cfif>

						<cfif isdefined("rsCxP") and len(trim(rsCxP.CFformato))>
							<cfquery name="rsCxPTotal" dbtype="query">
								select sum(SumaLineas) as SumaLineas
								from rsCxP
							</cfquery>
							
							<cfset LvarDiferencia = rsReporteTotal.TESDPmontoPago - rsCxPTotal.SumaLineas>
							<cfloop query="rsCxP">
								<tr>
									<td align="right" class="style8">&nbsp;*</td>
									<td>
										<table border="0" cellpadding="1" cellspacing="1" style="width:100%">
											<tr>
												<td align="left" class="style8" style="width:40%" nowrap="nowrap">
													&nbsp;&nbsp;
													#CFformato#
												</td>
												<td align="left" class="style8" style="width:40%" nowrap="nowrap">
													#Descripcion#&nbsp;
												</td>
												<cfif SumaLineas NEQ 0>
													<td nowrap align="right" class="style8" style="width:20%" nowrap="nowrap">
														#LSNumberFormat(SumaLineas + LvarDiferencia,',9.00')#&nbsp;&nbsp;
													</td >
												</cfif>
											</tr >
										</table>
									</td>
									<td>&nbsp;</td>
									<td style="border-right: solid 1px gray">&nbsp;</td>
								</tr>
								<cfset LvarDiferencia = 0.00>
							</cfloop> 
						</cfif>
					<cfelse>
						<cfset LvarListaNon = (LvarCurrentRow MOD 2)>
						<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
							<td align="left">
								&nbsp;&nbsp;
								<span class="style8">#rsReporteTotal.CFformato#</span>
							</td>
							<td align="left">
								<span class="style8">#rsReporteTotal.TESDPdescripcion#&nbsp;#rsReporteTotal.EmpresaOri#</span>
							</td>
							<cfif rsReporteTotal.TESDPmontoPago EQ "">
								<td nowrap align="right">
									<span class="style8">???</span>&nbsp;&nbsp;
								</td>
								<td align="right" style="border-right: solid 1px gray;">&nbsp;
									
								</td>
							<cfelseif rsReporteTotal.TESDPmontoPago GT 0>
								<td nowrap align="right">
									<span class="style8">#LSNumberFormat(rsReporteTotal.TESDPmontoPago,',9.00')#</span>&nbsp;&nbsp;
								</td>
								<td align="right" style="border-right: solid 1px gray;">&nbsp;
									
								</td>
							<cfelse>
								<td nowrap align="right">&nbsp;</td>
								<td align="right" style="border-right: solid 1px gray;">
									<span class="style8">#LSNumberFormat(Abs(rsReporteTotal.TESDPmontoPago),',9.00')#</span>&nbsp;&nbsp;
								</td>
							</cfif>
						</tr>				  
					</cfif>
					<cfset LvarCurrentRow = LvarCurrentRow + 1>
				</cfloop>		  
					<tr class=<cfif LvarListaNon+1>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
						<td colspan="4" align="left" style="border-top:solid 1px gray;border-right:solid 1px gray;">
							<strong>
								<span class="style8">
									Paid by: 
									#rsReporteTotal.EmpresaPago#
								</span>
							</strong>
						</td>
					<tr>
				  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon + 1>listaNon<cfelse>listaPar</cfif>';">
					<td colspan="2" nowrap="nowrap">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<span class="style8">#rsReporteTotal.CFformatoPago#</span>
					</td>
					<td>&nbsp;</td>
					<td nowrap style="border-right: solid 1px gray;" class="style8" align="right">#LSNumberFormat(rsReporteTotal.TESOPtotalPago,',9.00')#&nbsp;</td>
				  </tr>			

				<cfif LvarRecordCount LT 20>
					<cfloop index = "LoopCount" from = "1" to = "#21 - LvarRecordCount#">
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td style="border-right: solid 1px gray;">&nbsp;</td>
					  </tr>			
					</cfloop>
				</cfif>
				</table>
			</td>
		  </tr>
		</table>		
		
		
		<table width="100%"  border="0" cellspacing="2" cellpadding="2">
			<tr>
				<td nowrap><strong>Prepared by:</strong></td>
				<td nowrap>&nbsp;</td>
				<td nowrap><strong>Reviewed by:</strong></td>
				<td nowrap>&nbsp;</td>
				<td nowrap><strong>Approved by:</strong></td>
				<!---<td nowrap><strong>Authorized by:&nbsp;</strong></td>--->
			</tr>
			<tr>
				<td colspan="5">&nbsp;</td>
			</tr>
			<tr>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;">#LvarNombreSolicitante#</td>
				<td nowrap>&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;">#rsVerifica.TESOPRevisado#</td>
				<td nowrap>&nbsp;</td>
				<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;">#rsVerifica.TESOPAprobado#</td>
				<!---<td style="border-top-width: 1px; border-top-style: solid; border-top-color: gray;">#rsVerifica.TESOPRefrendado#</td>--->
			</tr>
			<tr>
				<td colspan="3" align="left"><strong>Date:</strong>&nbsp;#DateFormat(rsReporteTotal.TESOPfechaGeneracion,'MM/DD/YYYY')#</td>
				<td colspan="2" align="right"><strong>Time:</strong>&nbsp;#TimeFormat(rsReporteTotal.TESOPfechaGeneracion)#</td>
			</tr>
		</table>
		<!--- </cfdocument> --->
<cfelse>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		Select count(1) as cantidad
		  from TESsolicitudPago sp
		 where sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 		   and sp.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#" null="#form.TESOPid EQ ""#">	
	</cfquery>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>	  
		<tr>
			<cfif rsSQL.cantidad EQ 0>
				<td align="center"><strong>Empty list</strong></td>
			</cfif>
		</tr>	  
		<tr>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr>
		  <td align="center">&nbsp;</td> 
		</tr>				  
	</table>
</cfif>
</cfoutput>
