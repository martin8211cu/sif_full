<cfif Not IsDefined("session.id_carrito")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>
<cfset pmt_id_carrito = session.id_carrito>
<cfparam name="url.nuevatarjeta" default="">

<cfquery datasource="#session.dsn#" name="carrito">
	select direccion_envio,direccion_facturacion,observaciones
	from Carrito
	where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
</cfquery>

<cfquery datasource="aspsecure" name="tarjetas">
	select id_tarjeta
	from UsuarioTarjeta
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	order by id_tarjeta desc
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
	function rowclicked(rownum) {
		if(document.form1.tarjeta.length) {
			document.form1.tarjeta[rownum].checked = true;
		}
	}
	function validar(f) {
		if (f["tc_tipo"]) {
			if (f.tc_tipo.value == '') { alert ("Seleccione el tipo de tarjeta"); f.tc_tipo.focus(); return false; }
			if (f.tc_numero.value == '') { alert ("Digite el número de tarjeta"); f.tc_numero.focus(); return false; }
			if (f.tc_nombre.value == '') { alert ("Escriba su nombre tal y como aparece en su tarjeta"); f.tc_nombre.focus(); return false; }
			if (f.tc_vence_mes.value == '') { alert ("Seleccione el mes de vencimiento de la tarjeta"); f.tc_vence_mes.focus(); return false; }
			if (f.tc_vence_ano.value == '') { alert ("Seleccione el a&ntilde;o de vencimiento de la tarjeta"); f.tc_vence_ano.focus(); return false; }
			if (f.tc_digito.value == '') { alert ("Digite los dígitos verificadores de su tarjeta"); f.tc_digito.focus(); return false; }
		} else {
			var radios = f.tarjeta;
			if (radios.length) {
				var anychecked = false;
				var rindex = 0;
				for (rindex = 0; rindex < radios.length; rindex++) {
					anychecked |= radios[rindex].checked;
				}
				if (!anychecked) {
					alert("Seleccione el medio de pago deseado.");
					return false;
				}
			} else {
				radios.checked = true;
			}
		}
		return true;
	}
//-->
</script>

<cfinclude template="../../public/estilo.cfm">

<cfoutput>
<form action="payment2.cfm" method="post" name="form1" style="margin:0" onSubmit="return validar(this)">
 <table width="679" border="0" align="center" cellspacing="2">
<tr><td colspan="2">

<cfif (Len(url.nuevatarjeta) NEQ 0) OR (tarjetas.RecordCount IS 0)>
	<cf_tarjeta action="input">
<cfelse>
	<table border="0" width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="4"  align="center" class="tituloListas">Seleccione su forma de pago</td>
		</tr><tr>
	<cfloop query="tarjetas">
	<cf_tarjeta action="select" name="data_tarjeta" key="#tarjetas.id_tarjeta#">
		<tr>
		  <td valign="top"><input type="radio" value="#data_tarjeta.id_tarjeta#" id="tarjeta" name="tarjeta" <cfif tarjetas.CurrentRow IS 1>checked</cfif>></td>
		  <td style="cursor:pointer;" onClick="rowclicked(#tarjetas.CurrentRow - 1#)"><b>Tarjeta
                <cfif data_tarjeta.tc_tipo eq 'VISA' >
    VISA
      <cfelseif data_tarjeta.tc_tipo eq 'AMEX' >
    AMEX
    <cfelseif trim(data_tarjeta.tc_tipo) eq 'MC'>
    MASTERCARD
                </cfif>
          </b></td>
		  <td>&nbsp;</td>
		  <td align="right">&nbsp;</td>
		</tr>
		<tr style="cursor:pointer;" onClick="rowclicked(#tarjetas.CurrentRow - 1#)">
		  <td valign="top">&nbsp;</td>
		  <td nowrap><b>N&uacute;mero</b></td>
		  <td>&nbsp;</td>
		  <td>#repeatstring('X', max(8,len(trim(data_tarjeta.tc_numero))-4))##right(trim(data_tarjeta.tc_numero), 4)#</td>
		</tr>
		<tr style="cursor:pointer;" onClick="rowclicked(#tarjetas.CurrentRow - 1#)">
		  <td valign="top">&nbsp;</td>
		  <td nowrap><b>Nombre impreso en la tarjeta</b></td>
		  <td>&nbsp;</td>
		  <td>#data_tarjeta.tc_nombre#</td>
		</tr>
		<tr style="cursor:pointer;" onClick="rowclicked(#tarjetas.CurrentRow - 1#)">
		  <td valign="top">&nbsp;</td>
		  <td nowrap><b>Vencimiento</b></td>
		  <td>&nbsp;</td>
		  <td>#data_tarjeta.tc_vence_mes# / #data_tarjeta.tc_vence_ano#</td>
		</tr>
		<tr style="cursor:pointer;" onClick="rowclicked(#tarjetas.CurrentRow - 1#)">
		  <td valign="top">&nbsp;</td>
		  <td nowrap><b>C&oacute;digo Postal</b></td>
		  <td>&nbsp;</td>
		  <td>#data_tarjeta.direccion.codPostal#&nbsp;</td>
		</tr>
		<tr style="cursor:pointer;" onClick="rowclicked(#tarjetas.CurrentRow - 1#)">
		<td valign="top">&nbsp;</td>
		<td colspan="3">&nbsp;
		</td>
		</tr>
		<tr><td colspan="4"><hr size="1%"></td></tr>
	</cfloop>
	</table>
</cfif>

</td>
  <td width="100" valign="top">
  
  </td>
</tr>
	    <tr>
		  <td colspan="2" align="center">
		  <cfif (Len(url.nuevatarjeta) IS 0) AND (tarjetas.RecordCount NEQ 0)>
		  <input type="button" name="btnOtra" value="Utilizar otra tarjeta" onClick="javascript:location.href='payment.cfm?nuevatarjeta=y';">
		  <cfelseif (Len(url.nuevatarjeta) NEQ 0) AND (tarjetas.RecordCount NEQ 0)>
		  <input type="button" name="btnOtra" value="Utilizar una tarjeta registrada" onClick="javascript:location.href='payment.cfm';">
		  </cfif>
		  <input name="pago" type="submit" id="pago" value="Confirmar" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago">
	      <input name="pago2" type="button" id="pago2" value="Atr&aacute;s" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago">
	      <input name="pago3" type="submit" id="pago3" value="Cancelar" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago"></td>
	      <td width="100" valign="top">&nbsp;</td>
	    </tr>
	    <tr>
	      <td colspan="2" align="center">&nbsp;</td>
          <td width="100" valign="top">&nbsp;</td>
      </tr>
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
	    <tr align="right">
	      <td colspan="2">&nbsp;</td>
          <td width="100" valign="top">&nbsp;</td>
      </tr>
  </table>
</form>
  </cfoutput>
</cf_templatearea>
</cf_template>
