<cfquery datasource="#session.DSN#" name="data1">
	select RHPcodigo 
	from RHEmpleadosPlan 
	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfif data1.recordcount gt 0>
	<table width="99%" cellpadding="0" cellspacing="0" align="center">
		<tr>
			<td colspan="4" style="padding:3px" bgcolor="#E3EDEF" >
				<strong><font size="2"><cf_translate key="LB_ProcesoEnPlanesDeSucesion">Progreso en Planes de Sucesi&oacute;n</cf_translate></font></strong>
			</td>
		</tr>
			<cfloop query="data1">
				<cfset ps = data1.RHPcodigo >
				<cfset ps_habilidades_requeridas = data.competenciasRequeridas(ps, session.Ecodigo, 'h')>
				<cfset ps_conocimientos_requeridos = data.competenciasRequeridas(ps, session.Ecodigo, 'c')>
				
				<cfquery datasource="#session.DSN#" name="descpuesto">
					select RHPdescpuesto
					from RHPuestos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
				</cfquery>
				
				<tr><td>
					<table width="100%" cellpadding="0" cellspacing="0">
						<cfoutput>
						<tr>
							<td align="left" style="padding:3px; " bgcolor="##DADADA">
								<strong><cf_translate key="LB_PlanDeSucesion">Plan de Sucesi&oacute;n</cf_translate>:&nbsp; #trim(ps)# - #descpuesto.RHPdescpuesto#</strong>
							</td>
						</tr>
						</cfoutput>
					
						<tr><td>
							<!--- Competencias requeridas por el puesto --->
							<table width="100%" cellpadding="2" cellspacing="0" >
								<tr>
									<td class="tituloListas"><cf_translate key="LB_Habilidad" XmlFile="/rh/generales.xml">Habilidad</cf_translate></td>
									<td class="tituloListas" align="right"><cf_translate key="LB_PctRequerido">Pct. requerido</cf_translate></td>
									<td class="tituloListas" align="right"><cf_translate key="LB_PctQuePosee">Pct. que posee</cf_translate></td>
									<td class="tituloListas" align="right"><cf_translate key="LB_PctFaltante">Pct. faltante</cf_translate></td>
								</tr>
								<cfset ps_total_competencias = 0 >
								<cfset ps_total_competencias_tiene = 0 >
								<cfif ps_habilidades_requeridas.recordcount gt 0>
									<cfoutput query="ps_habilidades_requeridas">
										<cfset posee = data.competenciasPosee(form.DEid, ps, 'h', ps_habilidades_requeridas.RHHid, session.Ecodigo)>
										<cfif len(trim(posee)) eq 0>
											<cfset posee = 0 >
										</cfif>
										<cfset falta = ps_habilidades_requeridas.nota - posee >
										<cfif falta lt 0 >
											<cfset falta = 0  >
										</cfif>
									
										<tr class="<cfif ps_habilidades_requeridas.currentrow mod 2>listaPar<cfelse>listaNon</cfif> ">
											<td>#trim(ps_habilidades_requeridas.RHHcodigo)# - #ps_habilidades_requeridas.RHHdescripcion#</td>
											<td align="right">#LSNumberFormat(ps_habilidades_requeridas.nota,',9.00')#%</td>
											<td align="right">#LSNumberFormat(posee,',9.00')#%</td>
											<td align="right">#LSNumberFormat(falta,',9.00')#%</td>
										</tr>
										<cfset ps_total_competencias = ps_total_competencias + ps_habilidades_requeridas.nota >
										<cfset ps_total_competencias_tiene = ps_total_competencias_tiene + posee >
									</cfoutput>
								<cfelse>
									<tr><td colspan="4" align="center">-<cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate>-</td></tr>
								</cfif>
					
								<tr>
									<td class="tituloListas"><cf_translate key="LB_Conocimiento" XmlFile="/rh/generales.xml">Conocimiento</cf_translate></td>
									<td class="tituloListas" align="right"><cf_translate key="LB_PctRequerido">Pct. requerido</cf_translate></td>
									<td class="tituloListas" align="right"><cf_translate key="LB_PctQuePosee">Pct. que posee</cf_translate></td>
									<td class="tituloListas" align="right"><cf_translate key="LB_PctFaltante">Pct. faltante</cf_translate></td>
								</tr>
					
								<cfif ps_conocimientos_requeridos.recordcount gt 0>
									<cfoutput query="ps_conocimientos_requeridos">
										<cfset posee = data.competenciasPosee(form.DEid, ps, 'c', ps_conocimientos_requeridos.RHCid, session.Ecodigo)>
										<cfif len(trim(posee)) eq 0>
											<cfset posee = 0 >
										</cfif>
										<cfset falta = ps_conocimientos_requeridos.nota - posee >
										<cfif falta lt 0 >
											<cfset falta = 0  >
										</cfif>
					
										<tr class="<cfif ps_conocimientos_requeridos.currentrow mod 2>listaPar<cfelse>listaNon</cfif> ">
											<td>#trim(ps_conocimientos_requeridos.RHCcodigo)# - #ps_conocimientos_requeridos.RHCdescripcion#</td>
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
									<tr><td>&nbsp;</td></tr>
								<cfelse>
									<tr><td colspan="4" align="center">-<cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate>-</td></tr>
								</cfif>
					
							</table>
						</td></tr>
					</table>
				</td></tr>
			</cfloop>
	</table>
<cfelse>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td style="padding:3px" bgcolor="#E3EDEF" >
				<strong><font size="2"><cf_translate key="LB_ProcesoEnPlanesDeSucesion">Progreso en Planes de Sucesi&oacute;n</cf_translate></font></strong>
			</td>
		</tr>
		<tr><td align="center">-- <cf_translate key="LB_ElEmpleadoNoEstaParticipandoEnNingunPlanDeSucesion">El empleado no esta participando en ning&uacute;n plan de sucesi&oacute;n</cf_translate> --</td></tr>
	</table>
</cfif>