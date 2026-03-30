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

<cfset LvarID="">
<cfset LvarIniciales=false>
<cfset LvarEx="">
<cfset LvarInclude="">


<cfif not isdefined ('form.MIGDiid') and isdefined ('url.MIGDiid') and trim(url.MIGDiid) >
	<cfset form.MIGDiid=url.MIGDiid>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif isdefined ('URL.MIGArid') and trim(URL.MIGArid) NEQ "">
	<cfset LvarIniciales=true>
	<cfset LvarID=URL.MIGArid>
	<cfset LvarReadOnly=true>
	<cfset LvarEx="Limpiar">
<cfelse>
	<cfset LvarReadOnly=false>
	<cfif modo EQ 'ALTA'>
		<cfset LvarInclude="Importar">
	</cfif>
</cfif>




<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsDistrito">
		select
				MIGDiid,
				MIGDicodigo,
				MIGDidescripcion,
				MIGArid,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGDistrito
		where MIGDiid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGDiid#">
	</cfquery>
	<cfif trim(rsDistrito.MIGArid) GT 0>
		<cfset LvarID=rsDistrito.MIGArid>
		<cfset LvarIniciales=true>
	</cfif>

	<cfquery name="rsJerarquia" datasource="#session.dsn#">
		select a.MIGPaid,a.MIGPacodigo,a.MIGPadescripcion,b.MIGRid,b.MIGRcodigo,b.MIGRdescripcion,c.MIGArcodigo,c.MIGArdescripcion
		from  MIGPais a
			inner join MIGRegion b
				on a.MIGPaid=b.MIGPaid
			inner join MIGArea c
				on b.MIGRid=c.MIGRid
			inner join MIGDistrito d
				on d.MIGArid=c.MIGArid
		where d.MIGDiid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MIGDiid#">
	</cfquery>

</cfif>

<style type="text/css">
<!--
.style2 {color: #000000}
.style4 {font-size: 10px; font-weight: bold; color: #0000CC; }
-->
</style>


<cfoutput>
	<form method="post" name="form1" action="DistritoSQL.cfm" onSubmit="return validar(this);">
	<cfif isdefined ('URL.bandera')>
		<input type="hidden" id="Distrito" value="Distrito"  name="Distrito"/>
	</cfif>

	<table align="center">
	<cfif modo NEQ 'ALTA'>
		<tr>
			<td align="left"><span class="style4"><span class="style2">Pa&iacute;s:</span>#rsJerarquia.MIGPacodigo#-#rsJerarquia.MIGPadescripcion#</span></td>
		</tr>
		<tr>
			<td><span class="style4"><span class="style2">Regi&oacute;n:</span>#rsJerarquia.MIGRcodigo#-#rsJerarquia.MIGRdescripcion#</span></td>
		</tr>
		<tr>
			<td><span class="style4"><span class="style2">&Aacute;rea:</span>#rsJerarquia.MIGArcodigo#-#rsJerarquia.MIGArdescripcion#</span></td>
		</tr>
	<cfelse>
		<tr>
			<td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>

	</cfif>
		<tr valign="baseline">
			<td align="right">&Aacute;rea: </td>
			<td align="left" >
				<cf_conlis title="Lista Áreas"
					campos = "MIGArid,MIGArcodigo,MIGArdescripcion"
					desplegables = "N,S,S"
					modificables = "N,S,S"
					tabla="MIGArea"
					columnas="MIGArid,MIGArcodigo,MIGArdescripcion"
					filtro="Ecodigo=#session.Ecodigo#"
					desplegar="MIGArcodigo, MIGArdescripcion"
					etiquetas="Codigo,Descripción"
					formatos="S,S"
					traerInicial="#LvarIniciales#"
					readonly="#LvarReadOnly#"
					traerFiltro="MIGArid=#LvarID#"
					align="left,left"
					Size="0,20,40"
					form="form1"
					filtrar_por="MIGArcodigo,MIGArdescripcion"
					tabindex="1"
					fparams="MIGArid"
					/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Distrito: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#rsDistrito.MIGDicodigo#
					<input type="hidden" name="MIGDiid" id="MIGDiid" value="#htmlEditFormat(rsDistrito.MIGDiid)#">
				<cfelse>
					<input type="text" name="MIGDicodigo" id='MIGDicodigo' maxlength="10" value="" size="20" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n Distrito:</td>
			<td align="left"><input type="text" name="MIGDidescripcion" id='MIGDidescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsDistrito.MIGDidescripcion)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" exclude="#LvarEx#" include="#LvarInclude#" tabindex="1"></td>
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
		CodP = document.form1.MIGArid.value;
		CodP = CodP.replace(/(^\s*)|(\s*$)/g,"");
		if (CodP.length==0){
			error_msg += "\n - El Área no puede quedar en blanco.";
			error_input = formulario.MIGArid;
		}

		Codigo = document.form1.MIGDicodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código del Distrito no puede quedar en blanco.";
			error_input = formulario.MIGDicodigo;
		}
	</cfif>
		desp = document.form1.MIGDidescripcion.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGDidescripcion;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGDicodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGDicodigo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>
