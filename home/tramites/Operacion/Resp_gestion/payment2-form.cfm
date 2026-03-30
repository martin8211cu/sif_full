<cfparam name="url.forma_pago">

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
<cfparam name="url.importe_pago" default="0">
<cfparam name="url.moneda_pago" default="">
<cfparam name="url.factor" default="1">

<cfif url.importe_pago is 0 or Len(url.moneda_pago) is 0>
	<cfset url.importe_pago = NumberFormat(total_header.saldo,',0.00')  >
	<cfset url.moneda_pago  = total_header.moneda >
	<cfset url.factor       = '1.00' >
</cfif>

<form action="payment_go.cfm" method="post" name="form1" style="margin:0" onSubmit="return form_being_submitted(this);">
<table width="400" >
<tr><td class="tituloListas">
	Total por pagar: &nbsp; #total_header.moneda# #NumberFormat(total_header.saldo,',0.00')#
</td></tr>
<tr><td class="subTitulo tituloListas">
	Cancelar con: &nbsp; #url.moneda_pago# #url.importe_pago# 
	<cfif url.moneda_pago neq total_header.moneda>
	(T.C. #url.factor#)</cfif></td></tr>
	
	<tr>
	  <td align="right">
	  <cfif url.forma_pago is 'T'>
			<!--- solo si fuera a usar tarjetas pre-registradas
			<cfif Not IsDefined("url.tarjeta")>--->
				<cf_tarjeta action="readform" name="tarj">
			<!---<cfelse>
				<cf_tarjeta action="select" key="#url.tarjeta#" name="tarj">
			</cfif>--->
			<cf_tarjeta action="display" data="#tarj#" titulo="Pago con tarjeta">
			<cf_tarjeta action="hidden" data="#tarj#" >
		<cfelseif url.forma_pago is 'C'>
			<cfparam name="url.cheque_numero">
			<cfparam name="url.cheque_cuenta">
			<cfparam name="url.cheque_banco">
			<input name="cheque_numero" type="hidden" value="#HTMLEditFormat(url.cheque_numero)#">
			<input name="cheque_cuenta" type="hidden" value="#HTMLEditFormat(url.cheque_cuenta)#">
			<input name="cheque_banco" type="hidden" value="#HTMLEditFormat(url.cheque_banco)#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr align="center">
				<td colspan="3" class="tituloListas">Pago con cheque</td>
			  </tr>
			  <tr>
				<td width="200" align="right"><strong>N&uacute;mero de cheque:</strong></td>
				<td width="5">&nbsp;</td>
				<td width="364">#HTMLEditFormat(url.cheque_numero)#
				</td>
			  </tr>
			  <tr>
				<td align="right"><strong>N&uacute;mero de cuenta cliente:</strong></td>
				<td>&nbsp;</td>
				<td>#HTMLEditFormat(url.cheque_cuenta)#</td>
			  </tr>
			  <tr>
				<td align="right"><strong>Siglas del Banco:</strong></td>
				<td>&nbsp;</td>
				<td>#HTMLEditFormat(url.cheque_banco)#</td>
			  </tr>
			</table>
		<cfelseif url.forma_pago is 'E'>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr align="center">
				<td colspan="3" class="tituloListas subTitulo">Pago en efectivo</td>
			  </tr></table>
		<cfelse>
			<cfthrow message="Forma de pago invlida: #url.forma_pago#">
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
			  <input type="hidden" name="importe_pago" value="#HTMLEditFormat(Replace(url.importe_pago,',','','all'))#">
			  <input type="hidden" name="factor" value="#HTMLEditFormat(Replace(url.factor,',','','all'))#">
			  <input type="hidden" name="moneda_pago" value="#HTMLEditFormat(url.moneda_pago)#">
			  <input type="hidden" name="forma_pago" value="#HTMLEditFormat(url.forma_pago)#">
			  
			  </td>
	    </tr>
  	</table>
	<cfquery datasource="#session.tramites.dsn#" name="RSinst">
		select  ts_rversion
		from TPInstanciaRequisito
		where id_instancia  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_instancia#">
		and id_requisito =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
	</cfquery>
	
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#RSinst.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	
	<input type="hidden" name="ID_INSTANCIA" 	 value="<cfif isdefined("url.ID_INSTANCIA")>#url.ID_INSTANCIA#</cfif>">
	<input type="hidden" name="ID_REQUISITO" 	 value="<cfif isdefined("url.ID_REQUISITO")>#url.ID_REQUISITO#</cfif>">
	<input type="hidden" name="ts_rversion" 	 value="<cfif isdefined("ts")>#ts#</cfif>">
	<input type="hidden" name="NUM_AUTORIZACION" value="<cfif isdefined("url.NUM_AUTORIZACION")>#url.NUM_AUTORIZACION#</cfif>">
	<input type="hidden" name="NUM_AUTORIZACION" value="<cfif isdefined("url.NUM_AUTORIZACION")>#url.NUM_AUTORIZACION#</cfif>">
	<input type="hidden" name="id_persona" value="<cfif isdefined("url.id_persona")>#url.id_persona#</cfif>">
	<input type="hidden" name="id_tramite" value="<cfif isdefined("url.id_tramite")>#url.id_tramite#</cfif>">
</form>
</cfoutput>
