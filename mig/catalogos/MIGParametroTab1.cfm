<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif isdefined("Form.Cambio")>
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
<cfset LvarInclude="">

<cfset LvarInclude="Lista">


<cfif not isdefined ('form.MIGParid') and isdefined ('url.MIGParid') and trim(url.MIGParid) >
	<cfset form.MIGParid=url.MIGParid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsEncPar">
		select
				MIGParid,
				MIGParcodigo,
				MIGPardescripcion,
				MIGPartipo,
				MIGParsubtipo,
				MIGParactual,
				Dactiva
		from MIGParametros
		where MIGParid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGParid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="formPrinc" action="MIGParametroSQL.cfm" onSubmit="return validarForm(this);">
	<table>
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Par&aacute;metro: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsEncPar.MIGParcodigo#
					<input type="hidden" name="MIGParid" id="MIGParid" value="#htmlEditFormat(rsEncPar.MIGParid)#">
				<cfelse>
					<input type="text" name="MIGParcodigo" id='MIGParcodigo' maxlength="10" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Nombre Par&aacute;metro:</td>
			<td align="left"><input type="text" name="MIGPardescripcion" id='MIGPardescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsEncPar.MIGPardescripcion)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Tipo:</td>
			<td align="left"><input type="text" name="MIGPartipo" id='MIGPartipo' maxlength="256" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsEncPar.MIGPartipo)#</cfif>" size="100" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Sub Tipo:</td>
			<td align="left"><input type="text" name="MIGParsubtipo" id='MIGParsubtipo' maxlength="256" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsEncPar.MIGParsubtipo)#</cfif>" size="100" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"> </td>
			<td align="left">
				<fieldset>
					<legend>
						<strong>Aplica para Calificaci&oacute;n?</strong>
							<table>
								<tr>
									<td align="left" nowrap="nowrap" > No:<input name="MIGParactual" type="radio" value="N" id="MIGParactual" <cfif modo NEQ 'ALTA' and rsEncPar.MIGParactual EQ "N">checked="checked"<cfelse>checked="checked"</cfif>/> S&iacute;:<input name="MIGParactual" type="radio" value="S" id="MIGParactual" <cfif modo NEQ 'ALTA' and rsEncPar.MIGParactual EQ "S">checked="checked"</cfif>/></td>
								</tr>
							</table>
					</legend>
				</fieldset>
			 </td>
		</tr>
<!---
		<tr valign="baseline">
			<td nowrap align="right">Estado:</td>
			<td align="left">
				<select name="Dactiva" id="Dactiva">
								<option value="">-Seleccione un Estado-</option>
								<option value="0"<cfif modo EQ 'CAMBIO'and rsEncPar.Dactiva EQ 0>selected="selected"</cfif>>Inactivo </option>
								<option value="1"<cfif modo EQ 'CAMBIO'and rsEncPar.Dactiva EQ 1>selected="selected"</cfif>>Activo</option>
				</select>
			</td>
		</tr>
--->
		<cfif modo NEQ 'ALTA'>
				<tr valign="baseline">		
					<td nowrap align="right">Estado:</td>
							<td>
									<input name="Dactiva" type="checkbox" value="1" id="Dactiva" 
											<cfif isdefined('rsEncPar.Dactiva') and rsEncPar.Dactiva EQ 1>checked="checked"
											</cfif>/>Activo
							</td>
					</td>
				</tr>
		</cfif>		
		
		
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" include="#LvarInclude#"></td>
		</tr>
	</table>
	</form>
</cfoutput>

<!---ValidacionesFormulario--->
<script type="text/javascript">
function validarForm(formulario)	{
	if (!btnSelected('Nuevo',document.formPrinc) && !btnSelected('Baja',document.formPrinc) && !btnSelected('Lista',document.formPrinc) ){
		var error_input;
		var error_msg = '';
		
	<cfif modo EQ 'ALTA'>
		Codigo = document.formPrinc.MIGParcodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El codigo del parámetro no puede quedar en blanco.";
			error_input = formulario.MIGParcodigo;
		}


	</cfif>
		desp = document.formPrinc.MIGPardescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGPardescripcion;
		}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}
<!---
--->
</script>


