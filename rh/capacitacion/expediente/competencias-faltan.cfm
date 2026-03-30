<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" bgcolor="#CCCCCC"><strong><font size="2"><cf_translate key="LB_Competencias_que_faltan">Competencias que faltan</cf_translate></font></strong></td>
	</tr>

	<tr><td>
		<!--- Competencias requeridas por el puesto --->
		<table width="100%" cellpadding="2" cellspacing="0" style="border:1px solid gray; ">
			<tr>
				<td class="tituloCorte"><cf_translate key="LB_Habilidades">Habilidades</cf_translate></td>
				<td class="tituloCorte"><cf_translate key="LB_Pct_Minimo">Pct. Mínimo</cf_translate></td>
			</tr>
			<cfset total_competencias_faltantes = 0>
			<cfif habilidades_faltantes.recordcount + habilidades_faltantes_pct.recordcount gt 0>
				<cfoutput query="habilidades_faltantes">
					<tr>
						<td>#trim(habilidades_faltantes.RHHcodigo)# - #habilidades_faltantes.RHHdescripcion#</td>
						<td align="right">#LSNumberFormat(habilidades_faltantes.nota,',9.00')#%</td>
					</tr>
					<cfif Len(habilidades_faltantes.nota)>
						<cfset total_competencias_faltantes = total_competencias_faltantes + habilidades_faltantes.nota>
					</cfif>
				</cfoutput>

				<cfoutput query="habilidades_faltantes_pct">
					<tr>
						<td>#trim(habilidades_faltantes_pct.RHHcodigo)# - #habilidades_faltantes_pct.RHHdescripcion#</td>
						<td align="right">#LSNumberFormat(habilidades_faltantes_pct.nota,',9.00')#%</td>
					</tr>
					<cfif Len(habilidades_faltantes_pct.nota)>
						<cfset total_competencias_faltantes = total_competencias_faltantes + habilidades_faltantes_pct.nota>
					</cfif>
				</cfoutput>
			<cfelse>
				<tr><td colspan="2" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>	
			</cfif> 
			
			<tr>
				<td class="tituloCorte"><cf_translate key="LB_Conocimientos">Conocimientos</cf_translate></td>
				<td class="tituloCorte"><cf_translate key="LB_Pct_Minimo">Pct. Mínimo</cf_translate></td>
			</tr>

			<cfif conocimientos_faltantes.recordcount + conocimientos_faltantes_pct.recordcount gt 0>
				<cfoutput query="conocimientos_faltantes">
					<tr>
						<td>#trim(conocimientos_faltantes.RHCcodigo)# - #conocimientos_faltantes.RHCdescripcion#</td>
						<td align="right">#LSNumberFormat(conocimientos_faltantes.nota,',9.00')#%</td>
					</tr>
					<cfif Len(conocimientos_faltantes.nota)>
						<cfset total_competencias_faltantes = total_competencias_faltantes + conocimientos_faltantes.nota>
					</cfif>
				</cfoutput>
				
				<cfoutput query="conocimientos_faltantes_pct">
					<tr>
						<td>#trim(conocimientos_faltantes_pct.RHCcodigo)# - #conocimientos_faltantes_pct.RHCdescripcion#</td>
						<td align="right">#LSNumberFormat(conocimientos_faltantes_pct.nota,',9.00')#%</td>
					</tr>
					<cfif Len(conocimientos_faltantes.nota)>
						<cfset total_competencias_faltantes = total_competencias_faltantes + conocimientos_faltantes_pct.nota>
					</cfif>
				</cfoutput>
			<cfelse>
				<tr><td colspan="2" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>	
			</cfif> 
			
		</table>
	</td></tr>
</table>
