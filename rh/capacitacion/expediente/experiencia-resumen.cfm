<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2723" default="0" returnvariable="LvarAprobarExperiencia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PendienteDeAprobacionRH" returnvariable="MSG_PendienteDeAprobacionRH" default="Pendiente de aprobación por RH" xmlFile="/rh/generales.xml">
<cfquery name="rsExperiencia" datasource="#session.DSN#">
	select 	a.RHEEid,
			a.RHEEnombreemp,
			a.RHEEpuestodes,
			case when <cf_dbfunction name="date_format" args="RHEEfecharetiro,dd/mm/yyyy"> = '01/01/6100' then '<cf_translate key="LB_Actualmente">Actualmente</cf_translate>' 
				else <cf_dbfunction name="date_format" args="RHEEfecharetiro,dd/mm/yyyy"> end as fhasta,
			a.RHEEfechaini,
			a.RHEEfunclogros,
			a.RHEEmotivo,
			a.RHEEestado
	from RHExperienciaEmpleado a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("RHOid") and len(trim(RHOid))>
			and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">	
		<cfelse>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">	
		</cfif>		
		<cfif not isdefined("LvarAuto") and LvarAprobarExperiencia><!---- mientras no sea autogestion se muestra unicamente los items aprobados---->
		 	and a.RHEEestado=1
		 </cfif>
	Order by a.RHEEfecharetiro desc
</cfquery>
<!---
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td><div style="overflow:auto; height:200; width:500; margin:0;">
---->		
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td class="tituloListas"><cf_translate key="LB_Institucion">Instituci&oacute;n</cf_translate></td>
					<td class="tituloListas"><cf_translate key="LB_FechaInicio">Fecha Inicio</cf_translate></td>
					<td class="tituloListas"><cf_translate key="LB_FechaRetiro">Fecha Retiro</cf_translate></td>
					<td class="tituloListas"><cf_translate key="LB_MotivoDeSalida">Motivo de salida</cf_translate></td>
				</tr>
				<cfif rsExperiencia.recordcount gt 0>
					<cfoutput query="rsExperiencia">
						<tr class="<cfif rsExperiencia.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<!---class="tituloCorte"--->
							<td >#rsExperiencia.RHEEnombreemp#</td>
							<td ><cf_locale name="date" value="#rsExperiencia.RHEEfechaini#"/></td>
						 
							<td ><cfif trim(rsExperiencia.fhasta) NEQ 'Actualmente'><cf_locale name="date" value="#rsExperiencia.fhasta#"/></cfif></td>
							<td >				
								<cfswitch expression="#rsExperiencia.RHEEmotivo#"> 
									<cfcase value="0"> 
										<cf_translate key="LB_Renuncia">Renuncia</cf_translate>
									</cfcase> 
									<cfcase value="10"> 
										<cf_translate key="LB_Despido">Despido</cf_translate>
									</cfcase> 
									<cfcase value="20"> 
										<cf_translate key="LB_FinDelContrato">Fin del contrato</cf_translate>
									</cfcase> 
									<cfcase value="30"> 
										<cf_translate key="LB_FinDeProyecto">Fin de proyecto</cf_translate>
									</cfcase> 
									<cfcase value="40"> 
										<cf_translate key="LB_CierreDeOperaciones">Cierre de operaciones</cf_translate>
									</cfcase>
									<cfdefaultcase> 
										<cf_translate key="LB_Otros">Otros</cf_translate>
									</cfdefaultcase> 
								</cfswitch> 
							</td>
					        <cfif rsExperiencia.RHEEestado neq 1 and LvarAprobarExperiencia>
			                	<td><cf_notas link="<img src='/cfmx/rh/imagenes/Excl16.gif' class='imgNoAprobado'>" titulo="" pageindex="3#currentrow#" msg="#MSG_PendienteDeAprobacionRH#"></td>
			                </cfif>
						</tr>
<!----
						<tr>
							<td colspan="4">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="15" class="listaCorte">&nbsp;</td>
										<td class="listaCorte">Logros y funciones</td>
									</tr>
									<tr>
										<td width="10">&nbsp;</td>							
										<td>
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td width="8">&nbsp;</td>
													<td>
														<cfif len(trim(rsExperiencia.RHEEfunclogros))>
															<cfset stExperiencia = REReplaceNoCase(rsExperiencia.RHEEfunclogros, '\n|\r|<[^>]*>', '', 'all')>
															#rsExperiencia.RHEEfunclogros#
														<cfelse>
															--- No hay logros y funciones registrados ---
														</cfif>
													</td>
												</tr>
											</table>
										</td>
									</tr>
			
								</table>
							</td>			
						</tr>
---->						
					</cfoutput>
				<cfelse>
					<tr><td colspan="4" align="center">-<cf_translate key="LB_ElColaboradorNoTieneExperienciaRegistrada">El colaborador no tiene experiencia registrada</cf_translate>-</td></tr>
				</cfif>
			</table>
<!----		
		</div></td>
	</tr>
</table>
--->

