<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("form.DDRlinea") and len(trim(form.DDRlinea)) gt 0>
	<cfquery name="rsInfoDetalle" datasource="#session.dsn#">
	
	
	select  hddr.DDRcantorigen,														<!--- Cantidad factura --->
								hddr.DDRcantrec,														<!--- Cantidad recibida --->
								#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRpreciou")#,														<!--- Precio factura --->
								#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRprecioorig")#,														<!--- Precio orden de compra --->
								hddr.Icodigo,
								coalesce(imp.Iporcentaje, 0) as Iporcentaje,							<!--- Porcentaje impuesto en la factura --->
								hedr.Mcodigo,															<!--- Codigo de la moneda de la factura --->
								eocm.EOnumero, 
								hddr.Ucodigo, 
								docm.Ucodigo as UcodigoOC, 
								coalesce(hddr.DDRdescporclin, 0) as DDRdescporclin,						<!--- Porcentaje descuento en la factura --->
								docm.DOcantidad - docm.DOcantsurtida as DOcantsaldo,					<!--- Cantidad del saldo en la linea de la orden de compra --->
								docm.DOcantidad,
								(docm.DOcantidad - docm.DOcantsurtida) as Saldo,
								coalesce(docm.DOporcdesc, 0) as DOporcdesc,		
								coalesce(hddr.DDRimptoporclin, 0.00) as DDRimptoporclin,						<!--- Porcentaje descuento en la orden de compra --->
								docm.DOobservaciones, 
								hddr.DDRobstolerancia,
								docm.DOalterna, 
								#LvarOBJ_PrecioU.enSQL_AS("docm.DOpreciou")#,
								hddr.DDRobsreclamo,
								(select mon.Mnombre
									from Monedas mon 
										where mon.Mcodigo = eocm.Mcodigo
											and mon.Ecodigo = eocm.Ecodigo
									) as Mnombre,
								case 
									when hddr.DDRaprobtolerancia = 10 then 1
									else 0
								end DDRaprobtolerancia,
								
								floor(((docm.DOcantidad - docm.DOcantsurtida) + (docm.DOcantidad * coalesce(clas.Ctolerancia, 0.00) / 100.00))) as CantidadPermitida,
				
								case 
									when (hddr.DDRgenreclamo = 1)  and 
										(hddr.DDRaprobtolerancia is null or
										hddr.DDRaprobtolerancia = 5 or
										hddr.DDRaprobtolerancia=20)
																then ((coalesce(clas.Ctolerancia, 0) / 100) * docm.DOcantidad)
									else 0
								end Ctolerancia,
																						<!--- Porcentaje de tolerancia del articulo 	(								(coalesce(clas.Ctolerancia, 0) / 100) * docm.DOcantidad as Ctolerancia,)		--->
								case when clas.Ctolerancia is null then 'F'
									 else 'V'
								end as ArticuloTieneTolerancia,
								impOC.Iporcentaje as IporcentajeOC,										<!--- Porcentaje de impuesto de la orden de compra --->
								case when docm.Ucodigo = hddr.Ucodigo then 1
									 when cu.CUfactor is not null then cu.CUfactor
									 when cua.CUAfactor is not null then cua.CUAfactor
									 else case when hddr.DDRcantorigen = 0 then 0
									 		   else hddr.DDRcantordenconv / hddr.DDRcantorigen
											   end
									 end as factorConversionU,											<!--- Factor de conversion (factura a orden) --->
								eocm.EOtc,																<!--- Tipo de cambio en la orden de compra --->
								hedr.EDRtc,																<!--- Tipo de cambio en la factura --->
								eocm.Mcodigo as McodigoOC,												<!--- Codigo de la moneda de la orden de compra asociada --->
								hddr.DDRgenreclamo,														<!--- Indica si la linea genera reclamo --->
								hddr.DDRtipoitem,
								EPDid
								
						from EDocumentosRecepcion hedr
						
							inner join DDocumentosRecepcion hddr
								on  hedr.EDRid = hddr.EDRid
								and hedr.Ecodigo = hddr.Ecodigo
														
							inner join DOrdenCM docm		
								on hddr.DOlinea = docm.DOlinea
								and hddr.Ecodigo = docm.Ecodigo	
							
							<!--- Para obtener el factor de conversion de factura a orden --->
							left outer join ConversionUnidades cu
								on cu.Ecodigo = hddr.Ecodigo
								and cu.Ucodigo = hddr.Ucodigo
								and cu.Ucodigoref = docm.Ucodigo
							
							<!--- Para obtener el porcentaje de impuesto de la orden de compra --->
							left outer join Impuestos impOC
								on impOC.Icodigo = docm.Icodigo
								and impOC.Ecodigo = hddr.Ecodigo
					
							inner join EOrdenCM eocm
								on docm.EOidorden=eocm.EOidorden
								and docm.Ecodigo = eocm.Ecodigo
												
							left outer join Articulos art
								on hddr.Aid = art.Aid
								and hddr.Ecodigo = art.Ecodigo	
					
							<!--- Para obtener el porcentaje de tolerancia del articulo --->
							left outer join Clasificaciones clas
								on clas.Ccodigo = art.Ccodigo
								and clas.Ecodigo = hddr.Ecodigo
					
							<!--- Para obtener factor de conversion de factura a orden si no estaba definido en la tabla ConversionUnidades --->			
							left outer join ConversionUnidadesArt cua
								on cua.Aid = art.Aid
								and art.Ucodigo = hddr.Ucodigo
								and cua.Ucodigo = docm.Ucodigo
								and cua.Ecodigo = hddr.Ecodigo
					
							left outer join Impuestos imp
								on hddr.Icodigo = imp.Icodigo
								and hddr.Ecodigo = imp.Ecodigo
						
						where hddr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and hddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
						and hddr.DDRlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDRlinea#">
	</cfquery>
	<!--- <cf_dump var="#rsInfoDetalle#"> --->


	<cfset montoReclamado = 0>
	<cfset totalFactura = 0>
	<cfset idPoliza = 0>
	<cfset modo= "alta">
	 <cfloop query="rsInfoDetalle"><!--- --->
		<cfif modo neq 'ALTA' and isdefined("rsInfoDetalle") and len(trim(rsInfoDetalle.EPDid))>
			<cfset totalFactura = totalFactura + calcularMonto(rsInfoDetalle.DDRcantorigen, rsInfoDetalle.DDRpreciou, rsInfoDetalle.DDRdescporclin, 0.00)>
		<cfelse>
			<cfset totalFactura = totalFactura + calcularMonto(rsInfoDetalle.DDRcantorigen, rsInfoDetalle.DDRpreciou, rsInfoDetalle.DDRdescporclin, rsInfoDetalle.Iporcentaje)>
			<cfset montoFacturado = LSNumberFormat(calcularMonto(rsInfoDetalle.DDRcantorigen, rsInfoDetalle.DDRpreciou, rsInfoDetalle.DDRdescporclin, rsInfoDetalle.DDRimptoporclin,0,rsInfoDetalle.DDRaprobtolerancia), '9.00')>
		</cfif>
		<cfif rsInfoDetalle.DDRgenreclamo eq 1>
			<cfif modo neq 'ALTA' and isdefined("rsInfoDetalle") and len(trim(rsInfoDetalle.EPDid))>
				<cfset idPoliza = rsInfoDetalle.EPDid>
				<cfset montoReclamado = calcularReclamo(rsInfoDetalle.DDRcantorigen, rsInfoDetalle.DDRpreciou, rsInfoDetalle.DDRdescporclin,
																	  rsInfoDetalle.Iporcentaje, rsInfoDetalle.DOcantsaldo, rsInfoDetalle.DDRpreciou,
																	  rsInfoDetalle.DDRdescporclin, rsInfoDetalle.Iporcentaje, rsInfoDetalle.DDRcantrec,
																	  rsInfoDetalle.Ctolerancia, rsInfoDetalle.Mcodigo, rsInfoDetalle.McodigoOC,
																	  rsInfoDetalle.EDRtc, rsInfoDetalle.EOtc, rsInfoDetalle.factorConversionU, 
																	  rsInfoDetalle.DDRtipoitem, rsInfoDetalle.ArticuloTieneTolerancia,idPoliza,rsInfoDetalle.DDRaprobtolerancia)>
			<cfelse>
				<cfif isdefined("rsInfoDetalle") and len(trim(rsInfoDetalle.EPDid)) GT 0>
					<cfset idPoliza = rsInfoDetalle.EPDid>								
				</cfif>
				<cfset montoReclamado = calcularReclamo(rsInfoDetalle.DDRcantorigen, rsInfoDetalle.DDRpreciou, rsInfoDetalle.DDRdescporclin,
																	  rsInfoDetalle.Iporcentaje, rsInfoDetalle.DOcantsaldo, rsInfoDetalle.DDRprecioorig,
																	  rsInfoDetalle.DOporcdesc, rsInfoDetalle.IporcentajeOC, rsInfoDetalle.DDRcantrec,
																	  rsInfoDetalle.Ctolerancia, rsInfoDetalle.Mcodigo, rsInfoDetalle.McodigoOC,
																	  rsInfoDetalle.EDRtc, rsInfoDetalle.EOtc, rsInfoDetalle.factorConversionU, 
																	  rsInfoDetalle.DDRtipoitem, rsInfoDetalle.ArticuloTieneTolerancia,idPoliza,rsInfoDetalle.DDRaprobtolerancia)>
			</cfif>
			
		<cfelse>
		<cfset montoReclamado = calcularReclamo(rsInfoDetalle.DDRcantorigen, rsInfoDetalle.DDRpreciou, rsInfoDetalle.DDRdescporclin,
																	  rsInfoDetalle.Iporcentaje, rsInfoDetalle.DOcantsaldo, rsInfoDetalle.DDRprecioorig,
																	  rsInfoDetalle.DOporcdesc, rsInfoDetalle.IporcentajeOC, rsInfoDetalle.DDRcantrec,
																	  rsInfoDetalle.Ctolerancia, rsInfoDetalle.Mcodigo, rsInfoDetalle.McodigoOC,
																	  rsInfoDetalle.EDRtc, rsInfoDetalle.EOtc, rsInfoDetalle.factorConversionU, 
																	  rsInfoDetalle.DDRtipoitem, rsInfoDetalle.ArticuloTieneTolerancia,idPoliza,rsInfoDetalle.DDRaprobtolerancia)>
			
		</cfif>
		<cfset idPoliza = 0>
	 </cfloop><!--- --->
	 <cfset LvarmontoReclamado = montoReclamado[1]>
	 <cfset LvarlineaUnidadesNoRecibidas = montoReclamado[5]>
	 <cfset LvarlineaUnidadesReclamo = montoReclamado[4]>
