<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset form.modo=url.modo>
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
<cfif not isdefined("Form.modo") and not isdefined ('URL.Nuevo') and not isdefined ('form.Nuevo')>
	<cfset form.modo=url.modo>
</cfif>
<cfset LvarInclude="Lista">

<cfif not isdefined ('form.MIGCueid') and isdefined ('url.MIGCueid') and trim(url.MIGCueid)>
	<cfset form.MIGCueid=url.MIGCueid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsCuentas">
		select 
				MIGCueid,
				MIGCuecodigo,
				MIGCuedescripcion,
				MIGCuetipo,
				MIGCuesubtipo,
				Dactiva
		from MIGCuentas
		where MIGCueid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGCueid#">
	</cfquery> 
</cfif>


<cfoutput>
	<form method="post" name="form1" action="CuentasSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline"> 
			<td nowrap align="right">C&oacute;digo Cuenta: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsCuentas.MIGCuecodigo)#
					<input type="hidden" name="MIGCueid" id="MIGCueid" value="#rsCuentas.MIGCueid#">
				<cfelse>
					<input type="text" name="MIGCuecodigo" id='MIGCuecodigo' maxlength="256" value="" size="80" tabindex="1" onFocus="javascript: this.select();">
				</cfif>	
			</td>
		</tr>		
		<tr valign="baseline"> 
			<td nowrap align="right">Nombre Cuenta:</td>
			<td align="left"><input type="text" name="MIGCuedescripcion" id='MIGCuedescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsCuentas.MIGCuedescripcion)#</cfif>" size="80" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr>
			<td nowrap align="right">Tipo Cuenta:</td>
			<td align="left" nowrap="nowrap">
				<select name="MIGCuetipo" id="MIGCuetipo">
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="I"<cfif modo EQ 'CAMBIO'and rsCuentas.MIGCuetipo EQ 'I'>selected="selected"</cfif>>Ingresos </option>
					<option value="G"<cfif modo EQ 'CAMBIO'and rsCuentas.MIGCuetipo EQ 'G'>selected="selected"</cfif>>Gastos</option>
					<option value="C"<cfif modo EQ 'CAMBIO'and rsCuentas.MIGCuetipo EQ 'C'>selected="selected"</cfif>>Costos </option>
					<option value="N"<cfif modo EQ 'CAMBIO'and rsCuentas.MIGCuetipo EQ 'N'>selected="selected"</cfif>>No Aplica</option>
					<option value="A"<cfif modo EQ 'CAMBIO'and rsCuentas.MIGCuetipo EQ 'A'>selected="selected"</cfif>>Activo</option>
					<option value="P"<cfif modo EQ 'CAMBIO'and rsCuentas.MIGCuetipo EQ 'P'>selected="selected"</cfif>>Pasivo </option>
					<option value="T"<cfif modo EQ 'CAMBIO'and rsCuentas.MIGCuetipo EQ 'T'>selected="selected"</cfif>>Capital</option>
				</select>
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Sub Tipo Cuenta:</td>
			<td align="left" nowrap="nowrap"><input type="text" name="MIGCuesubtipo" id='MIGCuesubtipo' maxlength="40" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsCuentas.MIGCuesubtipo)#</cfif>" size="80" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr>
			<td align="right" nowrap="nowrap">Estado:</td>
			<td align="left" nowrap="nowrap">
				<select name="Dactiva" id="Dactiva">
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="0"<cfif modo EQ 'CAMBIO'and rsCuentas.Dactiva EQ 0>selected="selected"</cfif>>Inactiva </option>
					<option value="1"<cfif modo EQ 'CAMBIO'and rsCuentas.Dactiva EQ 1>selected="selected"</cfif>>Activa</option>
				</select>
			</td>
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
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Importar',document.form1) && !btnSelected('Lista',document.form1) ){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		Codigo = document.form1.MIGCuecodigo.value; 
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,""); 
		if (Codigo.length==0){
			error_msg += "\n - El código de la Cuenta no puede quedar en blanco.";
			error_input = formulario.MIGCuecodigo;
		}
	</cfif>	
		desp = document.form1.MIGCuedescripcion.value; 
		desp = desp.replace(/(^\s*)|(\s*$)/g,""); 
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGCuedescripcion;
		}
		if (formulario.MIGCuetipo.value == "") {
			error_msg += "\n - El Tipo de Cuenta no puede quedar en blanco.";
			error_input = formulario.MIGCuetipo;
		}
<!---
		despt = document.form1.MIGCuesubtipo.value; 
		despt = despt.replace(/(^\s*)|(\s*$)/g,""); 
		if (despt.length==0){
			error_msg += "\n - El Sub_Tipo de Cuenta no puede quedar en blanco.";
			error_input = formulario.MIGCuesubtipo;
		}
--->
		if (formulario.Dactiva.value == "") {
			error_msg += "\n - El Estado no puede quedar en blanco.";
			error_input = formulario.Dactiva;
		}

		var validos = /^[a-zA-Z0-9_\-\_\[]+$/i;
		if (!validos.test(formulario.MIGCuecodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGCuecodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>
