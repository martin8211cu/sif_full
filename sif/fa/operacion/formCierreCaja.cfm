<!--- Selecciona la caja que se va a cerrar --->
<!--- caso 1. la caja existe en la session--->
<cfif isdefined("session.Caja") and len(trim(session.Caja)) gt 0>
	<cfset form.FCid = session.Caja >
<!--- no hay session y la caja esta en la tabla de cajas activas. Se supone que un usuario solo abre una caja a la vez. --->
<cfelse>
	<cfquery name="rsCajasActivas" datasource="#session.DSN#">
		select convert(varchar, FCid) as FCid 
		from FCajasActivas
	</cfquery>
	<cfif rsCajasActivas.RecordCount gt 0 >
		<cfset form.FCid = rsCajasActivas.FCid >
	<cfelse>
		<cfif isdefined("form.sFCid") and form.sFCid neq -1 >
			<cfset form.FCid = form.sFCid >
		<cfelse>
			<cfquery name="rsCajasUsuario" datasource="#session.DSN#">
				select convert(varchar, a.FCid ) as FCid, FCdesc
				from UsuariosCaja a, FCajas b
				where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.FCid=b.FCid
				and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			</cfquery>
			<cfif rsCajasUsuario.RecordCount gt 0 >
				<!--- Dibujar algo que me diga que escoja la caja --->
				<cfset caja = 1 >
			<cfelse>
				<cfset caja = 0 >
			</cfif>
		</cfif>	
	</cfif>
</cfif>

