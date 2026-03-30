<cfset session.FCid = 13>

<!---<cfinclude template="CalculoCierreSis.cfm">--->

<!--- determina si hay cierre pendiente, para esta caja--->
<cfquery name="rsCierre" datasource="#session.DSN#">
	select convert(varchar, FACid) as FACid
	from FACierres
	where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.FCid#">
	and FACestado='P'
</cfquery>

<cfif rsCierre.RecordCount gt 0>
	<cfset modo = 'CAMBIO' >
	<!--- datos para el modo cambio--->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select convert(varchar, b.FACid) as FACid, a.FADCminicial, a.FADCcontado, a.FADCfcredito, a.FADCefectivo, a.FADCcheques, 
			   a.FADCvouchers, a.FADCdepositos, a.FADCdiferencias, a.FADCncredito, convert(varchar, FCAfecha) as FCAfecha, 
			   convert(varchar, a.Mcodigo) as Mcodigo
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
	where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.FCid#">
</cfquery>

<!--- EUcodigo del usuario de la caja--->
<cfquery name="rsEucodigo" datasource="#session.DSN#">
	select convert(varchar, EUcodigo) as EUcodigo 
	from FCajasActivas a, FCajas b
	where a.FCid=b.FCid 
	and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.FCid#">
</cfquery>

<!--- monedas registradas en pagos --->
<cfquery name="rsMonedasP" datasource="#session.DSN#">
	select distinct b.Mcodigo, c.Mnombre 
	from ETransacciones a, FPagos b, Monedas c
	where a.FCid=b.FCid
	  and a.ETnumero=b.ETnumero
	  and b.Mcodigo=c.Mcodigo
	  and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.FCid#">
	  and ETestado='T'
	  and FACid is null
	order by b.Mcodigo
</cfquery>

<!--- Monedas registradas en las facturas--->
<cfquery name="rsMonedasT" datasource="#session.DSN#">
	select distinct a.Mcodigo, Mnombre 
	from ETransacciones a , Monedas b
	where a.Mcodigo=b.Mcodigo
	and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.FCid#">
	and ETestado='T'
    and FACid is null	
	order by Mcodigo
</cfquery>

<cfquery  name="rsDatosSis" datasource="#session.DSN#">
	select b.CCTcodigo, c.CCTvencim, a.FCid, b.ETnumero, a.Mcodigo as pMcodigo, a.FPmontoori, a.Tipo, FPtc,
		   b.Mcodigo as tMcodigo, ETtc, FPmontolocal
	from FPagos a, ETransacciones b, CCTransacciones c
	where a.FCid=b.FCid
	  and a.ETnumero=b.ETnumero
	  and b.Ecodigo=c.Ecodigo	
      and b.CCTcodigo=c.CCTcodigo
	  and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.FCid#">
	  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by b.CCTcodigo, a.Tipo
</cfquery>


