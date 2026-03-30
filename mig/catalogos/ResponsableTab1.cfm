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


<cfif not isdefined ('form.MIGReid') and isdefined ('url.MIGReid') and trim(url.MIGReid) >
	<cfset form.MIGReid=url.MIGReid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsResponsable">
		select
				MIGReid,
				MIGRcodigo,
				MIGRenombre,
				MIGRecorreo,
				MIGRecorreoadicional,
				case Dactivas
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGResponsables
		where MIGReid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGReid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="formPrinc" action="ResponsableSQL.cfm" onSubmit="return validarForm(this);">
	<table>
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Responsable: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsResponsable.MIGRcodigo#
					<input type="hidden" name="MIGReid" id="MIGReid" value="#htmlEditFormat(rsResponsable.MIGReid)#">
				<cfelse>
					<input type="text" name="MIGRcodigo" id='MIGRcodigo' maxlength="10" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Nombre Responsable:</td>
			<td align="left"><input type="text" name="MIGRenombre" id='MIGRenombre' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsResponsable.MIGRenombre)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Correo Electr&oacute;nico:</td>
			<td align="left"><input type="text" name="MIGRecorreo" id='MIGRecorreo' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsResponsable.MIGRecorreo)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Correo Electr&oacute;nico Adicional:</td>
			<td align="left"><input type="text" name="MIGRecorreoadicional" id='MIGRecorreoadicional' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsResponsable.MIGRecorreoadicional)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
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
function validarForm(formulario)	{
	if (!btnSelected('Nuevo',document.formPrinc) && !btnSelected('Baja',document.formPrinc) && !btnSelected('Lista',document.formPrinc) ){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		Codigo = document.formPrinc.MIGRcodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código del Responsable no puede quedar en blanco.";
			error_input = formulario.MIGRcodigo;
		}
	</cfif>
		desp = document.formPrinc.MIGRenombre.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGRenombre;
		}
		Correo = document.formPrinc.MIGRecorreo.value;
		Correo = Correo.replace(/(^\s*)|(\s*$)/g,"");
		if (Correo.length==0){
			error_msg += "\n - El correo no puede quedar en blanco.";
			error_input = formulario.MIGRecorreo;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGRcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGRcodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}
</script>