<cfif isdefined("form.FCid") and len(trim(form.FCid)) gt 0 >
			<!--- determina si hay cierre pendiente, para esta caja--->
			<cfquery name="rsCierre" datasource="#session.DSN#">
				select convert(varchar, max(FACid)) as FACid
				from FACierres
				where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				and FACestado='P'
			</cfquery>
			
			<cfif rsCierre.RecordCount gt 0 and len(trim(rsCierre.FACid)) gt 0>
				<cfset modo = 'CAMBIO' >
				<!--- datos para el modo cambio--->
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select convert(varchar, b.FACid) as FACid, a.FADCminicial, a.FADCcontado, a.FADCfcredito, a.FADCefectivo, a.FADCcheques, 
						   a.FADCvouchers, a.FADCdepositos, a.FADCdiferencias, a.FADCncredito, convert(varchar, FCAfecha) as FCAfecha, 
						   convert(varchar, a.Mcodigo) as Mcodigo, FADCtc
					from FADCierres a, FACierres b
					where a.FACid=b.FACid
					  and a.FACid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCierre.FACid#">
					  and b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			<cfelse>
				<cfset modo = 'ALTA' >
			</cfif>
			
			<!--- descripcion de la caja--->
			<cfquery name="rsCaja" datasource="#session.DSN#">
				select rtrim(FCcodigo)+', '+FCdesc as FCcaja 
				from FCajas 
				where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
			</cfquery>
			
			<!--- EUcodigo del usuario de la caja--->
			<cfquery name="rsEucodigo" datasource="#session.DSN#">
				select convert(varchar, EUcodigo) as EUcodigo 
				from UsuariosCaja a, FCajas b
				where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and a.Ulocalizacion=<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
				and a.FCid=b.FCid
			</cfquery>
			
			<!--- monedas registradas en pagos --->
			<cfquery name="rsMonedasP" datasource="#session.DSN#">
				select distinct b.Mcodigo, c.Mnombre 
				from ETransacciones a, FPagos b, Monedas c
				where a.FCid=b.FCid
				  and a.ETnumero=b.ETnumero
				  and b.Mcodigo=c.Mcodigo
				  and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and ETestado='T'
				  and FACid is null
				order by b.Mcodigo
			</cfquery>
			
			<!--- Monedas registradas en las facturas--->
			<cfquery name="rsMonedasT" datasource="#session.DSN#">
				select distinct a.Mcodigo, Mnombre 
				from ETransacciones a , Monedas b
				where a.Mcodigo=b.Mcodigo
				and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				and ETestado='T'
				and FACid is null	
				order by Mcodigo
			</cfquery>

			<cfset rsMonedas = QueryNew("Mcodigo, Mnombre")>
			<!--- Moneas registradas en los pagos--->
			<cfloop query="rsMonedasP">
				<!--- Agrega la fila procesada --->
				<cfset fila = QueryAddRow(rsMonedas, 1)>
				<cfset tmp  = QuerySetCell(rsMonedas, "Mcodigo", #rsMonedasP.Mcodigo#) >
				<cfset tmp  = QuerySetCell(rsMonedas, "Mnombre", #rsMonedasP.Mnombre#) >
			</cfloop>
			
			<!--- Moneas registradas en las transacciones y que no existan en el query --->
			<cfloop query="rsMonedasT">
				<!--- agrega la moneda solo si no existe --->
				<cfquery name="rsExisteMoneda" dbtype="query" >
					select Mcodigo from rsMonedas where Mcodigo=#rsMonedasT.Mcodigo#
				</cfquery>
				<cfif rsExisteMoneda.RecordCount eq 0>
					<!--- Agrega la fila procesada --->
					<cfset fila = QueryAddRow(rsMonedas, 1)>
					<cfset tmp  = QuerySetCell(rsMonedas, "Mcodigo", #rsMonedasT.Mcodigo#) >
					<cfset tmp  = QuerySetCell(rsMonedas, "Mnombre", #rsMonedasT.Mnombre#) >
				</cfif>
			</cfloop>
			
			<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
				select convert(varchar, Mcodigo) as Mcodigo
				from Empresas
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<style type="text/css">
			.listaPar2 {  background-color: #F5F5F5; vertical-align: middle; text-indent: 10px; padding-top: 2px; padding-bottom: 2px}
			</style>
			
			<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
			<script language="JavaScript1.2" type="text/javascript">
				function habilitar(){
					var total   = document.form1.elements.length;
					for (var i=0; i<total; i++){
						if ( document.form1.elements[i].type ==  'text' ){
							if ( document.form1.elements[i].disabled ) {
								document.form1.elements[i].disabled = false;
							}
							document.form1.elements[i].value = qf(document.form1.elements[i].value);
						}	
					}
				}
			
				function validar(){
					var total   = document.form1.elements.length;
					var mensaje = 'Se presentaron los siguientes errores:\n\n';
					var error = false;
					for (var i=0; i<total; i++){
						if ( document.form1.elements[i].type ==  'text' ){
							if ( document.form1.elements[i].value == '' ) {
								error    = true;
								mensaje +=  ' - ' + document.form1.elements[i].alt + ' es requerido. \n'
							}	
						}	
					}
					
					if (error){
						alert(mensaje);
					}
					else{
						habilitar();
					}
					
					return !error;
				}
				
				function diferencias (pcontado, pdinero, moneda){
					var contado = new Number(qf(pcontado))
					var dinero  = new Number(qf(pdinero))
					var diferencia = Math.abs(contado - dinero);
					eval('document.form1.FADCdiferencias_' + moneda).value = diferencia;
					fm(eval('document.form1.FADCdiferencias_' + moneda), 2);
				}
			
				function total_documentos(moneda){
					var contado  = new Number(qf(eval('document.form1.FADCcontado_' + moneda + '.value')));	
					eval('document.form1.totalFADCcontado_' + moneda).value = contado;
					fm(eval('document.form1.totalFADCcontado_' + moneda), 2);
					
					//calcula las diferencias
					diferencias(eval('document.form1.totalFADCcontado_' + moneda).value, eval('document.form1.totalFADCdinero_' + moneda).value, moneda);
				}
			
				function ftotal_dinero(moneda){
					var efectivo  = new Number(qf(eval('document.form1.FADCefectivo_' + moneda + '.value')));	
					var cheques   = new Number(qf(eval('document.form1.FADCcheques_' + moneda + '.value')));	
					var vouchers  = new Number(qf(eval('document.form1.FADCvouchers_' + moneda + '.value')));	
					var depositos = new Number(qf(eval('document.form1.FADCdepositos_' + moneda + '.value')));	
			
					
					eval('document.form1.totalFADCdinero_' + moneda).value = efectivo + cheques + vouchers + depositos;
					fm(eval('document.form1.totalFADCdinero_' + moneda), 2);
					
					// calcula las diferencias
					diferencias(eval('document.form1.totalFADCcontado_' + moneda).value, eval('document.form1.totalFADCdinero_' + moneda).value, moneda);
				}
				
				function calculos(moneda){
					// tipo de cambio
					var tc = new Number(qf(eval("document.form1.FADCtc_" + moneda + ".value")));
			
					// facturas
					var contado   = new Number(qf(eval("document.form1.FADCcontado_" + moneda + ".value"))*tc );
			
					// efectivo
					var efectivo  = new Number(qf(eval("document.form1.FADCefectivo_" + moneda + ".value"))*tc );
					var cheques   = new Number(qf(eval("document.form1.FADCcheques_" + moneda + ".value"))*tc );
					var vouchers  = new Number(qf(eval("document.form1.FADCvouchers_" + moneda + ".value"))*tc );
					var depositos = new Number(qf(eval("document.form1.FADCdepositos_" + moneda + ".value"))*tc );
					var total_efectivo =  efectivo + cheques + vouchers + depositos;
			
					// credito	
					var facturas  = new Number(qf(eval("document.form1.FADCfcredito_" + moneda + ".value"))*tc );
					var notas = new Number(qf(eval("document.form1.FADCncredito_" + moneda + ".value"))*tc );
					var total_credito = facturas - notas; 
			
					// hacer un objeto oculto donde ponga los resultados y los modifique cada vez que recalcula
					return new Array(contado, total_efectivo, total_credito);
				}
			
			/*
				function total(moneda){}
				function total2(moneda){alert(moneda)}
				*/
				
				function total(){
				// RESULTADO
				// Calcula los montos totales, en moneda local, al tipo de cambio que se capturo para cada moneda.
				// datos[0] = facturas de contado
				// datos[1] = total de efectivo
				// datos[2] = total de credito 
			
					moneda = document.form1.Mcodigo.value;
					total_docs    = 0;
					total_dinero  = 0;
					total_credito = 0; 
			
					// es un arreglo de monedas
					if (document.form1.Mcodigo.length >= 1){
						for (var i=0; i<document.form1.Mcodigo.length; i++ ){
							datos = calculos(document.form1.Mcodigo[i].value);
							total_docs    = parseFloat(total_docs)   +  parseFloat(datos[0]);
							total_dinero  = parseFloat(total_dinero) + parseFloat(datos[1]);
							total_credito = parseFloat(total_credito) + parseFloat(datos[2]);
						}
					}
					// es una sola moneda
					else{
						datos = calculos(moneda);
							total_docs    = parseFloat(total_docs)   +  parseFloat(datos[0]);
							total_dinero  = parseFloat(total_dinero) + parseFloat(datos[1]);
							total_credito = parseFloat(total_credito) + parseFloat(datos[2]);
					}
			
			
			
					document.form1.tFAcontado.value   = fm(total_docs, 2);
					document.form1.tFAdinero.value    = fm(total_dinero, 2);
					document.form1.tcFAcredito.value  = fm(total_credito, 2);
					document.form1.tdFAcredito.value  = fm(total_credito, 2);
					document.form1.tContado.value     = fm(total_docs+total_credito, 2);
					document.form1.tDinero.value      = fm(total_dinero+total_credito, 2);
				}
			
				function regresar(){
					document.form1.action = "/cfmx/sif/fa/MenuFA.cfm";
					document.form1.submit();
				}
			
			</script>
			
			<form action="SQLCierreCaja.cfm" name="form1" method="post" onSubmit="javascript: return validar();" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <cfoutput>	
			  <tr> 
				<td colspan="3"><div align="center"><strong><font size="2">Caja: #rsCaja.FCcaja#</font></strong></div></td>
			  </tr>
			  <tr> 
				<td colspan="3"><div align="center"><strong><font size="2">Fecha de Cierre: #LSDateFormat(Now(), 'dd/mm/yyyy')#</font></strong></div></td>
			  </tr>
			
			  <tr>
				<td colspan="3">
					<input type="hidden" name="FACid" value="<cfif modo neq 'ALTA'>#rsCierre.FACid#</cfif>">
					<input type="hidden" name="EUcodigo" value="#rsEucodigo.EUcodigo#">
				</td>
			  </tr>
			
			  <!--- Pintado dinamico del form --->	
			  <cfset index = 1 >	
			  <cfif rsMonedas.RecordCount gt 0>	
				  <cfloop query="rsMonedas">
					  <cfif modo neq 'ALTA'>
						<cfquery name="rsForm" dbtype="query">
							select FACid, FADCminicial, FADCcontado, FADCfcredito, FADCefectivo, FADCcheques, 
								   FADCvouchers, FADCdepositos, FADCncredito, FCAfecha, Mcodigo, FADCtc,
								   ( FADCefectivo + FADCcheques + FADCvouchers + FADCdepositos ) as FADCdinero,
								   (FADCcontado - ( FADCefectivo + FADCcheques + FADCvouchers + FADCdepositos ))*-1 as FADCdiferencias
								   
							from rsDatos
							where Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMonedas.Mcodigo#">
						</cfquery>
					  </cfif>
			
					  <cfif modo neq 'ALTA' and rsForm.RecordCount gt 0  >
						<cfset dmodo = 'CAMBIO'  >
					  <cfelse>	
						  <cfset dmodo = 'ALTA'  >
					  </cfif>
					  
						<cfif dmodo eq 'ALTA'>  
					
							<cfif rsMonedaLocal.Mcodigo eq rsMonedas.Mcodigo >
								<cfset moneda = 1.00 >
							<cfelse>
								<cfquery name="rsTipoCambio" datasource="#session.DSN#">
									select tc.Mcodigo, tc.TCcompra, tc.TCventa
									from Htipocambio tc
									where tc.Ecodigo =  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
									  and tc.Mcodigo =  <cfqueryparam value="#rsMonedas.Mcodigo#" cfsqltype="cf_sql_numeric">
									  and tc.Hfecha  <= '#LSDateFormat(Now(),"YYYYMMDD")#'
									  and tc.Hfechah >  '#LSDateFormat(Now(),"YYYYMMDD")#'
								</cfquery>
								<cfset moneda = rsTipoCambio.TCventa >
							</cfif>
						</cfif>
					  
					  <tr>
						<td width="1%"><input type="hidden" name="Mcodigo" value="#rsMonedas.Mcodigo#"></td>	
						<td>
							<fieldset>
								<legend><font size="2"><strong>Moneda:&nbsp; #rsMonedas.Mnombre# </strong></font></legend>
								
							<table width="100%" border="0" cellpadding="2" cellspacing="2">
							  <tr> 
								<td nowrap align="right">Monto Inicial:&nbsp;</td>
								<td nowrap> 
									<input name="FADCminicial_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCminicial, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El monto inicial para la moneda #rsMOnedas.Mnombre#">
								</td>
								<td align="right">Tipo de Cambio:&nbsp;</td>
								<td ><input name="FADCtc_#rsMonedas.Mcodigo#" type="text" <cfif rsMonedaLocal.Mcodigo eq rsMonedas.Mcodigo>readonly</cfif> style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCtc, 'none')#<cfelse>#moneda#</cfif>" size="15" maxlength="15" alt="El Tipo de cambio para la moneda #rsMonedas.Mnombre#"></td>
							  </tr>
							  <tr class="listaPar2"> 
								<td colspan="2"><strong>Documentos de Contado</strong></td>
								<td colspan="4"><strong>Dinero</strong></td>
							  </tr>
							  <tr> 
								<td nowrap align="right">Facturas de Contado:&nbsp;</td>
								<td nowrap> <input name="FADCcontado_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_documentos('#rsMonedas.Mcodigo#'); total();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCcontado, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Facturas de Contado para la moneda #rsMonedas.Mnombre#"></td>
								<td nowrap align="right">Efectivo:&nbsp;</td>
								<td ><input name="FADCefectivo_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); ftotal_dinero('#rsMonedas.Mcodigo#'); total();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCefectivo, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Efectivo para la moneda #rsMonedas.Mnombre#"></td>
							  </tr>
				
							  <tr>
								<td colspan="2" nowrap>&nbsp;</td>
								<td nowrap align="right">Cheques:&nbsp;</td>
								<td ><input name="FADCcheques_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); ftotal_dinero('#rsMonedas.Mcodigo#'); total();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCcheques, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Cheques para la moneda #rsMonedas.Mnombre#"></td>
							  </tr>	
				
							  <tr>
								<td colspan="2" nowrap>&nbsp;</td>	
								<td align="right">Voucheres:&nbsp;</td>
								<td><input name="FADCvouchers_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); ftotal_dinero('#rsMonedas.Mcodigo#'); total();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCvouchers, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Vouchers para la moneda #rsMonedas.Mnombre#"></td>
							  </tr>	
				
							  <tr> 
								<td colspan="2" nowrap>&nbsp;</td>
								<td align="right">Dep&oacute;sito:&nbsp;</td>
								<td><input name="FADCdepositos_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); ftotal_dinero('#rsMonedas.Mcodigo#'); total();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCdepositos, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Dep&oacute;sitos para la moneda #rsMonedas.Mnombre#"></td>
							  </tr>
							  <tr> 
								<td div align="right"><strong>Total:&nbsp;</strong></td>
								<td><input name="totalFADCcontado_#rsMonedas.Mcodigo#" type="text" disabled="true" style="text-align: right;"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCcontado, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15"></td>
								<td align="right"><strong>Total:&nbsp;</strong></td>
								<td><input name="totalFADCdinero_#rsMonedas.Mcodigo#" type="text" disabled="true" style="text-align: right;"   onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCdinero, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15"></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>
			
							  <tr> 
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td align="right"><strong>Diferencia:&nbsp;</strong></td>
								<td><input name="FADCdiferencias_#rsMonedas.Mcodigo#" type="text" disabled="true" style="text-align: right;"   onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCdiferencias, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15"></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>
			
							  <tr> 
								<td colspan="6">&nbsp;</td>
							  </tr>
							  <tr class="listaPar2"> 
								<td colspan="6"><strong>Documentos de Cr&eacute;dito</strong></td>
							  </tr>
							  <tr> 
								<td nowrap> <div align="right">Facturas de Cr&eacute;dito:&nbsp;</div></td>
								<td nowrap> <input name="FADCfcredito_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total(); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCfcredito, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Facturas de Crédito para la moneda #rsMonedas.Mnombre#"></td>
								<td nowrap align="right">Notas de Cr&eacute;dito:&nbsp;</td>
								<td nowrap> <input name="FADCncredito_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total(); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCncredito, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Notas de Crédito para la moneda #rsMonedas.Mnombre#"></td>
								<td nowrap>&nbsp;</td>
								<td nowrap>&nbsp;</td>
							  </tr>
							</table>
								</fieldset>	
							</td>
					  </tr>
					  <tr><td>&nbsp;</td></tr>
					  <cfset index = index +1>	
				  </cfloop>
			
				  
				  <tr><td>&nbsp;</td></tr>
				  <tr>
					<td width="1%">&nbsp;</td>
					<td colspan="3" align="center">
						<fieldset><legend><font size="2"><strong>Montos en Moneda Local</strong></font></legend>
			
						<table width="40%" align="center" border="0">
							<cf_templatecss>
			
							<tr>
								<td width="30%" nowrap></td>
								<td align="center" width="35%" nowrap><b>Contado + Cr&eacute;dito</b></td>
								<td align="center" width="35%" nowrap><b>Dinero + Cr&eacute;dito</b></td>
							</tr>
			
							<tr>
								<td width="30%" nowrap><b>Facturas de Contado</b></td>
								<td align="center" width="35%" nowrap><input class="cajasinborde" type="text" name="tFAcontado" size="25" value="0.00" readonly="" style="text-align: right;"></td>
								<td align="center"><input class="cajasinborde" type="text" name="blanco" size="25" value="0.00" readonly="" style="text-align: right;" ></td>
							</tr>
							<tr>
								<td><b>Dinero</b></td>
								<td align="center"><input class="cajasinborde" type="text" name="blanco" size="25" value="0.00" readonly="" style="text-align: right;" ></td>
								<td align="center"><input class="cajasinborde" type="text" name="tFAdinero" size="25" value="0.00" readonly="" style="text-align: right;"></td>
							</tr>
							
							<tr>
								<td><b>Facturas de Cr&eacute;dito</b></td>
								<td align="center" ><input class="cajasinborde" type="text" name="tcFAcredito" size="25" value="0.00" readonly="" style="text-align: right;" ></td>
								<td align="center" ><input class="cajasinborde" type="text" name="tdFAcredito" size="25" value="0.00" readonly="" style="text-align: right;" ></td>
							</tr>
							<tr>
								<td><b>Total</b></td>
								<td align="center"><input class="cajasinborde" type="text" name="tContado" size="25" value="0.00" readonly="" style="text-align: right;" ></td>
								<td align="center" ><input class="cajasinborde" type="text" name="tDinero" size="25" value="0.00" readonly="" style="text-align: right;" ></td>
							</tr>
						</table>
						</fieldset>
					</td>
				  </tr>
				  <tr><td>&nbsp;</td></tr>
				  
				  <tr> 
					<cfif modo eq 'ALTA'>
						<td colspan="3" nowrap align="center">
							<input type="submit" name="btnAceptar" value="Aceptar">
							<input type="reset" name="btnLimpiar" value="Limpiar">
							<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
						</td>
					<cfelse>
						<td colspan="3" nowrap align="center">
							<input type="submit" name="btnModificar" value="Modificar">
							<input type="reset" name="btnLimpiar" value="Limpiar">
							<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
						</td>
					</cfif>
				  </tr>
					<script language="JavaScript1.2" type="text/javascript">
						total();
					</script>	
			  <cfelse>
				   <tr><td colspan="3" align="center"><strong><font size="2">No existen datos para el Cierre</font></strong></td></tr>
				   <tr><td>&nbsp;</td></tr>
				   <tr> 
					 <td nowrap align="center">
						 <input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
					 </td>
				   </tr>
			  </cfif>
				<tr><td><input type="hidden" name="FCid" value="#form.FCid#"></td></tr>
			  </cfoutput>	
			</table>
			</form>
<cfelse>
	<script language="JavaScript1.2" type="text/javascript">
		function regresar(){
			document.form2.action = "/cfmx/sif/fa/MenuFA.cfm";
			document.form2.submit();
		}
	</script>
	<form action="" name="form2" method="post">
	<table width="100%">
	<cfif caja eq 1 >
		<tr>
			<td align="right" width="50%"><font size="2">Seleccione la Caja para el Cierre:&nbsp;</font></td>
			<td align="left" width="50%">
				<select name="sFCid" onChange="javascript:document.form2.submit();">
					<option value="-1">--Seleccionar Caja--</option>
					<cfoutput query="rsCajasUsuario" >
						<option value="#rsCajasUsuario.FCid#">#rsCajasUsuario.FCdesc#</option>
					</cfoutput>
				</select> 
			</td>
		</tr>
	<cfelse>
		<tr><td align="center"><font size="2"><b>No se han autorizado Cajas para este Usuario.</b></font></td></tr>
	</cfif>		
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="2"><input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();"></td></tr>
	</table>
	</form>
</cfif>