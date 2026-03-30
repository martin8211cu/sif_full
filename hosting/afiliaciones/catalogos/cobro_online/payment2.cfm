<cfparam name="form.cobros" type="string">
<cfparam name="form.forma_pago">
<cf_template>
<cf_templatearea name=title>Realizar pago </cf_templatearea>
<cf_templatearea name=body>
<script type="text/javascript">
<!--
function form_being_submitted(f) {
	f.regresar.disabled = true;
	f.pago.disabled = true;
	return true;
}
-->
</script>
<cfoutput>
<cfinclude template="payment_header.cfm">
<cfparam name="form.importe_pago" default="0">
<cfparam name="form.moneda_pago" default="">
<cfparam name="form.factor" default="1">

<cfif form.importe_pago is 0 or Len(form.moneda_pago) is 0>
	<cfset form.importe_pago = NumberFormat(total_header.saldo,',0.00')  >
	<cfset form.moneda_pago  = total_header.moneda >
	<cfset form.factor       = '1.00' >
</cfif>

<form action="payment_go.cfm" method="post" name="form1" style="margin:0" onSubmit="return form_being_submitted(this);">
<table width="679" >
<tr><td class="tituloListas">
	Total por pagar: &nbsp; #total_header.moneda# #NumberFormat(total_header.saldo,',0.00')#
</td></tr>
<tr><td class="subTitulo tituloListas">
	Cancelar con: &nbsp; #form.moneda_pago# #form.importe_pago# 
	<cfif form.moneda_pago neq total_header.moneda>
	(T.C. #form.factor#)</cfif></td></tr>
	
	<tr>
	  <td align="right">
	  <cfif form.forma_pago is 'T'>
			<!--- solo si fuera a usar tarjetas pre-registradas
			<cfif Not IsDefined("form.tarjeta")>--->
				<cf_tarjeta action="readform" name="tarj">
			<!---<cfelse>
				<cf_tarjeta action="select" key="#form.tarjeta#" name="tarj">
			</cfif>--->
			<cf_tarjeta action="display" data="#tarj#" titulo="Pago con tarjeta">
			<cf_tarjeta action="hidden" data="#tarj#" >
		<cfelseif form.forma_pago is 'C'>
			<cfparam name="form.cheque_numero">
			<cfparam name="form.cheque_cuenta">
			<cfparam name="form.cheque_Bid">
					
			<cfquery datasource="#session.dsn#" name="bancos">
				select Bid, Bdescripcion
				from Bancos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cheque_Bid#">
			</cfquery>
			
			<input name="cheque_numero" type="hidden" value="#HTMLEditFormat(form.cheque_numero)#">
			<input name="cheque_cuenta" type="hidden" value="#HTMLEditFormat(form.cheque_cuenta)#">
			<input name="cheque_Bid" type="hidden" value="#HTMLEditFormat(bancos.Bid)#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr align="center">
				<td colspan="3" class="tituloListas">Pago con cheque</td>
			  </tr>
			  <tr>
				<td width="200" align="right"><strong>N&uacute;mero de cheque:</strong></td>
				<td width="5">&nbsp;</td>
				<td width="364">#HTMLEditFormat(form.cheque_numero)#
				</td>
			  </tr>
			  <tr>
				<td align="right"><strong>N&uacute;mero de cuenta cliente: </strong></td>
				<td>&nbsp;</td>
				<td>#HTMLEditFormat(form.cheque_cuenta)#</td>
			  </tr>
			  <tr>
				<td align="right"><strong>Banco:</strong></td>
				<td>&nbsp;</td>
				<td>#HTMLEditFormat(bancos.Bdescripcion)#</td>
			  </tr>
			</table>
		<cfelseif form.forma_pago is 'E'>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr align="center">
				<td colspan="3" class="tituloListas subTitulo">Pago en efectivo</td>
			  </tr></table>
		<cfelse>
			<cfthrow message="Forma de pago inválida: #form.forma_pago#">
		</cfif>
	  </td>
  </tr>
	    <tr>
	      <td align="center">Para confirmar, oprima el bot&oacute;n de confirmar <strong>una sola vez</strong>. Si lo presiona varias veces, podr&iacute;a afectar el procesamiento de su transacci&oacute;n. </td>
    </tr>
	    <tr>
		  <td align="center">
	      <input name="pago2" type="button" id="regresar" value="&lt;&lt; Regresar" onClick="history.back()" >
		  &nbsp; &nbsp;
			  <input name="pago" type="submit" id="pago" value="Continuar &gt;&gt;" >
			  <input type="hidden" name="cobros" value="#HTMLEditFormat(form.cobros)#">
			  <input type="hidden" name="importe_pago" value="#HTMLEditFormat(Replace(form.importe_pago,',','','all'))#">
			  <input type="hidden" name="factor" value="#HTMLEditFormat(Replace(form.factor,',','','all'))#">
			  <input type="hidden" name="moneda_pago" value="#HTMLEditFormat(form.moneda_pago)#">
			  <input type="hidden" name="forma_pago" value="#HTMLEditFormat(form.forma_pago)#">
			  
			  </td>
	    </tr>
  </table>
</form>
</cfoutput>
</cf_templatearea>
</cf_template>
