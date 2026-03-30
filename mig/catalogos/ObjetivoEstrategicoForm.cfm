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

<cfif not isdefined ('form.MIGOEid') and isdefined ('url.MIGOEid') and trim(url.MIGOEid) >
	<cfset form.MIGOEid=url.MIGOEid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsObjetivoE">
		select
				MIGOEid,
				MIGOEcodigo,
				MIGOEdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGOEstrategico
		where MIGOEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGOEid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="ObjetivoEstrategicoSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Objetivo Estrat&eacute;gico: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsObjetivoE.MIGOEcodigo#
					<input type="hidden" name="MIGOEid" id="MIGOEid" value="#rsObjetivoE.MIGOEid#">
				<cfelse>
					<input type="text" name="MIGOEcodigo" id='MIGOEcodigo' maxlength="10" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Objetivo Estrat&eacute;gico:</td>
			<td align="left"><input type="text" name="MIGOEdescripcion" id='MIGOEdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#rsObjetivoE.MIGOEdescripcion#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
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
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Importar',document.form1)){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		if (formulario.MIGOEcodigo.value == "") {
			error_msg += "\n - El código no puede quedar en blanco.";
			error_input = formulario.MIGOEcodigo;
		}
	</cfif>
		if (formulario.MIGOEdescripcion.value == "") {
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGOEdescripcion;
		}

		//caracteres especiales
		var invalidos = /^[a-z0-9_\-\.\[\]\(\)]+$/i;
		<!---if (!invalidos.test(formulario.MIGOEdescripcion.value)){
			error_msg += "\n - La descripción no puede contener caracteres especiales.";
			error_input = formulario.MIGOEdescripcion;
		}--->
		if (!invalidos.test(formulario.MIGOEcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGOEcodigo;
		}

		//no numeros en el primer caracter del dato codigo
		var firts = parseInt(formulario.MIGOEcodigo.value.charAt(0));
		if (!isNaN(firts)){
			error_msg += "\n - El código no puede iniciar con numeros.";
			error_input = formulario.MIGOEcodigo;
		}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>




