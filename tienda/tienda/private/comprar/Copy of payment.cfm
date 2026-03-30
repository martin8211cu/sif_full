<cfif Not IsDefined("session.id_carrito")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>
<cfset pmt_id_carrito = session.id_carrito>

<cfquery datasource="#session.dsn#" name="carrito">
	select direccion_envio,direccion_facturacion,observaciones
	from Carrito
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
</cfquery>

<cf_template>
<cf_templatearea name=title>Realizar pago </cf_templatearea>
<cf_templatearea name=header>
<cfinclude template="/tienda/tienda/public/carrito_p.cfm">
</cf_templatearea>
<cf_templatearea name=body>
<script type="text/javascript">
<!--
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
	function validar(f) {
		if (f.tc_tipo.value == '') { alert ("Seleccione el tipo de tarjeta"); f.tc_tipo.focus(); return false; }
		if (f.tc_numero.value == '') { alert ("Digite el número de tarjeta"); f.tc_numero.focus(); return false; }
		if (f.tc_nombre.value == '') { alert ("Escriba su nombre tal y como aparece en su tarjeta"); f.tc_nombre.focus(); return false; }
		if (f.tc_vence_mes.value == '') { alert ("Seleccione el mes de vencimiento de la tarjeta"); f.tc_vence_mes.focus(); return false; }
		if (f.tc_vence_ano.value == '') { alert ("Seleccione el a&ntilde;o de vencimiento de la tarjeta"); f.tc_vence_ano.focus(); return false; }
		if (f.tc_digito.value == '') { alert ("Digite los dígitos verificadores de su tarjeta"); f.tc_digito.focus(); return false; }
	}
//-->
</script>

<cfinclude template="../../public/estilo.cfm">

<cfoutput>
<form action="payment2.cfm" method="post" name="form1" style="margin:0" onSubmit="return validar(this)">
 <table width="679" border="0" align="center" cellspacing="2">
<tr><td colspan="2">
<cf_direccion action="display" key="#carrito.direccion_envio#" title="Dirección de envío" prefix="env">
<cf_direccion action="display" key="#carrito.direccion_facturacion#" title="Dirección de facturación" prefix="fac">
</td>
  <td width="100" valign="top">&nbsp;</td>
</tr>

<cfif Len(Trim(carrito.observaciones))>
<tr><td colspan="2">Observaciones</td></tr>
<tr><td colspan="2">#HTMLEditFormat(carrito.observaciones)#</td></tr>
</cfif>
<tr><td colspan="2">

<cf_tarjeta action="input">

</td>
  <td width="100" valign="top">
  
  </td>
</tr>
	    
	    <tr>
	      <td colspan="2" align="center">&nbsp;</td>
          <td width="100" valign="top">&nbsp;</td>
      </tr>
	    <tr>
		  <td colspan="2" align="center"><input name="pago" type="submit" id="pago" value="Confirmar" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago">
	      <input name="pago2" type="button" id="pago2" value="Atr&aacute;s" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago">
	      <input name="pago3" type="submit" id="pago3" value="Cancelar" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago"></td>
	      <td width="100" valign="top">&nbsp;</td>
	    </tr>
	    <tr align="right">
	      <td colspan="2">&nbsp;</td>
          <td width="100" valign="top">&nbsp;</td>
      </tr>
  </table>
</form>
  </cfoutput>
</cf_templatearea>
</cf_template>
