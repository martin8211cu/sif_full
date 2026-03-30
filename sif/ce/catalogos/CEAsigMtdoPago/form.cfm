<cfif isdefined("Form.Cambio") or isdefined("form.btnRegresar") or isdefined("form.BotonSel")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA' AND isdefined("form.testmptipo")>
	<cfquery datasource="#Session.DSN#" name="rs">
		SELECT * 
		FROM TEStipoMedioPago
		WHERE TESTMPtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.testmptipo#">
	</cfquery>
	<cfif len(trim(#rs.TESTMPMtdoPago#)) NEQ 0>
		<cfquery datasource="#Session.DSN#" name="rs">
		SELECT * FROM TEStipoMedioPago, CEMtdoPago 
		WHERE TEStipoMedioPago.TESTMPMtdoPago = CEMtdoPago.Clave
		AND TESTMPtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.testmptipo#">
	</cfquery>
	</cfif>
</cfif>
<cfset LvarAction   = 'ActionSql.cfm'>

<cfquery datasource="#Session.DSN#" name="rsMtdosPago">
	select * 
	from CEMtdoPago
	order by Concepto asc
</cfquery>


<cfoutput>
	<form action="#LvarAction#" method="post" name="form1">
		<cfset form.LVarClave="">
		<table align="center" cellpadding="0" cellspacing="2">
			<tr valign="baseline">
				<td nowrap align="right"><strong><cf_translate key=LB_Concepto>Operación</cf_translate>:</strong>&nbsp;</td>
				<td>
					<cfoutput>
					<input type="text" name="descsif" id="descsif" value="<cfif MODO NEQ "ALTA" AND isdefined("form.TESTMPdescripcion")>#rs.TESTMPdescripcion#</cfif>"  size="47" maxlength="200" tabindex="1" readonly ="true">
					</cfoutput>
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong><cf_translate key=LB_Codigo> Método de pago</cf_translate>:</strong>&nbsp;</td>
				<td>	
					<select name="MtdoPago" id="MtdoPago">
						<option value="-1">-- Seleccione una opcion --</option>
					<cfloop query="rsMtdosPago">
						<option value="#rsMtdosPago.Clave#" <cfif MODO NEQ "ALTA" AND isDefined("rs.Concepto") AND rs.Concepto EQ rsMtdosPago.Concepto>selected</cfif>>#rsMtdosPago.Concepto#</option>
					</cfloop>
					<cfif rsMtdosPago.recordCount EQ 0>
						<option value="-1">(No existen Conceptos de pago configurados)</option>
					</cfif>
				</select>
				</td>
			</tr>
			<tr valign="baseline">
				<td colspan="2" align="center">
					<input type="hidden" name="idAsig" value="<cfif MODO NEQ "ALTA" AND isdefined("rs.TESTMPtipo")>#rs.TESTMPtipo#</cfif>">
					<br>
					<input type="submit" name="update" value="Modificar"> 
				</td>
			</tr>

		</table>
	</form>
</cfoutput>
