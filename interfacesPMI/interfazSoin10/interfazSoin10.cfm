<cf_templateheader title="Interfaz Documentos">
	<cfquery name="rsDatosOrigen" datasource="#session.dsn#">
		select
				a.Aid,
				a.Adescripcion,
				oc.OCcontrato,
				coalesce(td.OCTTDcantidad,0) as OCTTDcantidad,
				(pt.OCPTentradasCantidad - pt.OCPTsalidasCantidad) as Existencia,
				case
					when (pt.OCPTentradasCantidad) > 0 
						then (pt.OCPTentradasCostoTotal) / (pt.OCPTentradasCantidad)
						else 0.00
				end as OCTTDcostoUnitario,
				coalesce(pt.OCPTentradasCantidad,0) as Entradas,
				coalesce(
					(
						select sum(OCPTMcostoValuacion) 
						  from OCPTmovimientos m
						  	inner join OCconceptoCompra cc
								 on cc.OCCid		= m.OCCid
								and cc.Ecodigo		= #session.Ecodigo#
								and cc.OCCcodigo	= '00'
						 where m.OCTid  = pt.OCTid
						   and m.Aid	= pt.Aid
						   and m.OCPTMtipoOD = 'O'
					)
				,0) as CostoProd,
				coalesce(
					(
						select sum(OCPTMcostoValuacion) 
						  from OCPTmovimientos m
						  	inner join OCconceptoCompra cc
								 on cc.OCCid		= m.OCCid
								and cc.Ecodigo		= #session.Ecodigo#
								and cc.OCCcodigo	<> '00'
						 where m.OCTid  = pt.OCTid
						   and m.Aid	= pt.Aid
						   and m.OCPTMtipoOD = 'O'
					)
				,0) as CostoNoProd
		  from OCtransporteTransformacion t
		  	inner join OCtransporteProducto tp
				inner join Articulos a
				   on a.Aid	= tp.Aid
				inner join OCordenComercial oc
				   on oc.OCid	= tp.OCid
				inner join OCproductoTransito pt
				   on pt.OCTid	= tp.OCTid
				  and pt.Aid	= tp.Aid
				  and pt.OCPTentradasCantidad >= 0
			   on tp.OCTid		= t.OCTid
			  and tp.OCtipoOD	= 'O'
			left join OCtransporteTransformacionD td
			   on td.OCTTid			= t.OCTTid
			  and td.Aid			= tp.Aid
			  and td.OCTTDtipoOD	= 'O'
		 where t.OCTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		   and t.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by a.Aid, oc.OCcontrato
	</cfquery>

	<cfquery name="rsDatosDestino" datasource="#session.dsn#">
		select
				a.Aid,
				a.Adescripcion,
				oc.OCcontrato,
				(pt.OCPTentradasCantidad - pt.OCPTsalidasCantidad) as Existencia,
				case
					when (pt.OCPTentradasCantidad - pt.OCPTsalidasCantidad) > 0 
						then (pt.OCPTentradasCostoTotal - pt.OCPTsalidasCostoTotal) / (pt.OCPTentradasCantidad - pt.OCPTsalidasCantidad)
						else 0.00
				end as OCTTDcostoUnitario,
				coalesce(td.OCTTDcantidad,0) as OCTTDcantidad,
				coalesce(td.OCTTDcostoTotal,0) as OCTTDcostoTotal
		  from OCtransporteTransformacion t
		  	inner join OCtransporteProducto tp
				inner join Articulos a
				   on a.Aid	= tp.Aid
				inner join OCordenComercial oc
				   on oc.OCid	= tp.OCid
				inner join OCproductoTransito pt
				   on pt.OCTid	= tp.OCTid
				  and pt.Aid	= tp.Aid
				  and pt.OCPTentradasCantidad = 0
			   on tp.OCTid		= t.OCTid
			  and tp.OCtipoOD	= 'D'
			left join OCtransporteTransformacionD td
			   on td.OCTTid			= t.OCTTid
			  and td.Aid			= tp.Aid
			  and td.OCTTDtipoOD	= 'D'
		 where t.OCTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		   and t.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by a.Aid, oc.OCcontrato
	</cfquery>
	