<cfset rsMonedas = QueryNew("Mcodigo, Mnombre")>
<!--- Moneas registradas en los pagos--->
<cfloop query="rsMonedasP">
	<!--- Agrega la fila procesada --->
	<cfset fila = QueryAddRow(rsMonedas, 1)>
	<cfset tmp  = QuerySetCell(rsMonedas, "Mcodigo", #rsMonedasP.Mcodigo#) >
	<cfset tmp  = QuerySetCell(rsMonedas, "Mnombre", #rsMonedasP.Mnombre#) >
</cfloop>

<!--- Moneas registradas en las transacciones y qu e no existan en el query --->
<cfloop query="rsMonedasT">
	<!--- agrega la moneda solo si no existe --->
	<cfquery name="rsExisteMoneda" dbtype="query" >
		select Mcodigo from rsMonedas where Mcodigo=#rsMonedasT.Mcodigo#
	</cfquery>	
	<cfif rsExisteMoneda.RecordCount eq 0>
		<!--- Agrega la fila procesada --->
		<cfset fila = QueryAddRow(rsMonedas, 1)>
		<cfset tmp  = QuerySetCell(rsMonedas, "Mcodigo", #rsMonedasP.Mcodigo#) >
		<cfset tmp  = QuerySetCell(rsMonedas, "Mnombre", #rsMonedasP.Mnombre#) >
	</cfif>
</cfloop>

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

	function total_dinero(moneda){
		var efectivo  = new Number(qf(eval('document.form1.FADCefectivo_' + moneda + '.value')));	
		var cheques   = new Number(qf(eval('document.form1.FADCcheques_' + moneda + '.value')));	
		var vouchers  = new Number(qf(eval('document.form1.FADCvouchers_' + moneda + '.value')));	
		var depositos = new Number(qf(eval('document.form1.FADCdepositos_' + moneda + '.value')));	
		eval('document.form1.totalFADCdinero_' + moneda).value = efectivo + cheques + vouchers + depositos;
		fm(eval('document.form1.totalFADCdinero_' + moneda), 2);
		
		// calcula las diferencias
		diferencias(eval('document.form1.totalFADCcontado_' + moneda).value, eval('document.form1.totalFADCdinero_' + moneda).value, moneda);
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
    <td colspan="3"><div align="center"><strong><font size="2">Fecha de Cierre: #LSDateFormat(Now(), 'dd/mm/yy')#</font></strong></div></td>
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
					   FADCvouchers, FADCdepositos, FADCdiferencias, FADCncredito, FCAfecha, Mcodigo,
					   ( FADCefectivo + FADCcheques + FADCvouchers + FADCdepositos ) as FADCdinero
				from rsDatos
				where Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMonedas.Mcodigo#">
			</cfquery>
		  </cfif>	
		  
		  <tr>
			<td width="1%"><input type="hidden" name="Mcodigo" value="#rsMonedas.Mcodigo#"></td>	
			<td>
				<fieldset>
					<legend><font size="2"><strong>Moneda:&nbsp; #rsMonedas.Mnombre# </strong></font></legend>
					
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr> 
					<td nowrap align="right">Monto Inicial:&nbsp;</td>
					<td nowrap> 
						<input name="FADCminicial_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCminicial, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El monto inicial para la moneda #rsMOnedas.Mnombre#">
					</td>
				  </tr>
				  <tr class="listaPar2"> 
					<td colspan="6"><strong>Documentos de Contado</strong></td>
				  </tr>
				  
				  <tr>
				      <td>&nbsp;</td>
					  <td><strong>Cajero</strong></td>
					  <td><strong>Sistema</strong></td>
					  <td>&nbsp;</td>
					  <td><strong>Cajero</strong></td>
					  <td><strong>Sistema</strong></td>
				  </tr>
				  
				  <tr> 
					<td nowrap align="right">Facturas de Contado:&nbsp;</td>
					<td nowrap> <input name="FADCcontado_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_documentos('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCcontado, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Facturas de Contado para la moneda #rsMonedas.Mnombre#"></td>

					<cfquery name="rsFADCcontado" dbtype="query">
						select sum(FPmontoori) as monto 
						from rsDatosSis
						where pMcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
					</cfquery>
					<td ><input name="FADCcontadosis_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsFADCcontado.RecordCount gt 0>#LSCurrencyFormat(rsFADCcontado.Monto, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" ></td>

					<td nowrap align="right">Efectivo:&nbsp;</td>
					<td ><input name="FADCefectivo_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCefectivo, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Efectivo para la moneda #rsMonedas.Mnombre#"></td>
					<cfquery name="rsEfectivo" dbtype="query">
						select sum(FPmontoori) as monto 
						from rsDatosSis
						where pMcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
						and Tipo='E'
					</cfquery>
					<td ><input name="FADCefectivosis_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsEfectivo.RecordCount gt 0>#LSCurrencyFormat(rsEfectivo.Monto, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" ></td>
				  </tr>
	
				  <tr>
					<td colspan="3" nowrap>&nbsp;</td>
					<td nowrap align="right">Cheques:&nbsp;</td>
					<td ><input name="FADCcheques_#rsMonedas.Mcodigo#"    type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCcheques, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" ></td>
					<cfquery name="rsCheques" dbtype="query">
						select sum(FPmontoori) as monto 
						from rsDatosSis
						where pMcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
						and Tipo='C'
					</cfquery>
					<td ><input name="FADCchequessis_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsCheques.RecordCount gt 0 >#LSCurrencyFormat(rsCheques.Monto, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" ></td>
				  </tr>	
	
				  <tr>
					<td colspan="3" nowrap>&nbsp;</td>	
					<td align="right">Voucheres:&nbsp;</td>
					<td><input name="FADCvouchers_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCvouchers, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Vouchers para la moneda #rsMonedas.Mnombre#"></td>
					<cfquery name="rsVouchers" dbtype="query">
						select sum(FPmontoori) as monto 
						from rsDatosSis
						where pMcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
						and Tipo='T'
					</cfquery>
					<td ><input name="FADCvoucherssis_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsVouchers.RecordCount gt 0 >#LSCurrencyFormat(rsVouchers.Monto, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" ></td>
					
				  </tr>	
	
				  <tr> 
					<td colspan="3" nowrap>&nbsp;</td>
					<td align="right">Dep&oacute;sito:&nbsp;</td>
					<td><input name="FADCdepositos_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCdepositos, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Dep&oacute;sitos para la moneda #rsMonedas.Mnombre#"></td>
					<cfquery name="rsDepositos" dbtype="query">
						select sum(FPmontoori) as monto 
						from rsDatosSis
						where pMcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
						and Tipo='D'
					</cfquery>
					<td ><input name="FADCdepositossis_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsDepositos.RecordCount gt 0 >#LSCurrencyFormat(rsDepositos.Monto, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" ></td>
				  </tr>

				  <tr> 
					<td div align="right"><strong>Total:&nbsp;</strong></td>
					<td><input name="totalFADCcontado_#rsMonedas.Mcodigo#" type="text" disabled="true" style="text-align: right;"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCcontado, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15"></td>
					<td>&nbsp;</td>
					<td align="right"><strong>Total:&nbsp;</strong></td>
					<td><input name="totalFADCdinero_#rsMonedas.Mcodigo#" type="text" disabled="true" style="text-align: right;"   onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCdinero, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15"></td>
					<td ><input name="totalFADCdinerosis_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsFADCcontado.RecordCount gt 0>#LSCurrencyFormat(rsFADCcontado.Monto, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" ></td>
					<td>&nbsp;</td>
				  </tr>

				  <tr> 
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>Diferencia:&nbsp;</strong></td>
					<td><input name="FADCdiferencias_#rsMonedas.Mcodigo#" type="text" disabled="true" style="text-align: right;"   onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCdiferencias, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15"></td>
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
					<td nowrap> <input name="FADCfcredito_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCfcredito, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Facturas de Crédito para la moneda #rsMonedas.Mnombre#"></td>
					<cfquery name="rsFADCfcredito" dbtype="query">
						select sum(FPmontoori) as monto 
						from rsDatosSis
						where pMcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonedas.Mcodigo#">
						and CCTvencim != -1
					</cfquery>
					<td ><input name="FADCfcreditosis_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); total_dinero('#rsMonedas.Mcodigo#');"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsFADCfcredito.RecordCount gt 0>#LSCurrencyFormat(rsFADCfcredito.Monto, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" ></td>

					<td nowrap align="right">Notas de Cr&eacute;dito:&nbsp;</td>
					<td nowrap> <input name="FADCncredito_#rsMonedas.Mcodigo#" type="text" style="text-align: right;" tabindex="#index#"  onfocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2); "  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.FADCncredito, 'none')#<cfelse>0.00</cfif>" size="15" maxlength="15" alt="El Monto en Notas de Crédito para la moneda #rsMonedas.Mnombre#"></td>
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
  <cfelse>
  	   <tr><td colspan="3" align="center"><strong><font size="2">No existen datos para el Cierre</font></strong></td></tr>
       <tr><td>&nbsp;</td></tr>
	   <tr> 
		 <td nowrap align="center">
			 <input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
		 </td>
	   </tr>
  </cfif>
  </cfoutput>	
</table>
</form>
