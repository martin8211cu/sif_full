<cfparam name="url.TESCFEid" default="">
<cfquery datasource="#session.dsn#" name="data">
	select *
	  from TESCFestados
	 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Tesoreria.TESid#" null="#Len(session.Tesoreria.TESid) Is 0#">
	   and TESCFEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#url.TESCFEid#" 	null="#Len(url.TESCFEid) Is 0#">
	   and TESCFEimpreso=0 
	   and TESCFEentregado=0 
	   and TESCFEanulado=0
</cfquery>

<cfset CAMBIO = data.RecordCount>

<style type="text/css">
<!--
.SinBorde {
 	border:none;
}
-->
</style>


<cfoutput>
<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: TESCFestados - Tipos de Endosos
				// Columna: TESid ID Tesoreria numeric
				if (formulario.TESid.value == "") {
					error_msg += "\n - ID Tesoreria no puede quedar en blanco.";
					error_input = formulario.TESid;
				}
				
				// Columna: TESCFEcodigo Código char(10)
				if (formulario.TESCFEcodigo.value == "") {
					error_msg += "\n - Código no puede quedar en blanco.";
					error_input = formulario.TESCFEcodigo;
				}
				
				// Columna: TESCFEdescripcion Descripcion varchar(40)
				if (formulario.TESCFEdescripcion.value == "") {
					error_msg += "\n - Descripcion no puede quedar en blanco.";
					error_input = formulario.TESCFEdescripcion;
				}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script>

<form action="estadosCustodia_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center" colspan="2" class="tituloListas">
			    Estado de Custodia
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right" valign="top" nowrap><strong>C&oacute;digo</strong>&nbsp;</td>
			<td valign="top"><input name="TESCFEcodigo" type="text" value="#HTMLEditFormat(data.TESCFEcodigo)#" tabindex="1"></td>
		</tr>
		<tr>
			<td align="right" valign="top" nowrap><strong>Descripci&oacute;n&nbsp;del&nbsp;Estado:</strong>&nbsp;</td>
			<td valign="top">
				<input name="TESid" id="TESid" type="hidden" value="#HTMLEditFormat(session.Tesoreria.TESid)#">
				<input name="TESCFEid" id="TESCFEid" type="hidden" value="#HTMLEditFormat(data.TESCFEid)#">
				<input name="TESCFEdescripcion" id="TESCFEdescripcion" type="text" tabindex="1"
					value="#HTMLEditFormat(data.TESCFEdescripcion)#" maxlength="40" size="60" onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td colspan="2" class="formButtons">
			<cfif data.RecordCount>
				<cf_botones modo='CAMBIO' tabindex="1">
			<cfelse>
				<cf_botones modo='ALTA' tabindex="1">
			</cfif>
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	<cfif data.RecordCount>
		document.form1.TESCFEcodigo.focus();		
	<cfelse>
		document.frmTES.TESid.focus();
	</cfif>
</script>

