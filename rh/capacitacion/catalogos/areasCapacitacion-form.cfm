<cfset modo = "ALTA">
<cfif isdefined("form.RHACid") and len(trim(form.RHACid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select RHACid, RHACcodigo, RHACdescripcion, ts_rversion
		from  RHAreasCapacitacion	
		where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACid#"> 
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
		if (formulario.RHACcodigo.value == "") {
			error_msg += "\n - Código de Área de Capacitación no puede quedar en blanco.";
			error_input = formulario.RHACcodigo;
		}
		// Columna: RHACdescripcion Descripción del Área varchar(60)
		if (formulario.RHACdescripcion.value == "") {
			error_msg += "\n - Descripción del Área no puede quedar en blanco.";
			error_input = formulario.RHACdescripcion;
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

<form action="areasCapacitacion-sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td >
				<input name="RHACcodigo" size="10" id="RHACcodigo" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHACcodigo)#</cfif>" maxlength="10" onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td>
				<input name="RHACdescripcion" size="40" id="RHACdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.RHACdescripcion)#</cfif>" maxlength="60" onfocus="this.select()"  >
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
		<input type="hidden" name="RHACid" value="#HTMLEditFormat(data.RHACid)#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>
</cfoutput>

