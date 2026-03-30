<cfquery name="rsDatos" datasource="#session.DSN#">
	select * from ccrhPagoRecibos
	where Did  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>

<cfset modo = 'ALTA'>

<cfif isdefined("url.Modo") or rsDatos.RecordCount NEQ 0>
	<cfset modo = 'CAMBIO'>
	<!---Sumatoria de los documentos del detalle--->
	<cfquery name="rsTotal" datasource="#session.DSN#">
		select sum(montoAplicado) as total
		from ccrhPagoRecibos a
		where Did  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
</cfif>

	<cfoutput>
	
	<cfif isdefined("url.vs_mensaje") and len(trim(url.vs_mensaje))>
		<tr>
			<td>
				<table>
					<tr>
						<td style="color:##FF0000" valign="baseline"><strong>#url.vs_mensaje#</strong></td>
					</tr>
				</table>
			</td>
		</tr>						
	</cfif>
	
	<!----<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Registro de Pagos de Caja">---->
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Registro de Pagos de Caja">

		<cfif isdefined("form.Did") and len(trim(form.Did))>
			<cfquery name="rsPendientes" datasource="#session.DSN#">
				select 1 
				from DeduccionesEmpleadoPlan 
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				and PPpagado=0
			</cfquery>
		</cfif>
		
		<cfif not isdefined("form.btnRecalcular")>
			<cfquery name="dataPlan" datasource="#session.DSN#">
				select 	a.TDid,
						d.TDcodigo,
						d.TDdescripcion,
						a.Dreferencia, 
						a.Ddescripcion, 
						a.SNcodigo,
						e.SNnumero,
						e.SNnombre,
						a.Dmonto, 
						a.Dtasa, 
						a.Dfechaini, 
						a.Dobservacion,
						( select distinct PPtasamora 
						  from DeduccionesEmpleadoPlan b 
						  where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and b.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
							and b.PPpagado = 0 
							and a.Did = b.Did 
							and a.Ecodigo=b.Ecodigo ) as Dtasamora,
						( select coalesce(count(1),0)
						  from DeduccionesEmpleadoPlan c
						  where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							and c.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
							and c.PPpagado = 0 
							and a.Did = c.Did
							and a.Ecodigo = c.Ecodigo ) as Dnumcuotas
				from DeduccionesEmpleado a
				
				inner join TDeduccion d
				on a.TDid=d.TDid
				   and a.Ecodigo=d.Ecodigo 
			
				left outer join SNegocios e
				on a.SNcodigo=e.SNcodigo
				   and a.Ecodigo=e.SNcodigo
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				  and a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
			</cfquery>
	
			<cfquery name="dataSaldo" datasource="#session.DSN#">
				select PPfecha_vence, coalesce(PPsaldoant, 0) as PPsaldoactual
				from DeduccionesEmpleadoPlan 
				where Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#"> 
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
				  and PPpagado=0
				  and PPnumero = ( select min(PPnumero) 
				  					from DeduccionesEmpleadoPlan 
									where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
										and Did=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#"> 
										and PPpagado=0)
				order by PPfecha_vence
			</cfquery>
			
			<cfquery name="rsTipoNomina" datasource="#session.DSN#">
				select Tcodigo 
				from LineaTiempo 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta 
			</cfquery>
			<!--- Si el empleado está cesado, buscar la ultima nomina en la cual estaba --->
			<cfif rsTipoNomina.recordCount EQ 0>
				<cfquery name="rsTipoNomina" datasource="#session.DSN#">
					select a.Tcodigo 
					from LineaTiempo a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and a.LThasta = (select max(x.LThasta)
										from LineaTiempo x
										where x.DEid = a.DEid
											and x.Ecodigo = a.Ecodigo
										)
				</cfquery>
			</cfif>
	
			<cfquery name="rsPeriodicidad" datasource="#session.DSN#">
				select Ttipopago 
				from TiposNomina 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoNomina.Tcodigo)#">
			</cfquery>
			
			<cfquery name="dataMoneda" datasource="#session.DSN#">
				select Mcodigo 
				from Empresas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))><!---Si se cambio la moneda default del conlis--->
				<cfset vn_Mcodigo = form.Mcodigo>
			 <cfelse>
				<cfset vn_Mcodigo = dataMoneda.Mcodigo>	
			 </cfif>
	
			<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script> 
			<form name="form1"  method="post" style="margin:0; " action="registroPagosCaja-sql.cfm"><!--- onSubmit="javascript: return validar(this);" --->
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr><td><table width="99%" align="center" border="0" cellpadding="2" cellspacing="0"><tr><td align="center" style=" border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:##CCCCCC;" valign="baseline"><strong><font size="2">Informaci&oacute;n de Deducci&oacute;n</font></strong></td></tr></table></td></tr>					
					<tr><td>
						<table width="99%" align="center" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
							<tr>
								<td width="1%" nowrap align="right"><strong>Tipo de Deducci&oacute;n:&nbsp;</strong></td>
								<td>#dataPlan.TDcodigo# - #dataPlan.TDdescripcion#</td>
								<td align="right" width="1%" nowrap><strong>Referencia:&nbsp;</strong></td>
								<td>#dataPlan.Dreferencia#</td>
							</tr>		
							<tr>
								<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
								<td>#dataPlan.Ddescripcion#</td>
								<td align="right"><strong>Socio:&nbsp;</strong></td>
								<td>#dataPlan.SNnumero# - #dataPlan.SNnombre#</td>
							</tr>		
							<tr>
								<td align="right"><strong>Monto:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataPlan.Dmonto,',9.00')#</td>
								<td align="right"><strong>Saldo actual:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataSaldo.PPsaldoactual,',9.00')#<input type="hidden" name="Dmonto" value="#dataSaldo.PPsaldoactual#"></td>
							</tr>							
							<tr>
								<td nowrap align="right"><strong>Fecha Inicial:&nbsp;</strong></td>
								<td>#LSdateFormat(dataSaldo.PPfecha_vence,'dd/mm/yyyy')#<input type="hidden" name="PPfecha_vence" value="#LSdateFormat(dataSaldo.PPfecha_vence,'dd/mm/yyyy')#"></td>
								<td nowrap align="right"><strong>Cuotas restantes:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataPlan.Dnumcuotas,',9.00')#<input type="hidden" name="Dnumcuotas" value="#dataPlan.Dnumcuotas#"></td>
							</tr>							
							<tr>
								<td align="right"><strong>Inter&eacute;s:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataPlan.Dtasa,',9.00')#%<input type="hidden" name="Dtasa" value="#dataPlan.Dtasa#"></td>
								<td align="right" nowrap><strong>Inter&eacute;s Moratorio:&nbsp;</strong></td>
								<td>#LSNumberFormat(dataPlan.Dtasamora,',9.00')#%<input type="hidden" name="Dtasamora" value="#dataPlan.Dtasamora#"></td>
							</tr>						
						</table>
					</td>
					</tr>					
					<tr><td><table width="99%" align="center" border="0" cellpadding="2" cellspacing="0"><tr><td align="center" style=" border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:##CCCCCC;" valign="baseline"><strong><font size="2">Registro de Pago de Caja</font></strong></td></tr></table></td></tr>					
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<table width="55%" align="center">
								<tr>
									<td align="right" width="46%"><strong>Tipo de pago:</strong>&nbsp;</td>
									<td width="54%">
										<select name="tipopago" onchange="javascript: funcCambioTipoPago(this.value);">
											<option value="PE">Pago Extraordinario</option>
											<option value="PC">Pago Cuota</option>
										</select>
								  </td>
								</tr>
						  </table>
					  </td>									
					</tr>	
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<table width="99%" align="center" border="0">														
								<tr>
									<!----=============== Datos Pago Extraordinario ===============----->
									<td id="TDpagoextra">
										<table width="99%">
											<tr>
												<td align="right"><strong>Documento:</strong>&nbsp;</td>
												<td>
													<input type="text" name="EPEdocumento" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsDatos.documento#</cfoutput></cfif>" 
													size="30" maxlength="20"  <cfif modo NEQ 'ALTA'>readonly=""</cfif>>
												</td>
												<td align="right"><strong>Fecha Documento:</strong>&nbsp;</td>
												<td>
													<cfset Hoy = LSDateFormat(Now(), 'dd/mm/yyyy')>
													<cf_sifcalendario form="form1" name="EPEfechadoc" value="#Hoy#">
												</td>
											</tr>
											<tr>
												<td align="right" nowrap><strong>Moneda:</strong>&nbsp;</td>
												<td>													
													 <cf_sifmonedas onChange="asignaTC(); funcRecarga();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1"
													 value="#vn_Mcodigo#">
												</td>
												<td align="right" nowrap><strong>Tipo de Cambio:</strong>&nbsp;</td>
												<td>
													<input tabindex="1" type="text" name="DPEtc" style="text-align:right"size="18" maxlength="10" 
																onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
																onFocus="javascript:this.select();" 
																onChange="javascript: fm(this,4);"
																value="0.00"> 
												</td>
											</tr>
											<tr>
												<!---<td nowrap align="right"><strong>Monto Efectivo:&nbsp;</strong></td>
												<td valign="top">
													<input name="Dmontopago" tabindex="1" type="text" value="0.00" size="15" maxlength="15" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
												</td>--->
												<td nowrap align="right"><strong>Monto Documentos:&nbsp;</strong></td>
												<td valign="top" >
													<input name="Dmontodoc"  class="Cajasinborde" tabindex="1" type="text" value="<cfif modo NEQ 'ALTA'><cfoutput>#LSNumberFormat(rsTotal.total,',9.00')#</cfoutput><cfelse>0.00</cfif>" 
													size="15" maxlength="15" style="text-align: right;" onblur="javascript: fm(this,2);"  
													onfocus="javascript:this.value=qf(this); this.select();"  
													onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" readonly="">
												</td>
												<td colspan="2" align="center">
													<table><tr>
														<td nowrap align="right">&nbsp;</td>
														<td valign="top">&nbsp;</td>
														<td align="right"><a href="javascript:verPlan();" ><b>Ver Plan de Pagos</b></a></td>
														<td><a href="javascript:verPlan();" ><img src="../../imagenes/findsmall.gif" border="0" alt="Ver Plan de Pagos"></a></td>
													</tr></table>
												</td>
											</tr>
											<!----Encabezado ---->
											<tr>
												<td colspan="4">
													<table align="center" width="100%">
														<tr>
															<td>
																<table width="100%" cellpadding="0" cellspacing="0">
																	<tr><td><table width="99%" align="center" border="0" cellpadding="2" cellspacing="0"><tr><td align="center" style=" border-bottom-style:solid; border-bottom-width:1px; border-bottom-color:##CCCCCC;" valign="baseline"><strong><font size="2">Documentos de Pago</font></strong></td></tr></table></td></tr>
																	<tr><td>
																		<table width="80%" align="center" cellpadding="2" cellspacing="0" >
																			<tr>
																				<td align="right" nowrap="nowrap"><strong>Documento(Recibo):&nbsp;</strong></td>
																				<td>
																					<cf_dbfunction name="concat" args="b.TDcodigo,'-',b.TDdescripcion" returnvariable = "TDeduccion">														
																					<cf_conlis title="Lista de Documentos de Caja (Recibos)"
																						campos = "Id_referencia,DPEreferencia,Cformato,MontoDisponible" 
																						desplegables = "N,S,N,N" 
																						modificables = "N,N,N,N" 
																						size = "0,20,0,0"
																						asignar="Id_referencia,DPEreferencia,Cformato,MontoDisponible"
																						asignarformatos="I,S,S,M"
																						tabla="	PagoPorCaja a
																								inner join TDeduccion b
																									on a.TDid = b.TDid
																								inner join Monedas c
																									on a.Mcodigo = c.Mcodigo
																								inner join CContables d
																									on a.Ccuenta = d.Ccuenta"																	
																						columnas="	a.Id as Id_referencia,
																									a.NoDocumento as DPEreferencia,
																									a.fechaalta,
																									a.MontoTotalPagado,
																									coalesce(a.MontoTotalPagado - coalesce(a.MontoUtilizado,0),0) as MontoDisponible,
																									c.Miso4217,
																									d.Cformato,																									
																									#TDeduccion# as TDeduccion"
																						filtro="a.Ecodigo =#session.Ecodigo#
																								and a.Mcodigo = #vn_Mcodigo#
																								and a.DEid = #form.DEid#
																								and (a.MontoTotalPagado - MontoUtilizado) > 0
																								order by (a.MontoTotalPagado - MontoUtilizado) asc"
																						desplegar="	DPEreferencia,
																									fechaalta,
																									MontoTotalPagado,
																									MontoDisponible,
																									Miso4217,
																									TDeduccion"
																						etiquetas="	No.Documento, 
																									Fecha, 
																									Monto, 
																									Monto Disponible,
																									Moneda, 
																									Tipo Deducci&oacute;n"
																						formatos="S,D,M,M,S,S"
																						align="left,left,right,right,left,left"
																						showEmptyListMsg="true"
																						debug="false"
																						form="form1"
																						width="800"
																						height="500"
																						left="70"
																						top="20"
																						filtrar_por="NoDocumento/
																									fechaalta/
																									MontoTotalPagado/
																									coalesce(a.MontoTotalPagado - coalesce(a.MontoUtilizado,0),0)/
																									Miso4217/																									
																									#TDeduccion#"
																						filtrar_por_delimiters="/"
																						funcion="funcCargaMto">
																				</td>
																				<td align="right" nowrap="nowrap"><strong>Monto aplicar:&nbsp;</strong></td>
																				<td>
																					<input name="DPEmonto" tabindex="1" type="text" value="0.00" size="15" maxlength="15" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
																				</td>
																				<td style="padding-left:10px; ">
																					<input type="submit" name="btnAgregar" value="Agregar" onclick="javascript: return validar(this);">
																				</td>
																			</tr>										
																			<tr><td>&nbsp;</td></tr>																			
																		</table>
																	</td></tr>
																</table> 
															</td>
														</tr>
													</table>
												</td>
											</tr>
											<!---Fin del encabezado---->										
											<!---Detalle del pago---->
											<cfif rsDatos.RecordCount NEQ 0>
												<tr>
													<td colspan="4" align="center">
														<cfinclude template="registoPagoCaja-detalle.cfm">
													</td>
												</tr>
											</cfif>
										</table>
									</td>
									<!----Fin de pago extraordinario ---->									
								</tr>	
								<tr>
									<!---=============== Pago de cuota ===============---->
								  <td id="TDpagocuota" style="display:none;" colspan="4" align="center">
										<table align="center" width="80%">											
											<tr>
												<td align="right" nowrap="nowrap"><strong>Cuota a pagar:&nbsp;</strong></td>
												<td>
													<cf_conlis title="Lista de Cuotas Pendientes"
														campos = "Did_cuota, PPnumero, fecha" 
														desplegables = "N,S,N" 
														modificables = "N,S,N" 
														size = "0,7,12"
														tabla="	DeduccionesEmpleadoPlan pp"																	
														columnas="	pp.Did as Did_cuota,
																	pp.PPnumero,														 																																																						
																	coalesce(pp.PPfecha_pago,pp.PPfecha_vence) as fecha,
																	pp.PPsaldoant as saldoant,
																	case when pp.PPfecha_pago is null then pp.PPprincipal  else pp.PPpagoprincipal end as principal,
																	case when pp.PPfecha_pago is null then pp.PPinteres    else pp.PPpagointeres+pp.PPpagomora end as intereses,
																	case when pp.PPfecha_pago is null then pp.PPprincipal+pp.PPinteres  else pp.PPpagointeres+pp.PPpagomora+pp.PPpagoprincipal end as total,
																	case when pp.PPfecha_pago is null then pp.PPsaldoant-pp.PPprincipal else pp.PPsaldoant-pp.PPpagoprincipal end as saldofinal"														
														filtro = "pp.Ecodigo = #session.Ecodigo#
																 and pp.Did = #form.Did#																 
																 and pp.PPfecha_pago is null"														
														desplegar="	PPnumero,
																	fecha,
																	principal,
																	intereses,
																	total,
																	saldofinal"
														etiquetas="	Num., 
																	Fecha, 
																	Principal, 
																	Intereses, 
																	Cuota,
																	Saldo"
														formatos="I,D,M,M,M,M"
														align="left,left,right,right,right,left"
														asignar="Did_cuota, PPnumero, fecha"
														asignarformatos="N,S,D"
														showEmptyListMsg="true"
														debug="false"
														form="form1"
														width="800"
														height="500"
														left="70"
														top="20"
														filtrar_por="PPnumero|
																	coalesce(pp.PPfecha_pago,pp.PPfecha_vence)|
																	case when pp.PPfecha_pago is null then pp.PPprincipal  else pp.PPpagoprincipal end|
																	case when pp.PPfecha_pago is null then pp.PPinteres    else pp.PPpagointeres+pp.PPpagomora end|
																	case when pp.PPfecha_pago is null then pp.PPprincipal+pp.PPinteres  else pp.PPpagointeres+pp.PPpagomora+pp.PPpagoprincipal end|
																	case when pp.PPfecha_pago is null then pp.PPsaldoant-pp.PPprincipal else pp.PPsaldoant-pp.PPpagoprincipal end"
														filtrar_por_delimiters="|">
												</td>
												<td align="right" nowrap="nowrap"><strong>Documento(Recibo):&nbsp;</strong></td>
												<td>
												 	<cf_dbfunction name="concat" args="b.TDcodigo,'-',b.TDdescripcion" returnvariable = "TDeduccion">														
													<cf_conlis title="Lista de Documentos de Caja (Recibos)"
														campos = "Id, NoDocumento" 
														desplegables = "N,S" 
														modificables = "N,N" 
														size = "0,20"
														tabla="	PagoPorCaja a
																inner join TDeduccion b
																	on a.TDid = b.TDid
																inner join Monedas c
																	on a.Mcodigo = c.Mcodigo"																	
														columnas="	a.Id,
																	a.NoDocumento,
																	a.fechaalta,
																	a.MontoTotalPagado,
																	coalesce(a.MontoTotalPagado - coalesce(a.MontoUtilizado,0),0) as Disponible,
																	c.Miso4217,
																	#TDeduccion# as TDeduccion"
														filtro="a.Ecodigo =#session.Ecodigo#
																and a.Mcodigo = #vn_Mcodigo#
																and a.DEid = #form.DEid#
																and (a.MontoTotalPagado - MontoUtilizado) > 0
																order by (a.MontoTotalPagado - MontoUtilizado) asc"
														desplegar="	NoDocumento,
																	fechaalta,
																	MontoTotalPagado,
																	Disponible,
																	Miso4217,
																	TDeduccion"
														etiquetas="	No.Documento, 
																	Fecha, 
																	Monto, 
																	Disponible,
																	Moneda, 
																	Tipo Deducci&oacute;n"
														formatos="S,D,M,M,S,S"
														align="left,left,right,right,left,left"
														asignar="Id,NoDocumento"
														asignarformatos="I,S"
														showEmptyListMsg="true"
														debug="false"
														form="form1"
														width="800"
														height="500"
														left="70"
														top="20"
														filtrar_por="NoDocumento/
																	fechaalta/
																	MontoTotalPagado/
																	coalesce(a.MontoTotalPagado - coalesce(a.MontoUtilizado,0),0)/
																	Miso4217/
																	#TDeduccion#"
														filtrar_por_delimiters="/">
												</td>
												<td>
													<table align="center">
														<tr>
															<td align="right"><a href="javascript:verPlan();" ><b>Ver Plan de Pagos</b></a></td>
															<td><a href="javascript:verPlan();" ><img src="../../imagenes/findsmall.gif" border="0" alt="Ver Plan de Pagos"></a></td>
														</tr>
													</table>
												</td>
											</tr>											
										</table>
									</td>
									<!---Fin de pago de cuota---->
								</tr>															
							</table>
						</td>
					</tr>										
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center">
						<input type="submit" value="<< Regresar" name="btnRegresar2" onclick="javascript: funcRegresar();">
						<input type="submit" value="Aceptar" name="btnRecalcular" onClick="javascript: return aceptar_plan()">
					</td></tr>
					<tr><td align="center">&nbsp;</td></tr>
				</table>
	
				<!--- empleado y deduccion actuales --->
				<input type="hidden" name="EPEdocumento" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsDatos.documento#</cfoutput></cfif>">
				<!---<input type="hidden" name="EPEdocumento" value="#form.EPEdocumento#">--->
				<input type="hidden" name="DEid" value="#form.DEid#">
				<input type="hidden" name="Did" value="#form.Did#">
				<input type="hidden" name="TDid" value="#form.TDid#">
				<input type="hidden" name="Dperiodicidad" value="#rsPeriodicidad.Ttipopago#">
				<input type="hidden" name="Dtraercuentas" value="0"> <!--- 0 No usa cuentas, 1 Usa cuentas --->
				<input type="hidden" name="SNcodigo" value="#dataPlan.SNcodigo#">
				
				
			</form>
			
			<script type="text/javascript" language="javascript1.2">
				//Sugiere el monto disponible del documento seleccionado en en campo del monto aplicar
				function funcCargaMto(){
					document.form1.DPEmonto.value = document.form1.MontoDisponible.value;
				}
				
				function funcRegresar(){
					var params = '';
					params = params + '?DEid=#form.DEid#'; //&TDid=#form.TDid#
					//Si se va a salir de la pantalla y hay registros en la temporal (sin aplicar) se deben eliminar
					<cfif rsDatos.RecordCount NEQ 0>
						if (confirm('¿Desea regresar a la lista y perder la información?')){
							params = params + '&eliminarTMP=1';
							document.form1.action='listaRegistroPagosCaja.cfm'+params; 
							document.form1.submit();
						}
					<cfelse>
						document.form1.action='listaRegistroPagosCaja.cfm'+params; 
						document.form1.submit();
					</cfif>					
				}
				//Aceptar plan
				function aceptar_plan(){
					var error = false;
					var mensaje = '';
					if (document.form1.tipopago.value == 'PC'){//SI ES UN PAGO CUOTA
						if (document.form1.Did_cuota.value == '' ){
							error   = true;
							mensaje = mensaje + ' - Debe seleccionar la cuota a cancelar.\n';
						}
						if (document.form1.Id.value == '' ){
							error   = true;
							mensaje = mensaje + ' - Debe seleccionar el recibo con el cual cancelar la cuota.\n';
						}
					}
					else{//SI ES UN PAGO EXTRAORDINARIO
						if ( trim(document.form1.EPEdocumento.value) == '' ){
							error   = true;
							mensaje = mensaje + ' - El campo Documento es requerido.\n';
						}
	
						if ( trim(document.form1.EPEfechadoc.value) == '' ){
							error   = true;
							mensaje = mensaje + ' - El campo Fecha Documento es requerido.\n';
						}
	
						if ( trim(document.form1.Mcodigo.value) == '' ){
							error = true;
							mensaje = mensaje + ' - El campo Moneda es requerido.';
						}
	
						if ( trim(document.form1.DPEtc.value) == '' ){
							error = true;
							mensaje = mensaje + ' - El campo Tipo de Cambio es requerido.';
						}
						
						if (#rsDatos.RecordCount# == 0){
							error = true;
							mensaje = mensaje + ' - Debe haber al menos un documento(recibo) seleccionado.';
						}
					}
					if ( error ){
						alert(mensaje);
						return false;
					}
					else{
						if ( confirm('¿Esta seguro(a) que desea registrar el pago?') ) {													
							document.form1.DPEtc.disabled = false;
							document.form1.action = 'registroPagosCaja-sql.cfm';
							document.form1.submit();
							return true;
						}
					}
					
				}
				
				function validar(f){
				//function funcAgrega(f){
					var error   = false;
					var suma = 0;
					var mensaje = 'Se presentaron los siguientes errores:\n';
					var f = document.form1;
					
					if (f.tipopago.value == 'PE'){//SI ES UN PAGO EXTRAORDINARIO
						if ( trim(f.EPEdocumento.value) == '' ){
							error   = true;
							mensaje = mensaje + ' - El campo Documento es requerido.\n';
						}
	
						if ( trim(f.EPEfechadoc.value) == '' ){
							error   = true;
							mensaje = mensaje + ' - El campo Fecha Documento es requerido.\n';
						}
	
						if ( trim(f.Mcodigo.value) == '' ){
							error = true;
							mensaje = mensaje + ' - El campo Moneda es requerido.\n';
						}
	
						if ( trim(f.DPEtc.value) == '' ){
							error = true;
							mensaje = mensaje + ' - El campo Tipo de Cambio es requerido.\n';
						}
	
						/*if ( trim(f.Dmontopago.value) == '' ){
							error = true;
							mensaje = mensaje + ' - El campo Monto Efectivo es requerido.';
						}*/
	
						if ( trim(f.Dmontodoc.value) == '' ){
							error = true;
							mensaje = mensaje + ' - El campo Monto Documentos es requerido.\n';
						}
						
						if ( trim(f.DPEmonto.value) == '' ){
							error = true;
							mensaje = mensaje + ' - El campo Monto Aplicar es requerido.\n';
						}
						
						if ( trim(f.Id_referencia.value) == '' ){
							error = true;
							mensaje = mensaje + ' - El campo Documento(recibo) es requerido.\n';
						}
	
						if (parseInt(qf(f.DPEmonto.value)) == 0){
							error = true;
							mensaje = mensaje + ' - El campo Monto Aplicar no puede ser cero.\n';
						}
						else{							
							//El monto aplicar es menor o igual al monto disponible del recibo - documento de caja
							if ( parseInt(qf(f.MontoDisponible.value)) < parseInt(qf(f.DPEmonto.value)))							
							{
								error   = true;
								mensaje = mensaje + ' - El Monto a Aplicar es mayor al disponible del documento(recibo) seleccionado.\n';
							}
							//El monto a aplicar es mayor que el saldo de la deduccion
							if (f.Dmonto.value == '' || (parseInt(qf(f.DPEmonto.value))) > (parseInt(qf(f.Dmonto.value))) ){ //#dataSaldo.PPsaldoactual#
								error   = true;
								mensaje = mensaje + ' - El monto a aplicar puede ser menor o igual al Saldo actual.\n';							
							}
							//El monto en dctos tiene que ser menor al saldo de la deduccion
							if ( (parseInt(qf(f.Dmontodoc.value))) > (parseInt(qf(f.Dmonto.value))) )//#dataSaldo.PPsaldoactual#
							{
								error   = true;
								mensaje = mensaje + ' - El monto en documentos debe ser menor o igual al Saldo actual de la Deducción.\n';
							}
						}
						/*if ( (parseInt(qf(f.Dmontopago.value)) + parseInt(qf(f.Dmontodoc.value))) == 0 ){
							error = true;
							mensaje = mensaje + ' - El monto efectivo y el monto en documentos son iguales a cero, al menos uno de ellos debe ser diferente a cero.';
						}
						else
						{
							if ( (parseInt(qf(f.Dmontopago.value)) + parseInt(qf(f.Dmontodoc.value))) > #dataSaldo.PPsaldoactual#)
							{
								error   = true;
								mensaje = mensaje + ' - La suma del Monto Efectivo y del Monto Documentos debe ser menor o igual al Saldo actual.\n';
							}
						}
	
						if ( index == 0 && parseFloat(qf(f.Dmontodoc.value)) > 0 ){
							error   = true;
							mensaje = mensaje + ' - Al menos un Documento de Pago es requerido.\n';
						}*/
					
					}
					else{//PAGO DE CUOTA
						//alert(f.)
						if (f.Did_cuota.value == '' ){
							error   = true;
							mensaje = mensaje + ' - Debe seleccionar la cuota a cancelar.\n';
						}
						if (f.Id.value == '' ){
							error   = true;
							mensaje = mensaje + ' - Debe seleccionar el recibo con el cual cancelar la cuota.\n';
						}
					}
					
					if ( error ){
						alert(mensaje);
						return false;
					}
					//else{
						//f.Dcantidad.value = index; 
						f.DPEtc.disabled = false;
						return true;
						//document.form1.submit();
					//}
				}
				
				// TAG DE MONEDAS - INI
				function asignaTC() {						
					if (document.form1.Mcodigo.value == "<cfoutput>#dataMoneda.Mcodigo#</cfoutput>") {		
						formatCurrency(document.form1.TC,2);
						document.form1.DPEtc.disabled = true;			
					}
					else{
						document.form1.DPEtc.disabled = false;
					}	
					var estado = document.form1.DPEtc.disabled;
					document.form1.DPEtc.disabled = false;
					document.form1.DPEtc.value = fm(document.form1.TC.value,2);
					document.form1.DPEtc.disabled = estado;	
				}
				asignaTC();
				
				function funcRecarga(){
					document.form1.action = '';
					document.form1.submit();
				}
				// TAG MONEDAS - FIN
				
				function verPlan(){
					//window.open('cfmx/sif/ccrh/operacion/verPlanPagos.cfm?Did=#form.Did#', 'PlanPagos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=650,height=400,left=250, top=100,screenX=250,screenY=100');
					window.open('verPlanPagos.cfm?Did=#form.Did#', 'PlanPagos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=650,height=400,left=250, top=100,screenX=250,screenY=100');
				}
				
				function funcCambioTipoPago(prs_tipopago){
					if (prs_tipopago == 'PE'){//PAGO EXTRAORDINARIO
						document.getElementById("TDpagoextra").style.display = '';
						document.getElementById("TDpagocuota").style.display = 'none';
						document.form1.Did_cuota.value ='';
						document.form1.PPnumero.value ='';
						document.form1.fecha.value ='';
						document.form1.Id.value ='';
						document.form1.NoDocumento.value ='';
					} 
					else{//PAGO DE CUOTA
						document.getElementById("TDpagoextra").style.display = 'none';
						document.getElementById("TDpagocuota").style.display = '';
						document.form1.Id_referencia.value ='';
						document.form1.DPEreferencia.value ='';
						document.form1.Cformato.value ='';
						document.form1.MontoDisponible.value ='';
					}
				}	
			</script> 			
		</cfif>
	<cf_web_portlet_end>
	<!----</cf_web_portlet>---->
	</cfoutput>