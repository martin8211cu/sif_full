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


<cfif not isdefined ('form.MIGProLineas') and isdefined ('url.MIGProLineas') and trim(url.MIGProLineas) >
	<cfset form.MIGProLineas=url.MIGProLineas>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsLineas">
		select
				MIGProLinid,
				MIGProLincodigo,
				MIGProLindescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGProLineas
		where MIGProLinid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGProLinid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="LineasSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo L&iacute;neas:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsLineas.MIGProLincodigo)#
					<input type="hidden" name="MIGProLinid" id="MIGProLinid" value="#rsLineas.MIGProLinid#">
				<cfelse>
					<input type="text" name="MIGProLincodigo" id='MIGProLincodigo' maxlength="10" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n L&iacute;neas:</td>
			<td align="left"><input type="text" name="MIGProLindescripcion" id='MIGProLindescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsLineas.MIGProLindescripcion)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
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
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Importar',document.form1) ){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		Codigo = document.form1.MIGProLincodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código no puede quedar en blanco.";
			error_input = formulario.MIGProLincodigo;
		}
	</cfif>
		desp = document.form1.MIGProLindescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGProLindescripcion;
		}

<!--- /^[a-zA-Z0-9_\_\[\]\(\)]+$/i; --->
		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGProLincodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGProLincodigo;
		}

		//no números en el primer caracter del dato codigo
		var firts = parseInt(formulario.MIGProLincodigo.value.charAt(0));
		if (!isNaN(firts)){
			error_msg += "\n - El código no puede iniciar con numeros.";
			error_input = formulario.MIGProLincodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>




