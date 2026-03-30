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

<cfif not isdefined ('form.MIGRid') and isdefined ('url.MIGRid') and trim(url.MIGRid) >
	<cfset form.MIGRid=url.MIGRid>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>
<cfset LvarBotones="">
<cfset LvarEx="">
<cfset LvarID="">
<cfset LvarIniciales=false>
<cfif isdefined ('URL.MIGPaid') and trim(URL.MIGPaid) NEQ "">
	<cfset LvarIniciales=true>
	<cfset LvarID=URL.MIGPaid>
	<cfset LvarReadOnly=true>
	<cfset LvarEx="Limpiar">
<cfelse>
	<cfset LvarBotones="Lista">
	<cfset LvarReadOnly=false>
</cfif>
<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsRegion">
		select
				MIGRid,
				MIGPaid,
				CodFuente,
				MIGRcodigo,
				MIGRdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Estado desconocido'
				end as Dactiva
		from MIGRegion
		where MIGRid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGRid#">
	</cfquery>
	<cfif trim(rsRegion.MIGPaid) GT 0>
		<cfset LvarID=rsRegion.MIGPaid>
	</cfif>
	<cfif rsRegion.MIGPaid NEQ ''>
		<cfset LvarIniciales=true>
	</cfif>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="RegionSQL.cfm" onSubmit="return validar(this);">
		<cfif isdefined ('URL.bandera')>
			<input type="hidden" id="Region" value="Region"  name="Region"/>
		</cfif>
	<table >
		<tr valign="baseline">
			<td align="right">Pa&iacute;ses:</td>
			<td align="left" >
				<cf_conlis title="Lista de Países"
						campos = "MIGPaid, MIGPacodigo, MIGPadescripcion"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGPais"
						columnas="MIGPaid, MIGPacodigo, MIGPadescripcion"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="MIGPacodigo, MIGPadescripcion"
						etiquetas="Codigo,Descripción"
						formatos="S,S"
						align="left,left"
						readonly="#LvarReadOnly#"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGPaid=#LvarID#"
						filtrar_por="MIGPacodigo,MIGPadescripcion"
						tabindex="1"
						fparams="MIGPaid"
						/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Regi&oacute;n: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsRegion.MIGRcodigo#
					<input type="hidden" name="MIGRid" id="MIGRid" value="#htmlEditFormat(rsRegion.MIGRid)#" tabindex="1">
				<cfelse>
					<input type="text" name="MIGRcodigo" id='MIGRcodigo' maxlength="10" value="" size="20" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Regi&oacute;n:</td>
			<td align="left"><input type="text" name="MIGRdescripcion" id='MIGRdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsRegion.MIGRdescripcion)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<!---<tr valign="baseline">
			<td nowrap align="right">Estado:</td>
			<td align="left">
				<select name="Dactiva" size="1" tabindex="1">
					<option value="" ><cfif modo NEQ 'ALTA'>#rsRegion.Dactiva#</cfif></option>
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
		Codigo = document.form1.MIGRcodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código de la Región no puede quedar en blanco.";
			error_input = formulario.MIGRcodigo;
		}
	</cfif>
		CodP = document.form1.MIGPaid.value;
		CodP = CodP.replace(/(^\s*)|(\s*$)/g,"");
		if (CodP.length==0){
			error_msg += "\n - El País no puede quedar en blanco.";
			error_input = formulario.MIGPaid;
		}
		desp = document.form1.MIGRdescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGRdescripcion;
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