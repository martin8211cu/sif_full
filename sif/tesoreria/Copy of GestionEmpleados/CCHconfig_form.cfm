<cfquery name="rsSQL" datasource="#session.dsn#">
	select 
		CCHCmonto,
		CCHCmax,
		CCHCmin,
		CCHCdias,
		CCHCreintegro,
		CCHCdiasvencAnti,
		CCHCdiasvencAntiViat,
		CCHCantsPendientes
	from CCHconfig 
	where 
		Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif rsSQL.recordcount eq 0>
	<cfset modo ='ALTA'>
<cfelse>
	<cfset modo='CAMBIO'>
</cfif>
<form name="form1" method="post" action="CCHconfig_sql.cfm" >
<cfoutput>
	<table width="100%" border="0">
		<tr>
			<td width="50%" align="right">
				<strong>Monto M&aacute;ximo:</strong>
			</td>
			<td width="50%" align="left">
				<cfif modo eq 'CAMBIO'>
					<cf_inputNumber name="montoMax" value="#rsSQL.CCHCmonto#" size="23" enteros="13" decimales="2">
				<cfelse>
					<cf_inputNumber name="montoMax" size="23" enteros="13" decimales="2">
				</cfif>
		  </td>
		</tr>
		<tr>
			<td align="right">
				<strong>Porcentaje m&aacute;ximo de solicitud:</strong>
			</td>
			<td align="left">				
				<cfif modo eq 'CAMBIO'>
					<cf_inputNumber name="porcMax" value="#rsSQL.CCHCmax#" size="3" enteros="2" decimales="0">
				<cfelse>
					<cf_inputNumber name="porcMax" value="" size="3" enteros="2" decimales="0">
				</cfif>
				
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Porcentaje m&iacute;nimo de caja:</strong>
			</td>
			<td align="left">
				<cfif modo eq 'CAMBIO'>
					<cf_inputNumber name="porcMin" value="#rsSQL.CCHCmin#" size="3" enteros="2" decimales="0">
				<cfelse>
					<cf_inputNumber name="porcMin" value="" size="3" enteros="2" decimales="0">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>D&iacute;as m&aacute;ximos de liquidaci&oacute;n:</strong>
			</td>
			<td align="left">
				<cfif modo eq 'CAMBIO'>
					<cf_inputNumber name="dias1" size="3" value="#rsSQL.CCHCdias#" enteros="3" decimales="0">
				<cfelse>
					<cf_inputNumber name="dias1" size="3" value="" enteros="3" decimales="0">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Días de vencimiento anticipo:</strong>
			</td>
			<td align="left">
				<cfif modo eq 'CAMBIO'>
					<cf_inputNumber name="diasAnti" size="3" value="#rsSQL.CCHCdiasvencAnti#" enteros="3" decimales="0">
				<cfelse>
					<cf_inputNumber name="diasAnti" size="3" value="" enteros="3" decimales="0">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Días de vencimiento anticipo viático:</strong>
			</td>
			<td align="left">
				<cfif modo eq 'CAMBIO'>
					<cf_inputNumber name="diasAntiViat" size="3" value="#rsSQL.CCHCdiasvencAntiViat#" enteros="3" decimales="0">
				<cfelse>
					<cf_inputNumber name="diasAntiViat" size="3" value="" enteros="3" decimales="0">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Reintegro Autom&aacute;tico:</strong>
			</td>
			<td align="left">
				<input type="checkbox" name="reintegro"  <cfif rsSQL.CCHCreintegro eq 1> checked="checked"</cfif>/>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Se permite solicitar nuevos Anticipos teniendo pendientes:</strong>
			</td>
			<td align="left">
				<input type="checkbox" name="CCHCantsPendientes"  <cfif rsSQL.CCHCantsPendientes eq 1> checked="checked"</cfif>/>
			</td>
		</tr>
		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
					<input type="submit" value="Agregar"  name="agrega"   id="agrega"   onClick="javascript: habilitarValidacion(); "  />
					<input type="submit" value="Limpiar"  name="Limpiar"  id="Limpiar"  onClick="javascript: inhabilitarValidacion(); " />
					<input type="submit" value="Regresar" name="Regresar" id="Regresar" onClick="javascript: inhabilitarValidacion(); " />
				</td>
			<cfelse>
				<td colspan="3" align="center">
					<input type="submit" value="Modificar"  name="modificar"   id="modificar"   onClick="javascript: habilitarValidacion(); "  />
					<input type="submit" value="Regresar" name="Regresar" id="Regresar" onClick="javascript: inhabilitarValidacion(); " />
				</td>
			</cfif>
		</tr>
	</table>
</cfoutput>
</form>
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<!---ValidacionesFormulario--->

<cf_qforms>
<script language="javascript" type="text/javascript">
	function inhabilitarValidacion() {
		objForm.montoMax.required = false;	
		objForm.porcMax.required = false;		
		objForm.porcMin.required = false;		
		objForm.dias1.required = false;
		objForm.diasAnti.required=false;
		objForm.diasAntiViat.required=false;
	}

	function habilitarValidacion() {
		objForm.montoMax.required = true;	
		objForm.porcMax.required = true;		
		objForm.porcMin.required = true;	
		objForm.dias1.required = true;
		objForm.diasAnti.required=true;
		objForm.diasAntiViat.required=true;
	
	}
	
	objForm.montoMax.description = "Monto máximo";
	objForm.porcMax.description = "Porcentaje máximo de Solicitud";
	objForm.porcMin.description = "Porcentaje minimo de monto en caja";
	objForm.dias1.description = "Días máximo de liquidación";
	objForm.diasAnti.description = "Días de vencimiento anticipo";
	objForm.diasAntiViat.description = "Días de vencimiento anticipo viático";
	
	
</script>
