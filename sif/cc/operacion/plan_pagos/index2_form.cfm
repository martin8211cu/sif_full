
<cfoutput>
<cfset cuotas_pagadas = 0>
<cfset tipo = 'q'>
<cfset ult_cuota = documento.Dfecha>
<cfset pago_inicial = plan_pagos.principal>
<cfloop query="plan_pagos">
	<cfset dias_dif = Datediff('d', ult_cuota, plan_pagos.fecha)>
	<cfif dias_dif le 9>
		<cfset tipo = 's'>
	<cfelseif dias_dif gt 22>
		<cfset tipo = 'm'>
	<cfelse>
		<cfset tipo = 'q'>
	</cfif>
	<cfset ult_cuota = plan_pagos.fecha>
	<cfif plan_pagos.pagado>
		<cfset cuotas_pagadas = cuotas_pagadas + 1>
	<!---
	<cfelseif plan_pagos.intereses is 0 and plan_pagos.total neq 0 and plan_pagos.CurrentRow neq 1>
		<cfset pago_inicial = 0>
	--->
	<cfelseif plan_pagos.CurrentRow is 1 and plan_pagos.intereses neq 0>
		<cfset pago_inicial = 0>
	</cfif>
</cfloop>
<cfif pago_inicial neq 0>
	<cfset cuotas_pagadas = cuotas_pagadas +1 >
</cfif>

<cfquery datasource="#session.dsn#" name="pagos_pendientes">
	select Ecodigo,Pcodigo,CCTcodigo,PPnumero,DPmonto
	from DPagos dp
	where dp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and dp.Doc_CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
	  and dp.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
</cfquery>
<cfif pagos_pendientes.RecordCount>
	<table width="80%" align="center" border="0" cellspacing="0" cellpadding="0" style="margin:0 ">
  <tr>
    <td style="color:red"><br><strong>Advertencia:</strong>
		Hay <cfif pagos_pendientes.RecordCount is 1>un pago <cfelse> #pagos_pendientes.RecordCount# pagos </cfif>
		para este documento que a&uacute;n no ha sido aplicado. &nbsp;
		No podr&aacute; cambiar el plan de pagos mientras haya pagos en proceso.&nbsp;</td>
  </tr>
</table>
</cfif>

<form name="form1" action="index3_confirmar.cfm" method="get" onSubmit="return validar(this);">
	<input type="hidden" name="CCTcodigo" value="#HTMLEditFormat(Trim(url.CCTcodigo))#" tabindex="-1">
	<input type="hidden" name="Ddocumento" value="#HTMLEditFormat(Trim(url.Ddocumento))#" tabindex="-1">
	<cfif isdefined('form.params')>
		<input name="params" value="#form.params#" type="hidden" tabindex="-1">
	</cfif>
	<table width="450"  border="0" cellspacing="0" cellpadding="0">
	  	<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td width="180" align="right">Saldo actual </td>
			<td width="33">&nbsp;</td>
			<td width="180"><input name="saldo" tabindex="-1" type="text" id="saldo" style="text-align:right;border:1px solid gray" onfocus="this.select()" value="#NumberFormat(documento.Dsaldo,',0.00')#" size="20" readonly /></td>
			<td width="53">&nbsp;</td>
		</tr>
		
		<tr>
			<td>&nbsp;</td>
			<td align="right">N&uacute;mero de cuotas restantes </td>
			<td>&nbsp;</td>
		    <td><input name="plazo" type="text" maxlength="3" id="plazo" size="2" tabindex="1"
					style="text-align:right;background-color:##ffffcc"
					onfocus="this.select()" value="#plan_pagos.RecordCount - cuotas_pagadas#"
					onchange="calcular_cuotas(this.form)" 
					onkeyup="calcular_cuotas(this.form)" />
              <select name="tipo" onchange="calcular_cuotas(this.form)" style="background-color:##ffffcc" tabindex="1">
                <option value="s" <cfif tipo is 's'>selected</cfif>>Semanal</option>
                <option value="q" <cfif tipo is 'q'>selected</cfif>>Quincenal</option>
                <option value="m" <cfif tipo is 'm'>selected</cfif>>Mensual</option>
              </select></td>
		    <td>&nbsp;</td>
		</tr>
	 	<tr>
			<td>&nbsp;</td>
			<td align="right">&nbsp;</td>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td>
		  <td align="right">Pago inicial</td>
		  <td>&nbsp;</td>
		  <td><input name="pago_inicial" type="text" id="pago_inicial" maxlength="15" size="20" tabindex="1"
					value="#NumberFormat( pago_inicial , ',0.00' )#" 
					onfocus="this.select()" 
					onchange="calcular_cuotas(this.form)" 
					onkeyup="calcular_cuotas(this.form)" 
					onblur="formatCurrency(this,2)" style="text-align:right;background-color:##ffffcc" /></td>
		  <td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right">Fecha de pago inicial </td>
			<td>&nbsp;</td>
			<td align="left"><cf_sifcalendario name='primerfecha' value='#LSDateFormat(documento.Dvencimiento,'dd/mm/yyyy')#' 
					style="background-color:##ffffcc" tabindex="1">            </td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right">Tasa  anual de inter&eacute;s </td>
			<td>&nbsp;</td>
			<td align="left"><input name="interes" type="text" id="interes"  maxlength="6" size="10" tabindex="1"
					value="#NumberFormat(plan_pagos.PPtasa,'0.00')#" 
					onfocus="this.select()" 
					onchange="calcular_cuotas(this.form)" 
					onkeyup="calcular_cuotas(this.form)" 
					style="text-align:right;background-color:##ffffcc" />
		    %</td>
			<td>&nbsp;</td>
		</tr>
		
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap="nowrap">Tasa de inter&eacute;s moratorio </td>
			<td>&nbsp;</td>
			<td align="left" nowrap>
				<input name="mora" type="text" id="mora" size="10" maxlength="6"  tabindex="1"
					value="#NumberFormat(plan_pagos.PPtasamora,'0.00')#" 
					onFocus="this.select()" 
					style="text-align:right;background-color:##ffffcc">%</td>
			<td>&nbsp;</td>
		</tr>
		
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap>Monto  de cada cuota </td>
			<td>&nbsp;</td>
		    <td><input name="cuota" tabindex="-1" value=""  readonly type="text" id="cuota" size="20" 
					onfocus="this.select()" 
					onchange="calcular_cuotas(this.form)" 
					onkeyup="calcular_cuotas(this.form)" 
					style="text-align:right;border:1px solid gray" /></td>
		    <td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap>Cantidad de pagos </td>
			<td align="right">x</td>
		    <td><input name="plazo2" type="text" id="plazo2" tabindex="-1"  readonly value="#plan_pagos.RecordCount#" size="20" style="text-align:right;border:1px solid gray" /></td>
		    <td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap>Monto total </td>
			<td align="right">=</td>
		    <td><input name="total" tabindex="-1" readonly type="text" value="" id="total" size="20" style="text-align:right;border:1px solid gray" /></td>
		    <td>&nbsp;</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		  <td align="right" nowrap>&nbsp;</td>
		  <td>&nbsp;</td>
	      <td>&nbsp;</td>
	      <td>&nbsp;</td>
	  </tr>
		<tr>
			<td>&nbsp;</td>
		  <td align="right" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right" nowrap colspan="4">
				<cf_botones values="Calcular cuotas,Regresar" names="CalcularCuotas,Regresar" tabindex="1" >
				<!--- <input type="submit" value="Calcular cuotas"> --->			</td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>
	</table>
