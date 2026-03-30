<!--- habilidades requeridas--->
<cfset otras_habilidades = expediente.competencias(form.DEid, 'h', habilidades_puesto, session.Ecodigo)>
<cfset otros_conocimientos = expediente.competencias(form.DEid, 'c', conocimientos_puesto, session.Ecodigo)>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td>
		<!--- Competencias requeridas por el puesto --->
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr>
				<td class="tituloListas"><cf_translate key="LB_Habilidad">Habilidad</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_requerido">Pct. requerido</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_que_posee">Pct. que posee</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_faltante">Pct. faltante</cf_translate></td>
			</tr>
			<cfif otras_habilidades.recordcount gt 0>
				<cfoutput query="otras_habilidades">
					<tr class="<cfif otras_habilidades.currentrow mod 2>listaPar<cfelse>listaNon</cfif> ">
						<td>#trim(otras_habilidades.codigo)# - #otras_habilidades.descripcion#</td>
						<td align="right">N/A</td>
						<td align="right">#LSNumberFormat(otras_habilidades.nota,',9.00')#%</td>
						<td align="right">N/A</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr><td colspan="4" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>

			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="tituloListas"><cf_translate key="LB_Conocimiento">Conocimiento</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_requerido">Pct. requerido</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_que_posee">Pct. que posee</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_faltante">Pct. faltante</cf_translate></td>
			</tr>
			<cfif otros_conocimientos.recordcount gt 0>
				<cfoutput query="otros_conocimientos">
					<tr class="<cfif otros_conocimientos.currentrow mod 2>listaPar<cfelse>listaNon</cfif> ">
						<td>#trim(otros_conocimientos.codigo)# - #otros_conocimientos.descripcion#</td>
						<td align="right">N/A</td>
						<td align="right">#LSNumberFormat(otros_conocimientos.nota,',9.00')#%</td>
						<td align="right">N/A</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr><td colspan="4" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>
		</table>
	</td></tr>
</table>
