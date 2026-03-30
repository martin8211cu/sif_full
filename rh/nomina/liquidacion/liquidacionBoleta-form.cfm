<cfif isdefined("Url.DLlinea") and Len(Trim(Url.DLlinea)) and not isdefined("Form.DLlinea")>
	<cfset Form.DLlinea = Url.DLlinea>
</cfif>

<cfif isdefined("Url.DEid") and Len(Trim(Url.DEid)) and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<cfif isdefined("Form.DLlinea") and Len(Trim(Form.DLlinea))>
	<cfinclude template="liquidacionBoleta-calculo.cfm">
	
	<style type="text/css">
		.tituloReporte1 {
			font-size:18px;
			text-align:center;
		}
		.tituloReporte2 {
			font-size:16px;
			text-align:center;
		}
		.tituloReporte2 {
			font-size:14px;
			text-align:center;
		}
		.recuadro1 {
			border-left: 1px solid black;
			border-top: 1px solid black;
			border-right: 3px solid black;
			border-bottom: 3px solid black;
		}
		
		.recuadro2 {
			border-left: 1px solid black;
			border-top: 1px solid black;
			border-right: 1px solid black;
			border-bottom: 1px solid black;
		}
		
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
	</style>
	
	<cfoutput>
		<!--- <cfdocument format="flashpaper" 
			marginleft="2" 
			marginright="2" 
			marginbottom="3"
			margintop="1" 
			unit="cm" 
			pagetype="letter">	
		<cfdocumentitem type="header"> --->
		<table width="100%" cellspacing="0" cellpadding="2">
			<!--- BOLETA DE LIQUIDACION LABORAL --->
			<tr>
				<td>
					<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td align="center" class="tituloReporte1">#Session.Enombre#</td>
					  	</tr>
					  	<tr>
							<td align="center" class="tituloReporte2"><cf_translate key="LB_LIQUIDACION_LABORAL">LIQUIDACION LABORAL</cf_translate></td>
					  	</tr>
					  	<tr>
							<td align="center" class="tituloReporte2">#Ucase(rsEncabezado.RHTdesc)#</td>
					  	</tr>
					  	<tr><td>&nbsp;</td></tr>
					</table>
					
					<table width="90%" align="center" border="0" cellspacing="0" cellpadding="2" class="recuadro1">
					  	<tr>
							<td width="25%" align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Nombre" >Nombre</cf_translate>:</td>
							<td width="25%"><strong>#rsEncabezado.NombreCompleto#</strong></td>
							<td width="1%">&nbsp;</td>
							<td width="24%" align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Puesto" >Puesto</cf_translate>:</td>
							<td width="25%"><strong>#rsEncabezado.RHPdescpuesto#</strong></td>
					  	</tr>
					  	<tr>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Identificacion" >C&eacute;dula</cf_translate>:</td>
							<td><strong>#rsEncabezado.Deidentificacion#</strong></td>
							<td>&nbsp;</td>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Departamento" >Departamento</cf_translate>:</td>
							<td><strong>#rsEncabezado.Ddescripcion#</strong></td>
					  	</tr>
					  	<tr>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Fecha_Ingreso" >Fecha de Ingreso</cf_translate>: </td>
							<td><strong>#LSDateFormat(rsEncabezado.EVfantig, 'dd/mm/yyyy')#</strong></td>
							<td colspan="3">&nbsp;</td>
					  	</tr>
					  	<tr>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Fecha_de_Salida">Fecha de Salida</cf_translate>:</td>
							<td><strong>#LSDateFormat(rsEncabezado.DLfvigencia, 'dd/mm/yyyy')#</strong></td>
							<td>&nbsp;</td>
							<td colspan="2" rowspan="3" align="center" valign="bottom">
									<cfif rsSalPromAccion.RecordCount gt 0>
											
											<cfquery name="rsCalculos"  dbtype="query">
												select sum(RHSPAmonto) as total ,sum(RHSPAdias) as dias, sum(RHSPAmonto)/sum(RHSPAdias) as PromDiario
												from rsSalPromAccion
											</cfquery>
											
											<cfset PromSalDiario  = rsCalculos.PromDiario> 
											<cfset PromSalMensual  = rsCalculos.PromDiario * rsEncabezado.FactorDiasSalario> 
											<cfset TotalSalarios  = rsCalculos.total>
											<cfset periodos  = rsSalPromAccion.RecordCount> 
											
											<table  border="0" cellspacing="0" cellpadding="2">
											<tr>
												<td colspan="3" align="center"><strong>*** <cf_translate key="LB_Datos_Salariales">Datos Salariales</cf_translate> *** </strong></td>
											</tr>
											<tr>
												<td nowrap style="padding-right: 30px; "><cf_translate key="LB_Salario_Ultimos_Periodos">Total Salario &Uacute;ltimos Per&iacute;odos</cf_translate>(#LSNumberFormat(periodos, ',9.00')#)</td>
												<td width="1" align="center">#rsEncabezado.Msimbolo#</td>
												<td align="right" style="padding-left: 20px; ">#LSNumberFormat(TotalSalarios, ',9.00')#</td>
											</tr>
											
											<cfif isdefined("rspromedio.SalarioPromedioDiario")>
												<cfset SalarioPromedio = (rspromedio.SalarioPromedioDiario) * ValorPromedioDiario>
											<cfelse>
												<cfset SalarioPromedio = 0 >
											</cfif>
											
											<tr>
												<td nowrap style="padding-right: 30px; "><cf_translate key="LB_Salario_Promedio_Mensual">Salario Promedio Mensual</cf_translate></td>
												<td width="1" align="center">#rsEncabezado.Msimbolo#</td>
												<td align="right">#LSNumberFormat(PromSalMensual, ',9.00')#</td>
											</tr>
											<tr>
												<td nowrap style="padding-right: 30px; "><cf_translate key="LB_Salario_Diario">Salario Diario</cf_translate></td>
												<td width="1" align="center">#rsEncabezado.Msimbolo#</td>
												<td align="right"><cfif isdefined("rspromedio.SalarioPromedioDiario")>#LSNumberFormat(PromSalDiario, ',9.00')#<cfelse>0.00</cfif></td>
											</tr>
											</table> 
									<cfelse>
											<table  border="0" cellspacing="0" cellpadding="2">
											<tr>
												<td colspan="3" align="center"><strong>*** <cf_translate key="LB_Datos_Salariales">Datos Salariales</cf_translate> *** </strong></td>
											</tr>
											<tr>
												<td nowrap style="padding-right: 30px; "><cf_translate key="LB_Salario_Ultimos_Periodos">Salario &Uacute;ltimos Per&iacute;odos</cf_translate>(#CantidadPeriodos#)</td>
												<td width="1" align="center">#rsEncabezado.Msimbolo#</td>
												<td align="right" style="padding-left: 20px; ">#LSNumberFormat(SalarioUltimosPeriodos, ',9.00')#</td>
											</tr>
											
											<cfif isdefined("rspromedio.SalarioPromedioDiario")>
												<cfset SalarioPromedio = (rspromedio.SalarioPromedioDiario) * ValorPromedioDiario>
											<cfelse>
												<cfset SalarioPromedio = 0 >
											</cfif>
											
											<tr>
												<td nowrap style="padding-right: 30px; "><cf_translate key="LB_Salario_Promedio_Mensual">Salario Promedio Mensual</cf_translate></td>
												<td width="1" align="center">#rsEncabezado.Msimbolo#</td>
												<td align="right">#LSNumberFormat(SalarioPromedio, ',9.00')#</td>
											</tr>
											<tr>
												<td nowrap style="padding-right: 30px; "><cf_translate key="LB_Salario_Diario">Salario Diario</cf_translate></td>
												<td width="1" align="center">#rsEncabezado.Msimbolo#</td>
												<td align="right"><cfif isdefined("rspromedio.SalarioPromedioDiario")>#LSNumberFormat(rspromedio.SalarioPromedioDiario, ',9.00')#<cfelse>0.00</cfif></td>
											</tr>
											</table> 
									</cfif>
							</td>
					  	</tr>
						
					  	<tr>
							<td colspan="3">&nbsp;</td>
					  	</tr>
					  	<tr>
							<td colspan="2" align="center" valign="bottom">
						 		<table  border="0" cellspacing="0" cellpadding="2">
						  			<tr>
										<td>&nbsp;</td>
										<td align="center" style="padding-left: 10px; "><strong><cf_translate key="LB_Anos">A&ntilde;os</cf_translate></strong></td>
										<td align="center" style="padding-left: 10px; "><strong><cf_translate key="LB_Meses">Meses</cf_translate></strong></td>
										<td align="center" style="padding-left: 10px; "><strong><cf_translate key="LB_Dias">D&iacute;as</cf_translate></strong></td>
						  			</tr>
						  			<tr>
										<td nowrap><cf_translate key="LB_Antiguedad_Antes_de_Ley">Antig&uuml;edad Antes de Ley</cf_translate></td>
										<td align="center" style="padding-left: 10px; ">#AnnosAntesCorte#</td>
										<td align="center" style="padding-left: 10px; ">#MesesAntesCorte#</td>
										<td align="center" style="padding-left: 10px; ">#DiasAntesCorte#</td>
						  			</tr>
						  			<tr>
										<td nowrap><cf_translate key="LB_Antiguedad_Despues_de_Ley">Antig&uuml;edad Despu&eacute;s de Ley</cf_translate></td>
										<td align="center" style="padding-left: 10px; ">#AnnosDespuesCorte#</td>
										<td align="center" style="padding-left: 10px; ">#MesesDespuesCorte#</td>
										<td align="center" style="padding-left: 10px; ">#DiasDespuesCorte#</td>
						  			</tr>
								</table>
							</td>
							<td>&nbsp;</td>
					  	</tr>
				  	</table>
					<!--- </cfdocumentitem> --->
					<br>
					<table width="90%" align="center" border="0" cellspacing="0" cellpadding="2">
						<tr>
							<cfif rsOtrosRubrosEspeciales.recordCount or rsDetallePrestacionesSP.recordCount or rsDetalleOtrasPrestacionesSP.recordCount>
								<td valign="top">
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2" class="recuadro1">
									<tr>
										<td   nowrap colspan="4" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Otros_Rubros_Especiales">Otros Rubros Especiales</cf_translate></font></strong></td>
									</tr>
									<cfloop query="rsOtrosRubrosEspeciales">
										<tr>
											<td colspan="3"><font style="font-size:10px">#Descripcion#</font></td>
											<td colspan="1"align="right"><font style="font-size:10px">(#LSNumberFormat(Resultado, ',9.00')#)</font></td>
										</tr>
									</cfloop>
									<tr>
										<td style="border-bottom: 1px solid black; "><strong><font style="font-size:10px">&nbsp;</font></strong></td>
										<td align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></font></strong></td>
										<td align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Importe">Importe</cf_translate></font></strong></td>
										<td align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Total">Total</cf_translate></font></strong></td>
									</tr>
									<cfloop query="rsDetallePrestacionesSP">
										<tr>
											<td><font style="font-size:10px">#Descripcion#</td>
											<td align="right"><font style="font-size:10px">#LSNumberFormat(Cantidad, ',9.00')#</font></td>
											<td align="right"><font style="font-size:10px">#LSNumberFormat(Monto, ',9.00')#</font></td>
											<td align="right"><font style="font-size:10px">#LSNumberFormat(Resultado, ',9.00')#</font></td>
										</tr>
										<!--- <cfset TotalPrestaciones = TotalPrestaciones + Resultado> --->
									</cfloop>
									
									<cfif rsDetalleOtrasPrestacionesSP.recordCount>
										<tr><td colspan="4">&nbsp;</td></tr>
										<tr>
											<td colspan="4" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Otros_Rubros_Adicionales">Otros Rubros Adicionales</cf_translate></font></strong></td>
										</tr>
										<cfloop query="rsDetalleOtrasPrestacionesSP">
											<tr>
												<td><font style="font-size:10px">#Descripcion#</font></td>
												<td align="center"><font style="font-size:10px"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#LsCurrencyFormat(cantidad,'none')#</cfif></font></td>
											<td align="right"><font style="font-size:10px"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#LsCurrencyFormat(importe,'none')#</cfif></font></td>
											<td align="right"><font style="font-size:10px"><cfif cantidad EQ 0>#LsCurrencyFormat(importe,'none')#<cfelse>#LsCurrencyFormat(resultado,'none')#</cfif></font></td>
											</tr>
											<!--- <cfset TotalPrestaciones = TotalPrestaciones + importe> --->
										</cfloop>
									</cfif>									
									
								</table>
								
								</td>
							</cfif>
							<td valign="top">
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2" class="recuadro1">
									<tr>
										<!--- area de salarios de los ultimos 6 meses --->	
										<td valign="top">
											<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
												<tr>
													<td nowrap colspan="4" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Salario_Ultimos_Periodos">Salario &Uacute;ltimos Per&iacute;odos</cf_translate>(#CantidadPeriodos#)</font></strong></td>
												</tr>
												<tr>
													<td  width="33%" align="left" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Desde">Desde</cf_translate></font></strong></td>
													<td  width="33%" align="left" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Hasta">Hasta</cf_translate></font></strong></td>
													<td  width="1%" align="right" style="border-bottom: 1px solid black; ">&nbsp;</td>
													<td nowrap  width="33%" align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Salario_Mensual">Salario Mensual</cf_translate></font></strong></td>
												</tr>
												<cfset totaldias 	 = 0>
												<cfset totalsalarios = 0>
												<cfset mes = 0>
												<cfif isdefined("rsmeses") and  rsmeses.recordCount>
													<cfloop query="rsmeses">
													<tr>
														<td align="left"  <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:10px">#LSDateFormat(rsmeses.RCdesde, 'dd/mm/yyyy')#</font></td>
														<td align="left"  <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:10px">#LSDateFormat(rsmeses.RChasta, 'dd/mm/yyyy')#</font></td>
														<td align="right" <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:10px">#rsEncabezado.Msimbolo#</font></td>
														<td align="right" <cfif  rsmeses.recordCount eq  rsmeses.currentRow>style="border-bottom: 1px solid black;"</cfif>><font style="font-size:10px">#LSNumberFormat(rsmeses.salario, ',9.00')#</font></td>
													</tr>
													<cfset totalsalarios = totalsalarios + rsmeses.salario>
													<cfset totaldias     = totaldias + rsmeses.dias>															
													
													<!--- 					
													<cfset fecha         = rsmeses.RCdesde>
													<cfif mes neq  Month(fecha)>
														<cfset mes 			 =  Month(fecha)>
														<cfset totaldias     = totaldias + DaysInMonth(fecha)>
													</cfif>	
													--->

													</cfloop>
												</cfif>
												<tr>
													<td nowrap="nowrap"><strong><font style="font-size:10px"><cf_translate key="LB_Mes">Total D&iacute;as</cf_translate></font></strong></td>
													<td align="left" ><font style="font-size:10px">#LSNumberFormat(totaldias, ',9')#</font></td>
													<td align="right" ><font style="font-size:10px">#rsEncabezado.Msimbolo#</font></td>
													<td align="right" ><font style="font-size:10px">#LSNumberFormat(totalsalarios, ',9.00')#</font></td>
												</tr>
											</table>
										</td>
										<!--- area de promedios 										
										<td valign="top">
											<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
												<tr>
													<td  colspan="2"  nowrap align="center"  style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Mensual_promedio">Mensual promedio</cf_translate></font></strong></td>
												</tr>
												<tr>
													<td   width="40%" align="right"  ><font style="font-size:10px">#rsEncabezado.Msimbolo#</font></td>
													<td   width="60%"align="left"  ><font style="font-size:10px">#LSNumberFormat(SalarioPromedio, ',9.00')#</font></td>
												</tr>
												<tr>
													<td  colspan="2"  nowrap align="center" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Quincenal_promedio">Quincenal promedio</cf_translate></font></strong></td>
												</tr>
												<tr>
													<td  align="right" ><font style="font-size:10px">#rsEncabezado.Msimbolo#</font></td>
													<td  align="left" ><font style="font-size:10px">#LSNumberFormat(SalarioQuincena, ',9.00')#</font></td>
												</tr>
												<tr>
													<td  colspan="2"  nowrap align="center"  style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Diario_promedio">Diario promedio</cf_translate></font></strong></td>
												</tr>
												<cfset SalarioPromedioDiario2 = totalsalarios / totaldias>
												<tr>
													<td  align="right" ><font style="font-size:10px">#rsEncabezado.Msimbolo#</font></td>
													<td  align="left" ><font style="font-size:10px">#LSNumberFormat(SalarioPromedioDiario2, ',9.00')#</font></td>
													
												</tr>
											</table>
										</td>--->
									</tr>	
								</table>
							</td>
						</tr>
					</table>
					<cfset TotalPrestaciones = 0>
					<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
					  	<tr>
							<td style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Detalle_de_Prestaciones_Legales">Detalle de Prestaciones Legales</cf_translate></font></strong></td>
							<td align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></font></strong></td>
							<td align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Importe">Importe</cf_translate></font></strong></td>
							<td align="right" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Total">Total</cf_translate></font></strong></td>
					  	</tr>
						<cfloop query="rsDetallePrestaciones">
					  		<tr>
								<td><font style="font-size:10px">#Descripcion#</td>
								<td align="right"><font style="font-size:10px">#LSNumberFormat(Cantidad, ',9.00')#</font></td>
								<td align="right"><font style="font-size:10px">#LSNumberFormat(Monto, ',9.00')#</font></td>
								<td align="right"><font style="font-size:10px">#LSNumberFormat(Resultado, ',9.00')#</font></td>
					  		</tr>
					  		<cfset TotalPrestaciones = TotalPrestaciones + Resultado>
					  	</cfloop>
						<!--- agrega linea con datos de la renta solo si es mayor que cero el monto --->
						<cfif isdefined("rsEncabezado.renta") and len(trim(rsEncabezado.renta)) and rsEncabezado.renta gt 0 >
							<tr>
								<td><font style="font-size:10px"><cf_translate key="LB_Renta" xmlfile="/rh/nomina/liquidacion/liquidacionProceso.xml">Renta</cf_translate></td>
								<td align="right"><font style="font-size:10px">0.00</font></td>
								<td align="right"><font style="font-size:10px">#LSNumberFormat(rsEncabezado.renta, ',9.00')#</font></td>
								<td align="right"><font style="font-size:10px">#LSNumberFormat(rsEncabezado.renta, ',9.00')#</font></td>
							</tr>
						</cfif>
						
						<cfif rsDetalleOtrasPrestaciones.recordCount>
							<tr><td colspan="4">&nbsp;</td></tr>
						  	<tr>
								<td colspan="4" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Otros_Rubros_Adicionales">Otros Rubros Adicionales</cf_translate></font></strong></td>
						  	</tr>
						  	<cfloop query="rsDetalleOtrasPrestaciones">
						  		<tr>
									<td><font style="font-size:10px">#Descripcion#</font></td>
									<td align="center"><font style="font-size:10px"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#LsCurrencyFormat(cantidad,'none')#</cfif></font></td>
								<td align="right"><font style="font-size:10px"><cfif cantidad EQ 0><div align="center">-</div><cfelse>#LsCurrencyFormat(importe,'none')#</cfif></font></td>
								<td align="right"><font style="font-size:10px"><cfif cantidad EQ 0>#LsCurrencyFormat(importe,'none')#<cfelse>#LsCurrencyFormat(resultado,'none')#</cfif></font></td>
						  		</tr>
						  		<cfset TotalPrestaciones = TotalPrestaciones + importe>
						  	</cfloop>
					  	</cfif>
					  	
						<cfif rsDetalleAportesRealizados.recordCount> 
							<tr><td colspan="4">&nbsp;</td></tr>
							<tr>
								<td colspan="4" style="border-bottom: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Aportes_Realizados">Aportes Realizados</cf_translate></font></strong></td>
							</tr>
							<cfloop query="rsDetalleAportesRealizados">
						  		<tr>
									<td><font style="font-size:10px">#Descripcion#</font></td>
									<td colspan="3" align="right"><font style="font-size:10px">(#LSNumberFormat(Resultado, ',9.00')#)</font></td>
						  		</tr>
						  		<cfset TotalPrestaciones = TotalPrestaciones - Resultado>
							</cfloop>
						</cfif>
						
						<tr><td colspan="4">&nbsp;</td></tr>

						<cfif isdefined("rsEncabezado.renta") and len(trim(rsEncabezado.renta)) and rsEncabezado.renta gt 0 >
							<cfset TotalPrestaciones = TotalPrestaciones + rsEncabezado.renta >
						</cfif>

					  	<tr>
							<td style="border-top: 1px solid black; "><strong><font style="font-size:10px"><cf_translate key="LB_Total_de_Salarios_y_Prestaciones_por_Pagar">Total de Salarios y Prestaciones por Pagar</cf_translate>:</font></strong></td>
							<td colspan="3" align="right" style="border-top: 1px solid black; "><font style="font-size:10px">#LSNumberFormat(TotalPrestaciones, ',9.00')#</font></td>
					  	</tr>
					</table>
			
					<cfif len(trim(TotalPrestaciones)) eq 0>
						<cfset TotalPrestaciones = 0 >
					</cfif>
					
					<!--- <cfinvoke component="sif.Componentes.montoEnLetras" returnvariable="montoletras" method="fnMontoEnLetras">
						<cfinvokeargument name="Monto" value="#TotalPrestaciones#">
					</cfinvoke> --->
					
					<cfinvoke component="rh.Componentes.sp_MontoLetras" method="MontoLetras" returnvariable="Vmontoletras">
						<cfinvokeargument name="conexion" value="#session.DSN#">		
						<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
						<cfinvokeargument name="debug" value="false">
						<cfinvokeargument name="Monto" value="#TotalPrestaciones#">
					</cfinvoke>
					
					<!---
					<cfquery name="rsConvert" datasource="#Session.DSN#">
						declare @montoletras varchar(255)
						exec sp_MontoLetras @Monto = #TotalPrestaciones#, @Letras = @montoletras output
						select @montoletras as montoletras
					</cfquery>
					--->
					<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
					  	<tr>
							<!---
							<td colspan="9" class="recuadro2">
								Recibí la suma de <strong>#LSNumberFormat(TotalPrestaciones, ',9.00')# (#UCase(Trim(montoletras))#)</strong> como
								pago completo y total de la liquidaci&oacute;n detallada anteriormente. Al recibir esta cantidad declaro
								completamente liquidado mi contrato de trabajo y satisfechas todas y cada una de las sumas y prestaciones a
								que ten&iacute;a derecho por mis servicios ordinarios y extraordinarios prestados a #Session.Enombre# y por consiguiente
								declaro que la compa&ntilde;&iacute;a no me adeuda suma alguna.
							</td>
							--->
							<td colspan="9" class="recuadro2">
								<font style="font-size:10px">
								<cf_translate key="MSG_ComoPagoCompletoYTotalDeLaLiquidacionDetalladaAnteriormente">Como pago completo y total de la liquidaci&oacute;n detallada anteriormente, recibí la suma de </cf_translate><strong>#LSNumberFormat(TotalPrestaciones, ',9.00')# (#UCase(Trim(Vmontoletras))#)</strong>. <cf_translate key="MSG_MENSAJE_DE_PAGO_Al_RecibirEstaCantidadDeclaro">Al recibir esta cantidad declaro
								completamente liquidado mi contrato de trabajo y satisfechas todas y cada una de las sumas y prestaciones a
								que ten&iacute;a derecho por mis servicios ordinarios y extraordinarios prestados a #Session.Enombre# y por consiguiente
								declaro que la compa&ntilde;&iacute;a no me adeuda suma alguna.</cf_translate>
								</font>
							</td>
					  	</tr>
					  	<tr><td colspan="9">&nbsp;</td></tr>
					  	<tr><td colspan="9" align="center" bgcolor="##CCCCCC"><strong><cf_translate key="LB_RECIBIDO_CONFORME">RECIBIDO CONFORME</cf_translate></strong></td></tr>
					  	<tr>
							<td colspan="9">
								<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
									<tr>
										<td width="11%" style="border-bottom: 1px solid black;">&nbsp;</td>
										<td width="1%">&nbsp;</td>
										<td width="11%" style="border-bottom: 1px solid black;">&nbsp;</td>
										<td width="1%">&nbsp;</td>
										<td width="11%" style="border-bottom: 1px solid black;">&nbsp;</td>
									</tr>
									<tr align="center">
										<td nowrap><cf_translate key="LB_Jefe_de_Administracion">Jefe de Administraci&oacute;n</cf_translate></td>
										<td nowrap>&nbsp;</td>
										<td nowrap><cf_translate key="LB_Departamento_de_Auditoria">Departamento de Auditor&iacute;a</cf_translate></td>
										<td nowrap>&nbsp;</td>
										<td nowrap><cf_translate key="LB_Confeccionado_por">Confeccionado por</cf_translate></td>
									</tr>
									<tr align="center">
										<td nowrap><cf_translate key="LB_fecha">Fecha</cf_translate>:&nbsp;#LSDateFormat(Now(), "dd/mm/yyyy")#.&nbsp;</td>
										<td nowrap>&nbsp;</td>
										<td nowrap><cf_translate key="LB_fecha">Fecha</cf_translate>:&nbsp;____ / ____ / ____ .&nbsp;</td>
										<td nowrap>&nbsp;</td>
										<td nowrap><cf_translate key="LB_fecha">Fecha</cf_translate>:&nbsp;#LSDateFormat(rsEncabezado.RHLPfecha, "dd/mm/yyyy")#.&nbsp;</td>
									</tr>
								</table>
							</td>
					  	</tr>
					  	<tr><td colspan="9">&nbsp;</td></tr>
					  	<tr>
							<td width="12%" style="border-bottom: 1px solid black;">&nbsp;</td>
							<td width="1%">&nbsp;</td>
							<td width="11%" style="border-bottom: 1px solid black;">&nbsp;</td>
							<td width="1%">&nbsp;</td>
							<td width="11%" style="border-bottom: 1px solid black;">&nbsp;</td>
							<td width="1%">&nbsp;</td>
							<td width="11%" style="border-bottom: 1px solid black;">&nbsp;</td>
							<td width="1%">&nbsp;</td>
							<td width="11%" style="border-bottom: 1px solid black;">&nbsp;</td>
					  	</tr>
					  	<tr align="center">
							<td nowrap><cf_translate key="LB_Firma_del_Trabajador">Firma del Trabajador</cf_translate></td>
							<td nowrap>&nbsp;</td>
							<td nowrap><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></td>
							<td nowrap>&nbsp;</td>
							<td nowrap><cf_translate key="LB_Testigo">Testigo</cf_translate></td>
							<td nowrap>&nbsp;</td>
							<td nowrap><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></td>
							<td nowrap>&nbsp;</td>
							<td nowrap><cf_translate key="LB_Fecha_Entregado">Fecha Entregado</cf_translate></td>
					  	</tr>
					</table>
					<br>
				</td>
			</tr>
			<tr class="pageEnd"><td>&nbsp;</td></tr>
			<tr><td><H1 class=Corte_Pagina></H1></td></tr>

			
			<!--- BOLETA DE DETALLE DE OBLIGACIONES --->
			<tr>
				<td>
					<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td class="tituloReporte1">#Session.Enombre#</td>
					  	</tr>
					  	<tr align="center">
							<td class="tituloReporte2"><cf_translate key="LB_LIQUIDACION_LABORAL">LIQUIDACION LABORAL</cf_translate></td>
					  	</tr>
					  	<tr align="center">
							<td class="tituloReporte2"><cf_translate key="LB_DETALLE_OBLIGACIONES">DETALLE OBLIGACIONES</cf_translate></td>
					  	</tr>
					  	<tr><td>&nbsp;</td></tr>
					</table>
	
					<table width="90%" align="center" border="0" cellspacing="0" cellpadding="2" class="recuadro1">
						<tr>
							<td width="25%" align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Nombre">Nombre</cf_translate>:</td>
							<td width="25%"><strong>#rsEncabezado.NombreCompleto#</strong></td>
							<td width="1%">&nbsp;</td>
							<td width="24%" align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Puesto">Puesto</cf_translate>:</td>
							<td width="25%"><strong>#rsEncabezado.RHPdescpuesto#</strong></td>
					  	</tr>
					  	<tr>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate>:</td>
							<td><strong>#rsEncabezado.Deidentificacion#</strong></td>
							<td>&nbsp;</td>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Departamento">Departamento</cf_translate>:</td>
							<td><strong>#rsEncabezado.Ddescripcion#</strong></td>
					  	</tr>
					  	<tr>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Fecha_de_Ingreso">Fecha de Ingreso</cf_translate>: </td>
							<td><strong>#LSDateFormat(rsEncabezado.EVfantig, 'dd/mm/yyyy')#</strong></td>
							<td>&nbsp;</td>
							<td align="right" nowrap style="padding-right: 30px;"><cf_translate key="LB_Fecha_de_Salida">Fecha de Salida</cf_translate>: </td>
							<td><strong>#LSDateFormat(rsEncabezado.DLfvigencia, 'dd/mm/yyyy')#</strong></td>
					  	</tr>
				  	</table>
					<br>
					
					<cfset TotalObligaciones = 0>
					<cfset ObligacionesSocio = 0>
					<cfset cortesocio = "">
					<cfset nombresocio = "">
					
					<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
						<cfloop query="rsDetalleObligaciones">
					  		<cfif cortesocio NEQ rsDetalleObligaciones.SNnumero>
						  		<!--- Pintar Sumatoria de Obligaciones --->
						  		<cfif rsDetalleObligaciones.CurrentRow NEQ 1>
						  			<tr>
										<td colspan="2"><strong>Total #nombresocio#:</strong></td>
										<td align="right">#LSNumberFormat(ObligacionesSocio, ',9.00')#</td>
										<td>&nbsp;</td>
						  			</tr>
						  		</cfif>
						  		<tr>
									<td style="border-bottom: 1px solid black; " colspan="4">
										<table border="0" cellspacing="0" cellpadding="0">
								  			<tr>
												<td style="padding-right: 30px;"><strong><cf_translate key="LB_Socio_de_Negocio">Socio de Negocio</cf_translate>: #SNnumero# #SNnombre#</strong></td>
												<td><strong><cf_translate key="LB_Cuenta_Contable">Cuenta Contable</cf_translate>: #Cformato#</strong></td>
								  			</tr>
										</table>
									</td>
						  		</tr>
						  		<cfset cortesocio = rsDetalleObligaciones.SNnumero>
						  		<cfset nombresocio = rsDetalleObligaciones.SNnombre>
						  		<cfset ObligacionesSocio = 0>
					  		</cfif>
					  		
							<tr>
								<td width="10%" align="center"><strong>#TDcodigo#</strong></td>
								<td>#Descripcion#</td>
								<td align="right">#LSNumberFormat(Resultado, ',9.00')#</td>
								<td width="50%" align="right">&nbsp;</td>
					  		</tr>
					  		
							<cfset TotalObligaciones = TotalObligaciones + Resultado>
					  		<cfset ObligacionesSocio = ObligacionesSocio + Resultado>
					  	</cfloop>
					  	
						<tr>
							<td colspan="2"><strong><cf_translate key="LB_total">Total</cf_translate> #nombresocio#:</strong></td>
							<td align="right">#LSNumberFormat(ObligacionesSocio, ',9.00')#</td>
							<td>&nbsp;</td>
					  	</tr>
					  	<tr>
							<td colspan="4">&nbsp;</td>
					  	</tr>
					  	<tr>
							<td colspan="2" style="border-top: 1px solid black; "><strong><cf_translate key="LB_Total_Obligaciones">Total Obligaciones</cf_translate>:</strong></td>
							<td align="right" style="border-top: 1px solid black; ">#LSNumberFormat(TotalObligaciones, ',9.00')#</td>
							<td style="border-top: 1px solid black; ">&nbsp;</td>
					  	</tr>
					  	<tr>
							<td colspan="4">&nbsp;</td>
					  	</tr>
					</table>
				</td>
			</tr>
		</table>
		<!--- </cfdocument> --->
	</cfoutput>
	
</cfif>