</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Transformaci&oacute;n de Productos en Transito">
					<script language="JavaScript" src="../../js/utilesMonto.js"></script>
					<form action="TransfProdTransito.cfm-sql.cfm" method="post" name="form1">
						<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
							<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
							<cfif  modo NEQ 'ALTA'>
							<tr>
								<td>
								<a href="javascript: verEncabezado('Ecabezado');" ><img  id="img_Ecabezado" src="../../imagenes/abajo.gif"  width="10" height="10" border="0" >
									Ocultar encabezado	</a> 
								</td>
							</tr>
							</cfif>
							<tr id="TR_Ecabezado">
								<td>
									<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
										<tr>
											<td width="10%" align="left"><strong>Transporte:</strong></td>
											<td width="20%">
												
												<cfif isdefined("rsDatos.OCTid") and len(trim(rsDatos.OCTid))>
													#rsDatos.OCTtransporte#
												<cfelse>
													<cfset ArrayTRANS=ArrayNew(1)>
													<cf_conlis
														Campos="OCTid,OCTtransporte"
														Desplegables="N,S"
														Modificables="N,S"
														Size="0,30"
														tabindex="1"
														ValuesArray="#ArrayTRANS#" 
														Title="Lista de Transportes"
														Tabla="OCtransporte"
														Columnas="OCTid,OCTtransporte,OCTvehiculo,OCTruta,OCTtipo"
														Filtro=" Ecodigo = #Session.Ecodigo#"
														Desplegar="OCTtransporte,OCTvehiculo,OCTruta,OCTtipo"
														Etiquetas="Transporte,Vehiculo,Ruta,Tipo"
														filtrar_por="OCTtransporte,OCTvehiculo,OCTruta,OCTtipo"
														Formatos="S,S,S,S"
														Align="left,left,left,left"
														form="form1"
														Asignar="OCTid,OCTtransporte"
														Asignarformatos="S,S"/>														
												</cfif>
										  </td>
											<td width="10%" align="left">&nbsp;&nbsp;<strong>Documento:</strong></td>
											<td width="60%">
											<input 	
												type="text" 
												size="20" 
												maxlength="20" 
												tabindex="1"
												onfocus="this.select()" 
												name="OCTTdocumento" value="<cfif isdefined("rsDatos.OCTTdocumento") and len(trim(rsDatos.OCTTdocumento))>#rsDatos.OCTTdocumento#</cfif>">
										  </td>
										</tr>	
										<tr>
											<td align="left" valign="top"><strong>Fecha:</strong></td>
											<td valign="top">
												<cfif isdefined("rsDatos.OCTTfecha") and len(rsDatos.OCTTfecha)>
													<cf_sifcalendario form="form1" name="OCTTfecha" value="#LSDateformat(rsDatos.OCTTfecha,'dd/mm/yyyy')#" tabindex="1">
												<cfelse>
													<cf_sifcalendario form="form1" name="OCTTfecha" tabindex="1">
												</cfif>	
											</td>

											<td align="left" valign="top">&nbsp;&nbsp;<strong>Observaciones:</strong></td>
											<td colspan="1">
												<textarea tabindex="1" name="OCTTobservaciones" cols="70" rows="4"><cfif isdefined("rsDatos.OCTTobservaciones") and len(rsDatos.OCTTobservaciones)>#rsDatos.OCTTobservaciones#</cfif></textarea>
											</td>
										</tr>
																														
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<cfif  modo EQ 'ALTA'>
										<cf_botones modo="#modo#" tabindex="1"></td>
									<cfelse>
										<cf_botones modo="#modo#" include='Aplicar' includevalues='Aplicar' tabindex="1"></td>
									</cfif>	
								</td>
							</tr>	
							<tr>
								<td>	
									<cfif  modo NEQ 'ALTA'>
									<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
										<tr>
											<td width="51%" valign="top">
												<fieldset><legend>Productos Origen</legend>
												<table width="100%" border="0">
													<tr>
														<td>
															<table width="100%" border="0" cellpadding="0" cellspacing="2">
																<tr bgcolor="##CCCCCC">
																	<td><strong>Producto</strong></td>
																	<td align="right"><strong>Existencia</strong></td>
																	<td align="right"><strong>Cantidad</strong></td>
																	<td align="right" nowrap>&nbsp;&nbsp;<strong>Costo Unitario</strong></td>
																	<td align="right">&nbsp;&nbsp;<strong>Costo</strong></td>
																</tr>
																<cfset COSTOG_O = 0>
																<cfoutput query="rsDatosOrigen" group="Aid">
																	<cfset LvarOCs="">
																	<cfoutput group="OCcontrato">
																		<cfset LvarOCs = LvarOCs & " " & trim(OCcontrato)>
																	</cfoutput>
																	<tr>
																		<td style="font-size:9px">#rsDatosOrigen.Adescripcion#<BR>(OC:#LvarOCs#)</td>
																		<td align="right">#LSCurrencyFormat(rsDatosOrigen.existencia,'none')#</td>
																		<td style="font-size:9px" align="right">
																			<input name="CANT_#rsDatosOrigen.Aid#" 
																			tabindex="1" 
																			type="text" 
																			onBlur="javascript: fm(this,2);" 
																			onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
																			style=" font-size:9px;text-align:right" 
																			onFocus="javascript:document.form1.CANT_#rsDatosOrigen.Aid#.select();" 
																			onChange="javascript:fm(this,2);calcula_CostoO(this,#rsDatosOrigen.Aid#);" 
																			value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDatosOrigen.OCTTDcantidad,'none')#<cfelse>0.00</cfif>" 
																			size="15" 
																			maxlength="15">
																		</td>
																																			<td style="font-size:9px" align="right">
																			<input name="UNIT_#rsDatosOrigen.Aid#" 
																			tabindex="-1" 
																			type="text" 
																			style=" font-size:9px; text-align:right; border: medium none; visibility:visible;"
																			onFocus="javascript:document.form1.UNIT_#rsDatosOrigen.Aid#.select();" 
																			onChange="javascript:fm(this,2);" 
																			value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDatosOrigen.OCTTDcostoUnitario,'none')#<cfelse>0.00</cfif>" 
																			size="15" 
																			maxlength="15">
																		</td>																			
																		<td style="font-size:9px" align="right">
																			<input name="TOTAL_#rsDatosOrigen.Aid#" 
																			tabindex="-1" 
																			type="text" 
																			style=" font-size:9px; text-align:right; border: medium none; visibility:visible;"
																			onFocus="javascript:document.form1.TOTAL_#rsDatosOrigen.Aid#.select();" 
																			onChange="javascript:fm(this,2);" 
																			value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDatosOrigen.CostoProd,'none')#<cfelse>0.00</cfif>" 
																			size="15" 
																			maxlength="15">
																		</td>	
																																		
																	</tr>
																	<cfset COSTOG_PROD		= COSTOG_PROD 	 + #rsDatosOrigen.CostoProd#>
																	<cfset COSTOG_NO_PROD	= COSTOG_NO_PROD + #rsDatosOrigen.CostoNoProd#>
																</cfoutput>
																<tr>
																	<td  colspan="5"><hr></td>	
																</tr>
																<tr>
																	<td  colspan="3">&nbsp;</td>	
																	<td>
																		<input name="COSTOG_PROD" 
																			tabindex="-1" 
																			type="text" 
																			style=" font-size:9px; text-align:right; border: medium none; visibility:visible;"
																			onFocus="javascript:document.form1.COSTOG_PROD" 
																			onChange="javascript:fm(this,2);" 
																			value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(COSTOG_PROD,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" 
																			size="20" 
																			maxlength="20">
																	</td>
																	<td>
																		<input name="COSTOG_NO_PROD" 
																			tabindex="-1" 
																			type="text" 
																			style=" font-size:9px; text-align:right; border: medium none; visibility:visible;"
																			onFocus="javascript:document.form1.COSTOG_NO_PROD" 
																			onChange="javascript:fm(this,2);" 
																			value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(COSTOG_NO_PROD,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" 
																			size="20" 
																			maxlength="20">
																	</td>
																</tr>

															</table>
														</td>
													</tr>
												</table>
												</fieldset>
											</td>
											<td width="50%" valign="top">
												<fieldset><legend>Productos Destino</legend>
												<table width="100%" border="0">
													<tr>
														<td>
															<table width="100%" border="0" cellpadding="0"  cellspacing="2">
																<tr bgcolor="##CCCCCC">
																	<td ><strong>Producto</strong></td>
																	<td align="right"><strong>Cantidad</strong></td>
																	<td align="right" nowrap>&nbsp;&nbsp;<strong>Costo Unitario</strong></td>
																	<td align="right">&nbsp;&nbsp;<strong>Costo</strong></td>
																</tr>
																<cfset COSTOG_D = 0>
																<cfset CANTG_D  = 0>

																<cfoutput query="rsDatosDestino" group="Aid">
																	<cfset LvarOCs="">
																	<cfoutput group="OCcontrato">
																		<cfset LvarOCs = LvarOCs & " " & trim(OCcontrato)>
																	</cfoutput>
																	<tr>
																		<td style="font-size:9px">#rsDatosDestino.Adescripcion#<BR>(#LvarOCs#)</td>
																		<td style="font-size:9px" align="right">
																			<input name="CANT_#rsDatosDestino.Aid#" 
																			tabindex="1" 
																			type="text" 
																			onBlur="javascript: fm(this,2);"  
																			onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
																			onFocus="javascript:document.form1.CANT_#rsDatosDestino.Aid#.select();" 
																			onChange="javascript:fm(this,2);calcula_CostoD(this,#rsDatosDestino.Aid#,#rsDatosDestino.OCTTDcantidad#);" 
																			value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDatosDestino.OCTTDcantidad,'none')#<cfelse>0.00</cfif>" 
																			size="15" 
																			style=" font-size:9px;text-align:right"
																			maxlength="15">
																		</td>
																		<td style="font-size:9px" align="right">
																			<input name="UNIT_#rsDatosDestino.Aid#" 
																			tabindex="-1" 
																			type="text" 
																			style=" font-size:9px;text-align:right; border: medium none; visibility:visible;"
																			onFocus="javascript:document.form1.UNIT_#rsDatosDestino.Aid#.select();" 
																			onChange="javascript:fm(this,2);" 
																			value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDatosDestino.OCTTDcostoUnitario,'none')#<cfelse>0.00</cfif>" 
																			size="15"
																			maxlength="15">
																		</td>	
																		<td style="font-size:9px" align="right">
																			<input name="TOTAL_#rsDatosDestino.Aid#" 
																			tabindex="-1" 
																			type="text" 
																			onFocus="javascript:document.form1.TOTAL_#rsDatosDestino.Aid#.select();" 
																			onChange="javascript:fm(this,2);" 
																			value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDatosDestino.OCTTDcostoTotal,'none')#<cfelse>0.00</cfif>" 
																			size="15" 
																			style=" font-size:9px;text-align:right; border: medium none; visibility:visible;"
																			maxlength="15">
																		</td>																																																				
																	</tr>
																	<cfset COSTOG_D = COSTOG_D + #rsDatosDestino.OCTTDcostoTotal#>
																	<cfset CANTG_D = CANTG_D + #rsDatosDestino.OCTTDcantidad#>
																</cfoutput>
																<tr>
																	<td  colspan="4"><hr></td>	
																</tr>
																<tr>
																	<td  colspan="3"><input name="CANTG_D" type="hidden" value="#CANTG_D#"></td>	
																	<td>
																		<input name="COSTOG_D" 
																			tabindex="-1" 
																			type="text" 
																			style=" font-size:9px; text-align:right; border: medium none; visibility:visible;"
																			onFocus="javascript:document.form1.COSTOG_D" 
																			onChange="javascript:fm(this,2);" 
																			value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(COSTOG_D,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" 
																			size="20" 
																			maxlength="20">
																	</td>
																</tr>																
															</table>
														</td>
													</tr>
												</table>
												</fieldset>
											</td>
										</tr>
										<tr>
											<td  colspan="2" align="center">
											<!---<input class="btnNormal" type="reset" name="Refrescar" value="Refrescar" tabindex="1">
											 <input type="submit" name="btnCalcular" class="btnNormal" value="Calcular" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcCalcular) return funcCalcular();" tabindex="1"> --->
											<td>
										</tr>
									</table>
									</cfif>								
								</td>
							</tr>
						</table>
						<cfif  modo NEQ 'ALTA'>
							<input name="OCTTid" type="hidden" value="#rsDatos.OCTTid#">
						</cfif>
					</form>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	
