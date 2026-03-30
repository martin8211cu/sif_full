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
<script language="javascript" src="../../js/utilesMonto.js"></script>
<cfif not isdefined ('form.MIGSDid') and isdefined ('url.MIGSDid') and trim(url.MIGSDid) >
	<cfset form.MIGSDid=url.MIGSDid>
</cfif>
<cfset LvarBotones="">
<cfset LvarEx="">
<cfset LvarID="">
<cfset LvarIniciales=false>

<cfif isdefined ('URL.MIGDid') and trim(URL.MIGDid) NEQ "">
	<cfset LvarIniciales=true>
	<cfset LvarID=URL.MIGDid>
	<cfset LvarReadOnly=true>
	<cfset LvarEx="Limpiar">
<cfelse>
<cfset LvarBotones="Lista">
<cfset LvarReadOnly=false>
</cfif>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsSub_Direcciones">
		select
				MIGSDid,
				MIGDid,
				MIGSDcodigo,
				MIGSDdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Estado desconocido'
				end as Dactiva
		from MIGSDireccion
		where MIGSDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGSDid#">
	</cfquery>
	<cfif trim(rsSub_Direcciones.MIGDid) GT 0>
		<cfset LvarID=rsSub_Direcciones.MIGDid>
	</cfif>
	<cfif rsSub_Direcciones.MIGDid NEQ ''>
		<cfset LvarIniciales=true>
	</cfif>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="Sub_DireccionSQL.cfm" onSubmit="return validar(this);">
		<cfif isdefined ('URL.bandera')>
			<input type="hidden" id="SubD" value="SubD"  name="SubD"/>
		</cfif>
	<table >
		<tr>
			<td align="right">Direcci&oacute;n:</td>
			<td align="left" >
				<cf_conlis title="Lista de Direcciones"
						campos = "MIGDid, MIGDcodigo, MIGDnombre"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGDireccion"
						columnas="MIGDid, MIGDcodigo, MIGDnombre"
						filtro="Ecodigo = #Session.Ecodigo#"
						desplegar="MIGDcodigo, MIGDnombre"
						etiquetas="Codigo,Descripción"
						formatos="S,S"
						align="left,left"
						readonly="#LvarReadOnly#"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGDid=#LvarID#"
						filtrar_por="MIGDcodigo,MIGDnombre"
						Size="0,20,60"
						tabindex="1"
						fparams="MIGDid"
						/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Sub_Direcci&oacute;n: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsSub_Direcciones.MIGSDcodigo)#
					<input type="hidden" name="MIGSDid" id="MIGSDid" value="#rsSub_Direcciones.MIGSDid#" tabindex="1">
				<cfelse>
					<input type="text" name="MIGSDcodigo" id='MIGSDcodigo' maxlength="10" value="" size="20" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Sub_Direcci&oacute;n:</td>
			<td align="left"><input type="text" name="MIGSDdescripcion" id='MIGSDdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsSub_Direcciones.MIGSDdescripcion)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<!---<tr valign="baseline">
			<td nowrap align="right">Estado:</td>
			<td align="left">
				<select name="Dactiva" size="1" tabindex="1">
					<option value="" ><cfif modo NEQ 'ALTA'>#rsSub_Direcciones.Dactiva#</cfif></option>
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
		Codigo = document.form1.MIGSDcodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código de la Sub Dirección no puede quedar en blanco.";
			error_input = formulario.MIGSDcodigo;
		}
	</cfif>

		desp = document.form1.MIGSDdescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGSDdescripcion;
		}
		if (formulario.MIGDid.value == "") {
			error_msg += "\n - La Dirección no puede quedar en blanco.";
			error_input = formulario.MIGDid;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGSDcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGSDcodigo;
		}
		
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>