<cfif IsDefined('url.chk') And Len(url.chk)>
	<cfset url.cobros = url.chk>
<cfelseif IsDefined('url.id_cobro') And Len(url.id_cobro)>
	<cfset url.cobros = url.id_cobro>
<cfelse>
	<cfthrow message="Especifique el documento por aplicar">
</cfif>
<cf_template>
<cf_templatearea name="title">Registro de pago recibido</cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="payment_header.cfm">
<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

<cfoutput>
<script type="text/javascript">
<!--
	function sumar(f){
		fm(f.pago_efe,2);
		fm(f.pago_ch,2);
		f.total_recibido.value = parseFloat(f.pago_efe.value.replace(/,/g, '')) + parseFloat(f.pago_ch.value.replace(/,/g, ''));
		fm(f.total_recibido,2);
	}
	function validar(f){
		sumar(f);
		var total_recibido = f.total_recibido.value.replace(/,/g, '');
		if (parseFloat(total_recibido) != #NumberFormat(total_header.saldo,'0.00')#) {
			alert('El total de efectivo y cheques debe ser #NumberFormat(total_header.saldo,',0.00')#');
			return false;
		}
		return true;
	}
//-->
</script>
<form name="form1" method="post" action="" onSubmit="return validar(this);">
  <table  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>&nbsp;</td>
      <td colspan="2">&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3">Forma de pago </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>Efectivo</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><input name="pago_efe" type="text" id="pago_efe" style="text-align:right" onFocus="this.select()" onBlur="sumar(this.form)" value="0.00" size="20" maxlength="20"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><label for="pago_ch">Cheque</label></td>
      <td>N&ordm; de cheque </td>
      <td>Banco</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><input name="pago_ch" type="text" id="pago_ch" style="text-align:right" onFocus="this.select()" onBlur="sumar(this.form)" value="0.00" size="20" maxlength="20"></td>
      <td><input name="cheque_numero" type="text" id="cheque_numero" size="20" maxlength="20" onFocus="this.select()"></td>
      <td><input name="cheque_banco" type="text" id="cheque_banco" size="20" maxlength="20" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>Total recibido </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><input name="total_recibido" type="text" id="total_recibido" style="text-align:right" onFocus="this.select()" value="0.00" size="20" maxlength="20"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="2">&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="2">&nbsp;</td>
      <td><input type="submit" name="Submit" value="Aceptar"></td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
</cfoutput>
</cf_templatearea>
</cf_template>
