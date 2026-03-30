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

<cfif not isdefined ('form.MIGGid') and isdefined ('url.MIGGid') and trim(url.MIGGid) >
	<cfset form.MIGGid=url.MIGGid>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>
<cfset LvarBotones="">
<cfset LvarEx="">
<cfset LvarID="">
<cfset LvarIniciales=false>
<cfif isdefined ('URL.MIGSDid') and trim(URL.MIGSDid) NEQ "">
	<cfset LvarIniciales=true>
	<cfset LvarID=URL.MIGSDid>
	<cfset LvarReadOnly=true>
	<cfset LvarEx="Limpiar">
<cfelse>
	<cfset LvarBotones="Lista">
	<cfset LvarReadOnly=false>
</cfif>


<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.DSN#" name="rsGerencias">
		select
				MIGGid,
				MIGSDid,
				MIGGcodigo,
				MIGGdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Estado desconocido'
				end as Dactiva
		from MIGGerencia
		where MIGGid = #form.MIGGid#
	</cfquery>
	<cfif trim(rsGerencias.MIGSDid) GT 0>
		<cfset LvarID=rsGerencias.MIGSDid>
	</cfif>
	<cfif rsGerencias.MIGSDid NEQ ''>
		<cfset LvarIniciales=true>
	</cfif>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="GerenciaSQL.cfm" onSubmit="return validar(this);">
	<cfif isdefined ('URL.bandera')>
			<input type="hidden" id="Gerencia" value="Gerencia"  name="Gerencia"/>
		</cfif>
	<table >
		<tr>
			<td align="right">Sub_Direccion</td>
			<td align="left" >
				<cf_conlis title="Lista de Sub_Direcciones"
						campos = "MIGSDid, MIGSDcodigo, MIGSDdescripcion"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGSDireccion"
						columnas="MIGSDid, MIGSDcodigo, MIGSDdescripcion"
						filtro="Ecodigo = #Session.Ecodigo#"
						desplegar="MIGSDcodigo, MIGSDdescripcion"
						etiquetas="Codigo,Descripción"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales#"
						readonly="#LvarReadOnly#"
						traerFiltro="MIGSDid=#LvarID#"
						filtrar_por="MIGSDcodigo,MIGSDdescripcion"
						Size="0,20,60"
						tabindex="1"
						fparams="MIGSDid"
						/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Gerencia: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsGerencias.MIGGcodigo)#
					<input type="hidden" name="MIGGid" id="MIGGid" value="#rsGerencias.MIGGid#" tabindex="1">
				<cfelse>
					<input type="text" name="MIGGcodigo" id='MIGGcodigo' maxlength="10" value="" size="20" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Gerencia:</td>
			<td align="left"><input type="text" name="MIGGdescripcion" id='MIGGdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsGerencias.MIGGdescripcion)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<!---<tr valign="baseline">
			<td nowrap align="right">Estado:</td>
			<td align="left">
				<select name="Dactiva" size="1" tabindex="1">
					<option value="" ><cfif modo NEQ 'ALTA'>#rsGerencias.Dactiva#</cfif></option>
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
			<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" include="#LvarBotones#" exclude="#LvarEx#"tabindex="1"></td>
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
		Codigo = document.form1.MIGGcodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código de la Gerencia no puede quedar en blanco.";
			error_input = formulario.MIGGcodigo;
		}
	</cfif>
		desp = document.form1.MIGGdescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGGdescripcion;
		}
		if (formulario.MIGSDid.value == "") {
			error_msg += "\n - La Sub Dirección no puede quedar en blanco.";
			error_input = formulario.MIGSDid;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGGcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGGcodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>