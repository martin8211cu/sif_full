<cfif Not IsDefined("session.id_carrito")><cflocation url="../../public/index.cfm" addtoken="no"></cfif>

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

<cfinclude template="../../public/estilo.cfm">
<script type="text/javascript">
<!--
function form_being_submitted(f) {
	f.pago.disabled = true;
	f.pago2.disabled = true;
	f.pago3.disabled = true;
	return true;
}
-->
</script>
<cfoutput>
<form action="payment_go.cfm" method="post" name="form1" style="margin:0" onSubmit="return form_being_submitted(this);">
 <table width="679" border="0" align="center" cellspacing="2">
	<tr><td><cf_direccion action="display" key="#carrito.direccion_envio#" title="Dirección de envío" prefix="env"></td></tr>
	<tr><td><cf_direccion action="display" key="#carrito.direccion_facturacion#" title="Dirección de facturación" prefix="fac"></td></tr>
	<cfif Len(Trim(carrito.observaciones))>
	<tr><td class="tituloListas">Observaciones</td></tr>
	<tr><td>#HTMLEditFormat(carrito.observaciones)#</td></tr>
	</cfif>
</tr>
	<tr>
	  <td align="right">
		<cfif Not IsDefined("form.tarjeta")>
			<cf_tarjeta action="readform" name="tarj">
		<cfelse>
			<cf_tarjeta action="select" key="#form.tarjeta#" name="tarj">
		</cfif>
		<cf_tarjeta action="display" data="#tarj#">
		<cf_tarjeta action="hidden" data="#tarj#">
	  </td>
  </tr>
	    <tr>
	      <td align="center">Para confirmar, oprima el bot&oacute;n de confirmar <strong>una sola vez</strong>. Si lo presiona varias veces, podr&iacute;a afectar el procesamiento de su transacci&oacute;n. </td>
    </tr>
	    <tr>
		  <td align="center"><input name="pago" type="submit" id="pago" value="Confirmar" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago">
	      <input name="pago2" type="button" id="pago2" value="Atr&aacute;s" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago">
	      <input name="pago3" type="submit" id="pago3" value="Cancelar" xrc="../../images/btn_realizarpago.gif" alt="Realizar pago"></td>
	    </tr>
  </table>
</form>
</cfoutput>
</cf_templatearea>
</cf_template>
