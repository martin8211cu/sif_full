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
<cfset LvarIncludes="">
<cfif modo EQ 'ALTA'>
	<cfset LvarIncludes="Importar">
</cfif>


<cfif not isdefined ('form.MIGEstid') and isdefined ('url.MIGEstid') and trim(url.MIGEstid) >
	<cfset form.MIGEstid=url.MIGEstid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsEstrategia">
		select
				MIGEstid,
				MIGEstcodigo,
				MIGEstdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGEstrategia
		where MIGEstid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGEstid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="EstrategiaSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Estrategia: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsEstrategia.MIGEstcodigo#
					<input type="hidden" name="MIGEstid" id="MIGEstid" value="#rsEstrategia.MIGEstid#">
				<cfelse>
					<input type="text" name="MIGEstcodigo" id='MIGEstcodigo' maxlength="10" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Estrategia:</td>
			<td align="left"><input type="text" name="MIGEstdescripcion" id='MIGEstdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsEstrategia.MIGEstdescripcion#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" include="#LvarIncludes#"></td>
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
		if (formulario.MIGEstcodigo.value == "") {
			error_msg += "\n - El código no puede quedar en blanco.";
			error_input = formulario.MIGEstcodigo;
		}
	</cfif>
		if (formulario.MIGEstdescripcion.value == "") {
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGEstdescripcion;
		}

		//caracteres especiales
		var invalidos = /^[a-z0-9_\-\.\[\]\(\)]+$/i;
		<!---if (!invalidos.test(formulario.MIGEstdescripcion.value)){
			error_msg += "\n - La descripci&oacute;n no puede contener caracteres especiales.";
			error_input = formulario.MIGEstdescripcion;
		}--->
		if (!invalidos.test(formulario.MIGEstcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGEstcodigo;
		}

		//no numeros en el primer caracter del dato codigo
		var firts = parseInt(formulario.MIGEstcodigo.value.charAt(0));
		if (!isNaN(firts)){
			error_msg += "\n - El código no puede iniciar con numeros.";
			error_input = formulario.MIGEstcodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>




