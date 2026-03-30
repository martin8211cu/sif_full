<cfif NOT (IsDefined("url.prod") AND IsDefined("url.prod") )>
  <cflocation url="index.cfm">
</cfif>

	<cfinclude template="carrito_create.cfm">

<cfquery datasource="#session.dsn#" name="data" maxrows="1">
	select p.Aid, p.Adescripcion,
		p.Acodigo as sku,
		p.Acodalterno as part_no,
		lp.DLprecio as precio, m.Miso4217 as moneda,
		afm.AFMdescripcion, afmm.AFMMdescripcion
	from Articulos p
		join DListaPrecios lp
			on lp.Aid = p.Aid
			and lp.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.lista_precios#">
			and lp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		left join Monedas m
			on m.Ecodigo = lp.Ecodigo
			and m.Miso4217 = lp.moneda
		left join AFMarcas afm
			on afm.AFMid = p.AFMid
		left join AFMModelos afmm
			on afmm.AFMid = p.AFMid
			and afmm.AFMMid = p.AFMMid
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and p.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
</cfquery>

<cfquery datasource="#session.dsn#" name="datos_var">
	select CDdescripcion, Valor
	from ArticulosValor ar , ClasificacionesDato cd
	where cd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and ar.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
	  and ar.CDcodigo = cd.CDcodigo
	order by Upper(CDdescripcion)
</cfquery>

<cfquery datasource="#session.dsn#" name="hayfoto">
	select count(1) as hay
	from ImagenArt ia
	where ia.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
	  and datalength(ia.IAimagen) != 0
</cfquery>

<cfset cantidad = 1>
<cfset observaciones = ''>
<cfset isnew = true>

<cfif IsDefined("session.listaFactura")>
	<cfquery datasource="#session.dsn#" name="cant">
		select cantidad, observaciones
		from VentaD
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
		  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
	</cfquery>

	<cfif Len(cant.cantidad)>
		<cfset cantidad = cant.cantidad>
		<cfset observaciones = cant.observaciones>
		<cfset isnew = false>
	</cfif>
</cfif>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title"><cfoutput>#data.Adescripcion#</cfoutput></cf_templatearea>
<cf_templatearea name="body">

	<script type="text/javascript" language="javascript1.2" src="../../../js/utilesMonto.js"></script>
	<cfinclude template="estilo.cfm">
	<cfinclude template="catpath.cfm">
	
	<cfoutput query="data">
		<form action="producto_go.cfm" method="post" name="form1" id="form1">
			<table width="750" border="0" cellspacing="0" cellpadding="4" align="l" class="catview_table">
				<tr>
					<td valign="top" class="catview_thinv">#Adescripcion#</td>
				</tr>
			
				<tr>
					<td valign="top" class="catview_th">
						<table border="0" cellspacing="0" cellpadding="2"  align="l">
							<tr>
								<td width="134" rowspan="3" valign="top">
									<cfif hayfoto.hay><a href="##" onClick="largerImage()">
										<a href="javascript:void(0)" onClick="largerImage()"><img src="producto_img.cfm?tid=#session.Ecodigo#&id=#URLEncodedFormat(data.Aid)#&dft=na&sz=nr" height="240" border="0"></a>
									</cfif>
								</td>
								
								<td width="77" valign="top"></td><td width="100%" valign="top"></td>
