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


<cfif not isdefined ('form.MIGPerid') and isdefined ('url.MIGPerid') and trim(url.MIGPerid) >
	<cfset form.MIGPerid=url.MIGPerid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsPerspectivas">
		select
				MIGPerid,
				MIGPercodigo,
				MIGPerdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGPerspectiva
		where MIGPerid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGPerid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="PerspectivasSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Perspectivas:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsPerspectivas.MIGPercodigo#
					<input type="hidden" name="MIGPerid" id="MIGPerid" value="#htmlEditFormat(rsPerspectivas.MIGPerid)#">
				<cfelse>
					<input type="text" name="MIGPercodigo" id='MIGPercodigo' maxlength="10" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Perspectivas:</td>
			<td align="left"><input type="text" name="MIGPerdescripcion" id='MIGPerdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsPerspectivas.MIGPerdescripcion)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
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
		Codigo = document.form1.MIGPercodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código no puede quedar en blanco.";
			error_input = formulario.MIGPercodigo;
		}
	</cfif>
		desp = document.form1.MIGPerdescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGPerdescripcion;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGPercodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGPercodigo;
		}

		//no números en el primer caracter del dato codigo
		var firts = parseInt(formulario.MIGPercodigo.value.charAt(0));
		if (!isNaN(firts)){
			error_msg += "\n - El código no puede iniciar con numeros.";
			error_input = formulario.MIGPercodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>