<!--- 	<cfdump var="#montoReclamado#"> --->
	

	<cfoutput>
	<form action="docsAprobarExcTolerancia-sql.cfm" method="post" name="formDetalle" onSubmit="javascript: sinbotones(); habObjts();">
		<input type="hidden" name="EDRid" value="#form.EDRid#">
		<input type="hidden" name="DDRlinea" value="#form.DDRlinea#">
		<input type="hidden" name="Opcion" value="">
		
		<!--- Guarda los filtros para no perderlos al hacer click en modificar --->
		<cfif isdefined("form.numparteF") and len(trim(form.numparteF)) gt 0>
			<input type="hidden" name="numparteF" value="#form.numparteF#">
		</cfif>
		<cfif isdefined("form.DOalternaF") and len(trim(form.DOalternaF)) gt 0>
			<input type="hidden" name="DOalternaF" value="#form.DOalternaF#">
		</cfif>
		<cfif isdefined("form.DOobservacionesF") and len(trim(form.DOobservacionesF)) gt 0>
			<input type="hidden" name="DOobservacionesF" value="#form.DOobservacionesF#">
		</cfif>
		<cfif isdefined("form.AcodigoF") and len(trim(form.AcodigoF)) gt 0>
			<input type="hidden" name="AcodigoF" value="#form.AcodigoF#">
		</cfif>
		<cfif isdefined("form.DOdescripcionF") and len(trim(form.DOdescripcionF)) gt 0>
			<input type="hidden" name="DOdescripcionF" value="#form.DOdescripcionF#">
		</cfif>
		<cfif isdefined("form.CMCid1")>
			<input type="hidden" name="CMCid1" value="#form.CMCid1#">
		</cfif>
		<cfif isdefined("form.Reclamo") and len(trim(form.Reclamo)) gt 0>
			<input type="hidden" name="Reclamo" value="#form.Reclamo#">
		</cfif>
		<cfif isdefined("form.PageNum_lista")>
		<input type="hidden" name="PageNum_lista" value="#form.PageNum_lista#">
		</cfif>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
			<tr>
				<td align="right" colspan="6">&nbsp;</td>
			</tr>
			<tr>
				<!--- Número de orden de compra --->
				<td align="right"><strong>N&uacute;mero de Orden:&nbsp;</strong></td>
				<td>#rsInfoDetalle.EOnumero#</td>
	
				<!--- Descripción alterna/Observaciones --->
				<td align="right"><strong>Descripci&oacute;n Alterna/Observaciones:&nbsp;</strong></td>
				<td>
					<input type="hidden" name="DOobservaciones" value="#Trim(rsInfoDetalle.DOobservaciones)#">
					<input type="hidden" name="DOalterna" value="#Trim(rsInfoDetalle.DOalterna)#">
					<a href="javascript: infoOrden('formDetalle');"><img border="0" src="../../imagenes/iedit.gif" alt="informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a>
				</td>
				
				<!--- Moneda de la orden de compra --->
				<td align="right"><strong>Moneda:&nbsp;</strong></td>
				<td>#rsInfoDetalle.Mnombre#</td>
			</tr>
			<tr>
				<!--- Precio unitario en OC --->
				<td align="right"><strong>Precio Unitario en OC:&nbsp;</strong></td>
				<td>#LvarOBJ_PrecioU.enCF_RPT(rsInfoDetalle.DOpreciou)#</td>
				
				<!--- Cantidad de la orden de compra --->
				<td align="right"><strong>Cantidad OC:&nbsp;</strong></td>
				<td>#LSNumberFormat(rsInfoDetalle.DOcantidad, ',9.00')#</td>
	
				<!--- Cantidad factura --->
				<td align="right"><strong>Cantidad Factura:&nbsp;</strong></td>
				<td>#LSNumberFormat(rsInfoDetalle.DDRcantorigen, ',9.00')#</td>
			</tr>
			<tr>
				<!--- Precio unitario en factura --->
				<td align="right"><strong>Precio Unitario en Factura:&nbsp;</strong></td>
				<td>#LvarOBJ_PrecioU.enCF_RPT(rsInfoDetalle.DDRpreciou)#</td>
	
				<!--- Saldo de la orden de compra --->
				<td align="right"><strong>Saldo OC:&nbsp;</strong></td>
				<td>#LSNumberFormat(rsInfoDetalle.Saldo, ',9.00')#</td>
	
				<!--- Cantidad recibida --->
				<td align="right"><strong>Cantidad Recibida:&nbsp;</strong></td>
				<td>#LSNumberFormat(rsInfoDetalle.DDRcantrec, ',9.00')#</td>
			</tr>
			<tr>
				<!--- % Descuento en orden de compra --->
				<td align="right"><strong>% Descuento OC :</strong></td>
				<td>#LSNumberFormat(rsInfoDetalle.DOporcdesc, ',9.00')#</td>
	
				<!--- Unidad en orden de compra --->
				<td align="right"><strong>Unidad OC:&nbsp;</strong></td>
				<td>#rsInfoDetalle.UcodigoOC#</td>
				
				<!--- Unidad de recepción --->
				<td align="right"><strong>Unidad Recepci&oacute;n:&nbsp;</strong></td>
				<td>#rsInfoDetalle.Ucodigo#</td>
			</tr>
			<tr>
				<!--- % Descuento factura --->
				<td align="right"><strong>% Descuento Factura:&nbsp;</strong></td>
				<td>#LSNumberFormat(rsInfoDetalle.DDRdescporclin, ',9.00')#</td>
	
				<!--- Porcentaje de tolerancia definido para el artículo --->
				<td align="right"><strong>%Tolerancia:&nbsp;</strong></td>
				<td>#LSNumberFormat(rsInfoDetalle.Ctolerancia, ',9.00')#</td>

				<!--- Exceso --->
				<td align="right"><strong>Exceso en Unidades de la OC:&nbsp;</strong></td>
				<td>#LSNumberFormat(LvarlineaUnidadesReclamo, ',9.00')#</td>
			</tr>
			<tr>
				<!--- Impuesto en orden de compra --->
				<td align="right"><strong>% Impuesto OC:&nbsp;</strong></td>
				<td>#rsInfoDetalle.Icodigo# - #LSNumberFormat(rsInfoDetalle.IporcentajeOC, ',9.00')#%</td>
	
				<!--- Cantidad permitida --->
				<td align="right"><strong>Cantidad permitida:&nbsp;</strong></td>
				<td>#LSNumberFormat(rsInfoDetalle.CantidadPermitida, ',9.00')#</td>

				<!--- Monto esperado = facturado - reclamado --->				
				<td align="right"><strong>Monto esperado:&nbsp;&nbsp;</strong></td>
				<td>			    #LSNumberFormat(montoFacturado - LvarmontoReclamado, ',9.00')#</td>
			</tr>
			<tr>
				<!--- Impuesto en factura --->
				<td align="right"><strong>% Impuesto Factura:</strong></td>
				<td>#rsInfoDetalle.Icodigo# - #LSNumberFormat(rsInfoDetalle.DDRimptoporclin, ',9.00')#%</td>
	
				<!--- Observaciones de reclamo --->
				<td align="right" nowrap><strong>Observaciones Reclamo:</strong></td>
				<td>&nbsp;&nbsp;<input type="hidden" name="DDRobsreclamo" id="DDRobsreclamo" value="#rsInfoDetalle.DDRobsreclamo#">
					<a href="javascript:info('formDetalle', 'DDRobsreclamo', true);"><img border="0" src="../../imagenes/iedit.gif" alt="Ver Observaciones"></a>
				</td>
	
				<!--- Tolerancia de Recepcion --->
				<td align="right" nowrap><strong>Observaciones Tolerancia:</strong></td>
				<td>
					<input type="hidden" name="DDRobstolerancia" id="DDRobstolerancia" value="#rsInfoDetalle.DDRobstolerancia#">
					<a href="javascript:info('formDetalle', 'DDRobstolerancia', true);"><img border="0" src="../../imagenes/iedit.gif" alt="Ver/Modificar Observaciones"></a>			  				
				</td>
			</tr>
			<tr>
				<!--- Monto facturado --->
				<td align="right"><strong>Monto facturado:&nbsp;</strong></td>
				<td>
					#LSNumberFormat(montoFacturado, ',9.00')#
				</td>
				
				<!--- Monto reclamado --->
				<td align="right"><strong>Monto reclamado:&nbsp;</strong></td>
				<td>
					#LSNumberFormat(LvarmontoReclamado, ',9.00')#
				</td>

				<!--- Observaciones de aprobación de tolerancia --->
				<!--- Genera reclamo --->
				<td align="right" nowrap><strong>Reclamo:</strong></td>
				<td>&nbsp;&nbsp;
					<input type="checkbox" disabled  name="DDRgenreclamo" id="DDRgenreclamo" <cfif rsInfoDetalle.DDRgenreclamo eq 1>checked</cfif>>				 
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>				
				<td>&nbsp;</td>				
				<td>&nbsp;</td>				
				<td>&nbsp;</td>				
				<td>&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<td align="center" colspan="6" valign="baseline">
					<!--- Botón de Modificar --->
                    <input type="submit" name="btnModificar" value="Modificar" onClick="javascript: document.formDetalle.Opcion.value = 'Modificar'">					
                  <!--- Botón Aprobar Línea --->
					<input type="button" name="btnAprobarLinea" value="Aprobar Tolerancia" onClick="javascript: aprobTole(1);">
					<input type="button" name="btnRechazarLinea" value="Rechazar Tolerancia" onClick="javascript: aprobTole(2);">					
					
					<!--- Botón de regresar a la lista --->
			  <input type="button" name="btnRegresar" value="Regresar" onClick="javascript: funcRegresar()">			  </td>
			</tr>
		</table>
	
	</form>
	
	</cfoutput>
</cfif>

<script language="javascript" type="text/javascript">	
	function aprobTole(param){
		if(param == 1){
			if(confirm('Desea aprobar la tolerancia de la línea ?.')){
				document.formDetalle.Opcion.value = 'AprobarLinea';			
				document.formDetalle.submit();				
			}
		}else{
			if(param == 2){
				if(confirm('Desea rechazar la tolerancia de la línea ?.')){
					document.formDetalle.Opcion.value = 'RechazarLinea';
					document.formDetalle.submit();
				}
			}
		}
	}
	function infoOrden(nombreForm){
		paramsURL = "?nombreForm=" + nombreForm;
		open('docsAprobarExcTolerancia-ordeninfo.cfm' + paramsURL, 'Orden','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=420,left=250, top=200,screenX=250,screenY=200');
	}
	function habObjts(){
		document.formDetalle.DDRgenreclamo.disabled=false;
	}
</script>
