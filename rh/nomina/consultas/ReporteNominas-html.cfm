<cf_htmlReportsHeaders 
title="Reporte de Nominas" 
filename="ReporteDeNominas.xls"
irA="ReporteNominas.cfm" 
>
<!---- variable de traduccion---->
<cfif radRep eq 3><!--- deducciones--->
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DETALLES" Default="Deducciones" returnvariable="LB_DETALLES"/>
<cfelseif radRep eq 4><!--- cargas--->
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DETALLES" Default="Cargas" returnvariable="LB_DETALLES"/>
<cfelseif radRep eq 5><!--- incidencias--->
	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DETALLES" Default="Incidencias" returnvariable="LB_DETALLES"/>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoEmpleado" 	Default="Monto Empleado" 		returnvariable="LB_MontoEmpleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoEmpresa"  	Default="Monto Empresa" 		returnvariable="LB_MontoEmpresa"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ValorCantidad"  	Default="Valor / Cantidad" 		returnvariable="LB_ValorCantidad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MontoIncidencia" Default="Monto Incidencia"		returnvariable="LB_MontoIncidencia"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" 	Default="Identificaci&oacute;n"	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" 			Default="Nombre"				returnvariable="LB_Nombre"/>


<style type="text/css">
	.RLTtopline {
		border-bottom-width: 1px;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: red;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000;
		font-size:11px;
		font-family:Arial;
		background-color: #CCCCCC;		
	}	
	
	.LTtopline {
		border-color: red;
		border-bottom-width: 0px;
		border-right-width: 0px;
		border-left-width: 0px;
		border-top-width: 0px;
		border-style: solid;
		font-size:11px;
		font-family:Arial;
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
</style>

<cfflush interval="512">
<cfsetting requesttimeout="36000">
			
	<cfif rsdatos.recordcount GT 0>
		<cfoutput>
		<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
		<!--- SIN AGRUPAMIENTO--->
		<cfif not isdefined("chkAgruparRC") and not isdefined("chkAgrupar") >
		<!--- fin datos sin agrupamiento--->
		<cfquery dbtype="query" name="rsdatosNominas">
			<cfif radRep eq 3>
			select DEid, cedula, nombre, descripcion, sum(monto) as monto from rsDatos
			<cfelse>
			select DEid, cedula, nombre, descripcion, sum(monto) as monto, sum(monto2) as monto2 from rsDatos
			</cfif>
			group by DEid, cedula, nombre, descripcion
		</cfquery>
			<!--- variables para guardar los totales finales---->
			<cfset totalEmpleados=0>
			<cfset totalPatronos=0>
			
			<cfquery dbtype="query" name="empleados">
			select distinct DEid, cedula, nombre from rsdatosNominas order by nombre
			</cfquery>
			
			<cfloop query="empleados">
				<tr class="RLTtopline">
					<td align="center">#LB_Identificacion#</td>
					<td align="center">#LB_Nombre#</td>
					<td align="center">#LB_DETALLES#</td>
				</tr>
				<tr class="LTtopline">
					<td  align="left" valign="top">#empleados.cedula#</td>
					<td  align="left" valign="top">#empleados.nombre#</td>
					
					<td  align="right" valign="top">
						<cfif radRep eq 3><!--- detalle de deducciones--->
						<table width="100%" align="center">
							<cfquery dbtype="query" name="detalle">
							select descripcion, monto from rsdatosNominas where DEid=#empleados.DEid#
							</cfquery>
								<cfif isdefined("detalle")>
									<cfquery dbtype="query" name="detalleTotal">
									select sum(monto) as monto from detalle
									</cfquery>
								</cfif>			
							<cfif detalleTotal.recordcount gt 0>
								<cfset totalEmpleados=totalEmpleados+detalleTotal.monto>
							</cfif>					
							<tr class="LTtopline"><td colspan="2" align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td></tr>
							<cfloop query="detalle">
							<tr class="LTtopline">
								<td align="left">#detalle.descripcion#</td>
								<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
							</tr>
							</cfloop>
						</table>
						<cfelseif radRep eq 4 or radRep eq 5><!--- detalle de Cargas o Incidencias--->
						<table width="100%" align="center">
							<cfquery dbtype="query" name="detalle">
							select descripcion, monto, monto2 from rsdatosNominas where DEid=#empleados.DEid#
							</cfquery>
								<cfif isdefined("detalle")>
									<cfquery dbtype="query" name="detalleTotal">
									select sum(monto) as monto, sum(monto2) as monto2 from detalle
									</cfquery>
								</cfif>			
							<cfif detalleTotal.recordcount gt 0>
								<cfset totalEmpleados=totalEmpleados+detalleTotal.monto>
								<cfset totalPatronos=totalPatronos+detalleTotal.monto2>
							</cfif>		
							<tr class="LTtopline">
								<td>&nbsp;</td>
								<cfif radRep eq 4>
									<td align="right"><strong>#LB_MontoEmpleado#</strong></td>
									<td align="right"><strong>#LB_MontoEmpresa#</strong></td>
								<cfelse>
									<td align="right"><strong>#LB_ValorCantidad#</strong></td>
									<td align="right"><strong>#LB_MontoIncidencia#</strong></td>
								</cfif>
							</tr>			
							<tr class="LTtopline">
								<td>&nbsp;</td>
								<cfif radRep eq 4><td align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td><cfelse><td>&nbsp;</td></cfif>
								<td align="right"><strong>#LSNumberFormat(detalleTotal.monto2,',.00')#</strong></td>
							</tr>
							<cfloop query="detalle">
							<tr class="LTtopline">
								<td align="left">#detalle.descripcion#</td>
								<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
								<td align="right">#LSNumberFormat(detalle.monto2,',.00')#</td>
							</tr>
							</cfloop>

						</table>
						</cfif>
					</td>
				</tr>
			</cfloop>
			<cfif radRep eq 3>
				<tr class="RLTtopline ">
					<td  align="right">&nbsp;</td>
					<td  align="center"><b>TOTAL GENERAL</b></td>
					<td  align="right"><strong>#LSNumberFormat(totalEmpleados,',.00')#</strong></td>
				</tr>	
			<cfelseif radRep eq 4 or radRep eq 5 >	
				<tr class="RLTtopline ">
					<td  align="center" colspan="2"><b>TOTAL GENERAL</b></td>
					<td  align="right">
							<table>
								<tr>
									<td align="right">&nbsp;</td>
									<cfif radRep eq 4>
									<td align="center"><strong>#LSNumberFormat(totalEmpleados,',.00')#</strong></td>
									<cfelse>
									<td  align="center">&nbsp;</td>
									</cfif>
									<td  align="center"><strong>#LSNumberFormat(totalPatronos,',.00')#</strong></td>
								</tr>
							</table>
					</td>				
				</tr>	
			</cfif>
		</cfif><!--- fin de sin agrupamiento--->
		
		<!--- AGRUPADO POR RELACION DE CALCULO Y CENTRO FUNCIONAL--->
		<cfif isdefined("chkAgruparRC") and isdefined("chkAgrupar") >
	
			<!--- variables para guardar los totales finales---->
			<cfset TotalPorCentroFuncional=0>
			<cfset TotalPorRelacion=0>

			<cfquery dbtype="query" name="PorRelacion">
			select distinct RCNid from rsDatos order by Tcodigo
			</cfquery>
			<cfset totalFinal=0>
			<cfset totalFinal2=0>
			<cfloop query="PorRelacion">
				<cfquery dbtype="query" name="PorRelacionNombre">
					select distinct Tcodigo,nomina,fechaHasta, fechaDesde,nomina from rsDatos where RCNid=#PorRelacion.RCNid#
				</cfquery>
				<tr>
					<td td colspan="4"><b><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate>  #trim(PorRelacionNombre.Tcodigo)# - #trim(PorRelacionNombre.nomina)#</b></td>
				</tr>
				<tr>
					<td td colspan="4">Desde #LSDateFormat(PorRelacionNombre.fechaDesde,'dd-mm-yyyy')#  Hasta #LSDateFormat(PorRelacionNombre.fechaHasta,'dd-mm-yyyy')#</td>
				</tr>
				
					<cfquery dbtype="query" name="PorCentro">
					select distinct CFid from rsDatos where RCNid=#PorRelacion.RCNid# order by CFcodigo 
					</cfquery>
						<cfset totalporNomina=0>
						<cfset totalporNomina2=0>
						<cfloop query="PorCentro">
							<cfquery dbtype="query" name="PorCentroNombre">
								select distinct CFcodigo,CFdescripcion from rsDatos where RCNid=#PorRelacion.RCNid# and CFid=#PorCentro.CFid#
							</cfquery>
								<tr>
									<td td colspan="4">Centro Funcional: <b>#PorCentroNombre.CFcodigo#</b> - <b>#PorCentroNombre.CFdescripcion#</b></td>
								</tr>
							<cfquery dbtype="query" name="empleados">
							select distinct DEid,cedula, nombre from rsDatos where RCNid=#PorRelacion.RCNid# and CFid=#PorCentro.CFid# order by nombre
							</cfquery>
							<cfset totalporCentro=0>
							<cfset totalporCentro2=0>
								<cfloop query="empleados">
									
											<tr class="RLTtopline">
												<td align="center">#LB_Identificacion#</td>
												<td align="center">#LB_Nombre#</td>
												<td align="center">#LB_DETALLES#</td>
											</tr>
											<tr class="LTtopline">
												<td  align="left" valign="top">#empleados.cedula#</td>
												<td  align="left" valign="top">#empleados.nombre#</td>
												<!--- detalle de deducciones--->
												<td  align="right" valign="top">
													<cfif radRep eq 3><!--- detalle de deducciones--->
													<table width="100%" align="center">	
														<cfquery dbtype="query" name="detalle">
														select descripcion, sum(monto) as monto from rsDatos where DEid=#empleados.DEid# and RCNid=#PorRelacion.RCNid# and CFid=#PorCentro.CFid#
														group by descripcion
														</cfquery>
															<cfif isdefined("detalle")>
																<cfquery dbtype="query" name="detalleTotal">
																select sum(monto) as monto from detalle
																</cfquery>
															</cfif>				
														<cfif detalleTotal.recordcount gt 0>
															<cfset totalporCentro=totalporCentro+ detalleTotal.monto>
															<cfset totalporNomina=totalporNomina+ detalleTotal.monto>
															<cfset totalFinal=totalFinal+ detalleTotal.monto>
														</cfif>
														<tr class="LTtopline"><td colspan="2" align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td></tr>
														<cfloop query="detalle">
														<tr class="LTtopline">
															<td align="left">#detalle.descripcion#</td>
															<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
														</tr>
														</cfloop>
														</table>
													<cfelseif radRep eq 4 or radRep eq 5><!--- detalle de Cargas o Incidencias--->
														<table width="100%" align="center">
															<cfquery dbtype="query" name="detalle">
															select descripcion, sum(monto) as monto, sum(monto2) as monto2 from rsDatos where DEid=#empleados.DEid# and RCNid=#PorRelacion.RCNid# and CFid=#PorCentro.CFid#
															group by descripcion
															</cfquery>
																<cfif isdefined("detalle")>
																	<cfquery dbtype="query" name="detalleTotal">
																	select sum(monto) as monto, sum(monto2) as monto2 from detalle
																	</cfquery>
																</cfif>			
															<cfif detalleTotal.recordcount gt 0>
																<cfset totalporCentro=totalporCentro+ detalleTotal.monto>
																<cfset totalporCentro2=totalporCentro2+ detalleTotal.monto2>
																<cfset totalporNomina=totalporNomina+ detalleTotal.monto>
																<cfset totalporNomina2=totalporNomina2+ detalleTotal.monto2>
																<cfset totalFinal=totalFinal+ detalleTotal.monto>
																<cfset totalFinal2=totalFinal2+ detalleTotal.monto2>
															</cfif>		
															<tr class="LTtopline">
																<td>&nbsp;</td>
																<cfif radRep eq 4>
																	<td align="right"><strong>#LB_MontoEmpleado#</strong></td>
																	<td align="right"><strong>#LB_MontoEmpresa#</strong></td>
																<cfelse>
																	<td align="right"><strong>#LB_ValorCantidad#</strong></td>
																	<td align="right"><strong>#LB_MontoIncidencia#</strong></td>
																</cfif>
															</tr>			
															<tr class="LTtopline">
																<td>&nbsp;</td>
																<cfif radRep eq 4><td align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td><cfelse><td>&nbsp;</td></cfif>
																<td align="right"><strong>#LSNumberFormat(detalleTotal.monto2,',.00')#</strong></td>
															</tr>
															<cfloop query="detalle">
															<tr class="LTtopline">
																<td align="left">#detalle.descripcion#</td>
																<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
																<td align="right">#LSNumberFormat(detalle.monto2,',.00')#</td>
															</tr>
															</cfloop>

														</table>
						
													</cfif>	
												</td>
											</tr>
										
								</cfloop><!--- fin del recorrido por empleado---->
								
							<cfif radRep eq 3>
								<tr class="RLTtopline ">
									<td  align="right">&nbsp;</td>
									<td  align="center"><b>TOTAL POR CENTRO FUNCIONAL : #PorCentroNombre.CFcodigo# - #PorCentroNombre.CFdescripcion#</b></td>
									<td  align="right"><strong>#LSNumberFormat(totalporCentro,',.00')#</strong></td>
								</tr>	
							<cfelseif radRep eq 4 or radRep eq 5 >	
								<tr class="RLTtopline ">
									<td  align="center" colspan="2"><b>TOTAL POR CENTRO FUNCIONAL : #PorCentroNombre.CFcodigo# - #PorCentroNombre.CFdescripcion#</b></td>
									<td  align="right">
											<table>
												<tr>
													<td align="right">&nbsp;</td>
													<cfif radRep eq 4>
													<td align="center"><strong>#LSNumberFormat(totalporCentro,',.00')#</strong></td>
													<cfelse>
													<td  align="center">&nbsp;</td>
													</cfif>
													<td  align="center"><strong>#LSNumberFormat(totalporCentro2,',.00')#</strong></td>
												</tr>
											</table>
									</td>				
								</tr>	
							</cfif>

						</cfloop><!--- fin de recorrido por centro funcional	--->	

					<cfif radRep eq 3>
						<tr class="RLTtopline ">
							<td  align="right">&nbsp;</td>
							<td  align="center"><b>TOTAL POR RELACION DE CALCULO: #trim(PorRelacionNombre.Tcodigo)# - #trim(PorRelacionNombre.nomina)#</b></td>
							<td  align="right"><strong>#LSNumberFormat(totalporNomina,',.00')#</strong></td>
						</tr>	
					<cfelseif radRep eq 4 or radRep eq 5 >	
						<tr class="RLTtopline ">
							<td  align="center" colspan="2"><b>TOTAL POR RELACION DE CALCULO: #trim(PorRelacionNombre.Tcodigo)# - #trim(PorRelacionNombre.nomina)#</b></td>
							<td  align="right">
									<table>
										<tr>
											<td align="right">&nbsp;</td>
											<cfif radRep eq 4>
											<td align="center"><strong>#LSNumberFormat(totalporNomina,',.00')#</strong></td>
											<cfelse>
											<td  align="center">&nbsp;</td>
											</cfif>
											<td  align="center"><strong>#LSNumberFormat(totalporNomina2,',.00')#</strong></td>
										</tr>
									</table>
							</td>				
						</tr>	
					</cfif>
			</cfloop><!---- fin de recorrido por relacion de calculo--->

			<cfif radRep eq 3>
				<tr class="RLTtopline ">
					<td  align="right">&nbsp;</td>
					<td  align="center"><b>TOTAL GENERAL</b></td>
					<td  align="right"><strong>#LSNumberFormat(totalFinal,',.00')#</strong></td>
				</tr>	
			<cfelseif radRep eq 4 or radRep eq 5 >	
				<tr class="RLTtopline ">
					<td  align="center" colspan="2"><b>TOTAL GENERAL</b></td>
					<td  align="right">
							<table>
								<tr>
									<td align="right">&nbsp;</td>
									<cfif radRep eq 4>
									<td align="center"><strong>#LSNumberFormat(totalFinal,',.00')#</strong></td>
									<cfelse>
									<td  align="center">&nbsp;</td>
									</cfif>
									<td  align="center"><strong>#LSNumberFormat(totalFinal2,',.00')#</strong></td>
								</tr>
							</table>
					</td>				
				</tr>	
			</cfif>

		</cfif><!--- fin de AGRUPADO POR RELACION DE CALCULO Y CENTRO FUNCIONAL--->

		<!--- AGRUPADO POR RELACION DE CALCULO--->
		<cfif isdefined("chkAgruparRC") and not isdefined("chkAgrupar") >
		<!--- fin datos sin agrupamiento--->
			<!--- variables para guardar los totales finales---->

			<cfquery dbtype="query" name="PorRelacion">
			select distinct RCNid from rsdatos order by Tcodigo
			</cfquery>
			
			<cfset totalFinal=0>
			<cfset totalFinal2=0>
			
			<cfloop query="PorRelacion">
			
				<cfset totalporNomina=0>	
				<cfset totalporNomina2=0>	
				
				<cfquery dbtype="query" name="PorRelacionNombre">
					select distinct Tcodigo,nomina,fechaHasta, fechaDesde,nomina from rsdatos where RCNid=#PorRelacion.RCNid# order by Tcodigo
				</cfquery>
				<tr>
					<td td colspan="4"><b><cf_translate  key="LB_Nomina">N&oacute;mina</cf_translate>  #trim(PorRelacionNombre.Tcodigo)# - #trim(PorRelacionNombre.nomina)#</b></td>
				</tr>
				<tr>
					<td td colspan="4">Desde #LSDateFormat(PorRelacionNombre.fechaDesde,'dd-mm-yyyy')#  Hasta #LSDateFormat(PorRelacionNombre.fechaHasta,'dd-mm-yyyy')#</td>
				</tr>
							<cfquery dbtype="query" name="empleados">
							select distinct DEid,cedula, nombre from rsdatos where RCNid=#PorRelacion.RCNid# order by nombre
							</cfquery>
							
								<cfloop query="empleados">
									
											<tr class="RLTtopline">
												<td align="center">#LB_Identificacion#</td>
												<td align="center">#LB_Nombre#</td>
												<td align="center">#LB_DETALLES#</td>
											</tr>
											<tr class="LTtopline">
												<td  align="left" valign="top">#empleados.cedula#</td>
												<td  align="left" valign="top">#empleados.nombre#</td>
												<!--- detalle de deducciones--->
												<td  align="right" valign="top">
													<cfif radRep eq 3><!--- detalle de deducciones--->
													<table width="100%" align="center">	
														<cfquery dbtype="query" name="detalle">
														select descripcion, sum(monto) as monto from rsdatos where DEid=#empleados.DEid# and RCNid=#PorRelacion.RCNid#
														group by descripcion
														</cfquery>
															<cfif isdefined("detalle")>
																<cfquery dbtype="query" name="detalleTotal">
																select sum(monto) as monto from detalle
																</cfquery>
															</cfif>				
														<cfif detalleTotal.recordcount gt 0>
															<cfset totalporNomina=totalporNomina+ detalleTotal.monto>
															<cfset totalFinal=totalFinal+ detalleTotal.monto>
														</cfif>
														<tr class="LTtopline"><td colspan="2" align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td></tr>
														<cfloop query="detalle">
														<tr class="LTtopline">
															<td align="left">#detalle.descripcion#</td>
															<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
														</tr>
														</cfloop>
														</table>
													<cfelseif radRep eq 4 or radRep eq 5><!--- detalle de Cargas o Incidencias--->
														<table width="100%" align="center">
															<cfquery dbtype="query" name="detalle">
															select descripcion, sum(monto) as monto, sum(monto2) as monto2 from rsdatos where DEid=#empleados.DEid# and RCNid=#PorRelacion.RCNid#
															group by descripcion
															</cfquery>
																<cfif isdefined("detalle")>
																	<cfquery dbtype="query" name="detalleTotal">
																	select sum(monto) as monto, sum(monto2) as monto2 from detalle
																	</cfquery>
																</cfif>			
															<cfif detalleTotal.recordcount gt 0>
																<cfset totalporNomina=totalporNomina+ detalleTotal.monto>
																<cfset totalporNomina2=totalporNomina2+ detalleTotal.monto2>
																<cfset totalFinal=totalFinal+ detalleTotal.monto>
																<cfset totalFinal2=totalFinal2+ detalleTotal.monto2>
															</cfif>		
															<tr class="LTtopline">
																<td>&nbsp;</td>
																<cfif radRep eq 4>
																	<td align="right"><strong>#LB_MontoEmpleado#</strong></td>
																	<td align="right"><strong>#LB_MontoEmpresa#</strong></td>
																<cfelse>
																	<td align="right"><strong>#LB_ValorCantidad#</strong></td>
																	<td align="right"><strong>#LB_MontoIncidencia#</strong></td>
																</cfif>
															</tr>			
															<tr class="LTtopline">
																<td>&nbsp;</td>
																<cfif radRep eq 4><td align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td><cfelse><td>&nbsp;</td></cfif>
																<td align="right"><strong>#LSNumberFormat(detalleTotal.monto2,',.00')#</strong></td>
															</tr>
															<cfloop query="detalle">
															<tr class="LTtopline">
																<td align="left">#detalle.descripcion#</td>
																<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
																<td align="right">#LSNumberFormat(detalle.monto2,',.00')#</td>
															</tr>
															</cfloop>

														</table>
						
													</cfif>	
												</td>
											</tr>
										
								</cfloop><!--- fin del recorrido por empleado---->
								
					<cfif radRep eq 3>
						<tr class="RLTtopline ">
							<td  align="right">&nbsp;</td>
							<td  align="center"><b><b>TOTAL POR RELACION DE CALCULO: #trim(PorRelacionNombre.Tcodigo)# - #trim(PorRelacionNombre.nomina)#</b></b></td>
							<td  align="right"><strong>#LSNumberFormat(totalporNomina,',.00')#</strong></td>
						</tr>	
					<cfelseif radRep eq 4 or radRep eq 5 >	
						<tr class="RLTtopline ">
							<td  align="center" colspan="2"><b><b>TOTAL POR RELACION DE CALCULO: #trim(PorRelacionNombre.Tcodigo)# - #trim(PorRelacionNombre.nomina)#</b></b></td>
							<td  align="right">
									<table>
										<tr>
											<td align="right">&nbsp;</td>
											<cfif radRep eq 4>
											<td align="center"><strong>#LSNumberFormat(totalporNomina,',.00')#</strong></td>
											<cfelse>
											<td  align="center">&nbsp;</td>
											</cfif>
											<td  align="center"><strong>#LSNumberFormat(totalporNomina2,',.00')#</strong></td>
										</tr>
									</table>
							</td>				
						</tr>	
					</cfif>
	
			</cfloop><!---- fin de recorrido por relacion de calculo--->

			<cfif radRep eq 3>
				<tr class="RLTtopline ">
					<td  align="right">&nbsp;</td>
					<td  align="center"><b>TOTAL GENERAL</b></td>
					<td  align="right"><strong>#LSNumberFormat(totalFinal,',.00')#</strong></td>
				</tr>	
			<cfelseif radRep eq 4 or radRep eq 5 >	
				<tr class="RLTtopline ">
					<td  align="center" colspan="2"><b>TOTAL GENERAL</b></td>
					<td  align="right">
							<table>
								<tr>
									<td align="right">&nbsp;</td>
									<cfif radRep eq 4>
									<td align="center"><strong>#LSNumberFormat(totalFinal,',.00')#</strong></td>
									<cfelse>
									<td  align="center">&nbsp;</td>
									</cfif>
									<td  align="center"><strong>#LSNumberFormat(totalFinal2,',.00')#</strong></td>
								</tr>
							</table>
					</td>				
				</tr>	
			</cfif>	

		</cfif><!--- fin de AGRUPADO POR RELACION DE CALCULO--->
	
		<!--- AGRUPADO POR CENTRO FUNCIONAL--->
		<cfif not isdefined("chkAgruparRC") and isdefined("chkAgrupar") >
		<!--- fin datos sin agrupamiento--->
			<!--- variables para guardar los totales finales---->

			<cfquery dbtype="query" name="PorCentro">
				select distinct CFcodigo,CFdescripcion, CFid from rsdatos order by CFcodigo
			</cfquery>
			
			<cfset totalFinal=0>
			<cfset totalFinal2=0>
			
			<cfloop query="PorCentro">
			
				<cfset totalporCentro=0>	
				<cfset totalporCentro2=0>	
	
						<tr>
							<td td colspan="4">Centro Funcional: <b>#PorCentro.CFcodigo#</b> - <b>#PorCentro.CFdescripcion#</b></td>
						</tr>
							<cfquery dbtype="query" name="empleados">
							select distinct DEid,cedula, nombre from rsdatos where CFid=#PorCentro.CFid# order by nombre
							</cfquery>
							
								<cfloop query="empleados">
									
											<tr class="RLTtopline">
												<td align="center">#LB_Identificacion#</td>
												<td align="center">#LB_Nombre#</td>
												<td align="center">#LB_DETALLES#</td>
											</tr>
											<tr class="LTtopline">
												<td  align="left" valign="top">#empleados.cedula#</td>
												<td  align="left" valign="top">#empleados.nombre#</td>
												<!--- detalle de deducciones--->
												<td  align="right" valign="top">
													<cfif radRep eq 3><!--- detalle de deducciones--->
													<table width="100%" align="center">	
														<cfquery dbtype="query" name="detalle">
														select descripcion, sum(monto) as monto from rsdatos where DEid=#empleados.DEid# and CFid=#PorCentro.CFid#
														group by descripcion
														</cfquery>
															<cfif isdefined("detalle")>
																<cfquery dbtype="query" name="detalleTotal">
																select sum(monto) as monto from detalle
																</cfquery>
															</cfif>				
														<cfif detalleTotal.recordcount gt 0>
															<cfset totalporCentro=totalporCentro+ detalleTotal.monto>
															<cfset totalFinal=totalFinal+ detalleTotal.monto>
														</cfif>
														<tr class="LTtopline"><td colspan="2" align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td></tr>
														<cfloop query="detalle">
														<tr class="LTtopline">
															<td align="left">#detalle.descripcion#</td>
															<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
														</tr>
														</cfloop>
														</table>
													<cfelseif radRep eq 4 or radRep eq 5><!--- detalle de Cargas o Incidencias--->
														<table width="100%" align="center">
															<cfquery dbtype="query" name="detalle">
															select descripcion, sum(monto) as monto, sum(monto2) as monto2 from rsdatos where DEid=#empleados.DEid# and CFid=#PorCentro.CFid#
															group by descripcion
															</cfquery>
																<cfif isdefined("detalle")>
																	<cfquery dbtype="query" name="detalleTotal">
																	select sum(monto) as monto, sum(monto2) as monto2 from detalle
																	</cfquery>
																</cfif>			
															<cfif detalleTotal.recordcount gt 0>
																<cfset totalporCentro=totalporCentro+ detalleTotal.monto>
																<cfset totalporCentro2=totalporCentro2+ detalleTotal.monto2>
																<cfset totalFinal=totalFinal+ detalleTotal.monto>
																<cfset totalFinal2=totalFinal2+ detalleTotal.monto2>
															</cfif>		
															<tr class="LTtopline">
																<td>&nbsp;</td>
																<cfif radRep eq 4>
																	<td align="right"><strong>#LB_MontoEmpleado#</strong></td>
																	<td align="right"><strong>#LB_MontoEmpresa#</strong></td>
																<cfelse>
																	<td align="right"><strong>#LB_ValorCantidad#</strong></td>
																	<td align="right"><strong>#LB_MontoIncidencia#</strong></td>
																</cfif>
															</tr>			
															<tr class="LTtopline">
																<td>&nbsp;</td>
																<cfif radRep eq 4><td align="right"><strong>#LSNumberFormat(detalleTotal.monto,',.00')#</strong></td><cfelse><td>&nbsp;</td></cfif>
																<td align="right"><strong>#LSNumberFormat(detalleTotal.monto2,',.00')#</strong></td>
															</tr>
															<cfloop query="detalle">
															<tr class="LTtopline">
																<td align="left">#detalle.descripcion#</td>
																<td align="right">#LSNumberFormat(detalle.monto,',.00')#</td>
																<td align="right">#LSNumberFormat(detalle.monto2,',.00')#</td>
															</tr>
															</cfloop>
														</table>
						
													</cfif>	
												</td>
											</tr>
										
								</cfloop><!--- fin del recorrido por empleado---->
								
					<cfif radRep eq 3>
						<tr class="RLTtopline ">
							<td  align="right">&nbsp;</td>
							<td  align="center"><b>TOTAL POR CENTRO FUNCIONAL : #PorCentro.CFcodigo# - #PorCentro.CFdescripcion#</b></td>
							<td  align="right"><strong>#LSNumberFormat(totalporCentro,',.00')#</strong></td>
						</tr>	
					<cfelseif radRep eq 4 or radRep eq 5 >	
						<tr class="RLTtopline ">
							<td  align="center" colspan="2"><b>TOTAL POR CENTRO FUNCIONAL : #PorCentro.CFcodigo# - #PorCentro.CFdescripcion#</b></td>
							<td  align="right">
									<table>
										<tr>
											<td align="right">&nbsp;</td>
											<cfif radRep eq 4>
											<td align="center"><strong>#LSNumberFormat(totalporCentro,',.00')#</strong></td>
											<cfelse>
											<td  align="center">&nbsp;</td>
											</cfif>
											<td  align="center"><strong>#LSNumberFormat(totalporCentro2,',.00')#</strong></td>
										</tr>
									</table>
							</td>				
						</tr>	
					</cfif>
	
			</cfloop><!---- fin de recorrido por centro funcional--->

			<cfif radRep eq 3>
				<tr class="RLTtopline ">
					<td  align="right">&nbsp;</td>
					<td  align="center"><b>TOTAL GENERAL</b></td>
					<td  align="right"><strong>#LSNumberFormat(totalFinal,',.00')#</strong></td>
				</tr>	
			<cfelseif radRep eq 4 or radRep eq 5 >	
				<tr class="RLTtopline ">
					<td  align="center" colspan="2"><b>TOTAL GENERAL</b></td>
					<td  align="right">
							<table>
								<tr>
									<td align="right">&nbsp;</td>
									<cfif radRep eq 4>
									<td align="center"><strong>#LSNumberFormat(totalFinal,',.00')#</strong></td>
									<cfelse>
									<td  align="center">&nbsp;</td>
									</cfif>
									<td  align="center"><strong>#LSNumberFormat(totalFinal2,',.00')#</strong></td>
								</tr>
							</table>
					</td>				
				</tr>	
			</cfif>	

		</cfif><!--- fin de AGRUPADO POR CENTRO FUNCIONAL--->

		</table>
		</cfoutput>
	</cfif>	<!--- fin de tiene datos--->

<cfif isdefined("rsdatos") and rsdatos.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
</cfif>

		