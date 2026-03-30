<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ReporteDeValoracionDePuestosSinProcesar"
		Default="Reporte de Valoraci&oacute;n de Puestos sin Procesar"
		returnvariable="LB_ReporteDeValoracionDePuestosSinProcesar"/>

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ReporteDeValoracionDePuestosSinProcesar#'>		
		<!--- Inicia el pintado de la pantalla --->
		<cfoutput>
		<form method="get" name="form1" action="puestosSinProcesar-rep.cfm">
			<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td width="50%">
						<table width="100%">
							<tr>
								<td valign="top">	
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_ValoracionDePuestosSinProcesar"
									Default="Valoraci&oacute;n de Puestos Sin Procesar"
									returnvariable="LB_ValoracionDePuestosSinProcesar"/>
									
									
									<cf_web_portlet_start border="true" titulo="#LB_ValoracionDePuestosSinProcesar#" skin="info1">
										<div align="justify">
											<cf_translate key="MSG_EnEsterReporteSeCalificanAspectosMuyPrecisosYPuntualesDeCadaPuestoEvaluadoEncontraremosDosTiposDeReporteElResumidoYElDetalladoEnElResumidoSeListanLosPuestosDefinidosYElTotalDePuntosObtenidosEnElDetalladoSeMuestraComoSeObtuvoLaCalificacionObtenidaEsteReporteSePuedeGenerarEnVariosFormatosAumentandoAsíSuUtilidadYEficienciaEnElTrasladoDeDatos">
											En &eacute;sta consulta se muestra el proceso de 
										  calificaci&oacute;n de aspectos muy precisos y puntuales de
										  cada puesto a evaluar; La consulta puede ser de 
										  dos tipos resumida y detallada; La consulta resumida lista
										  los puestos definidos y el total de
										  puntos obtenidos hasta el momento. 
										  La consulta detallada muestra cada uno de los aspectos evaluados para obtener la calificaci&oacute;n.
										  Este reporte se puede generar en varios formatos, aumentando as&iacute; su utilidad
										  y eficiencia en el traslado de datos.
										  </cf_translate>
										</div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>  
					</td>
					<td width="50%" valign="top">
						<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td nowrap="true" align="right"><strong><cf_translate key="LB_CentroFuncional"  XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
								<td><cf_rhcfuncional tabindex="1"></td>
							</tr>
							<!--- Tipos de Puestos --->
							<cfquery name="rsTipos" datasource="#session.dsn#">
								select RHTPid, RHTPcodigo, RHTPdescripcion
								from RHTPuestos
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							</cfquery>
							<tr>
								<td align="right"><strong><cf_translate key="LB_Tipo" XmlFile="/rh/generales.xml">Tipo</cf_translate>:&nbsp;</strong></td>
								<td align="left">
									<select name="RHTPid" tabindex="1">
										<option value=""></option>
									  	<cfloop query="rsTipos">
											<option value="#rsTipos.RHTPid#">
												#rsTipos.RHTPcodigo# - #rsTipos.RHTPdescripcion#
											</option>
									  </cfloop>
									</select>
								</td>
							</tr>
							<!--- Tipos de Puestos --->
							
							<cfquery name="rsRelacionVal" datasource="#session.dsn#">
								select HYERVid,HYERVdescripcion
								from HYERelacionValoracion
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  							  and HYERVestado = 0
							</cfquery>
							<tr>
								<td align="right" nowrap="true"><strong><cf_translate key="LB_RelacionDeValoracion" XmlFile="/rh/generales.xml">Relaci&oacute;n de Varloraci&oacute;n</cf_translate>:&nbsp;</strong></td>
								<td align="left">
									<select name="HYERVid" tabindex="1">
										<option value=""></option>
									  	<cfloop query="rsRelacionVal">
											<option value="#rsRelacionVal.HYERVid#">
												#rsRelacionVal.HYERVdescripcion#
											</option>
									  </cfloop>
									</select>
								</td>
							</tr>
							<tr>
                            	<td align="right" nowrap>
									<strong><cf_translate key="LB_Formato">Formato</cf_translate>:</strong>&nbsp;
								</td>
								<td>
                                    <select name="formato" tabindex="1">
                                      <option value="flashpaper">Flash Paper</option>
                                      <option value="pdf">Adobe PDF</option>
                                      <option value="excel">Microsoft Excel</option>
                                    </select>
								</td>
                          	</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td align="center" nowrap colspan="2">
									<div align="center">
							    	<input name="tipo1" type="radio" tabindex="1" value="0"  checked onClick="javascript:document.form1.tipo2.checked=false;" id="tipo1">
									<label for=tipo1><cf_translate key="RAD_Resumida">Resumida</cf_translate></label>   
	 						    	<input name="tipo2" type="radio" tabindex="1" value="1" onClick="javascript:	document.form1.tipo1.checked=false;" id="tipo2">
 						      		<label  for=tipo2><cf_translate key="RAD_Detallada">Detallada</cf_translate></label>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
 						      		<!--- <input name="tipo" type="hidden" value="<cfif isdefined("form.tipo")>#form.tipo#<cfelse>0</cfif>"> --->
							    	</div>
								</td>
						  	</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td colspan="2" align="center">
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Generar"
										Default="Generar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Generar"/>
									<input type="submit" name="Reporte" value="#BTN_Generar#" tabindex="1">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		</cfoutput>
		<!--- Finaliza el pintado de la pantalla --->
	<cf_web_portlet_end>
<cf_templatefooter>
