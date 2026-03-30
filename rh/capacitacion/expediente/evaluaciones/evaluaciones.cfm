<table width="99%" align="center" cellpadding="3" cellspacing="0" >
	<TR><TD valign="top">
	<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
		Default="Evaluaciones" Key="LB_Evaluaciones" returnvariable="LB_Evaluaciones"/>
		<cf_web_portlet_start border="true" titulo="#LB_Evaluaciones#" skin="#Session.Preferences.Skin#">

			<table width="100%" cellspacing="2" cellpadding="2">
				<tr>
					<td width="33%" valign="top">
						<!--- evaluaciones  360  --->
						<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
							Default="Evaluaciones 360" Key="LB_Evaluaciones_360" returnvariable="LB_Evaluaciones_360"/>
						<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Evaluaciones_360#" >
						<table width="99%" align="center" cellpadding="0" cellspacing="2"  bgcolor="#FFFFFF">
							<!---<tr><td colspan="3" align="center" bgcolor="#CCCCCC"><strong><font size="2">Evaluaciones 360</font></strong></td></tr>--->
							<tr><td>
							<cfif evaluacion360.recordcount gt 0 >
								<cfoutput query="evaluacion360">
									<table width="100%" cellpadding="0" cellspacing="0" >
										<!--- Encabezado --->
										<tr class="listaCorte">
											<td><strong><cf_translate key="LB_Evaluacion">Evaluación</cf_translate>:</strong></td>
											<td colspan="4">#evaluacion360.RHEEdescripcion#&nbsp;</td>
										</tr>
										<tr class="listaCorte">
											<td><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong></td>
											<td colspan="4"><cf_locale name="date" value="#evaluacion360.RHEEfdesde#"/></td>
										</tr>
										<tr class="listaCorte">
											<td><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:</strong></td>
											<td colspan="4">#trim(evaluacion360.RHPcodigo)# - #evaluacion360.RHPdescpuesto#</td>
										</tr>
				
										<!--- Notas --->
										<tr class="titulolistas" style="border-top:1px solid black;">
											<td colspan="5" align="center" style="border-top:1px solid gray;"><strong><cf_translate key="LB_Notas">Notas</cf_translate></strong></td>
										</tr>
										<tr bgcolor="##FAFAFA" >
											<td align="center"><strong><cf_translate key="LB_Global">Global</cf_translate></strong></td>
											<td align="center"><strong><cf_translate key="LB_Autoevaluacion">Autoevaluación</cf_translate></strong></td>
											<td align="center"><strong><cf_translate key="LB_Jefe">Jefe</cf_translate></strong></td>
											<td align="center"><strong><cf_translate key="LB_Otros">Otros</cf_translate></strong></td>
											<td align="center"></td>
										</tr>
				
										<tr>
											<cfquery name="rsParam" datasource="#session.dsn#">
												select Pvalor from RHParametros where Ecodigo=#session.Ecodigo#
												and Pcodigo=2106
											</cfquery>
											<cfif rsParam.Pvalor eq 1>
												<cfquery name="rsEv" datasource="#session.dsn#">
													select Porc_dist from RHEEvaluacionDes where RHEEid=#evaluacion360.RHEEid#
												</cfquery>
												<cfif rsEv.Porc_dist gt 0 and len(trim(evaluacion360.RHLEnotajefe)) gt 0 and len(trim(evaluacion360.RHLEpromotros)) gt 0 >
													<cfset LvarPorcJ=#rsEv.Porc_dist#>
													<cfset LvarPorcO=100-LvarPorcJ>
													<cfset LvarGlobalJ=#evaluacion360.RHLEnotajefe#*#LvarPorcJ#/100>
													<cfset LvarGlobalO=#evaluacion360.RHLEpromotros#*#LvarPorcO#/100>
													<cfset LvarGlobalt=LvarGlobalJ+LvarGlobalO>
												<cfelseif len(trim(evaluacion360.RHLEnotajefe)) gt 0 and len(trim(evaluacion360.RHLEpromotros)) gt 0>
													<cfset LvarGlobalt=(#evaluacion360.RHLEnotajefe#+#evaluacion360.RHLEpromotros#)/2>
												<cfelse>
													<cfset LvarGlobalt=0>
												</cfif>
											<td align="center"><cfif len(trim(LvarGlobalt))>#LSNumberFormat(LvarGlobalt,',9.00')#<cfelse>-</cfif></td>
											<cfelse>
											<td align="center"><cfif len(trim(evaluacion360.promglobal))>#LSNumberFormat(evaluacion360.promglobal,',9.00')#<cfelse>-</cfif></td>
											</cfif>
											<td align="center"><cfif len(trim(evaluacion360.RHLEnotaauto))>#LSNumberFormat(evaluacion360.RHLEnotaauto,',9.00')#<cfelse>-</cfif></td>
											<td align="center"><cfif len(trim(evaluacion360.RHLEnotajefe))>#LSNumberFormat(evaluacion360.RHLEnotajefe,',9.00')#<cfelse>-</cfif></td>
											<td align="center"><cfif len(trim(evaluacion360.RHLEpromotros))>#LSNumberFormat(evaluacion360.RHLEpromotros,',9.00')#<cfelse>-</cfif></td>
											<td align="center"><img src="/cfmx/rh/imagenes/findsmall.gif" border="0" alt="Consultar detalle de la evaluaci&oacute;n" style="cursor:hand;" onClick="javascript:detalle_evaluacion(#form.DEid#, #evaluacion360.RHEEid#, 1);" >
											<img src="/cfmx/rh/imagenes/Documentos2.gif" border="0" alt="Consultar detalle del plan de acci&oacute;n registrado" style="cursor:hand;" onClick="javascript:detalle_plan(#form.DEid#, #evaluacion360.RHEEid#);" ></td>
										</tr>
									</table>
									<br>
								</cfoutput>
							<cfelse>
								<table width="100%" cellpadding="2" cellspacing="0" >
									<tr><td align="center">- <cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
								</table>
							</cfif>
			
							</td></tr>
						</table>
						<cf_web_portlet_end>
					</td>

					<td width="33%" valign="top">
						<!--- evaluaciones  a su cargo  --->
						<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
							Default="Evaluaciones a su cargo" Key="LB_Evaluaciones_a_su_cargo" returnvariable="LB_Evaluaciones_a_su_cargo"/>	
						<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Evaluaciones_a_su_cargo#" >
						<table width="99%" align="center" cellpadding="0" cellspacing="2"  bgcolor="#FFFFFF">
							<!--- <tr><td colspan="3" align="center" bgcolor="#CCCCCC"><strong><font size="2">Evaluaciones a su cargo</font></strong></td></tr> --->
							<tr><td>
							<cfif misevaluaciones.recordcount gt 0 >
								<cfoutput query="misevaluaciones" group="RHEEid">
									<table border="0" width="100%" cellpadding="0" cellspacing="0"  >
										<!--- Encabezado --->
										<tr class="listaCorte">
											<td colspan="2"><strong><cf_translate key="LB_Evaluacion">Evaluación</cf_translate>:&nbsp;</strong> #misevaluaciones.RHEEdescripcion#</td>
										</tr>
										<tr class="listaCorte">
											<td colspan="2"><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:&nbsp;</strong> <cf_locale name="date" value="#misevaluaciones.RHEEfdesde#"/> <img src="/cfmx/rh/imagenes/findsmall.gif" border="0" alt="Consultar detalle de la evaluaci&oacute;n" style="cursor:hand;" onClick="javascript:detalle_evaluacion(#form.DEid#, #misevaluaciones.RHEEid#, 2);" ></td>
										</tr>
				
										<!--- Notas --->
										<tr class="titulolistas" style="border-top:1px solid black;">
											<td style="border-top:1px solid gray;"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate></strong></td>
											<td align="right" style="border-top:1px solid gray;"><strong><cf_translate key="LB_Nota">Nota</cf_translate></strong></td>
										</tr>
										<cfoutput>
											<tr class="<cfif misevaluaciones.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
												<td>#misevaluaciones.empleado#</td>
												<td align="right" ><cfif len(trim(misevaluaciones.nota))>#LSNumberFormat(misevaluaciones.nota,',9.00')#<cfelse>-</cfif></td>
											</tr>
										</cfoutput>
									</table>
									<br>
								</cfoutput>
							<cfelse>
								<table width="100%" cellpadding="2" cellspacing="0"  >
									<tr><td align="center">- <cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
								</table>
							</cfif>
							</td></tr>
						</table>
						<cf_web_portlet_end>
					</td>
					
					<td width="33%" valign="top">
						<!--- OTRAS EVALUACIONES --->
						<!--- Cuestionario de Benziger --->
						<cfset otrasevaluaciones = expediente.otrasevaluaciones(form.DEid, session.Ecodigo, '20') >
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Cuestionario de Benziger" Key="LB_Cuestionario_de_Benziger" returnvariable="LB_Cuestionario_de_Benziger"/>	
						<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Cuestionario_de_Benziger#" >
							<cfif otrasevaluaciones.recordcount gt 0 >
								<table width="99%" align="center" cellpadding="0" cellspacing="2"  bgcolor="#FFFFFF">
									<!---<tr><td colspan="3" align="center" bgcolor="#CCCCCC"><strong><font size="2">Otras Evaluaciones</font></strong></td></tr>--->
									<tr><td>
										<cfoutput query="otrasevaluaciones">
											<table width="100%" cellpadding="2" cellspacing="0"  >
												<!--- Encabezado --->
												<tr class="listaCorte">
													<td><strong><cf_translate key="LB_Evaluacion">Evaluación</cf_translate>:</strong></td>
													<td colspan="3">#otrasevaluaciones.RHEEdescripcion#</td>
												</tr>
												<tr class="listaCorte">
													<td><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong></td>
													<td colspan="3"><cf_locale name="date" value="#otrasevaluaciones.RHEEfdesde#"/></td>
												</tr>
												<tr class="listaCorte">
													<td><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:</strong></td>
													<td colspan="3">#trim(otrasevaluaciones.RHPcodigo)# - #otrasevaluaciones.RHPdescpuesto#</td>
												</tr>
						
												<tr class="listaCorte">
													<td><strong><cf_translate key="LB_Nota">Nota</cf_translate>:</strong></td>
													<td colspan="3"><cfif len(trim(otrasevaluaciones.promglobal))>#LSNumberFormat(otrasevaluaciones.promglobal,',9.00')#<cfelse>-</cfif></td>
												</tr>
											</table>
											<br>
										</cfoutput>
									</td></tr>
								</table>
							<cfelse>
								<table width="100%" cellpadding="2" cellspacing="0" >
									<tr><td align="center">- <cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
								</table>
							</cfif>
						<cf_web_portlet_end>
						
						<br>
						
						<!--- Otros Cuestionarios (test, otros) --->
						<cfset otrasevaluaciones = expediente.otrasevaluaciones(form.DEid, session.Ecodigo, '30,40') >
						<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
							Default="Otras Evaluaciones" Key="LB_Otras_Evaluaciones" returnvariable="LB_Otras_Evaluaciones"/>							
						<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Otras_Evaluaciones#" >
							<cfif otrasevaluaciones.recordcount gt 0 >
								<table width="99%" align="center" cellpadding="0" cellspacing="2">
									<!---<tr><td colspan="3" align="center" bgcolor="#CCCCCC"><strong><font size="2">Otras Evaluaciones</font></strong></td></tr>--->
									<tr><td>
										<cfoutput query="otrasevaluaciones">
											<table width="100%" cellpadding="2" cellspacing="0"  >
												<!--- Encabezado --->
												<tr class="listaPar">
													<td><strong><cf_translate key="LB_Evaluacion">Evaluación</cf_translate>:</strong></td>
													<td colspan="5">#otrasevaluaciones.RHEEdescripcion#</td>
												</tr>
												<tr class="listaPar">
													<td><strong><cf_translate key="LB_Fecha">Fecha</cf_translate>:</strong></td>
													<td colspan="5"><cf_locale name="date" value="#otrasevaluaciones.RHEEfdesde#"/></td>
												</tr>
												<tr class="listaPar">
													<td><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:</strong></td>
													<td colspan="5">#trim(otrasevaluaciones.RHPcodigo)# - #otrasevaluaciones.RHPdescpuesto#</td>
												</tr>						
												
												<tr class="listaPar" style="border-top:1px solid black;">
													<td colspan="5" align="center" style="border-top:1px solid gray;">
													<strong><cf_translate key="LB_Notas">Notas</cf_translate></strong></td>
												</tr>
												
												<tr bgcolor="##FAFAFA" >
													<td align="center"><strong><cf_translate key="LB_Global">Global</cf_translate></strong></td>
													<td align="center"><strong><cf_translate key="LB_Autoevaluacion">Autoevaluación</cf_translate></strong></td>
													<td align="center"><strong><cf_translate key="LB_Jefe">Jefe</cf_translate></strong></td>
													<td align="center"><strong><cf_translate key="LB_Otros">Otros</cf_translate></strong></td>
													<td align="center"></td>
												</tr>
												<tr>
													<cfquery name="rsParam" datasource="#session.dsn#">
														select Pvalor from RHParametros where Ecodigo=#session.Ecodigo#
														and Pcodigo='2106'
													</cfquery>
													<cfif rsParam.Pvalor eq 1>
														<cfquery name="rsEv" datasource="#session.dsn#">
															select Porc_dist from RHEEvaluacionDes where RHEEid=#otrasevaluaciones.RHEEid#
														</cfquery>
														<cfif rsEv.Porc_dist gt 0 and len(trim(otrasevaluaciones.RHLEnotajefe)) gt 0 and len(trim(otrasevaluaciones.RHLEpromotros)) gt 0 >
															<cfset LvarPorcJ=#rsEv.Porc_dist#>
															<cfset LvarPorcO=100-LvarPorcJ>
															<cfset LvarGlobalJ=#otrasevaluaciones.RHLEnotajefe#*#LvarPorcJ#/100>
															<cfset LvarGlobalO=#otrasevaluaciones.RHLEpromotros#*#LvarPorcO#/100>
															<cfset LvarGlobalt=LvarGlobalJ+LvarGlobalO>
														<cfelseif len(trim(otrasevaluaciones.RHLEnotajefe)) gt 0 and len(trim(otrasevaluaciones.RHLEpromotros)) gt 0>
															<cfset LvarGlobalt=(#otrasevaluaciones.RHLEnotajefe#+#otrasevaluaciones.RHLEpromotros#)/2>
														<cfelse>
															<cfset LvarGlobalt=0>
														</cfif>
													<td align="center"><cfif len(trim(LvarGlobalt))>#LSNumberFormat(LvarGlobalt,',9.00')#<cfelse>-</cfif></td>
													<cfelse>
													<td align="center"><cfif len(trim(otrasevaluaciones.promglobal))>#LSNumberFormat(evaluacion360.promglobal,',9.00')#<cfelse>-</cfif></td>
													</cfif>
													<td align="center"><cfif len(trim(otrasevaluaciones.RHLEnotaauto))>#LSNumberFormat(evaluacion360.RHLEnotaauto,',9.00')#<cfelse>-</cfif></td>
													<td align="center"><cfif len(trim(otrasevaluaciones.RHLEnotajefe))>#LSNumberFormat(evaluacion360.RHLEnotajefe,',9.00')#<cfelse>-</cfif></td>
													<td align="center"><cfif len(trim(otrasevaluaciones.RHLEpromotros))>#LSNumberFormat(evaluacion360.RHLEpromotros,',9.00')#<cfelse>-</cfif></td>
													<td align="center"><img src="/cfmx/rh/imagenes/findsmall.gif" border="0" alt="Consultar detalle de la evaluaci&oacute;n" style="cursor:hand;" onClick="javascript:detalle_evaluacion(#form.DEid#, #evaluacion360.RHEEid#, 1);" >
													<img src="/cfmx/rh/imagenes/Documentos2.gif" border="0" alt="Consultar detalle del plan de acci&oacute;n registrado" style="cursor:hand;" onClick="javascript:detalle_plan(#form.DEid#, #evaluacion360.RHEEid#);" ></td>
												</tr>
												<tr><td>&nbsp;</td></tr>
											</table>
											<br>
										</cfoutput>
									</td></tr>
								</table>
							<cfelse>
								<table width="100%" cellpadding="2" cellspacing="0" >
									<tr><td align="center">- <cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
								</table>
							</cfif>
						<cf_web_portlet_end>
					</td>
				</tr>
			</table>

				<cf_web_portlet_end>
			</TD></TR>
		</table>

		<script language="javascript1.2" type="text/javascript">
			var popUpWinEval=0;
			function popUpWindowEval(URLStr, left, top, width, height){
				if(popUpWinEval) {
					if(!popUpWinEval.closed) popUpWinEval.close();
				}
				popUpWinEval = open(URLStr, 'popUpWinEval', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				window.onfocus = closePopUpEval;
			}
			function closePopUpEval(){
				if(popUpWinEval) {
					if(!popUpWinEval.closed) popUpWinEval.close();
					popUpWinEval=null;
				}
			}

			function detalle_evaluacion(empleado, evaluacion, tipo){
				popUpWindowEval('evaluaciones/consulta-evaluaciones.cfm?DEid='+empleado+'&RHEEid='+evaluacion+'&tipo='+tipo, 75, 50, 1000, 700);
			}
			
			function detalle_plan(empleado, evaluacion){
				popUpWindowEval('evaluaciones/plan_accion.cfm?DEid='+empleado+'&RHEEid='+evaluacion, 500, 500, 500, 300);
			}
			
		</script>

