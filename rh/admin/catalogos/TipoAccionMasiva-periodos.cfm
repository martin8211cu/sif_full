<fieldset>
<legend><b><cf_translate key="LB_FechaDeReferenciaParaPeriodos">Fecha de Referencia para Periodos</cf_translate>&nbsp;</b></legend>
	<table width="90%" border="0" cellpadding="1" cellspacing="0" align="center">
		<tr>
			<td width="21%" align="right" nowrap><cf_translate key="LB_FechaDeReferencia">Fecha de Referencia</cf_translate></td>
			<td width="79%">
				<select name="RHTAfutilizap">
					<option value="0"<cfif modo EQ "CAMBIO" and rsForm.RHTAfutilizap EQ 0> selected</cfif>><cf_translate key="CMB_FechaDeIngreso">Fecha de Ingreso</cf_translate></option>
					<option value="1"<cfif modo EQ "CAMBIO" and rsForm.RHTAfutilizap EQ 1> selected</cfif>><cf_translate key="CMB_FechaDeAnualidad">Fecha de Anualidad</cf_translate></option>
					<option value="2"<cfif modo EQ "CAMBIO" and rsForm.RHTAfutilizap EQ 2> selected</cfif>><cf_translate key="CMB_FechaDeVacaciones">Fecha de Vacaciones</cf_translate></option>
				</select>
			</td>
		</tr>
	</table>
</fieldset>