<!--- 								<td width="77" valign="top"></td><td width="240" valign="top"></td> --->
							</tr>

							<tr valign="top">
								<td colspan="2" align="center" valign="top">
									<table width="100%"  border="0" cellspacing="3" cellpadding="3">
										<cfif len(Trim(sku))>
											<tr valign="top">
												<td valign="top">C&oacute;digo (SKU)</td>
												<td valign="top">#sku#</td>
											</tr>
										</cfif>
										
										<cfif len(AFMdescripcion)>
											<tr valign="top">
												<td valign="top">Marca</td>
												<td valign="top">#AFMdescripcion#<cfif not len(AFMdescripcion)>n/d</cfif></td>
											</tr>
										</cfif>
			
										<cfif Len(AFMMdescripcion)>
											<tr valign="top">
												<td valign="top">Modelo</td>
												<td valign="top">#AFMMdescripcion#<cfif not len(AFMMdescripcion)>n/d</cfif></td>
											</tr>
										</cfif>

										<cfif Len(Trim(part_no))>
											<tr valign="top">
												<td valign="top">N&uacute;mero de Parte </td>
												<td valign="top">#part_no#<cfif not len(part_no)>n/d</cfif></td>
											</tr>
										</cfif>
			
										<tr valign="top">
											<td valign="top">Precio</td>
											<td valign="top">#moneda# #LSCurrencyFormat(precio,'none')# ivi</td>
										</tr>

										<tr valign="top">
											<td valign="top">Cantidad</td>
											<td valign="top"><input name="cantidad" type="text" class="flat" value="#cantidad#" size="10" maxlength="4" onFocus="select()" ></td>
										</tr>

										<tr valign="top">
											<td colspan="2" valign="top" >
												<input type="hidden" name="prod" value="#url.prod#">
												<table border="0"><tr>
												<td width="10%">&nbsp;</td>
												<td>
													<cfif isnew>
													<cf_boton index="1" texto="Comprar" funcion="updateQty()">
													<cfelse>
													<cf_boton index="2" texto="Actualizar&nbsp;cantidad" funcion="updateQty()">
													</cfif>
												</td><td width="10%">&nbsp;</td><td>
													<cf_boton index="3" texto="Regresar" link="index.cfm">
												</td>
												<td width="10%">&nbsp;</td>
												</tr></table>
											</td>
										</tr>

										<cfif datos_var.RecordCount>
											<tr valign="top">
												<td colspan="2" class="subTitulo tituloListas" valign="top">Caracter&iacute;sticas del producto</td>
											</tr>
										</cfif>
			
										<cfloop query="datos_var">
											<tr valign="top">
												<td valign="top">#HTMLEditFormat(CDdescripcion)#&nbsp;</td>
												<td valign="top">#HTMLEditFormat(Valor)#&nbsp;</td>
											</tr>
										</cfloop>
										
										<tr><td colspan="2">&nbsp;</td></tr>
										
										<!--- ******** --->
										<tr>
											<td colspan="2">
												<table border="0" width="100%" cellpadding="0" cellspacing="4">
													<tr>
														<td width="50%" valign="top">
															
															<!--- recupera la lista de precios y la oficina del vendedor --->
															<cfquery name="rsDatosVendedor" datasource="#session.DSN#">
																select Ocodigo, LPid
																from VentaE
																where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
															</cfquery>
															
															<!--- recupera los datos del producto, segun su lista de precios --->
															<cfquery name="rsdata" datasource="#session.DSN#">
																select coalesce(a.precio_credito, 0) as precio_credito, coalesce(a.prima_minima, 0) as prima_minima, coalesce(a.plazo_sugerido, 0) as plazo_sugerido, 
																       coalesce(a.plazo_maximo, 0) as plazo_maximo, coalesce(a.interes_corriente, 0) as interes_corriente , coalesce(precio_credito_vendedor, 0) as precio_credito_vendedor,
																	   coalesce(precio_credito_supervisor, 0) as precio_credito_supervisor
																from DListaPrecios a
																
																inner join EListaPrecios b
																on a.LPid=b.LPid
																 and a.Ecodigo=b.Ecodigo
																
																where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																  and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
																  <cfif len(trim(rsDatosVendedor.LPid))>
																  	and a.LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosVendedor.LPid#">
																  <cfelse>
																  	and b.LPdefault = 1
																  </cfif>
															</cfquery>
															
															<table width="100%" cellpadding="0" cellspacing="0">
																<tr><td colspan="2" bgcolor="##F5F5F5"><strong>Financiamiento</strong></td></tr>
																<tr>
																	<td>Precio Cr&eacute;dito</td>
																	<td>
																		<input type="hidden" name="precio_credito_vendedor" value="#rsdata.precio_credito_vendedor#">
																		<input type="hidden" name="precio_credito_supervisor" value="#rsdata.precio_credito_supervisor#">
																		<input type="text" class="flat" name="PrecioCredito" value="#NumberFormat(rsdata.precio_credito,',0.00')#" tabindex="1" size="10" maxlength="10" style="text-align: right; " onBlur="javascript:fm(this,2); calcular_cuotas(this.form); validar_precio(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
																	</td>
																</tr>
																<tr>
																	<td>Plazo Meses</td>
																	<td>
																		<input type="hidden" name="plazo_maximo" value="#rsdata.plazo_maximo#">
																		<input type="text" class="flat" name="PlazoMeses" value="#NumberFormat(rsdata.plazo_sugerido,'0')#" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,0); validar_plazo(this.form); calcular_cuotas(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
																	</td>
																</tr>
																<tr>
																	<td>Tipo de Cuota</td>
																	<td>
																		<select name="tipo" onChange="calcular_cuotas(this.form)">
																			<option value="s" >Semanal</option>
																			<option value="q" >Quincenal</option>
																			<option value="m" >Mensual</option>
																		</select>
																	</td>
																</tr>
																<tr>
																	<td>N&uacute;mero de Cuotas</td>
																	<td><input type="text" class="flat" name="NumCuotas" readonly value="0" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>																</tr>
																<tr>
																	<td>Prima</td>
																	<td>
																		<input type="hidden" name="prima_minima" value="#rsdata.prima_minima#" >
																		<input type="text" class="flat" name="Prima" value="#NumberFormat(rsdata.prima_minima,',0.00')#" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,2); validar_prima(this.form); calcular_cuotas(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
																	</td>
																</tr>
																<tr>
																	<td>Inter&eacute;s Anual</td>
																	<td><input type="text" class="flat" readonly name="Intereses" value="#NumberFormat(rsdata.interes_corriente,'0.00')#" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,2); calcular_cuotas(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >%</td>
																</tr>
																<tr>
																	<td>Monto de Cuota</td>
																	<td><input type="text" class="flat" name="CuotaMensual" value="0.00" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,2); calcular_plazo(this.form);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
																</tr>
																<tr>
																	<td>PagoTotal</td>
																	<td><input type="text" class="flat" readonly name="PagoTotal" value="0.00" tabindex="1" size="10" maxlength="10" style="text-align: right;" onBlur="javascript:fm(this,2); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
																</tr>
																
																<tr><td colspan="2" id="warning"></td></tr>
																
															</table>
														</td>
														<td width="50%" valign="top" >
															<table width="100%" cellpadding="0" cellspacing="0">
																<tr><td bgcolor="##F5F5F5"><strong>Existencia de Producto</strong></td></tr>
																<tr><td>&nbsp;</td></tr>
																<tr>
																	<td class="subTitulo">Almacenes Locales</td>
																</tr>
																<tr>
																	<td>
																		<cfquery name="rsLista" datasource="#session.DSN#">
																			select a.Aid
																			from Almacen a
																			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
																			  and a.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosVendedor.Ocodigo#">
																		</cfquery>
																		<cfset locales = ValueList(rsLista.Aid) >
																		
																		<cfquery name="rsLista" datasource="#session.DSN#">
																			select a.Aid, a.Almcodigo, a.Bdescripcion, coalesce ( b.Eexistencia, 0) as Eexistencia
																			from Almacen a
																			
																			inner join Existencias b
																			on a.Ecodigo=b.Ecodigo
																			and a.Aid=b.Alm_Aid
																			and b.Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
																			
																			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
																			  and a.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosVendedor.Ocodigo#">
  																			order by Eexistencia desc
																		</cfquery>
																		<cfinvoke 
																				component="sif.Componentes.pListas"
																				method="pListaQuery"
																				returnvariable="pListaRet"> 
																			<cfinvokeargument name="query" value="#rsLista#"/> 
																			<cfinvokeargument name="desplegar" value="Bdescripcion,Eexistencia"/> 
																			<cfinvokeargument name="etiquetas" value="Almac&eacute;n,Existencia"/> 
																			<cfinvokeargument name="formatos" value="S,M"/> 
																			<cfinvokeargument name="align" value="left,right"/> 
																			<cfinvokeargument name="ajustar" value="N"/> 
																			<cfinvokeargument name="checkboxes" value="N"/> 
																			<cfinvokeargument name="inlcuyeForm" value="false"/> 
																			<cfinvokeargument name="showLink" value="false"/> 
																			<cfinvokeargument name="showEmptyListMsg" value="true"/> 
																		</cfinvoke> 
																	</td>
																</tr>
																<tr>
																	<td class="subTitulo">Almacenes Cercanos</td>
																</tr>
																<tr>
																	<td >
																		<cfquery name="rsLista2" datasource="#session.DSN#">
																			select distinct Bdescripcion, Eexistencia
																			from AlmacenCercano a
																			
																			inner join Existencias b
																			on a.Alm_Aid=b.Alm_Aid
																			and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
																			and b.Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
																			
																			inner join Almacen c
																			on a.Alm_Aid=c.Aid
																			and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
																			
																			<!---where a.Alm_Aid not in ( select Aid from Almacen where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" > and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosVendedor.Ocodigo#"> )
																			  and a.Aid in (select Aid from Almacen where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" > and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatosVendedor.Ocodigo#">)--->
																			<cfif len(trim(locales))>
																				where a.Alm_Aid not in ( #locales# )
																				and a.Aid in ( #locales# )
																			 <cfelse>
																			 	where 1=2
																			 </cfif>
																			 order by Eexistencia desc
																			  
																		</cfquery>
																		<cfinvoke 
																				component="sif.Componentes.pListas"
																				method="pListaQuery"
																				returnvariable="pListaRet"> 
																			<cfinvokeargument name="query" value="#rsLista2#"/> 
																			<cfinvokeargument name="desplegar" value="Bdescripcion,Eexistencia"/> 
																			<cfinvokeargument name="etiquetas" value="Almac&eacute;n,Existencia"/> 
																			<cfinvokeargument name="formatos" value="S,M"/> 
																			<cfinvokeargument name="align" value="left,right"/> 
																			<cfinvokeargument name="ajustar" value="N"/> 
																			<cfinvokeargument name="checkboxes" value="N"/> 
																			<cfinvokeargument name="inlcuyeForm" value="false"/> 
																			<cfinvokeargument name="showLink" value="false"/> 
																			<cfinvokeargument name="showEmptyListMsg" value="true"/> 
																		</cfinvoke> 
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<!--- ******** --->										
										
									</table>
								</td>
							</tr>
							
							<tr valign="top">
								<td align="center" valign="top" colspan="2">&nbsp;</td>
							</tr>

							<tr valign="top">
								<td colspan="3" align="center" valign="top"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
</cfoutput>

<script type="text/javascript">
<!--
	document.getElementById("warning").innerHTML = '';
	calcular_cuotas(document.forms[1]);
	
	function updateQty() {
		document.form1.submit();
	}

	function validar_plazo(f){
		var plazo = parseFloat(qf(f.PlazoMeses.value));
		var plazo_maximo = parseFloat(qf(f.plazo_maximo.value));
		
		if ( plazo > plazo_maximo ){
			alert('El plazo es mayor al plazo máximo permitido.');
			f.PlazoMeses.value = plazo_maximo;
		}
	}	

	function validar_prima(f){
		var prima = parseFloat(qf(f.Prima.value));
		var prima_minima = parseFloat(qf(f.prima_minima.value));
		
		if ( prima < prima_minima ){
			alert('La prima es menor a la prima mínima permitida.');
			f.Prima.value = prima_minima;
			formatCurrency(f.Prima, 2);
		}
	}	

	function validar_precio(f){
		var precio = parseFloat(qf(f.PrecioCredito.value));
		var precio_supervisor = parseFloat(qf(f.precio_credito_supervisor.value));
		var precio_vendedor = parseFloat(qf(f.precio_credito_vendedor.value));
		
		document.getElementById("warning").innerHTML = '';

		// Valida que el precio del supervisor no sea mayor al del vendedor
		if ( precio_supervisor > precio_vendedor ){
			precio_vendedor = precio_supervisor;
		}
		
		// 1. Precio entre el precio del supervisor y el precio del Vendedor
		if ( precio < precio_vendedor && precio >= precio_supervisor  ){
			document.getElementById("warning").innerHTML = '<font color="#FF0000">Requiere autorización del Supervisor.</font>' ;
		}
		else if ( precio < precio_supervisor ){
			document.getElementById("warning").innerHTML = '<font color="#FF0000">No est autorizado para dar este precio.</font>' ;
		}
	}

	function calcular_cuotas(f){
		var plazo = Math.abs(Math.round(parseFloat(f.PlazoMeses.value)));
		var tipo = f.tipo.value;
		/* preguntar a danim. Asumo que un mes tiene 4 semanas y 1 mes tiene 2 quincenas */
		if (tipo == 'q') {
			plazo *= 2;
		} else if (tipo == 's') {
			plazo *= 4;
		}

		var interes = Math.abs(Math.round(parseFloat(f.Intereses.value)*100) / 10000);
		var saldo = qf(f.PrecioCredito.value);  // toma como saldo el precio del articulo
		var pago_inicial = Math.abs(Math.round(parseFloat(f.Prima.value.replace(/,/g, ''))*100) / 100); // toma como pago inicial la prima

		if (isNaN(pago_inicial)){
			pago_inicial = 0;
			f.Prima.value = 0;
		} else if (pago_inicial != parseFloat(f.Prima.value.replace(/,/g, ''))) {
			f.Prima.value = pago_inicial;
			formatCurrency(f.Prima,2);
		}

		if (pago_inicial > saldo) {
			pago_inicial = saldo;
			saldo = 0;
			f.Prima.value = pago_inicial;
			formatCurrency(f.Prima,2);
		} else {
			saldo -= pago_inicial;
		}

		if (isNaN(plazo)) {
			f.PlazoMeses.value = '';
		}

		if (isNaN(interes)) {
			f.Intereses.value = '';
		} else if (interes*100 != parseFloat(f.Intereses.value)) {
			f.Intereses.value = interes*100;
			formatCurrency(f.Intereses,2);
		}
		
		if (tipo == 'm') {
			// plazo ok, el plazo está en meses
			interes /= 12;
		} else if (tipo == 'q') {
			interes /= 24;
		} else if (tipo == 's') {
			interes /= 52;
		}
		
		if (isNaN(plazo) || isNaN(interes) || plazo <= 0) {
			cuota = saldo;
			plazo = 1;
			interes = 0;
		} 
		if (interes != 0) {
			cuota = saldo / ( (1 - Math.pow (1+interes, -plazo)) / interes );
		} else {
			cuota = saldo / plazo;
		}

		f.NumCuotas.value = plazo;
		f.CuotaMensual.value = cuota;
		//f.plazo2.value = plazo;
		f.PagoTotal.value = pago_inicial + cuota*plazo;
		formatCurrency(f.CuotaMensual, 2);
		formatCurrency(f.PagoTotal, 2);
	}

	// ****************************************************
	// ****************************************************
	function calcular_plazo(f){
		// quitar prima al precio ?????
		var cuota = parseFloat(qf(f.CuotaMensual.value));
		
		if ( cuota > 0 ) {
			var plazo = 0;
			var tipo = f.tipo.value;
	
			var interes = Math.abs(Math.round(parseFloat(f.Intereses.value)*100) / 10000);
			var saldo = qf(f.PrecioCredito.value);  // toma como saldo el precio del articulo
			var pago_inicial = Math.abs(Math.round(parseFloat(f.Prima.value.replace(/,/g, ''))*100) / 100); // toma como pago inicial la prima
	
			if (isNaN(pago_inicial)){
				pago_inicial = 0;
				f.Prima.value = 0;
			} else if (pago_inicial != parseFloat(f.Prima.value.replace(/,/g, ''))) {
				f.Prima.value = pago_inicial;
				formatCurrency(f.Prima,2);
			}
	
			if (pago_inicial > saldo) {
				pago_inicial = saldo;
				saldo = 0;
				f.Prima.value = pago_inicial;
				formatCurrency(f.Prima,2);
			} else {
				saldo -= pago_inicial;
			}
	
			/*
			if (isNaN(plazo)) {
				f.PlazoMeses.value = '';
			}*/ /* else if (plazo != f.PlazoMeses.value) {
				f.PlazoMeses.value = plazo;
			}*/
	
			if (isNaN(interes)) {
				f.Intereses.value = '';
			} else if (interes*100 != parseFloat(f.Intereses.value)) {
				f.Intereses.value = interes*100;
				formatCurrency(f.Intereses,2);
			}
			
			if (tipo == 'm') {
				// plazo ok, el plazo está en meses
				interes /= 12;
			} else if (tipo == 'q') {
				interes /= 24;
			} else if (tipo == 's') {
				interes /= 52;
			}
			
			/*
			if (isNaN(plazo) || isNaN(interes) || plazo <= 0) {
				//cuota = saldo;
				plazo = 1;
				interes = 0;
			} 
			*/
	
			// plazo corresponde a la cantidad de cuotas
			if (interes != 0) {
				plazo = - Math.log (1 - saldo * interes / cuota) / Math.log(1+interes)
			} else {
				plazo = saldo / cuota;
			}
	
			f.PlazoMeses.value = plazo;
			
			// plazo2 corresponde a meses plazo 
			var plazo2 = 0;
			if (tipo == 'q') {
				plazo2 = plazo / 2;
			} else if (tipo == 's') {
				plazo2 = plazo / 4;
			} else if ( tipo == 'm' ){
				plazo2 = plazo;
			}
			
			f.NumCuotas.value = plazo;
			f.PlazoMeses.value = plazo2;
			formatCurrency(f.PlazoMeses, 2);
			
			
			f.PagoTotal.value = pago_inicial + cuota*plazo;
			formatCurrency(f.CuotaMensual, 2);
			formatCurrency(f.PagoTotal, 2);
			
			validar_plazo(document.forms[1]);
		}
	}
	//*****************************************************
	//*****************************************************



	<cfoutput>
	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}
	function largerImage() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
		}
		var width=362;
		var height=<cfif hayfoto.hay GT 1>382<cfelse>300</cfif>;
		var left = (screen.width - width) / 2;
		var top = (screen.height - height) / 2;
		window.gPopupWindow=window.open("prodimages.cfm?prod=#JSStringFormat(URLEncodedFormat(data.Aid))
			#", "largerImage",
			"width="+width+",height="+height+",left=" + left + ",top=" + top + ",toolbar=no");
		window.onfocus = closePopup;
	}
	</cfoutput>
//-->
</script>
</cf_templatearea>
</cf_template>
