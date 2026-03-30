<cfparam name="url.RHTCid" default="">

<cfset modo = "ALTA">
<cfif isdefined("url.RHTCid") and len(trim(url.RHTCid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select RHTCdescripcion,RHTCid,ts_rversion
		from  RHTipoCurso
		where RHTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTCid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: RHTipoCurso - RH Tipos de Cursos
				// Columna: RHTCdescripcion Descripción varchar(80)
				if (formulario.RHTCdescripcion.value == "") {
					error_msg += "\n - Descripción no puede quedar en blanco.";
					error_input = formulario.RHTCdescripcion;
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

<cfoutput>
<form action="RHTipoCurso-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td width="43%" valign="top" align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td width="57%" valign="top">
				<input name="RHTCdescripcion" id="RHTCdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#data.RHTCdescripcion#</cfif>" maxlength="80"onfocus="this.select()"  >
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="3" class="formButtons" align="center">
			<cfif modo NEQ 'ALTA'>
				<cf_botones modo='CAMBIO'>
			<cfelse>
				<cf_botones modo='ALTA'>
			</cfif>
		</td></tr>
	</table>
			<input type="hidden" name="RHTCid" value="<cfif modo NEQ 'ALTA'>#data.RHTCid#</cfif>">
			<cfif modo NEQ 'ALTA'>
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#data.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
</form>
</cfoutput>