</form>

<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"> // </script>
<script type="text/javascript">
<!--
	function calcular_cuotas(f){
		var plazo = Math.abs(Math.round(parseFloat(f.plazo.value)));
		var interes = Math.abs(Math.round(parseFloat(f.interes.value)*100) / 10000);
		var saldo = #NumberFormat(documento.Dsaldo,'0.00')#;
		var tipo = f.tipo.value;
		var pago_inicial = Math.abs(Math.round(parseFloat(f.pago_inicial.value.replace(/,/g, ''))*100) / 100);
		if (isNaN(pago_inicial)){
			pago_inicial = 0;
			f.pago_inicial.value = 0;
		} else if (pago_inicial != parseFloat(f.pago_inicial.value.replace(/,/g, ''))) {
			f.pago_inicial.value = pago_inicial;
			formatCurrency(f.pago_inicial,2);
		}
		if (pago_inicial > saldo) {
			pago_inicial = saldo;
			saldo = 0;
			f.pago_inicial.value = pago_inicial;
			formatCurrency(f.pago_inicial,2);
		} else {
			saldo -= pago_inicial;
		}
		if (isNaN(plazo)) {
			f.plazo.value = '';
		} else if (plazo != f.plazo.value) {
			f.plazo.value = plazo;
		}
		if (isNaN(interes)) {
			f.interes.value = '';
		} else if (interes*100 != parseFloat(f.interes.value)) {
			f.interes.value = interes*100;
			formatCurrency(f.interes,2);
		}
		
		if (tipo == 'm') {
			// plazo ok, el plazo está en meses
			interes /= 12;
		} else if (tipo == 'q') {
			interes /= 24;
		} else if (tipo == 's') {
			interes /= 52;
		}
		
		if (isNaN(plazo) || isNaN(interes) || plazo <= 0) {
			cuota = saldo;
			plazo = 1;
			interes = 0;
		} 
		if (interes != 0) {
			cuota = saldo / ( (1 - Math.pow (1+interes, -plazo)) / interes );
		} else {
			cuota = saldo / plazo;
		}
		f.cuota.value = cuota;
		f.plazo2.value = plazo;
		f.total.value = cuota*plazo;
		formatCurrency(f.cuota, 2);
		formatCurrency(f.total, 2);
	}
	function validar(f){
		calcular_cuotas(f);
		if (isNaN(f.plazo.value) || f.plazo.value.length == 0) {
			alert ("Por favor especifique el número de cuotas restantes.  Debe ser una cantidad entera, y puede ser cero si desea consolidar el pago en una sola cuota sin intereses.");
			f.plazo.focus();
			return false;
		}
		if (isNaN(f.interes.value) || f.interes.value.length == 0) {
			alert ("Por favor especifique la tasa anual de interés.");
			f.interes.focus();
			return false;
		}
		return true;
	}
	calcular_cuotas(document.form1);
	document.form1.plazo.focus();
	
	function funcRegresar(){
		location.href = "index.cfm?#form.params#";
		return false;
	}
//-->
</script>
</cfoutput>