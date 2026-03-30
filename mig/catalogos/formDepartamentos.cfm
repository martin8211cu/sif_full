<cfif not isdefined("Form.modo")>
	<cfset form.modo="ALTA">
<cfelseif Form.modo EQ "CAMBIO">
	<cfset form.modo="CAMBIO">
<cfelse>
	<cfset form.modo="ALTA">
</cfif>
<cfset LvarID="">
<cfset LvarBotones="Importar">
<cfset LvarIniciales=false>
<cfif isdefined ('URL.MIGGid') and trim(URL.MIGGid) NEQ "">
	<cfset LvarIniciales=true>
	<cfset LvarID=URL.MIGGid>
	<cfset LvarReadOnly=true>
<cfelse>
	<cfset LvarReadOnly=false>
</cfif>
<cfif isDefined("session.Ecodigo") and isDefined("Form.Dcodigo") and len(trim(#Form.Dcodigo#)) NEQ 0>
	<cfquery name="rsDepartamentos" datasource="#Session.DSN#" >
	Select Dcodigo, Deptocodigo, Ddescripcion, ts_rversion,MIGGid
	from Departamentos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#" >
		order by Ddescripcion asc
	</cfquery>
<cfif modo NEQ 'ALTA' and rsDepartamentos.MIGGid GT 0>
	<cfset LvarID=rsDepartamentos.MIGGid>
	<cfset LvarIniciales=true>

</cfif>

</cfif>
<cfoutput>
<form action="SQLDepartamentos.cfm" method="post" name="form1" onSubmit="return validar(this);">
	<cfif modo EQ 'CAMBIO'>
		<input name="Deptocodigo" id="Deptocodigo" value="#rsDepartamentos.Deptocodigo#"  type="hidden"/>
		<input type="hidden" name="xDeptocodigo" value="#rsDepartamentos.Deptocodigo#" >
	</cfif>

	<cfif isdefined ('URL.bandera')>
		<input type="hidden" id="Depto" value="Depto"  name="Depto"/>
	</cfif>
	<table width="50%" align="center" cellpadding="0" cellspacing="0">
		<tr>
		  <td>&nbsp;</td>
		  <td align="right" nowrap="nowrap">Gerencia Asociada:</td>
		  <td>&nbsp;</td>
			<td align="left">

			<cf_conlis title="Lista Gerencias"
						campos = "MIGGid,MIGGcodigo,MIGGdescripcion"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGGerencia"
						columnas="MIGGid,MIGGcodigo,MIGGdescripcion"
						filtro="Ecodigo = #Session.Ecodigo#"
						desplegar="MIGGcodigo, MIGGdescripcion"
						etiquetas="Codigo,Descripción"
						formatos="S,S"
						align="left,left"
						form="form1"
						readonly="#LvarReadOnly#"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGGid=#LvarID#"
						filtrar_por="MIGGcodigo,MIGGdescripcion"
						tabindex="1"
						fparams="MIGGid"
						/>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr valign="baseline" bgcolor="##FFFFFF">
			<td>&nbsp;</td>
			<td align="right" nowrap>C&oacute;digo:</td>
			<td>&nbsp;</td>
			<td>
				<input name="Deptocodigo" type="text"  size="10" maxlength="10"  alt="El Código" tabindex="1" <cfif modo NEQ "ALTA"> disabled="disabled"</cfif>
					value="<cfif modo NEQ "ALTA">#htmlEditFormat(rsDepartamentos.Deptocodigo)#</cfif>" >

			</td>
			<td>&nbsp;</td>
		</tr>

		<tr valign="baseline" bgcolor="##FFFFFF">
			<td>&nbsp;</td>
			<td align="right" nowrap>Descripci&oacute;n:</td>
			<td>&nbsp;</td>
			<td>
				<input type="text" name="Ddescripcion" tabindex="1" size="40" maxlength="60"  alt="La Descripción"
					value="<cfif #modo# NEQ "ALTA">#htmlEditFormat(rsDepartamentos.Ddescripcion)#</cfif>" >
				<input type="hidden" name="Dcodigo" value="<cfif modo NEQ "ALTA">#rsDepartamentos.Dcodigo#</cfif>">
				<input type="text" name="txt" readonly class="cajasinbordeb" size="1">
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<td colspan="5" align="center" nowrap>
				<cf_botones modo="#modo#" include="#LvarBotones#" tabindex="1">
			</td>
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
		Codigo = document.form1.Deptocodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código de la Sub Dirección no puede quedar en blanco.";
			error_input = formulario.Deptocodigo;
		}
	</cfif>

		desp = document.form1.Ddescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.Ddescripcion;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.Deptocodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.Deptocodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>