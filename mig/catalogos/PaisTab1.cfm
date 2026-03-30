<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif isdefined("Form.CAMBIO")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif not isdefined ('form.MIGPaid') and isdefined ('url.MIGPaid') and trim(url.MIGPaid) >
	<cfset form.MIGPaid=url.MIGPaid>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsPais">
		select
				MIGPaid,
				CodFuente,
				MIGPacodigo,
				MIGPadescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Estado desconocido'
				end as Dactiva
		from MIGPais
		where MIGPaid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGPaid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="PaisSQL.cfm" onSubmit="return validar(this);">
	<table >
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Pa&iacute;s: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsPais.MIGPacodigo#
					<input type="hidden" name="MIGPaid" id="MIGPaid" value="#htmlEditFormat(rsPais.MIGPaid)#" tabindex="1">
				<cfelse>
					<input type="text" name="MIGPacodigo" id='MIGPacodigo' maxlength="10" value="" size="20" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Pa&iacute;s:</td>
			<td align="left"><input type="text" name="MIGPadescripcion" id='MIGPadescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsPais.MIGPadescripcion)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<!---<tr valign="baseline">
			<td nowrap align="right">Estado:</td>
			<td align="left">
				<select name="Dactiva" size="1" tabindex="1">
					<option value="" ><cfif modo NEQ 'ALTA'>#rsPais.Dactiva#</cfif></option>
					<option value="" >-Seleccione un Estado-</option>
					<option value="0" >Inactivo</option>
					<option value="1" >Activo</option>

				</select>
			</td>
		</tr>--->
		<tr>
			<td colspan="2" align="center" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" include="Lista" tabindex="1"></td>
		</tr>
	</table>
	</form>
</cfoutput>

<!---ValidacionesFormulario--->

<script type="text/javascript">
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Lista',document.form1) ){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		Codigo = document.form1.MIGPacodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código del País no puede quedar en blanco.";
			error_input = formulario.MIGPacodigo;
		}
	</cfif>
		desp = document.form1.MIGPadescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGPadescripcion;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGPacodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGPacodigo;
		}		
		
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>