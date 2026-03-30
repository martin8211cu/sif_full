<!--- Pone -1 al valor de la caja --->
<cfif not isdefined("form.FCid")>
	<cfset form.FCid = -1 >
</cfif>
<cfif isdefined("form.pFCid")>
	<cfset form.FCid = form.pFCid >
</cfif>

<cfquery name="rsCajas" datasource="#session.DSN#">
	select distinct convert( varchar, a.FCid) as FCid, FCcodigo, FCdesc
	from ETransacciones a, FCajas b
	where FACid is null
	  and ETestado = 'T'
	  and a.FCid=b.FCid
</cfquery>

<!--- Saca el cierre pendiente para esta caja --->
<cfquery name="rsCierre" datasource="#session.DSN#">
	select convert(varchar, max(FACid)) as FACid
	from FACierres
	where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
	and FACestado='T'
</cfquery>

<cfquery name="rsCaja" datasource="#session.DSN#">
	select FCcodigo, FCdesc
	from FCajas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
</cfquery>

<!--- Calula los montos globales, por monedas y tipos--->
<cfinclude template="CalculoMontosSis.cfm">

<link type="text/css" rel="stylesheet" href="../../css/sif.css" >
<link type="text/css" rel="stylesheet" href="consola.css" >
<style type="text/css">
	.sectionTitle {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		border: 1px solid #CCCCCC;
	}

	.sectionDiv {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		border: 1px solid #000000;
	}
	
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}

	.bottomline2 {
		border-bottom-style: solid;
		border-bottom-width: 1px;
		border-bottom-color: #CCCCCC;

		border-right-style: solid;
		border-right-width: 1px;
		border-right-color: #CCCCCC;

		border-top-style: solid;
		border-top-width: 1px;
		border-top-color: #CCCCCC;
		
		border-left-style: solid;
		border-left-width: 1px;
		border-left-color: #CCCCCC;
	}

	.bottomlineTR {
		border-bottom-style: solid;
		border-bottom-width: 1px;
		border-bottom-color: #CCCCCC;
	}
	
	.letra {  font-size:10pt; }
	.letra2 {  font-size:10pt; text-indent:10; }
	.fletra {  color:#FF0000; }
	.fletra2 {  font-size:10pt; color:#FF0000; text-indent:10; }
	
</style>

<script language="JavaScript1.2" type="text/javascript">
    function fnMinMax(tr, img){
		var tr  = document.getElementById(tr);
		var img = document.getElementById(img);
		
		if ( tr.style.display != "none" ){
			tr.style.display = "none";
			img.src = '/cfmx/sif/imagenes/w-max.gif';			
		}
		else{
			tr.style.display = ""
			img.src = '/cfmx/sif/imagenes/w-close.gif';
		}
	}
	
	function regresar(){
		document.form1.action = "/cfmx/sif/fa/MenuFA.cfm";
		document.form1.submit();
	}
	
	function caja(){
		document.form2.submit();
	}
	
</script>

<form method="post" name="form2" action="">
	<table border="0" width="100%">
		<tr>
			<td align="right" width="1%" nowrap>Caja:&nbsp;</td>
			<td>
				<select name="pFCid" onChange="javascript:caja();">
					<option value="-1" >-- Seleccionar Caja --</option>
					<cfoutput query="rsCajas" >
						<option value="#rsCajas.FCid#" <cfif isdefined("form.FCid") and form.FCid eq rsCajas.FCid >selected</cfif> >#rsCajas.FCcodigo#, #rsCajas.FCdesc#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
	</table>
</form>

<form method="post" name="form1" action="SQLCierreCajaSis.cfm">
<CF_sifHTML2Word Titulo="Cierre de Caja">
<table border="0" cellpadding="0" cellspacing="0" width="100%" >
	<cfif rsCierre.RecordCount gt 0 and len(trim(rsCierre.FACid)) gt 0>
		<tr><td>&nbsp;</td></tr>	
		<tr><td align="center" class="sectionTitle"><font size="3"><b>Reporte de Cierre de Caja<br><cfoutput>#Trim(rsCaja.FCcodigo)#, #rsCaja.FCdesc#</cfoutput></b></font></td></tr>
	
		<tr>
			<td align="center"><b>Fecha de Cierre:</b> <cfoutput>#LSDateFormat(Now(),'dd/mm/yy')#</cfoutput></td>
		</tr>
		<tr>
			<td align="center"><b>Hora de Cierre:</b> <cfoutput>#LSTimeFormat(Now(),'hh:mm:sstt')#</cfoutput></td>
		</tr>
		<tr>
			<td align="center"><b>Usuario:</b> <cfoutput>#session.usuario#</cfoutput></td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<table width="85%" align="center" border="0" class="bottomline2" cellpadding="0" cellspacing="0">
					<cfloop query="rsMonedasTran">
						<tr class="tituloAlterno">
							<td align="left" class="letra"><b><cfoutput>#get_moneda(rsMonedasTran.Mcodigo)#</cfoutput></b></td>
							<td align="right" class="letra"><b>Sistema</b></td>
							<td align="right" class="letra"><b>Usuario</b></td>
						</tr>
	
						<!--- calculo de datos del sistema --->
						<cfset sis_contado  = monto_tran(#rsMonedasTran.Mcodigo#,'sum(ETtotal)', '-1', '' ) >
						<cfset sis_fcredito = monto_tran(#rsMonedasTran.Mcodigo#,'sum(ETtotal)', '1', 'D' ) >
						<cfset sis_ncredito = monto_tran(#rsMonedasTran.Mcodigo#,'sum(ETtotal)', '1', 'C' ) >
						<cfset sis_credito  = sis_fcredito - sis_ncredito >
						<cfset sis_total    = sis_contado + sis_credito >
		
						<!--- calculo de datos dados por el usuario --->
						<cfset usu_contado  = monto_usu(#rsMonedasTran.Mcodigo#,'sum(FADCcontado)') >
						<cfset usu_fcredito = monto_usu(#rsMonedasTran.Mcodigo#,'sum(FADCfcredito)') >
						<cfset usu_ncredito = monto_usu(#rsMonedasTran.Mcodigo#,'sum(FADCncredito)') >
						<cfset usu_credito  = usu_fcredito - usu_ncredito >
						<cfset usu_total    = usu_contado + usu_credito >
		
						<!--- Montos de Contado --->
						<tr class="listaNon">
							<td nowrap <cfif sis_contado neq usu_contado >class="fletra2"<cfelse>class="letra"</cfif> >Contado</td>
							<td nowrap align="right" <cfif sis_contado neq usu_contado >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(sis_contado,'none')#</cfoutput></td>
							<td nowrap align="right" <cfif sis_contado neq usu_contado >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(usu_contado,'none')#</cfoutput></td>
						</tr>

						<!--- Facturas de Credito --->
						<tr class="listaNon">
							<td nowrap <cfif sis_fcredito gt usu_fcredito >class="fletra2"<cfelse>class="letra2"</cfif> >Facturas de Cr&eacute;dito</td>
							<td nowrap align="right" <cfif sis_fcredito neq usu_fcredito >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(sis_fcredito,'none')#</cfoutput></td>
							<td nowrap align="right" <cfif sis_fcredito neq usu_fcredito >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(usu_fcredito,'none')#</cfoutput></td>
							<cfoutput>
								<input type="hidden" name="FADCcontadosis_#rsMonedasTran.Mcodigo#" value="#sis_contado#">
								<input type="hidden" name="FADCfcreditosis_#rsMonedasTran.Mcodigo#" value="#sis_fcredito#">
							</cfoutput>
						</tr>
		
						<!--- Notas de Credito --->
						<tr class="listaPar">
							<td nowrap <cfif sis_ncredito neq usu_ncredito >class="fletra2"<cfelse>class="letra"</cfif> >Notas de Cr&eacute;dito</td>
							<td nowrap align="right" <cfif sis_ncredito neq usu_ncredito >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(sis_ncredito,'none')#</cfoutput></td>
							<td nowrap align="right" <cfif sis_ncredito neq usu_ncredito >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(usu_ncredito,'none')#</cfoutput></td>
							<cfoutput><input type="hidden" name="FADCncreditosis_#rsMonedasTran.Mcodigo#" value="#sis_ncredito#"></cfoutput>
						</tr>
						<tr><td><input type="hidden" name="Mcodigo" value="<cfoutput>#rsMonedasTran.Mcodigo#</cfoutput>"></td></tr>
					</cfloop> <!--- Resumen por Monedas --->

					<tr><td class="bottomline" colspan="3">&nbsp;</td></tr>
					<tr class="tituloAlterno">
						<td align="left" class="letra" ><font size="2"><b>Resumen en Moneda Local</b></font></td>
						<td nowrap class="letra" align="right" ><b>Sistema</b></td>
						<td nowrap class="letra" align="right" ><b>Usuario</b></td>
					</tr>

					<!--- calculo de datos del sistema --->
					<cfset sis_contado  = monto_tran('','sum(MontoLocal)', '-1', '' ) >
					<cfset sis_fcredito = monto_tran('','sum(MontoLocal)', '1', 'D' ) >
					<cfset sis_ncredito = monto_tran('','sum(MontoLocal)', '1', 'C' ) >
					<cfset sis_credito  = sis_fcredito - sis_ncredito >
					<cfset sis_total    = sis_contado + sis_credito >

					<!--- calculo de datos dados por el usuario --->
					<cfset usu_contado  = monto_usu('','sum(FADCcontadolocal)') >
					<cfset usu_fcredito = monto_usu('','sum(FADCfcreditolocal)') >
					<cfset usu_ncredito = monto_usu('','sum(FADCncreditolocal)') >
					<cfset usu_credito  = usu_fcredito - usu_ncredito >
					<cfset usu_total    = usu_contado + usu_credito >

					<!--- Montos de Contado --->
					<tr class="listaNon">
						<td nowrap <cfif sis_contado neq usu_contado >class="fletra2"<cfelse>class="letra"</cfif> >Contado</td>
						<td nowrap align="right" <cfif sis_contado neq usu_contado >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(sis_contado,'none')#</cfoutput></td>
						<td nowrap align="right" <cfif sis_contado neq usu_contado >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(usu_contado,'none')#</cfoutput></td>
					</tr>

					<!--- Facturas de Credito --->
					<tr class="listaNon">
						<td nowrap <cfif sis_fcredito gt usu_fcredito >class="fletra2"<cfelse>class="letra2"</cfif> >Facturas de Cr&eacute;dito</td>
						<td nowrap align="right" <cfif sis_fcredito neq usu_fcredito >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(sis_fcredito,'none')#</cfoutput></td>
						<td nowrap align="right" <cfif sis_fcredito neq usu_fcredito >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(usu_fcredito,'none')#</cfoutput></td>
					</tr>

					<!--- Notas de Credito --->
					<tr class="listaPar">
						<td nowrap <cfif sis_ncredito neq usu_ncredito >class="fletra2"<cfelse>class="letra"</cfif> >Notas de Cr&eacute;dito</td>
						<td nowrap align="right" <cfif sis_ncredito neq usu_ncredito >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(sis_ncredito,'none')#</cfoutput></td>
						<td nowrap align="right" <cfif sis_ncredito neq usu_ncredito >class="fletra2"<cfelse>class="letra"</cfif> ><cfoutput>#LSCurrencyFormat(usu_ncredito,'none')#</cfoutput></td>
					</tr>

					<!--- total --->
					<tr class="letra2">
						<td nowrap class="letra" ><b>Total</b></td>
						<td nowrap align="right" <cfif sis_total neq usu_total >class="fletra2"<cfelse>class="letra"</cfif>>
							<b><cfoutput>#LSCurrencyFormat((sis_total), 'none')#</cfoutput></b>
						</td>
						<td nowrap align="right" <cfif sis_total neq usu_total >class="fletra2"<cfelse>class="letra"</cfif>>
							<b><cfoutput>#LSCurrencyFormat((usu_total), 'none')#</cfoutput></b>
						</td>
					</tr>

					<!--- Faltantes o Sobrantes --->
					<tr class="letra2">
						<cfif sis_total lt usu_total >
							<cfset doc_diferencia = (sis_total-usu_total)*-1 >
						<cfelse>
							<cfset doc_diferencia = sis_total-usu_total >
						</cfif>
						<td nowrap class="letra" ><b><cfif sis_total gt usu_total >Faltantes<cfelseif sis_total lt usu_total >Sobrantes<cfelseif sis_total eq usu_total >Faltantes o Sobrantes</cfif></b></td>
						<td nowrap align="right"  class="letra">&nbsp;</td>
						<td nowrap align="right" <cfif sis_total neq usu_total >class="fletra2"<cfelse>class="letra"</cfif>>
							<b><cfoutput>#LSCurrencyFormat((doc_diferencia), 'none')#</cfoutput></b>
						</td>
					</tr>
				</table> <!--- Tabla de montos globales --->
			</td>
		</tr>
	
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="btnCerrar"   value="Cerrar Caja" onClick="javascript:if ( confirm('Desear efectuar el Proceso de Cierre de Caja?')){ return true; }else{ return false; }">
				<input type="submit" name="btnCancelar" value="Cancelar Cierre de Usuario" onClick="javascript:if ( confirm('Desear cancelar el Proceso de Cierre de Caja?')){ return true; }else{ return false; }">
				<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
			</td>
		</tr>	

		<cfif rsHayContado.RecordCount gt 0 >
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2" class="topline">&nbsp;</td></tr>
			
			<!--- sección de los detalles de Pago por moneda --->
			<tr><td colspan="2" align="center" class="tituloAlterno"><font size="2"><b>Detalle de Pagos por Moneda</b></font></td></tr>
			<tr><td>&nbsp;</td></tr>
		

			<tr>
				<td colspan="2" align="center">
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<!--- hay pagos para transacciones de contado --->
							<cfif rsMonedasPago.RecordCount gt 0 > 
							    <!--- columna 1: muestra los totales por moneda --->
								<td width="65%" valign="top">

								<table width="100%" border="0" cellpadding="0" cellspacing="0" class="sectionTitle" >
									<tr><td colspan="7" align="center" class="tituloAlterno"><font size="2"><b>Resumen de Pagos por Moneda</b></font></td></tr>
			
									<tr>
										<td></td>
										<td colspan="3" class="bottomline" align="center"><b>Moneda Origen</b></td>
										<td width="2%">&nbsp;</td>
										<td colspan="2" class="bottomline" align="center"><b>Moneda Local</b></td>
									</tr>
									<tr>
										<td><b>Moneda</b></td>
										<td align="right"><b>Sistema</b></td>
										<td align="right"><b>Usuario</b></td>
										<td align="right"><b>Diferencia</b></td>
										<td>&nbsp;</td>
										<td align="right"><b>Sistema</b></td>
										<td align="right"><b>Usuario</b></td>
									</tr>
									<cfoutput>
				
									<cfset tslmonto = 0 >
									<cfset tulmonto = 0 >
									<cfset ldiferencia = 0 >
									<cfloop query="rsMonedasPago">
										<tr class="<cfif rsMonedasPago.CurrentRow mod 2 >listaPar<cfelse>listaNon</cfif>" >
											<!--- montos en moneda origen --->
											<cfset smonto     = get_monto(rsMonedasPago.Mcodigo, '-1', '', '') >
											<cfset umonto     = monto_usu(rsMonedasPago.Mcodigo, "FADCefectivo + FADCcheques + FADCvouchers + FADCdepositos") >
											<cfset diferencia =  smonto - umonto >
													
											<!--- montos en moneda local --->
											<cfset slmonto = get_montolocal(rsMonedasPago.Mcodigo, '-1', '', '') >
											<cfset ulmonto = monto_usu(rsMonedasPago.Mcodigo, "FADCefectivolocal + FADCchequeslocal + FADCvoucherslocal + FADCdepositoslocal") >
											<cfset tslmonto = tslmonto + slmonto >
											<cfset tulmonto = tulmonto + ulmonto >
													
											<td <cfif diferencia gt 0 >class="fletra"</cfif> >#get_moneda(rsMonedasPago.Mcodigo)#</td>
											<td align="right" <cfif diferencia neq 0 >class="fletra"</cfif> >#LSCurrencyFormat(smonto, 'none')#</td>
											<td align="right" <cfif diferencia neq 0 >class="fletra"</cfif> >#LSCurrencyFormat(umonto, 'none')#</td>
											<td align="right" <cfif diferencia neq 0 >class="fletra"</cfif> >#LSCurrencyFormat(diferencia, 'none')#</td>
											<td>&nbsp;</td>
											<td align="right" <cfif diferencia neq 0 >class="fletra"</cfif> >#LSCurrencyFormat(slmonto, 'none')#</td>
											<td align="right" <cfif diferencia neq 0 >class="fletra"</cfif> >#LSCurrencyFormat(ulmonto, 'none')#</td>
										</tr>
									</cfloop>
									</cfoutput>
								</table><!--- monedas --->
								<cfset ldiferencia = tslmonto - tulmonto >
								<cfif ldiferencia gt 0 >
									<cfset titulo = "Faltantes" >
								<cfelseif ldiferencia lt 0 >
									<cfset ldiferencia = ldiferencia*-1 >
									<cfset titulo = "Sobrantes" >
								<cfelse>
									<cfset titulo = "Faltantes o Sobrantes" >
								</cfif>
										
								<table width="100%">
									<tr>
										<td align="right" width="55%" nowrap ><font size="2"><strong><cfoutput>#titulo#</cfoutput> en Moneda Local:&nbsp;</strong></font></td>
										<td align="left" nowrap <cfif ldiferencia neq 0 >class="fletra"</cfif> ><font size="2"><strong><cfoutput>#LSCurrencyFormat(ldiferencia, 'none')#</cfoutput></strong></font></td>
									</tr>
								</table>
							</td>
									
							<td width="1%"></td>
			
							<!--- columna 2: muestra el desglose por moneda --->
							<td width="34%" valign="top">
								<table width="100%" border="0" bordercolor="#eeeeee"  cellpadding="0" cellspacing="4" class="consola">
									<cfoutput>
									<cfloop query="rsMonedasPago">
										<cfset verDetalles = false>
										<tr>
											<td class="boxtitle">
												<table width="100%" >
													<tr>
														<td><b>#get_moneda(rsMonedasPago.Mcodigo)#</b></td>
														<td align="right" ><a href="javascript:fnMinMax('tr#rsMonedasPago.Mcodigo#', 'img#rsMonedasPago.Mcodigo#')"><img  align="middle" src="../../imagenes/w-max.gif" id="img#rsMonedasPago.Mcodigo#" width="16" height="16" border="0"></a></td>
													</tr>
												</table>	
											</td>
										</tr>
										<tr id="tr#rsMonedasPago.Mcodigo#" style="display: none;">
											<td>
												<table width="100%" class="bottomline2">
													<tr>
														<!--- <td width="1%">&nbsp;</td> --->
														<td><font size="1"><b>Tipo de Pago</b></font></td>
														<td align="right"><font size="1"><b>Usuario</b></font></td>
														<td align="right"><font size="1"><b>Sistema</b></font></td>
													</tr>
													<tr  class="listaPar">
														<cfset umonto = monto_usu(rsMonedasPago.Mcodigo, "FADCefectivo") >
														<cfset smonto = get_monto(rsMonedasPago.Mcodigo, '-1', 'E', '') >
														<cfif umonto neq smonto >
															<cfset verDetalles = true >
														</cfif>
														<td nowrap <cfif umonto neq smonto >class="fletra"</cfif>><font size="1" >Efectivo</font></td>
														<td align="right" <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">#LSCurrencyFormat(umonto, 'none')#</font></td>
														<td align="right" <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">#LSCurrencyFormat(smonto, 'none')#</font></td>
														<input type="hidden" name="FADCefectivosis_#rsMonedasPago.Mcodigo#" value="#smonto#">
													</tr>
													<tr  class="listaNon">
														<cfset umonto = monto_usu(rsMonedasPago.Mcodigo, "FADCcheques") >
														<cfset smonto = get_monto(rsMonedasPago.Mcodigo, '-1', 'C', '') >
														<cfif umonto neq smonto >
															<cfset verDetalles = true >
														</cfif>
														<td nowrap <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">Cheques</font></td>
														<td align="right" <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">#LSCurrencyFormat(umonto, 'none')#</font></td>
														<td align="right" <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">#LSCurrencyFormat(smonto, 'none')#</font></td>
														<input type="hidden" name="FADCchequessis_#rsMonedasPago.Mcodigo#" value="#smonto#">
													</tr>
													<tr  class="listaPar">
														<cfset umonto = monto_usu(rsMonedasPago.Mcodigo, "FADCvouchers") >
														<cfset smonto = get_monto(rsMonedasPago.Mcodigo, '-1', 'T', '') >
														<cfif umonto neq smonto >
															<cfset verDetalles = true >
														</cfif>
														<td nowrap <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">Vouchers</font></td>
														<td align="right" <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">#LSCurrencyFormat(umonto, 'none')#</font></td>
														<td align="right" <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">#LSCurrencyFormat(smonto, 'none')#</font></td>
														<input type="hidden" name="FADCvoucherssis_#rsMonedasPago.Mcodigo#" value="#smonto#">
													</tr>
													<tr  class="listaNon">
														<cfset umonto = monto_usu(rsMonedasPago.Mcodigo, "FADCdepositos") >
														<cfset smonto = get_monto(rsMonedasPago.Mcodigo, '-1', 'D', '') >
														<cfif umonto neq smonto >
															<cfset verDetalles = true >
														</cfif>
														<td nowrap <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">Dep&oacute;sitos</font></td>
														<td align="right" <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">#LSCurrencyFormat(umonto, 'none')#</font></td>
														<td align="right" <cfif umonto neq smonto >class="fletra"</cfif> ><font size="1">#LSCurrencyFormat(smonto, 'none')#</font></td>
														<input type="hidden" name="FADCdepositossis_#rsMonedasPago.Mcodigo#" value="#smonto#">
													</tr>
												</table><!--- Detalle de pagos --->
											</td>	
										</tr>
												
										<!--- muestra el detalle de montos por moneda abierto si hay diferencias --->
										<cfif verDetalles >
											<script language="JavaScript1.2" type="text/javascript">
												fnMinMax('tr#rsMonedasPago.Mcodigo#','img#rsMonedasPago.Mcodigo#');
											</script>
										</cfif>
				
										<tr><td><input type="hidden" name="Mcodigo" value="#rsMonedasPago.Mcodigo#"></td></tr>
									</cfloop>
										
									</cfoutput>
								</table>
							</td>
					<cfelse>
						<td align="center"><b>No se han registrado Pagos para las Transacciones de Contado</b></td>
					</cfif><!--- Hay pagos para Transacciones de Contado --->
					</tr>
					</table>
				</td>
			</tr>
		</cfif>

		<tr>
			<td>
				<input type="hidden" name="FCid" value="<cfoutput>#form.FCid#</cfoutput>">
				<input type="hidden" name="FACid" value="<cfoutput>#rsCierre.FACid#</cfoutput>">
			</td>
		</tr>
	
		<tr><td>&nbsp;</td></tr>
	<cfelse>
		<cfif isdefined("form.FCid") and form.FCid neq -1 >
			<tr><td>&nbsp;</td></tr>	
			<tr><td align="center" ><font size="3"><b>Reporte de Cierre de Caja<br><cfoutput>#Trim(rsCaja.FCcodigo)#, #rsCaja.FCdesc#</cfoutput></b></font></td></tr>
			<tr><td align="center"><font size="2">No existe Cierre pendiente para esta Caja</font></td></tr>
			<tr><td>&nbsp;</td></tr>	
		<cfelse>
			<tr><td>&nbsp;</td></tr>	
			<tr><td align="center" ><font size="3"><b>Debe seleccionar una Caja para el proceso de Cierre</b></font></td></tr>
			<tr><td>&nbsp;</td></tr>	
		</cfif>
	   <tr> 
		 <td nowrap align="center">
			 <input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
		 </td>
	   </tr>
		<tr><td>&nbsp;</td></tr>	
	</cfif>

</table> <!--- tabla general --->
</CF_sifHTML2Word>
</form>