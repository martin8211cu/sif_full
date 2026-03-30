<cfset modo = "ALTA">
<cfif isdefined("form.RHAGMid") and len(trim(form.RHAGMid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select RHAGMid, RHAGMnombre, ts_rversion
		from  RHAreaGrupoMat	
		where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHAGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHAGMid#"> 
	</cfquery>
</cfif>

<cfoutput>
<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: RHAreasCapacitacion - RHAreas de Capacitacion
		// Columna: RHACcodigo Código de Área de Capacitación char(10)
		// Columna: RHACdescripcion Descripción del Área varchar(60)
		if (formulario.RHAGMnombre.value == "") {
			error_msg += "\n - Descripción del Área no puede quedar en blanco.";
			error_input = formulario.RHAGMnombre;
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

<form action="RHAreaGrupoMat-sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td>
				<input name="RHAGMnombre" size="40" id="RHAGMnombre" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHAGMnombre)#</cfif>" maxlength="60" onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td colspan="2" class="formButtons">
				<cfif modo NEQ 'ALTA'>
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHAGMid" value="#HTMLEditFormat(data.RHAGMid)#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>
</cfoutput>

