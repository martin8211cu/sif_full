<cfif ExisteRecarga>

<cfparam name="url.tj" default="">
<cfparam name="url.recargaok" default="">

<script type="text/javascript" src="../../js/utilesMonto.js"></script>
<script type="text/javascript">
<!--
document.qrytj = '';
document.qrypw = '';
function consultarSaldo() {
	var f = document.form1;
	if (document.qrytj == f.tj.value && document.qrypq == f.pw.value)
		return true;
	if (f.tj.value.length == 0)
		return false;
	if (f.pw.value.length == 0)
		return false;
	setSaldo('Consultando...','Consultando...','');
	f.costo_total.value = 'Consultando...';
	document.qrytj = f.tj.value;
	document.qrypq = f.pw.value;
	window.open('/cfmx/saci/utiles/gestion-recarga-saldo.cfm?tj=' + escape(f.tj.value) + '&pw=' + escape(f.pw.value) + '&rand=' + Math.random(), 'iframesaldo');
	return false;
}
function quitarSaldo() {
	setSaldo('','','');
}
function setSaldo(s, cpm, mon) {
	var f = document.form1;
	f.saldo_actual.value = s;
	f.costo_por_hora.value = cpm;
	f.moneda1.value = mon;
	f.moneda2.value = mon;
	calcularCostoTotal();
}
function calcularCostoTotal() {
	var f = document.form1;
	var cph = f.costo_por_hora.value.replace(/,/g, '');
	if (isNaN(f.horas_recarga.value) || isNaN(cph)) {
		if (isNaN(f.horas_recarga.value))
			f.horas_recarga.value = '';
		if (isNaN(f.costo_por_hora.value))
			f.costo_total.value = '';
	} else {
		f.costo_total.value = fm( parseFloat(cph) * parseFloat(f.horas_recarga.value) + 0.004, 2);
	}
}
function validar(f) {
	if (!consultarSaldo()) return false;
	calcularCostoTotal();
	if (f.costo_total.value == 0) {
		alert('Especifique cuánto quiere pagar antes de continuar');
		return false;
	}
	return true;
}
//-->
</script>

<cfif Len(url.recargaok)>
	<cfif url.recargaok is 1>
		<cf_message text="La recarga ha sido aceptada" type="information">
	<cfelse>
		<cf_message text="La transacción ha sido rechazada" type="error">
	</cfif>
</cfif>
<form action="gestion-recarga-apply.cfm" method="post" name="form1" onsubmit="return validar(this);">
<cfinclude template="gestion-hiddens.cfm">
<table width="593" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="247">Número de tarjeta de prepago </td>
    <td width="145"><cfoutput>
      <input type="text" name="tj" value="#HTMLEditFormat(url.tj)#" onfocus="this.select()" onchange="consultarSaldo()" onblur="consultarSaldo()"></cfoutput></td>
    <td width="189">&nbsp;</td>
  </tr>
  <tr>
    <td>Contraseña de la tarjeta </td>
    <td><input type="password" name="pw" value="" onfocus="this.select()" onchange="consultarSaldo()" onblur="consultarSaldo()"></td>
    <td><input type="button" name="consultar_saldo" value="Consultar saldo ahora" onClick="consultarSaldo()" class="btnRefresh"></td>
  </tr>
  <tr>
    <td>Horas por recargar </td>
    <td><input type="text" name="horas_recarga" value="0" onfocus="this.select();consultarSaldo()" onchange="consultarSaldo();calcularCostoTotal()"></td>
    <td>horas</td>
  </tr>
  <tr>
    <td>Saldo actual </td>
    <td><input type="text" name="saldo_actual" value="" readonly="readonly" style="background-color:#CCCCCC"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Costo por hora </td>
    <td><input type="text" name="costo_por_hora" value="" readonly="readonly" style="background-color:#CCCCCC"></td>
    <td><input type="text" name="moneda1" value="" readonly="readonly" size="4" style="border:none"></td>
  </tr>
  <tr>
    <td>Costo total </td>
    <td><input type="text" name="costo_total" value="" readonly="readonly" style="background-color:#CCCCCC"></td>
    <td><input type="text" name="moneda2" value="" readonly="readonly" size="4" style="border:none"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="pagar" value="Pagar" class="btnSiguiente"></td>
    <td>&nbsp;</td>
  </tr>
</table>


</form>

<iframe name="iframesaldo" src="about:blank" width="1" height="1" frameborder="0" style="display:none">
</iframe>
</cfif>