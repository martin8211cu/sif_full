<cfparam name="url.TESEcodigo" default="">
<cfquery datasource="#session.dsn#" name="data">
	select TESid, TESEcodigo, TESEdescripcion, TESEdefault
	  from TESendoso
	 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Tesoreria.TESid#" 		null="#Len(session.Tesoreria.TESid) Is 0#">
	   and TESEcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#url.TESEcodigo#" 	null="#Len(url.TESEcodigo) Is 0#">
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
		// Validando tabla: TESendoso - Tipos de Endosos
				// Columna: TESid ID Tesoreria numeric
				if (formulario.TESid.value == "") {
					error_msg += "\n - ID Tesoreria no puede quedar en blanco.";
					error_input = formulario.TESid;
				}
				// Columna: TESEcodigo Codigo tipo Endoso char(10)
				if (formulario.TESEcodigo.value == "") {
					error_msg += "\n - Codigo tipo Endoso no puede quedar en blanco.";
					error_input = formulario.TESEcodigo;
				}
				// Columna: TESEdescripcion Descripcion varchar(40)
				if (formulario.TESEdescripcion.value == "") {
					error_msg += "\n - Descripcion no puede quedar en blanco.";
					error_input = formulario.TESEdescripcion;
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

<form action="tipoEndosos_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
			    Tipos de Endosos
			</td>
		</tr>
		<tr>
			<td valign="top">Tipo Endoso</td>
			<td valign="top">
				<input name="TESid" id="TESid" type="hidden" value="#HTMLEditFormat(session.Tesoreria.TESid)#">
				<input name="TESEcodigo" id="TESEcodigo" type="text" value="#HTMLEditFormat(data.TESEcodigo)#"   
					<cfif CAMBIO>tabindex="-1" class="sinBorde" readonly="yes"<cfelse> tabindex="1"</cfif>
					maxlength="10" size="10"
					onfocus="this.select()">
			</td>
		</tr>
		<tr>
			<td valign="top">Descripcion</td>
			<td valign="top">
				<input name="TESEdescripcion" id="TESEdescripcion" type="text" value="#HTMLEditFormat(data.TESEdescripcion)#" 
					maxlength="40" size="60" tabindex="1"
					onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top">&nbsp;</td>
			<td valign="top">
				<cfif data.TESEdefault EQ 1>
					<font color="##0033CC">
						(Este es el código de Endoso Default)
					</font>
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="2" class="formButtons">
			<cfif data.RecordCount>
				<cf_botones modo='CAMBIO' include="Endoso_Default" tabindex="1">
			<cfelse>
				<cf_botones modo='ALTA' tabindex="1">
			</cfif>
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	<cfif CAMBIO>
		document.form1.TESEdescripcion.focus();
	<cfelse>
		document.frmTES.TESid.focus();
	</cfif>
</script>