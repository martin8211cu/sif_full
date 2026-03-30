<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
			<cfset params="">
			<cfoutput>#pNavegacion#</cfoutput>
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10">&nbsp;</td>
					<td width="35%" valign="top">
						<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" 	returnvariable="LB_ayuda"/>
						<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="300" height="300">
							<p><cf_translate  key="LB_texto_de_ayuda">
								Este reporte muestra un listado de las incidencias segun el rango de fechas del calendario de pago, hist&oacute;ricas o sin aplicar, y segun su estado de aprobaci&oacute;n
							</cf_translate></p>
							<cf_web_portlet_end>
					</td>
					<td width="15">&nbsp;</td>
					<td width="65%" valign="top">
						
						<!--- ReporteLibroSalariosFiltro.cfm --->
						<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
						<cfinvoke Key="LB_EmpleadoFinal" Default="Empleado Final" returnvariable="LB_EmpleadoFinal" component="sif.Componentes.Translate" method="Translate"/>
						<cfinvoke Key="LB_FechaRige" Default="Fecha Rige" returnvariable="LB_FechaRige"  component="sif.Componentes.Translate" method="Translate" />
						<cfinvoke Key="LB_FechaVence" Default="Fecha Vence" returnvariable="LB_FechaVence" component="sif.Componentes.Translate" method="Translate"/>
						<cfoutput>
						
						<cfinclude template="ConsultaIncidenciasProceso-Variables.cfm">
						
						<cfset deshabilitar = false>
						<cf_web_portlet_start style="box" titulo="#LB_nav__SPdescripcion#">
							<table width="100%" align="center">
								<tr>
									<td>
										<form action="ConsultaIncidenciasProceso-Reporte.cfm" method="post" name="form1" style="margin:0">
											<table width="70%" align="center" border="0" cellpadding="2" cellspacing="2" style="margin:0">
												<tr><td>&nbsp;</td></tr>
												<cfif listFindNoCase('1,2',rol,',')>	<!--- si es jefe o administrador --->
												<tr>
													<td align="right" valign="top" nowrap="nowrap"><strong><cf_translate  key="LB_Centro_Funcional">Centro Funcional</cf_translate>:</strong></strong></td>
													<td colspan="3">
														<cf_rhcfuncional contables="1" tabindex="1">
													</td>
												</tr>
												</cfif>
												<tr>
												<td align="right" valign="top"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>:</strong></strong></td>
												<td colspan="3">
													<cfif menu EQ 'AUTO'>
														<cfif rol EQ 1>
															<cf_rhempleado form="form1" showTipoId="false" JefeDEid="#UserDEid#"><!---Jefe/autorizador/usuario en CF--->
														<cfelse>
															<cf_rhempleado form="form1" showTipoId="false" idempleado="#UserDEid#" JefeDEid="#UserDEid#" readOnly="true"><!---usuario normal--->
														</cfif>
													<cfelse>
														<cf_rhempleado form="form1" showTipoId="false"><!---Admin--->
													</cfif>
												</td>
												<tr>
													<td nowrap align="right"> <strong><cf_translate  key="LB_Fechadesde">Fecha desde</cf_translate> :&nbsp;</strong></td>
													<td><cf_sifcalendario form="form1" tabindex="1" name="Fdesde"></td>
												
													<td nowrap align="right"> <strong><cf_translate  key="LB_Fechahasta">Fecha hasta</cf_translate> :&nbsp;</strong></td>
													<td><cf_sifcalendario form="form1" tabindex="1" name="Fhasta"></td>
												</tr>
												 <tr>
													<td nowrap align="right"> <strong><cf_translate  key="LB_TipoIncidencia">Tipo Incidencia</cf_translate> :&nbsp;</strong></td>
													<td><select name="CItipo" id="CItipo" <cfif deshabilitar >disabled="disabled"</cfif>>
													<option value=""><cf_translate  key="CITodos">--- Todos ---</cf_translate></option>
													<option value="0"><cf_translate  key="CItipo0">Horas</cf_translate></option>
													<option value="1"><cf_translate  key="CItipo1">D&iacute;as</cf_translate></option>
													<option value="2"><cf_translate  key="CItipo2">Importe</cf_translate></option>
													<option value="3"><cf_translate  key="CItipo3">C&aacute;lculo</cf_translate></option>
													</select>
												  </td>
												</tr>
												
												<tr>
													<td nowrap align="right"> <strong><cf_translate  key="LB_TipoIncidencia">Incidencia</cf_translate> :&nbsp;</strong></td>
													<td>
														  <cfset DesdeAutogetion =''>
														  <cfif Menu EQ 'AUTO'>	<!---solo las visibles desde autogestion--->
															<cfset DesdeAutogetion ='and a.CIautogestion = 1'>
														  </cfif>
														  <cf_conlis title="Lista de Conceptos Incidentes"
																	campos = "CIid,CIcodigo,CIdescripcion" 
																	desplegables = "N,S,S" 
																	modificables = "N,S,N" 
																	size = "0,10,20"
																	asignar="CIid,CIcodigo,CIdescripcion"
																	asignarformatos="I,S,S"
																	tabla="	CIncidentes a"																	
																	columnas="CIid,CIcodigo, CIdescripcion, CInegativo"
																	filtro="a.Ecodigo =#session.Ecodigo#
																			and CIcarreracp = 0
																			and coalesce(a.CInomostrar,0) = 0
																			and CItipo <= 3
																			#DesdeAutogetion#"
																	desplegar="CIcodigo,CIdescripcion"
																	etiquetas="	Concepto, 
																				Descripcion"
																	formatos="S,S"
																	align="left,left"
																	showEmptyListMsg="true"
																	debug="false"
																	form="form1"
																	width="800"
																	height="500"
																	left="70"
																	top="20"
																	filtrar_por="CIcodigo,CIdescripcion"
																	valuesarray="">  <!---#va_arrayIncidencia#--->
													
													</td>
												</tr>
												
												<cfif aprobarIncidencias>
												<tr>
												<td align="right"><strong><cf_translate  key="LB_estado">Estado</cf_translate>:</strong></td>
												<td>
													<table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td width="1%">
																<select name="estado">
																	<option value=""><cf_translate  key="LB_Todos">---Todos---</cf_translate></option> 
																	<option value="0"><cf_translate  key="LB_Ingresadas">Ingresadas</cf_translate></option> 
																	<option value="1"><cf_translate  key="LB_Aprobadas">Pendientes</cf_translate></option> 
																	<option value="2"><cf_translate  key="LB_Aprobadas">Aprobadas</cf_translate></option> 
																	<option value="3"><cf_translate  key="LB_Rechazadas">Rechazadas</cf_translate></option> 
																</select>
														  	</td>
															<td>&nbsp;</td>
															<td>&nbsp;</td>
															
														</tr>
													</table>
												</td>
												</tr>
												</cfif>
												
												<cfif rol NEQ 0>
													<tr>
														<td align="right"><strong><cf_translate  key="LB_Agrupar_por">Agrupar por:</cf_translate>&nbsp;:</strong></td>
														<td><input name="group_by" type="radio" value="1" /><cf_translate  key="LB_CF">Centro Funcional</cf_translate>&nbsp;</td>
														<td><input name="group_by" type="radio" value="2" /><cf_translate  key="LB_Emp">Empleado</cf_translate>&nbsp; </td>
													</tr>
												</cfif>
												<!---<tr><th scope="row"  colspan="2" class="fileLabel"><cf_botones values="Ver" tabindex="1">&nbsp;</th></tr>--->
												<tr><td align="center" colspan="4"><input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" /></td></tr>
											</table>
									  </form>
									</td>
								</tr>
							</table>
						<cf_web_portlet_end>
						<cf_qforms>
							<cf_qformsrequiredfield name="Fdesde" description="#LB_FechaRige#">
							<!---<cf_qformsrequiredfield name="Fhasta" description="#LB_FechaVence#">--->
						</cf_qforms>
						</cfoutput>
						</td>
					<td width="15">&nbsp;</td>
				  </tr>
				</table>
			<br/>
	<cf_web_portlet_end>
<cf_templatefooter>