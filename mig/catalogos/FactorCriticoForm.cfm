<!---

 --->
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

<cfif modo EQ 'ALTA'>
	<cfset LvarInclude="Importar">
</cfif>


<cfif not isdefined ('form.MIGFCid') and isdefined ('url.MIGFCid') and trim(url.MIGFCid) >
	<cfset form.MIGFCid=url.MIGFCid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsFactorCritico">
		select
				MIGFCid,
				MIGFCcodigo,
				MIGFCdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGFCritico
		where MIGFCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGFCid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="FactorCriticoSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Factor Cr&iacute;tico: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsFactorCritico.MIGFCcodigo#
					<input type="hidden" name="MIGFCid" id="MIGFCid" value="#rsFactorCritico.MIGFCid#">
				<cfelse>
					<input type="text" name="MIGFCcodigo" id='MIGFCcodigo' maxlength="10" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Factor Cr&iacute;tico:</td>
			<td align="left"><input type="text" name="MIGFCdescripcion" id='MIGFCdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsFactorCritico.MIGFCdescripcion#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" include="#LvarInclude#"></td>
		</tr>
	</table>
	</form>
</cfoutput>

<!---ValidacionesFormulario--->

<script type="text/javascript">
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Importar',document.form1)){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		if (formulario.MIGFCcodigo.value == "") {
			error_msg += "\n - El código del Factor Crítico no puede quedar en blanco.";
			error_input = formulario.MIGFCcodigo;
		}
	</cfif>
		if (formulario.MIGFCdescripcion.value == "") {
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGFCdescripcion;
		}
		//caracteres especiales
		var invalidos = /^[a-z0-9_\-\.\[\]\(\)]+$/i;
		<!---if (!invalidos.test(formulario.MIGFCdescripcion.value)){
			error_msg += "\n - La descripción no puede contener caracteres especiales.";
			error_input = formulario.MIGFCdescripcion;
		}--->
		if (!invalidos.test(formulario.MIGFCcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGFCcodigo;
		}

		//no numeros en el primer caracter del dato codigo
		var firts = parseInt(formulario.MIGFCcodigo.value.charAt(0));
		if (!isNaN(firts)){
			error_msg += "\n - El código no puede iniciar con números.";
			error_input = formulario.MIGFCcodigo;
		}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>




