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

<cfif not isdefined ('form.MIGArid') and isdefined ('url.MIGArid') and trim(url.MIGArid) >
	<cfset form.MIGArid=url.MIGArid>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>
<cfset LvarBotones="">
<cfset LvarEx="">
<cfset LvarID="">
<cfset LvarIniciales=false>

<cfif isdefined ('URL.MIGRid') and trim(URL.MIGRid) NEQ "">
	<cfset LvarIniciales=true>
	<cfset LvarID=URL.MIGRid>
	<cfset LvarReadOnly=true>
	<cfset LvarEx="Limpiar">
<cfelse>
	<cfset LvarBotones="Lista">
	<cfset LvarReadOnly=false>
</cfif>



<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsArea">
		select
				MIGArid,
				MIGRid,
				CodFuente,
				MIGArcodigo,
				MIGArdescripcion,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Estado desconocido'
				end as Dactiva
		from MIGArea
		where MIGArid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGArid#">
	</cfquery>
	<cfif trim(rsArea.MIGRid) GT 0>
		<cfset LvarID=rsArea.MIGRid>
	</cfif>
	<cfif rsArea.MIGRid NEQ ''>
		<cfset LvarIniciales=true>
	</cfif>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="AreaSQL.cfm" onSubmit="return validar(this);">
	<cfif isdefined ('URL.bandera')>
			<input type="hidden" id="Area" value="Area"  name="Area"/>
		</cfif>
	<table >
		<tr valign="baseline">
			<td align="right">Regiones: </td>
			<td align="left" >
				<cf_conlis title="Lista de Regiones"
						campos = "MIGRid, MIGRcodigo, MIGRdescripcion"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGRegion"
						columnas="MIGRid, MIGRcodigo, MIGRdescripcion"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="MIGRcodigo, MIGRdescripcion"
						etiquetas="Codigo,Descripción"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales#"
						readonly="#LvarReadOnly#"
						traerFiltro="MIGRid=#LvarID#"
						filtrar_por="MIGRcodigo,MIGRdescripcion"
						Size="0,20,40"
						tabindex="1"
						fparams="MIGRid"
						/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo &Aacute;rea: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsArea.MIGArcodigo#
					<input type="hidden" name="MIGArid" id="MIGArid" value="#htmlEditFormat(rsArea.MIGArid)#" tabindex="1">
				<cfelse>
					<input type="text" name="MIGArcodigo" id='MIGArcodigo' maxlength="10" value="" size="20" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n &Aacute;rea: </td>
			<td align="left"><input type="text" name="MIGArdescripcion" id='MIGArdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsArea.MIGArdescripcion)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<!---<tr valign="baseline">
			<td nowrap align="right">Estado:</td>
			<td align="left">
				<select name="Dactiva" size="1" tabindex="1">
					<option value="" ><cfif modo NEQ 'ALTA'>#rsArea.Dactiva#</cfif></option>
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
		Codigo = document.form1.MIGArcodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código del Área no puede quedar en blanco.";
			error_input = formulario.MIGArcodigo;
		}
	</cfif>
		CodP = document.form1.MIGRid.value;
		CodP = CodP.replace(/(^\s*)|(\s*$)/g,"");
		if (CodP.length==0){
			error_msg += "\n - La Región no puede quedar en blanco.";
			error_input = formulario.MIGRid;
		}
		desp = document.form1.MIGArdescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGArdescripcion;
		}
		
		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGArcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGArcodigo;
		}
				
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>