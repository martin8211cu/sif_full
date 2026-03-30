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


<cfif not isdefined ('form.MIGProSegmentos') and isdefined ('url.MIGProSegmentos') and trim(url.MIGProSegmentos) >
	<cfset form.MIGProSegmentos=url.MIGProSegmentos>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsSegmento">
		select
				MIGProSegid,
				MIGProSegcodigo,
				MIGProSegdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGProSegmentos
		where MIGProSegid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGProSegid#">
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="SegmentoSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Segmento:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsSegmento.MIGProSegcodigo)#
					<input type="hidden" name="MIGProSegid" id="MIGProSegid" value="#rsSegmento.MIGProSegid#">
				<cfelse>
					<input type="text" name="MIGProSegcodigo" id='MIGProSegcodigo' maxlength="100" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Segmento:</td>
			<td align="left"><input type="text" name="MIGProSegdescripcion" id='MIGProSegdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsSegmento.MIGProSegdescripcion)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
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
		Codigo = document.form1.MIGProSegcodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código no puede quedar en blanco.";
			error_input = formulario.MIGProSegcodigo;
		}
	</cfif>
		desp = document.form1.MIGProSegdescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGProSegdescripcion;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGProSegcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGProSegcodigo;
		}

		//no números en el primer caracter del dato codigo
		var firts = parseInt(formulario.MIGProSegcodigo.value.charAt(0));
		if (!isNaN(firts)){
			error_msg += "\n - El código no puede iniciar con numeros.";
			error_input = formulario.MIGProSegcodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>
