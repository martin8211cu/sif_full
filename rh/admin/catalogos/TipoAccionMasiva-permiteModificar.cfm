<fieldset>
<legend><b>&nbsp;<cf_translate key="LB_PermiteModificar">Permite Modificar</cf_translate>&nbsp;</b></legend>
<table width="80%" border="0" cellpadding="1" cellspacing="0">
	<tr>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTActiponomina eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMctiponomina eq 0>disabled</cfif> name="RHTActiponomina" value="checkbox"></td>
		<td nowrap><cf_translate key="CHK_TipodeNomina">Tipo de N&oacute;mina</cf_translate></td>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTAcregimenv eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMcregimenv eq 0>disabled</cfif> name="RHTAcregimenv" value="checkbox"></td>
		<td nowrap><cf_translate key="CHK_RegimenDeVacaciones">R&eacute;gimen de Vacaciones</cf_translate></td>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTAcoficina eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMcoficina eq 0>disabled</cfif> name="RHTAcoficina" value="checkbox"></td>
		<td nowrap><cf_translate  key="CHK_Oficina">Oficina</cf_translate></td>
	</tr>
	<tr>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTAcjornada eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMcjornada eq 0>disabled</cfif> name="RHTAcjornada" value="checkbox"></td>
		<td nowrap><cf_translate  key="CHK_Jornada">Jornada</cf_translate></td>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTAcsalariofijo eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMcsalariofijo eq 0>disabled</cfif> name="RHTAcsalariofijo" value="checkbox"></td>
		<td nowrap><cf_translate key="CHK_PorcentajeSalarioFijo">% Salario Fijo</cf_translate></td>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTAcempresa eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMcempresa eq 0>disabled</cfif> name="RHTAcempresa" value="checkbox"></td>
		<td nowrap><cf_translate  key="CHK_Empresa">Empresa</cf_translate></td>
	</tr>
	<tr>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTAcdepto eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMcdepto eq 0>disabled</cfif> name="RHTAcdepto" value="checkbox"></td>
		<td nowrap><cf_translate  key="CHK_Departamento">Departamento</cf_translate></td>
		<td><input type="checkbox" onclick="javascript: showCompSalarial();" <cfif modo eq "CAMBIO" and rsForm.RHTAccomp eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMccomp eq 0>disabled</cfif> name="RHTAccomp" value="checkbox"></td>
		<td nowrap><cf_translate key="CHK_ComponentesSalariales">Componentes Salariales</cf_translate></td>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTAcpuesto eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMcpuesto eq 0>disabled</cfif> name="RHTAcpuesto" value="checkbox"></td>
		<td nowrap><cf_translate key="CHK_Puesto">Puesto</cf_translate></td>
	</tr>
	<tr>
		<td><input type="checkbox" <cfif modo eq "CAMBIO" and rsForm.RHTAccatpaso eq 1>checked</cfif> <cfif modo eq "CAMBIO" and rsForm.CAMccatpaso eq 0>disabled</cfif> name="RHTAccatpaso" value="checkbox"></td>
		<td colspan="5"><cf_translate key="CHK_CategoriaPaso">Categor&iacute;a / Paso</cf_translate> </td>
	</tr>
</table>
</fieldset>
