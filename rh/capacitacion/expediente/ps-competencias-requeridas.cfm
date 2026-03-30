<!--- habilidades requeridas--->
<cfset ps_habilidades_requeridas = expediente.competenciasRequeridas(ps, session.Ecodigo, 'h')>
<cfset ps_conocimientos_requeridos = expediente.competenciasRequeridas(ps, session.Ecodigo, 'c')>

						
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" bgcolor="#CCCCCC"><strong><font size="2"><cf_translate key="LB_Competencias_Requeridas">Competencias Requeridas</cf_translate></font></strong></td>
	</tr>

	<tr><td>
		<!--- Competencias requeridas por el puesto --->
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr>
				<td class="tituloListas"><cf_translate key="LB_Habilidad">Habilidad</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Nivel">Nivel</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_requerido">Pct. requerido</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_que_posee">Pct. que posee</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_faltante">Pct. faltante</cf_translate></td>
			</tr>
			<cfset ps_total_competencias = 0 >
			<cfset ps_total_competencias_tiene = 0 >
			<cfif ps_habilidades_requeridas.recordcount gt 0>
				<cfoutput query="ps_habilidades_requeridas">
					<cfset posee = expediente.competenciasPosee(form.DEid, ps, 'h', ps_habilidades_requeridas.RHHid, session.Ecodigo)>
					<cfif len(trim(posee)) eq 0>
						<cfset posee = 0 >
					</cfif>
					<cfset falta = ps_habilidades_requeridas.nota - posee >
					<cfif falta lt 0 >
						<cfset falta = 0  >
					</cfif>
				
					<tr class="<cfif ps_habilidades_requeridas.currentrow mod 2>listaPar<cfelse>listaNon</cfif> ">
						<td>#trim(ps_habilidades_requeridas.RHHcodigo)# - #ps_habilidades_requeridas.RHHdescripcion#</td>
						<td align="right">#ps_habilidades_requeridas.nivel#</td>
						<td align="right">#LSNumberFormat(ps_habilidades_requeridas.nota,',9.00')#%</td>
						<td align="right">#LSNumberFormat(posee,',9.00')#%</td>
						<td align="right">#LSNumberFormat(falta,',9.00')#%</td>
					</tr>
					<cfset ps_total_competencias = ps_total_competencias + ps_habilidades_requeridas.nota >
					<cfset ps_total_competencias_tiene = ps_total_competencias_tiene + posee >
				</cfoutput>
			<cfelse>
				<tr><td colspan="4" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>

			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="tituloListas"><cf_translate key="LB_Conocimiento">Conocimiento</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Nivel">Nivel</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_requerido">Pct. requerido</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_que_posee">Pct. que posee</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_faltante">Pct. faltante</cf_translate></td>
			</tr>

			<cfif ps_conocimientos_requeridos.recordcount gt 0>
				<cfoutput query="ps_conocimientos_requeridos">
					<cfset posee = expediente.competenciasPosee(form.DEid, ps, 'c', ps_conocimientos_requeridos.RHCid, session.Ecodigo)>
					<cfif len(trim(posee)) eq 0>
						<cfset posee = 0 >
					</cfif>
					<cfset falta = ps_conocimientos_requeridos.nota - posee >
					<cfif falta lt 0 >
						<cfset falta = 0  >
					</cfif>

					<tr class="<cfif ps_conocimientos_requeridos.currentrow mod 2>listaPar<cfelse>listaNon</cfif> ">
						<td>#trim(ps_conocimientos_requeridos.RHCcodigo)# - #ps_conocimientos_requeridos.RHCdescripcion#</td>
						<td align="right">#ps_conocimientos_requeridos.nivel#</td>
						<td align="right">#LSNumberFormat(ps_conocimientos_requeridos.nota,',9.00')#%</td>
						<td align="right">#LSNumberFormat(posee,',9.00')#%</td>
						<td align="right">#LSNumberFormat(falta,',9.00')#%</td>
					</tr>
					
					<cfset ps_total_competencias = ps_total_competencias + ps_conocimientos_requeridos.nota >

					<cfif posee gt ps_conocimientos_requeridos.nota >
						<cfset ps_total_competencias_tiene = ps_total_competencias_tiene + ps_conocimientos_requeridos.nota >
					<cfelse>
						<cfset ps_total_competencias_tiene = ps_total_competencias_tiene + posee >
					</cfif>
				</cfoutput>
			<cfelse>
				<tr><td colspan="4" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>

		</table>
	</td></tr>
</table>