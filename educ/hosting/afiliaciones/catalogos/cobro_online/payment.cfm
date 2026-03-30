<cfif IsDefined('url.chk') And Len(url.chk)>
	<cfset url.cobros = url.chk>
<cfelseif IsDefined('url.id_cobro') And Len(url.id_cobro)>
	<cfset url.cobros = url.id_cobro>
<cfelse>
	<cfthrow message="Especifique el documento por cobrar">
</cfif>

<cfquery datasource="#session.dsn#" name="carrito">
	select c.importe, c.importe - c.pagado as saldo
	from sa_cobros c
	where c.id_cobro in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cobros#" list="yes">)
	  and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and contabilizado = 0
</cfquery>

<cfquery datasource="#session.dsn#" name="monedas">
	select Miso4217, Mnombre
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 2
</cfquery>
<cfquery datasource="#session.dsn#" name="bancos">
	select Bid, Bdescripcion
	from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 2
</cfquery>




<cf_template>
<cf_templatearea name=title>Realizar pago </cf_templatearea>

<cf_templatearea name=body>
<cfoutput>
<cfinclude template="payment_header.cfm">

<table width="100%">
	<tr><td class="subTitulo tituloListas">
		Total por pagar: &nbsp; #total_header.moneda# #NumberFormat(total_header.saldo,',0.00')#
</td></tr></table>



<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script type="text/javascript">
<!--
	function factor_blur(f) {
		fm(f.factor,2);
		var float_factor = parseFloat(f.factor.value.replace(/,/g,''));
		if (float_factor == 0) {
			float_factor = 1;
			input_factor.value = '1.00';
		}
		f.importe_pago.value = #NumberFormat(total_header.saldo,'0.00')# / float_factor;
		fm(f.importe_pago,2);
	};
	function pago_blur(f) {
		fm(f.importe_pago,2);
		var float_pago = parseFloat(f.importe_pago.value.replace(/,/g,''));
		var float_factor = #NumberFormat(total_header.saldo,'0.00')# / float_pago;
		var float_factor = Math.round(float_factor * 100)/100;
		if (float_factor == 0) {
			float_factor = 1;
			input_factor.value = '1.00';
		}
		f.factor.value = float_factor;
		f.importe_pago.value = #NumberFormat(total_header.saldo,'0.00')# / float_factor;
		fm(f.factor,2);
		fm(f.importe_pago,2);
	};
	function change_moneda(f) {
		f.factor.disabled = f.moneda_pago.value == '#JSStringFormat(total_header.moneda)#';
		f.importe_pago.disabled = f.moneda_pago.value == '#JSStringFormat(total_header.moneda)#';
		f.factor.value = '1.00';
		factor_blur(f);
	}
	function change_forma_pago(f){
		var forma_pago = f.forma_pago.value;
		(document.all?document.all.detalle_tarjeta:document.getElementById('detalle_tarjeta')).
			style.display = ( forma_pago == 'T' ) ? 'block' : 'none';
		(document.all?document.all.detalle_cheque:document.getElementById('detalle_cheque')).
			style.display = ( forma_pago == 'C' ) ? 'block' : 'none';
	}

	function setMedio(onoff,rowid) {
		var objrow = document.getElementById(rowid);
		if (objrow) {
			objrow.style.display = onoff ? "inline" : "none";
		}
	}
	function onMedio(ctl) {
		var tc = ctl.value == 'T';
		var cb = ctl.value == 'C';
		setMedio(tc,"tc1");
		setMedio(tc,"tc2");
		setMedio(cb,"cb1");
		setMedio(cb,"cb2");
		setMedio(cb,"cb3");
		setMedio(cb,"cb4");
	}
	function rowclicked(rownum) {
		if(document.form1.tarjeta.length) {
			document.form1.tarjeta[rownum].checked = true;
		}
	}

	<!--- 
		regresa true si cuenta es una cuenta cliente valida
		basada en la funcion fnVerificaCC de Óscar --->
	function fnVerificaCC(cuenta)
	{
		if (cuenta.length != 17) {
			return ("La cuenta cliente debe tener 17 dígitos");
		}
		
		var pesos = "1234567891234567";
		
		var suma_digitos = 0;
		for (var i = 0; i<16; i++)
			suma_digitos +=
				parseInt(cuenta.substring(i, i+1)) *
				parseInt(pesos.substring(i, i+1));
		
		var LvarDigito = suma_digitos % 11;
		if (LvarDigito == 10)
			LvarDigito = 1;
		return (parseInt(cuenta.substring(16, 17)) == LvarDigito) ? null : "La cuenta cliente es incorrecta";
	}
 

	function validar(f) {
		factor_blur(f);
		var msg = '';
		var ctl = null;
		if (f.forma_pago.value == 'T') {
			if (f.tc_tipo.value == '') { msg += "\n* Seleccione el tipo de tarjeta"; ctl = ctl?ctl:f.tc_tipo; }
			if (f.tc_numero.value == '') { msg += "\n* Digite el número de tarjeta"; ctl = ctl?ctl:f.tc_numero; }
			if (f.tc_nombre.value == '') { msg += "\n* Escriba su nombre tal y como aparece en su tarjeta"; ctl = ctl?ctl:f.tc_nombre; }
			if (f.tc_vence_mes.value == '') { msg += "\n* Seleccione el mes de vencimiento de la tarjeta"; ctl = ctl?ctl:f.tc_vence_mes; }
			if (f.tc_vence_ano.value == '') { msg += "\n* Seleccione el año de vencimiento de la tarjeta"; ctl = ctl?ctl:f.tc_vence_ano; }
			if (f.tc_digito.value == '') { msg += "\n* Digite los dígitos verificadores de su tarjeta"; ctl = ctl?ctl:f.tc_digito; }
		} else if (f.forma_pago.value == 'C') {
			if (f.cheque_numero.value == '') { msg += "\n* Escriba el número de cheque"; ctl = ctl?ctl:f.tc_tipo; }
			if (f.cheque_cuenta.value == '') { msg += "\n* Escriba el número de cuenta del cheque"; ctl = ctl?ctl:f.tc_tipo; }
			else {
				var msg_cc = fnVerificaCC(f.cheque_cuenta.value);
				if (msg_cc) {
					msg += "\n* " + msg_cc;
					ctl = ctl?ctl:f.tc_tipo;
				}
			}
			if (f.cheque_Bid.value == '') { msg += "\n* Seleccione el banco emisor del cheque"; ctl = ctl?ctl:f.tc_tipo; }
		}
		if (msg.length || ctl) {
			alert('Verifique la siguiente información:' + msg);
			ctl.focus();
			return false;
		}
		return true;
	}