<cf_qforms>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	<cfif  modo EQ 'ALTA'>
		objForm.OCTid.description = "Transportes";
	</cfif>
	objForm.OCTTdocumento.description = "Documento";
	objForm.OCTTfecha.description = "Fecha";
	
	function verEncabezado(idx) {
		var tr = document.getElementById("TR_"+idx);
		var img = document.getElementById("img_"+idx);
		img.src = ((tr.style.display == "none") ? "../../imagenes/abajo.gif" : "../../imagenes/derecha.gif");
		tr.style.display = ((tr.style.display == "none") ? "" : "none");
	}	
	
	function habilitarValidacion() {
			<cfif  modo EQ 'ALTA'>
				objForm.OCTid.required = true;
			</cfif>
		objForm.OCTTdocumento.required = true;
		objForm.OCTTfecha.required = true;
	}

	function deshabilitarValidacion() {
		_allowSubmitOnError = true;
		<cfif  modo EQ 'ALTA'>
			objForm.OCTid.required = false;
		</cfif>
		objForm.OCTTdocumento.required = false;
		objForm.OCTTfecha.required = false;
	}			


	function calcula_CostoO(obj,llave){
		var valor 			 = qf(obj.value);
		var cant 			 = new Number(valor) ;
		var objtotal		 = eval("document.form1.TOTAL_"+llave);
		var objcostounitario = eval("document.form1.UNIT_"+llave);
		var COSTOG_O 		 = new Number(qf(document.form1.COSTOG_O.value));
		var costounitario    = new Number(qf(objcostounitario.value)) ;	
		var CostoAnterior    = new Number(qf(objtotal.value)) ;
		var NuevoCosto       = cant * costounitario;
		
		
		 objtotal.value = (NuevoCosto);
		if (NuevoCosto > CostoAnterior) {
			document.form1.COSTOG_O.value = COSTOG_O + ( NuevoCosto - CostoAnterior);
		}
		else if (NuevoCosto < CostoAnterior){
			document.form1.COSTOG_O.value = COSTOG_O - (CostoAnterior - NuevoCosto);
		}
		fm(document.form1.COSTOG_O,2);
		
		objtotal.value = (cant * costounitario );
		fm(objtotal,2) 
	}

	function calcula_CostoD(obj,llave,Actual){
		var valor 			 = qf(obj.value);
		var cant 			 = new Number(valor) ; 							  <!--- CANTIDAD DIGITADA--->
		var objtotal		 = eval("document.form1.TOTAL_"+llave);
		var objcostounitario = eval("document.form1.UNIT_"+llave);
		
		var COSTOG_O 		 = new Number(qf(document.form1.COSTOG_O.value)); <!--- SUMATORIA COSTOS PRODUCTOS ORIGEN --->
		var COSTOG_D 		 = new Number(qf(document.form1.COSTOG_D.value)); <!--- SUMATORIA COSTOS PRODUCTOS DESTINO  --->
		var CANTG_D 		 = new Number(qf(document.form1.CANTG_D.value));  <!--- SUMATORIA CANTIDADES PRODUCTOS DESTINO  --->
		var costounitario    = new Number(qf(objcostounitario.value)) ;		  <!--- COSTO UNITARIO--->	
		var CostoAnterior    = new Number(qf(objtotal.value)) ;
		
		<!--- ACTUALIZA EL MONTO DE LA SUMATORIO DE CANTIDADES DE PRODUCTOS --->
		<!--- PARA PODER CALCULAR EL COSTO  DEL PRODUCTO--->
		if (cant > Actual) {
			document.form1.CANTG_D.value = CANTG_D + ( cant - Actual);
			CANTG_D = CANTG_D  +  (cant - Actual);
		}
		else if (cant < Actual){
			document.form1.CANTG_D.value = CANTG_D - ( Actual - cant);
			CANTG_D = CANTG_D  -  (Actual - cant);
		}
		else if (cant == 0){
			document.form1.CANTG_D.value = CANTG_D -  Actual;
			CANTG_D = CANTG_D  -  Actual;
		}
		objcostounitario.value = 0;
		objtotal.value  = 0;
		document.form1.COSTOG_D.value = 0;
		fm(objtotal,2);
		fm(objcostounitario,2);
		fm(document.form1.COSTOG_D,2);
	}
	
	function funcAplicar(){
		alert('Proceso en construcción')
		return false
	}
	
	//-->
	</script>


