
<!--- habilidades requeridas--->
<cfset puesto = expediente.puestoEmpleado(form.DEid, session.Ecodigo)>
<cfset habilidades_requeridas = expediente.competenciasRequeridas(puesto.RHPcodigo, session.Ecodigo, 'h')>
<cfset habilidades_puesto = valuelist(habilidades_requeridas.RHHid) >
<cfset conocimientos_requeridos = expediente.competenciasRequeridas(puesto.RHPcodigo, session.Ecodigo, 'c')>
<cfset conocimientos_puesto = valuelist(conocimientos_requeridos.RHCid) >

<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td>
		<!--- Competencias requeridas por el puesto --->
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr>
				<td class="tituloListas"><cf_translate key="LB_Habilidad">Habilidad</cf_translate></td>
				<td class="tituloListas" align="left"><cf_translate key="LB_Nivel">Nivel</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_requerido">Pct. requerido</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_que_posee">Pct. que posee</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_faltante">Pct. faltante</cf_translate></td>
			</tr>
			<cfset total_competencias = 0 >
			<cfset total_competencias_tiene = 0 >
			<cfif habilidades_requeridas.recordcount gt 0>
				<cfoutput query="habilidades_requeridas">
					<cfset posee = expediente.competenciasPosee(form.DEid, puesto.RHPcodigo, 'h', habilidades_requeridas.RHHid, session.Ecodigo)>
					<cfif len(trim(posee)) eq 0>
						<cfset posee = 0 >
					</cfif>
					<cfset falta = habilidades_requeridas.nota - posee >
					<cfif falta lt 0 >
						<cfset falta = 0  >
					</cfif>
				
					<tr class="<cfif habilidades_requeridas.currentrow mod 2>listaPar<cfelse>listaNon</cfif> ">
						<td>#trim(habilidades_requeridas.RHHcodigo)# - #habilidades_requeridas.RHHdescripcion#</td>
						<td align="left">#trim(habilidades_requeridas.nivel)#</td>
						<td align="right">#LSNumberFormat(habilidades_requeridas.nota,',9.00')#%</td>
						<td align="right">#LSNumberFormat(posee,',9.00')#%</td>
						<td align="right">#LSNumberFormat(falta,',9.00')#%</td>
					</tr>
					<cfset total_competencias = total_competencias + habilidades_requeridas.nota >
					
					<cfif posee gt habilidades_requeridas.nota>
						<cfset total_competencias_tiene = total_competencias_tiene + habilidades_requeridas.nota >
					<cfelse>
						<cfset total_competencias_tiene = total_competencias_tiene + posee >
					</cfif>
					
				</cfoutput>
			<cfelse>
				<tr><td colspan="5" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>

			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="tituloListas"><cf_translate key="LB_Conocimiento">Conocimiento</cf_translate></td>
				<td class="tituloListas" align="left"><cf_translate key="LB_Nivel">Nivel</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_requerido">Pct. requerido</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_que_posee">Pct. que posee</cf_translate></td>
				<td class="tituloListas" align="right"><cf_translate key="LB_Pct_faltante">Pct. faltante</cf_translate></td>
			</tr>
			<cfif conocimientos_requeridos.recordcount gt 0>
				<cfoutput query="conocimientos_requeridos">
					<cfset posee = expediente.competenciasPosee(form.DEid, puesto.RHPcodigo, 'c', conocimientos_requeridos.RHCid, session.Ecodigo)>
					<cfif len(trim(posee)) eq 0>
						<cfset posee = 0 >
					</cfif>
					<cfset falta = conocimientos_requeridos.nota - posee >
					<cfif falta lt 0 >
						<cfset falta = 0  >
					</cfif>
				
					<tr class="<cfif conocimientos_requeridos.currentrow mod 2>listaPar<cfelse>listaNon</cfif> ">
						<td>#trim(conocimientos_requeridos.RHCcodigo)# - #conocimientos_requeridos.RHCdescripcion#</td>
						<td align="left">#trim(conocimientos_requeridos.nivel)#</td>
						<td align="right">#LSNumberFormat(conocimientos_requeridos.nota,',9.00')#%</td>
						<td align="right">#LSNumberFormat(posee,',9.00')#%</td>
						<td align="right">#LSNumberFormat(falta,',9.00')#%</td>
					</tr>
					<cfset total_competencias = total_competencias + conocimientos_requeridos.nota >
					<cfif posee gt habilidades_requeridas.nota>
						<cfset total_competencias_tiene = total_competencias_tiene + conocimientos_requeridos.nota >
					<cfelse>
						<cfset total_competencias_tiene = total_competencias_tiene + posee >
					</cfif>
				</cfoutput>
			<cfelse>
				<tr><td colspan="5" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>
		</table>
	</td></tr>
</table>