//-->
</script>


<form action="payment2.cfm" method="post" name="form1" style="margin:0" onSubmit="return validar(this)">

 <table width="679" border="0" align="center" cellspacing="2">
<tr>
  <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr align="center">
      <td colspan="3" class="tituloListas">Moneda del Pago </td> 
    </tr>
    <tr>
      <td width="200" align="right"><strong>Moneda: </strong></td>
      <td width="5" align="right">&nbsp;</td>
      <td width="364">
	  	<select name="moneda_pago" id="moneda_pago" onChange="change_moneda(this.form)" style="width:250px">
		<cfloop query="monedas">
			<option value="#HTMLEditFormat(monedas.Miso4217)#"
				<cfif monedas.Miso4217 is total_header.moneda> selected </cfif>	>#HTMLEditFormat(monedas.Mnombre)#</option>
		</cfloop>
		</select>
	  </td>
    </tr>
    <tr>
      <td align="right"><strong>Tipo de Cambio: </strong></td>
      <td align="right">&nbsp;</td>
      <td> <input type="text" size="30" disabled name="factor" style="text-align:right;width:250px" value="1.00" onBlur="factor_blur(this.form)" onFocus="this.select()"> </td>
    </tr>
    <tr>
      <td align="right"><strong>Importe del Pago: </strong></td>
      <td align="right">&nbsp;</td>
      <td> <input type="text" size="30" disabled name="importe_pago" style="text-align:right;width:250px" value="#NumberFormat(total_header.saldo,',0.00')#" onBlur="pago_blur(this.form)" onFocus="this.select()"> </td>
    </tr>
    <tr>
      <td align="right"><strong>Forma de Pago: </strong></td>
      <td align="right">&nbsp;</td>
      <td><select name="forma_pago" id="forma_pago" onchange="change_forma_pago(this.form)" style="width:250px " >
        <option value="T" selected>Tarjeta de Cr&eacute;dito</option>
        <option value="E">Efectivo</option>
        <option value="C">Cheque</option>
      </select></td>
    </tr>
  </table></td>
  <td>&nbsp;</td>
</tr>
<tr><td>
<div id="detalle_tarjeta" style="display:block">
	<cf_tarjeta action="input" title="Medio de pago"></div>
<div id="detalle_cheque" style="display:none">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr align="center">
    <td colspan="3" class="tituloListas">Cheque recibido </td>
  </tr>
  <tr>
    <td width="200" align="right"><strong>N&uacute;mero de cheque:</strong></td>
    <td width="5">&nbsp;</td>
    <td width="364"><input name="cheque_numero" style="width:250px " size="30" type="text" id="cheque_numero" onfocus="this.select()" maxlength="60"></td>
  </tr>
  <tr>
    <td align="right"><strong>N&uacute;mero de cuenta cliente: </strong></td>
    <td>&nbsp;</td>
    <td><input name="cheque_cuenta" style="width:250px " size="30" type="text" id="cheque_cuenta" onfocus="this.select()" maxlength="60"></td>
  </tr>
  <tr>
    <td align="right"><strong>Banco:</strong></td>
    <td>&nbsp;</td>
    <td><select name="cheque_Bid" id="cheque_Bid" style="width:250px " >
      <option value="" selected>(Seleccione Banco)</option>
      <option value="#bancos.Bid#" >#bancos.Bdescripcion#</option>
    </select></td>
  </tr>
</table>
</div>

</td>
  <td width="100" valign="top">
  
  </td>
</tr>
	    <tr>
		  <td align="center">
	      <input name="pago2" type="button" id="pago2" value="&lt;&lt; Regresar" onClick="history.back()" >
		  &nbsp; &nbsp;
			  <input name="pago" type="submit" id="pago" value="Continuar &gt;&gt;" >
		  </td>
	      <td width="100" valign="top">&nbsp;</td>
	    </tr>
	    <tr>
	      <td align="center">&nbsp;</td>
          <td width="100" valign="top">&nbsp;</td>
      </tr>
	    <tr align="right">
	      <td>&nbsp;</td>
          <td width="100" valign="top">&nbsp;</td>
      </tr>
  </table>
  <input type="hidden" name="cobros" value="#HTMLEditFormat(url.cobros)#">
</form>
</cfoutput>

<script type="text/javascript">
<!--
change_forma_pago(document.form1);
//-->
</script>
</cf_templatearea>
</cf_template>
