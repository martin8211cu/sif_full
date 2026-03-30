<cfquery datasource="asp" name="monedas">
	select Miso4217, Mnombre
	from Moneda
	order by 2
</cfquery>
<cfoutput>

<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<!--- Style para que los botones sean de colores --->

<form action="req_pago_sql.cfm" method="post" name="form1" style="margin:0" >
	<cfinclude template="payment_header.cfm">
	<table border="0" width="520" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
				<strong>Registro de Pato Realizado</strong>
			</td>
		</tr>	
		<tr>
			<td  align="right" class="tituloListas">Total por Pagar:</td>
			<td  class="tituloListas">#total_header.moneda# #NumberFormat(total_header.saldo,',0.00')#</td>
		</tr>
		<tr>
			<td align="right">N&uacute;mero Tiquete Caja: </td>
			<td ><input name="num_tiquete" size="20" type="text" id="num_autorizacion" onfocus="this.select()" maxlength="30"></td>
		</tr>
		<tr>
			<td align="right">N&uacute;mero Referencia: </td>
			<td ><input name="num_Referencia"  size="20" type="text" id="num_Referencia" onfocus="this.select()" maxlength="30"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="button"  onClick="javascript:valida();" value="Registrar Pago" class="boton">			
				<input type="button"  onClick="javascript: history.back();" value="Cancelar" class="boton">
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

	<input type="hidden" name="moneda" value="#total_header.moneda#">  
	<input type="hidden" name="monto_pagado" value="#total_header.saldo#">  
	<input type="hidden" name="id_persona" value="<cfif isdefined("url.id_persona")>#url.id_persona#</cfif>">
	<input type="hidden" name="id_tramite" value="<cfif isdefined("url.id_tramite")>#url.id_tramite#</cfif>">
	<input type="hidden" name="id_instancia" value="<cfif isdefined("url.id_instancia")>#url.id_instancia#</cfif>">
	<input type="hidden" name="id_requisito" value="<cfif isdefined("url.id_requisito")>#url.id_requisito#</cfif>">  
	<input type="hidden" name="ts_rversion" 	 value="<cfif isdefined("ts")>#ts#</cfif>">

</form>
</cfoutput>
<script type="text/javascript">
<!--	
	function validar(f) {
		var msg = '';
		var ctl = null;
		if (f.num_tiquete.value == '') { msg += "\n* Digite el número de tiquete"; ctl = ctl?ctl:f.num_tiquete; }
		if (msg.length || ctl) {
			alert('Verifique la siguiente información:' + msg);
			ctl.focus();
			return false;
		}
		return true;
	}
	
	function valida() {
		todobien = true;
		var msg = '';
		var ctl = null;
		if (document.form1.num_tiquete.value == '') { msg += "\n* Digite el número de tiquete"; ctl = ctl?ctl:document.form1.num_tiquete; }
		if (msg.length || ctl) {
			alert('Verifique la siguiente información:' + msg);
			ctl.focus();
			todobien = false;
		}
		if (todobien)
			document.form1.submit();
	}
//-->
</script>
