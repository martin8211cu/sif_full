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
			<cfset ps_total_competencias_faltantes = 0>
			<cfif ps_habilidades_faltantes.recordcount gt 0>
				<cfoutput query="ps_habilidades_faltantes">
					<tr>
						<td>#trim(ps_habilidades_faltantes.codigo)# - #ps_habilidades_faltantes.descripcion#</td>
						<td align="right">#LSNumberFormat(ps_habilidades_faltantes.nota,',9.00')#%</td>
					</tr>
					<cfset ps_total_competencias_faltantes = ps_total_competencias_faltantes + ps_habilidades_faltantes.nota>
				</cfoutput>
			<cfelse>
				<tr><td colspan="2" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>	
			</cfif> 
			
			<tr>
				<td class="tituloCorte"><cf_translate key="LB_Conocimientos">Conocimientos</cf_translate></td>
				<td class="tituloCorte"><cf_translate key="LB_Pct_Minimo">Pct. Mínimo</cf_translate></td>
			</tr>

			<cfif ps_conocimientos_faltantes.recordcount gt 0>
				<cfoutput query="ps_conocimientos_faltantes">
					<tr>
						<td>#trim(ps_conocimientos_faltantes.codigo)# - #ps_conocimientos_faltantes.descripcion#</td>
						<td align="right">#LSNumberFormat(ps_conocimientos_faltantes.nota,',9.00')#%</td>
					</tr>
					<cfset ps_total_competencias_faltantes = ps_total_competencias_faltantes + ps_conocimientos_faltantes.nota>
				</cfoutput>
				
			<cfelse>
				<tr><td colspan="2" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>	
			</cfif> 

			
		</table>
	</td></tr>
</table>