<!--- Modificacion: Se agregan los campos TESRPTCid, TESRPTCietu
	Justificacion: Se modifica componente para tomar en cuenta el Concepto de cobro por cambio de IETU
	Fecha: 07/07/2009
	Realizo: ABG --->
<!--- Se agrega el  complemento  INE para el SAT Mayo 2015
      Se Agrega el  Catlogo  de Métodos de PAgo del  SAT Junio 2015
	  Realizó: Israel Rodriguez---->
<cfsetting enablecfoutputonly="yes">
<cfparam name="form.ADDcodigo" default="">
<!---
	Creado por Luis A. Bolaños Gómez
		Fecha: 03/09/2008
		Motivo: Pantalla de Aplicacion de Cotizaciones
--->

<style type="text/css">
.content {
    width: 50%;
    margin: 0px auto;
}

.embed-container {
    height: 0;
    width: 100%;
    padding-bottom: 56.25%;
    overflow: hidden;
    position: relative;
}

.embed-container iframe {
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0;
    left: 0;
}
</style>

<!--- =========================================================== --->
<!--- NAVEGACION --->
<!--- =========================================================== --->
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>

<cfif isDefined("url.pageNum_lista") and len(Trim(url.pageNum_lista)) gt 0>
	<cfset form.pageNum_lista = url.pageNum_lista>
</cfif>
<cfif isDefined("url.sncodigo") and len(Trim(url.sncodigo)) GT 0>
	<cfset form.SNcodigo = url.sncodigo>
</cfif>

<cfparam name="Registros" default="20">
<cfparam name="form.pageNum_lista" default="1">

<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="rsOImpresion" datasource="#session.DSN#">
	select *
    from FAEOrdenImpresion a
    where a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cftry>
	<cfquery name="rsSocioAdenda" datasource="#session.DSN#">
		SELECT 	sa.*, a.ADDnombre
		FROM 	SocioAddenda sa
				INNER JOIN Addendas a
					ON  sa.Ecodigo = a.Ecodigo
					AND sa.ADDcodigo = a.ADDcodigo
		WHERE 	SNcodigo = #rsOImpresion.SNcodigo#
			AND sa.Ecodigo = #session.Ecodigo#
			AND StatusSeleccion = 1
	</cfquery>

	<cfquery name="rsEntidadesFiscales" datasource="#session.DSN#">
		SELECT 	EFcodigo,EFDescripcion
		FROM 	EntidadFiscal
	</cfquery>
<cfcatch>
</cfcatch>
</cftry>

<cfparam name="rsSocioAdenda.ADDnombre"  default="">
<cfparam name="rsSocioAdenda.ADDcodigo"  default="">

<!--- ID de Socio de Negocios --->
<cfquery name="rsIDSocio" datasource="#session.DSN#">
	select SNid,usaINE
    from SNegocios
    where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOImpresion.SNcodigo#">
    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="direcciones" datasource="#session.DSN#">
		select b.id_direccion, coalesce(c.direccion1,'') + ' / ' + coalesce(c.direccion2,'') as texto_direccion
		from SNegocios a
			inner join SNDirecciones b
				on a.SNid = b.SNid
			inner join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
  	    and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsOImpresion.SNcodigo#">
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	Select Mcodigo,Mnombre,Miso4217
	from Monedas m
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
    and Mcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsOImpresion.Mcodigo#">
</cfquery>

<cfquery name="rsRegFiscal" datasource="#Session.DSN#">
	Select codigo_RegFiscal,nombre_RegFiscal
	from FARegFiscal
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
    order by nombre_RegFiscal
</cfquery>


<cfquery name="rsTipoPago" datasource="#Session.DSN#">
	Select codigo_TipoPago,nombre_TipoPago
	from FATipoPago
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
    order by nombre_TipoPago
</cfquery>

<!--- busca los datos de la factura electronica --->
<cfquery name="rsfacele" datasource="#Session.DSN#">
        select foliofacele, factura,ltrim(rtrim(seriefacele)) as seriefacele
          from FAEOrdenImpresion a,         		 FAPreFacturaE b
		 where b.DdocumentoREF = a.OIdocumento
		   and b.CCTcodigoREF = a.CCTcodigo
           and b.TipoDocumentoREF = 1
           and b.Ecodigo = a.Ecodigo
           and a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
</cfquery>

<!--- AQUI EMPIEZA PANTALLA --->
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Facturación">
	<cfinclude template="../../portlets/pNavegacion.cfm">

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Impresión de Documentos'>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr class="AreaFiltro">
		  <td align="center"><strong><font style="font-size:18px">Orden Impresi&oacute;n: #rsOImpresion.OIdocumento# &nbsp; &nbsp; &nbsp; Transacci&oacute;n: #rsOImpresion.CCTcodigo#  &nbsp; &nbsp; &nbsp; Estatus: <cfif rsOImpresion.OIEstado EQ "P"> Preparaci&oacute;n <cfelseif rsOImpresion.OIEstado EQ "I"> Impresión <cfelseif rsOImpresion.OIEstado EQ "R"> Registro Resultados <cfelse> Desconocido </cfif>  </font></strong>
          </td>
		</tr>
		<tr>
			<td>
				<form style="margin: 0" name="form1" action="ProcImprimeDocumentoMFE.cfm" method="post" onsubmit="javascript:alerta();">
					<table width="100%" border="0" cellspacing="2" cellpadding="0">
                <tr>
						  <td colspan="2" ><strong>Cliente</strong></td>
                          <td><strong>Fecha</strong></td>
						</tr>
						<tr>
						  <td colspan="2">
						    	<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="C"  size="55" idquery="#rsOImpresion.SNcodigo#" modificable = "false">
						    	<input name="usaINE" type="hidden" value="#rsIDSocio.usaINE#" />
						  </td>
                          <td>
								<cfset LvarFecha = rsOImpresion.OIfecha>
							  <cfif rsOImpresion.OIEstado EQ "P">
	                                <cf_sifcalendario tabindex="2" form="form1" value="#DateFormat(LvarFecha,'dd/mm/yyyy')#" name="OIfecha" onChange="funcOIdiasvencimiento(this);" onBlur="funcOIdiasvencimiento(this);">
                                <cfelse>
                                <cf_sifcalendario tabindex="2" form="form1" value="#DateFormat(LvarFecha,'dd/mm/yyyy')#" name="OIfecha" readonly = "true">
                              </cfif>
						  </td>
                       </tr>
                       <tr>
       	        		 <td align="left" nowrap="nowrap" colspan="2">
                            	<strong>Direcci&oacute;n de Facturaci&oacute;n</strong>
                         </td>
                            <td align="left"><strong>Moneda</strong></td>
					  </tr>
                        <tr>
                        	<td colspan="2">
								<select style="width:347px" <cfif rsOImpresion.OIEstado NEQ "P"> disabled </cfif> name="id_direccion" id="id_direccion" tabindex="3" onfocus="fncCambioDir(this.id);">
								<option value="">- Niguna -</option>
								<cfloop query="direcciones">
									<option value="#id_direccion#" <cfif id_direccion eq rsOImpresion.id_direccionFact>selected</cfif>> #HTMLEditFormat(texto_direccion)#	</option>
								</cfloop>
								</select>
            				</td>
                            <td>
                            	<input type="text" disabled value="(#rsMonedas.Miso4217#)#HTMLEditFormat(rsMonedas.Mnombre)#" />
                            </td>
        			   </tr>
                       <tr>
        	        		<td align="left" nowrap="nowrap" colspan="2">
                            	<strong>Direcci&oacute;n de Env&iacute;o</strong>
                            </td>
                            <td align="left"><strong>Tipo Cambio</strong></td>
					  </tr>
                        <tr>
                        	<td colspan="2">
								<select style="width:347px" <cfif rsOImpresion.OIEstado NEQ "P"> disabled </cfif> name="id_direccion2" id="id_direccion2" tabindex="4" onfocus="fncCambioDir(this.id);">
								<option value="">- Ninguna -</option>
								<cfloop query="direcciones">
									<option value="#id_direccion#" <cfif id_direccion eq rsOImpresion.id_direccionEnvio>selected</cfif>> #HTMLEditFormat(texto_direccion)#	</option>
								</cfloop>
								</select>
            				</td>
                            <td>
                              <input name="TipoCambio" type="text" id="TipoCambio" value="#LSNumberFormat(rsOImpresion.OItipoCambio,',9.0000')#" style="text-align: right"  size="20" maxlength="10" tabindex="5" onFocus="this.value=qf(this); this.select();" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" <cfif rsMonedaLocal.Mcodigo EQ rsMonedas.Mcodigo or rsOImpresion.OIEstado NEQ "P"> disabled </cfif>>
        			   		</td>
                       </tr>
                       <tr>
		    				<td colspan="2"> </td>
                            <td rowspan="3" align="left" valign="top">
								<table width="95%"  border="0">
					  				<tr>
										<td>
											<fieldset><legend><strong>Vencimiento</strong></legend>
												<table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr>
														<td align="right"><strong>D&iacute;as Vencimiento:</strong></td>
														<td>
															<cf_inputNumber name="OIdiasvencimiento" value="#rsOImpresion.OIdiasvencimiento#" size="20" enteros="4" decimales="0" tabindex="6">
														</td>
													</tr>
													<tr>
														<td align="right"><strong>Fecha Vencimiento:</strong></td>
														<td>
															<cfif rsOImpresion.OIvencimiento NEQ "">
																<cfset LvarVencimiento = rsOImpresion.OIvencimiento>
                                                            <cfelse>
                                                            	<cfset LvarVencimiento = now()>
                                                            </cfif>
															<input name="OIvencimiento" type="text" readonly  size="10" tabindex="-1" value="#LSDateFormat(LvarVencimiento,'dd/mm/yyyy')#">
														</td>
													</tr>
												</table>
											</fieldset>
										</td>
					  				</tr>
							  </table>
							</td>
						</tr>
                        <tr>
                        	<td  colspan="2" valign="bottom"> <strong>Concepto Cobro Terceros</strong> </td>
                        </tr>
                        <tr>
                       		<td  colspan="2" valign="top">
					        	<cfif rsOImpresion.TESRPTCid NEQ "">
                  					<cf_cboTESRPTCid query="#rsOImpresion#" tabindex="7" SNid="#rsIDSocio.SNid#" CxP="no" CxC="yes">
              					<cfelse>
                  					<cfset form.TESRPTCid = "">
                  					<cf_cboTESRPTCid tabindex="7" SNid="#rsIDSocio.SNid#" CxP="no" CxC="yes">
              					</cfif>
            				</td>
                       </tr>
                       <tr>
       					 <td colspan="2"></td>
		    				<td rowspan="3" align="left" valign="top">
								<table width="95%"  border="0">
					  				<tr>
										<td>
											<fieldset><legend><strong>Totales</strong></legend>
												<table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr>
														<td align="right"><strong>Descuento Global:</strong></td>
														<td>
															<input name="Descuento" readonly="true" type="text" id="Descuento" value="#LSNumberFormat(rsOImpresion.OIdescuento,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="8">
														</td>
													</tr>
													<tr>
														<td align="right"><strong>Impuesto:</strong></td>
														<td>
															<input name="Impuesto" readonly="true" type="text" id="Impuesto" value="#LSNumberFormat(rsOImpresion.OIimpuesto,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="9">
														</td>
													</tr>
													<tr>
														<td align="right"><strong>IEPS:</strong></td>
														<td>
															<input name="IEPS" readonly="true" type="text" id="IEPS" value="#LSNumberFormat(rsOImpresion.OIieps,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="9">
														</td>
													</tr>
													<tr>
														<td align="right"><strong>Total:</strong></td>
														<td>
															<input readonly="true" name="Total" type="text" id="Total" value="#LSNumberFormat(rsOImpresion.OItotal,',9.00')#" style="text-align: right" size="20" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="10">
														</td>
													</tr>
												</table>
											</fieldset>
										</td>
					  				</tr>
							  </table>
						 </td>
						</tr>
                       	<tr>
                    		<td align="left" valign="top"><strong>Observaciones:</strong></td>
                       	</tr>
                       	<tr>
							<td  valign="top">
                            	<textarea tabindex="11" name="Observaciones" cols="50" rows="4" id="textarea" <cfif rsOImpresion.OIEstado NEQ "P"> disabled </cfif>>#rsOImpresion.OIObservacion#</textarea>
                            </td>
                       	</tr>
<!---                       	<tr> </tr>
                       	<tr> </tr>
--->
						<tr>
                        	<td width="100%" colspan="3">
                            	<table border="0" width="100%">
                                	<tr>
                                        <td align="left" nowrap="nowrap" width="25%">
                                            <strong>Tipo de Pago</strong>
                                        </td>
                                        <td align="left" width="25%">
                                        <select name="TipoPago" id="TipoPago" tabindex="12" onchange="alert('Debe Guardar antes de Generar FE')">
                                        	<option value="">- Selecionar Tipo Pago -</option>
                                            <cfloop query="rsTipoPago">
                                              <option value="#rsTipoPago.codigo_TipoPago#" <cfif isdefined("rsOImpresion") and rsOImpresion.codigo_TipoPago EQ rsTipoPago.codigo_TipoPago>selected</cfif>>#HTMLEditFormat(rsTipoPago.nombre_tipopago)#</option>
                                            </cfloop>
                                        </select>
                                        </td>
                                	</tr>
                                    <tr>
                                    	<td align="left" nowrap="nowrap" width="25%">
                                            <strong>Cuenta</strong>
                                        </td>
                                    	<td align="left"  width="25%">
                                        	<input type="text" name="cuentaB"  onchange="alert('Debe Guardar antes de Generar FE')" value="#rsOImpresion.Cta_tipoPago#"/>
                                    	</td>
                                    	                                        <td style="width: 100%;">&nbsp;</td>
                                        <!--- Genera FE --->
                                        <td align="right" colspan="3" nowrap="nowrap">
                                    		<cfif #rsfacele.factura# eq 1>
                                        		<input type="checkbox"  name="factura" id="factura" checked="checked" disabled/>
                                    		<cfelse>
                                        		<input type="checkbox"  name="factura" id="factura"  <cfif rsfacele.factura GT 0> checked="checked" </cfif>/>
                                    		</cfif>
                                    		<strong> Desea generar Factura Electr&oacute;nica</strong>
                                    	</td>
                                    </tr>
                                    <tr>
                                    	<td align="left" nowrap="nowrap" width="25%">
                                            <strong>R&eacute;gimen Fiscal</strong>
                                        </td>
                                        <td align="left" width="25%">
                                        <select name="RegFisc" id="RegFisc" tabindex="13" onchange="alert('Debe Guardar antes de Generar FE')">
                                        	<option value="">- Seleccionar R&eacute;gimen Fiscal -</option>
                                            <cfloop query="rsRegFiscal">
                                              <option value="#rsRegFiscal.codigo_RegFiscal#" <cfif isdefined("rsOImpresion") and rsOImpresion.codigo_RegFiscal EQ rsRegFiscal.codigo_RegFiscal>selected</cfif>>#HTMLEditFormat(rsRegFiscal.nombre_RegFiscal)#</option>
                                            </cfloop>
                                        </select>
                                        </td>
										<!--- ADENDA CHECK --->
										<td></td>
                                    <td align="left" colspan="3" nowrap="nowrap">
                                    	<cfif #rsfacele.factura# eq 1>
                                       		<input type="checkbox"  name="addenda" id="addenda" checked="checked" disabled/>
                                    	<cfelse>
                                    		<input type="checkbox"  name="addenda" id="addenda" onchange="adenda()" <cfif rsfacele.factura GT 0> checked="checked" </cfif> />
                                    	</cfif>
                                    	<strong> Desea agregar una adenda</strong>
                                    </td>
                                    </tr>
                             <cfif rsOImpresion.OIEstado EQ 'I'>
                               	<!---<cf_soinprintdocs_object FMT01COD="#rsOImpresion.FormatoImpresion#" OImpresionID="#rsOImpresion.OImpresionID#">--->
                             </cfif>

                             <cfif rsOImpresion.OIEstado EQ 'R' or rsOImpresion.OIEstado EQ 'P'>
                             	<tr>
                                   	<td colspan="1" align="Left" nowrap="nowrap">
                                       	<strong> Folio Factura Electr&oacute;nica</strong>
                                    </td>
                                	<td colspan="1" align="Left">
                                       	<input type="text" name="DocCxC" id="DocCxC" <cfif #rsfacele.foliofacele# gt 0> value="#trim(rsfacele.seriefacele)##trim(rsfacele.foliofacele)#"</cfif> size="36" maxlength="20"/>
                                    </td>
                                    <td></td><td style="width:65px;"><div id="aden">Addendas:</div>
                                    <td>
									<!--- ADENDA SELECT --->
									<select name="ADDcodigo" id="ADDcodigo" onchange="adendaFrame()">
										<option value="-1">-- Seleccionar --</option>
										<cfif len(rsSocioAdenda.ADDcodigo)>
											<cfloop query="rsSocioAdenda">
            									<cfoutput><option value="#rsSocioAdenda.ADDcodigo#" >#rsSocioAdenda.ADDnombre#</option></cfoutput>
          									</cfloop>
										</cfif>
									</select>
									</td>
								</td>
								</tr>
								<cfif isdefined("rsIDSocio.usaINE") and rsIDSocio.usaINE eq 1>
								<tr>
									<td align="left" colspan="2">
										<fieldset><legend><strong>Complemento INE</strong></legend>
											<table width="100%" border="0" cellpadding="0" cellspacing="0">
												<tr>
													<td align="right"><strong>Tipo Proceso:</strong></td>
													<td>
														<select name="OITipoProcesoINE" id="OITipoProcesoINE" onchange="toggle_comiteAmbito()" required>
															<option value="">-- Seleccionar --</option>
															<option value="Ordinario" <cfif isdefined("rsOImpresion") and rsOImpresion.OITipoProcesoINE EQ 'Ordinario'>selected</cfif>>Ordinario</option>
															<option value="Precampa&ntilde;a" <cfif isdefined("rsOImpresion") and rsOImpresion.OITipoProcesoINE EQ 'Precampaña'>selected</cfif>>Precampa&ntilde;a</option>
															<option value="Campa&ntilde;a" <cfif isdefined("rsOImpresion") and rsOImpresion.OITipoProcesoINE EQ 'Campaña'>selected</cfif>>Campa&ntilde;a</option>
														</select>
													</td>
												</tr>
												<tr id="trOIComiteAmbito" style="display:<cfif isdefined("rsOImpresion") and rsOImpresion.OITipoProcesoINE EQ ''>none</cfif>">
													<td id="tdTipoComite" align="right"
														style="display:<cfif isdefined("rsOImpresion") and (rsOImpresion.OITipoProcesoINE EQ '' or rsOImpresion.OITipoProcesoINE NEQ 'Ordinario')>none</cfif>"
													>
														<strong>Tipo Comit&eacute;:</strong>
													</td>
													<td id="tdAmbito" align="right"
														style="display:<cfif isdefined("rsOImpresion") and (rsOImpresion.OITipoProcesoINE EQ '' or rsOImpresion.OITipoProcesoINE EQ 'Ordinario')>none</cfif>"
													>
														<strong>Ambito:</strong>
													</td>
													<td>
														<select name="OIComiteAmbito" id="OIComiteAmbito" onchange="toggle_claveEntidad()">

														</select>
													</td>
												</tr>
												<tr id="trOIEntidad" style="display:none">
													<td align="right"><strong>Clave Entidad:</strong></td>
													<td>
														<select name="OIEntidad" id="OIEntidad">
															<option value="">-- Seleccionar --</option>
															<cfloop query="rsEntidadesFiscales">
				            									<cfoutput>
					            									<option value="#rsEntidadesFiscales.EFcodigo#"
					            										<cfif isdefined("rsOImpresion") and rsOImpresion.OIEntidad EQ rsEntidadesFiscales.EFcodigo>selected</cfif>
					            									>#rsEntidadesFiscales.EFcodigo# - #rsEntidadesFiscales.EFDescripcion#
																	</option>
																</cfoutput>
				          									</cfloop>
														</select>
													</td>
												</tr>
												<tr>
													<td align="right"><strong>ID Contabilidad:</strong></td>
													<td>
														<input type="text" name="OIIdContabilidad" id="OIIdContabilidad"
															value="#rsOImpresion.OIIdContabilidadINE#" size="38" maxlength="150"
															onkeyup="valid(this,'NumerosYcomas')"
														/>
													</td>
												</tr>
											</table>
										</fieldset></td>
									<td>&nbsp;</td>
								</tr>
								</cfif>
                                 <tr>
                                   	<td align="center" colspan="3">

                                	    <input type="hidden" name="ErrorDoc" id="ErrorDoc" value="0"/>
                                    	<!---
										<input type="checkbox" name="ErrorDoc" id="ErrorDoc" value="0"/>
										<strong> No se Imprimio Ningun Documento</strong>
										--->
                                    </td>
                                </tr>
                                <tr>
                                	<td colspan="4">&nbsp;</td>
                                </tr>
                                <tr>
                                	<td colspan="4">&nbsp;</td>
                                </tr>
                                <tr>
                              		<!---<td colspan="3" align="center"><input type="submit" name="Copia" value="Imprimir Copia" onclick="javascript:funCopia()" />--->
                                    <td colspan="3" align="center"><input type="hidden" name="Copia" value="Imprimir Copia" onclick="javascript:funCopia()" />
                              		  <input type="submit" name="Facele" value="Genera FE" onclick="javascript:funFE()" />
                                    <cfif rsfacele.foliofacele gt '0'>
                                 <!---   <input type="text" name="FolioFac" value="#rsfacele.foliofacele#" readonly = "false"/>  --->
                                    <input type="submit" name="impFacele" value="Envia FE" onclick="javascript:impfunFE()" />
                                    <input type="submit" name="Registra" value="Registrar Resultado" onclick="javascript:funRegistra()">
                                    </cfif>
                             		</cfif>
                                          	<input type="hidden" name="OImpresionID" id="OImpresionID" value="#rsOImpresion.OImpresionID#"/>
                                            <input type="hidden" name="modo" id="modo" value="nada" />
                                			<cfif rsOImpresion.OIEstado EQ 'P' or rsOImpresion.OIEstado EQ 'R'>
                                            	<input type="submit" name="Guardar" value="Guardar" onclick="javascript:funGuarda()">
<!---                                            <cfelseif rsOImpresion.OIEstado EQ 'R' or rsOImpresion.OIEstado EQ 'P'> --->
                                           		<input type="hidden" name="CCTcodigo" value="#rsOImpresion.CCTcodigo#" />
                                      <!---     		<cfif rsfacele.foliofacele gt '0'>
                                                <input type="submit" name="Registra" value="Registrar Resultado" onclick="javascript:funRegistra()">
                                               </cfif>    --->
											</cfif>


                            			<cfif rsOImpresion.OIEstado EQ 'P'>

                                        	<input type="submit" name="CancelaOI" value="Cancelar Orden de Impresi&oacute;n" onclick="javascript:funCancelaOI()">

                                 <!---       <td align="left"><input type="submit" name="Imprime" value="Iniciar Impresión" onclick="javascript:funImprime()" /></td> --->
                                           <input type="hidden" name="Imprime" value="Iniciar Impresi&oacute;n" onclick="javascript:funImprime()" />
                                        </cfif>
                                        <td colspan="3" <cfif rsOImpresion.OIEstado EQ 'I'> align="center" <cfelse> align="center" </cfif>>
                            				<input type="submit" name="Regresa" value="Lista Ordenes" onclick="javascript:funRegresa()">
                            			</td>
                                    </tr>
                               	</table>
                            </td>
						</tr>
				  </table>
				</form>
                </cfoutput>
			<!--- FORM PARA FILTRO DE SOCIOS DE NEGOCIOS --->
			</td>
		  </tr>
		<cfoutput>
			<tr>
				<td align="right">
					<table id="trAddenda" style="display:none;" border="0">
						<tr>
						<td colspan="7">
						<iframe id="frameAddenda" src="formAddenda.cfm?ADDcodigo=#form.ADDcodigo#" allowfullscreen style="width: 963px; border: none; height: 200px; ">
							<p>Your browser does not support iframes.</p>
						</iframe>
						</td>
						<tr>
					</table>
				</td>
			</tr>
    	  <!---<tr>
            <td  align="center" nowrap="nowrap" bgcolor="CCCCCC">
            	<strong>
                	<font style="font-size:17px"> Detalles Orden de Impresión  </font>
                </strong>
            </td>
		  </tr>--->
          <tr>
			<td>
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
					tabla="FAEOrdenImpresion a
                       		inner join FADOrdenImpresion b
								on b.OImpresionID = a.OImpresionID
								and b.Ecodigo = a.Ecodigo"
					columnas="a.OImpresionID, b.OIDetalle, b.ItemTipo, b.OIDdescripcion, b.OIDdescnalterna, b.OIDtotal, b.OIDdescuento, b.Icodigo, b.OIMontoIEPSLinea"
					desplegar="OIDetalle, ItemTipo, OIDdescripcion, OIDdescnalterna, OIDdescuento, OIMontoIEPSLinea, Icodigo, OIDtotal"
					etiquetas="L&iacute;nea, Tipo, Descripci&oacute;n, Descripci&oacute;n Alterna, Descuento, IEPS, IVA, Total"
					formatos="I,S,S,S,M,M,S,M"
					filtro= "a.OImpresionID = #form.OImpresionID#"
					align="left, left, left, left, right, right, right, right"
					checkboxes="N"
					ira="ProcImprimeDocumentoMFE.cfm"
					MaxRows="#Registros#"
                       showlink = "false">
				</cfinvoke>
			</td>
		  </tr>
        </table>
        <br />
        <br />
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td  align="center" nowrap="nowrap" bgcolor="00CCFF">
            	<strong>
                	<font style="font-size:17px"> Pre-Facturas Relacionadas  </font>
                </strong>
            </td>
		  </tr>
          <tr>
			<cfflush interval="64">
			<td>
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
						tabla="FAEOrdenImpresion a
                        		inner join FAPreFacturaE b
									on b.DdocumentoREF = a.OIdocumento
									and b.CCTcodigoREF = a.CCTcodigo
                                    and b.TipoDocumentoREF = 1
                                    and b.Ecodigo = a.Ecodigo"
						columnas="OImpresionID,PFDocumento, PFTcodigo, Descuento, FAieps, Impuesto, Total"
						desplegar="PFDocumento, PFTcodigo, Descuento, FAieps, Impuesto, Total"
						etiquetas="Documento, Transaccion, Descuento, IEPS, IVA, Total"
						formatos="S,S,M,M,M,M"
						filtro= "a.OImpresionID = #form.OImpresionID#"
						align="left, left, right, right, right, Right"
						checkboxes="N"
						ira="ProcImprimeDocumentoMFE.cfm"
						MaxRows="#Registros#"
                        showlink = "false">
					</cfinvoke>
			</td>
		  </tr>
	</table>
	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/fechas.js"></script>
<script type="text/javascript" src="/jquery/librerias/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>

<cf_qforms form="form1" objForm="objForm">
<script type="text/javascript">

	// Solo permite ingresar numeros y comas
	var r=
	{
		'special':/[\W]/g,
		'quotes':/['\''&'\"']/g,
		'noNumeros':/[^\d]/g,
		'NoLestras':/[A-Za-z]/g,
		'NumerosYcomas':/[^\d,]/g,
	}

	function valid(o,w)
	{
			o.value = o.value.replace(r[w],'');
	}


	function adenda(){
		if( document.form1.addenda.checked == true){
			$('#ADDcodigo').show('fast');
			// $('#aden').show('slow');
			// document.form1.ADDcodigo.style.display = "block";
			document.getElementById("aden").style.display = "block";
			if (document.getElementById('ADDcodigo').value != -1)
				toggleTrAddenda();
		}else{
			document.form1.ADDcodigo.style.display = "none";
			document.getElementById("aden").style.display = "none";
			toggleTrAddenda();
		}
	};
	adenda();
	function toggleTrAddenda(){
		if( document.form1.addenda.checked == true)
			$('#trAddenda').show('slow');
			// document.getElementById("trAddenda").style.display = "block";
		else
			$('#trAddenda').hide('fast');
			// document.getElementById("trAddenda").style.display = "none";
	};
	function setIframeHeight() {
		var iframe = document.getElementById("frameAddenda");
	    if (iframe) {
	        var iframeWin = iframe.contentWindow || iframe.contentDocument.parentWindow;
	        if (iframeWin.document.body) {
	            iframe.height = iframeWin.document.documentElement.scrollHeight || iframeWin.document.body.scrollHeight;
	        }
	    }
	};
	function adendaFrame(){
		if (document.getElementById('ADDcodigo').value != -1){
			document.getElementById('frameAddenda').src = "formAddenda.cfm?ADDcodigo="+document.getElementById('ADDcodigo').value;
			setIframeHeight();
			toggleTrAddenda();
		}
	};
<cfoutput>
	<cfif isdefined("rsIDSocio.usaINE") and rsIDSocio.usaINE eq 1>
		<cfif isdefined("rsOImpresion") and rsOImpresion.OITipoProcesoINE EQ 'Ordinario'>
			$('##tdTipoComite').show();
				$('##tdAmbito').hide();
				$('##OIComiteAmbito')
				    .find('option')
				    .remove()
				    .end()
				    .append('<option value="Ejecutivo Nacional">Ejecutivo Nacional</option>')
				    .append('<option value="Ejecutivo Estatal">Ejecutivo Estatal</option>')
				    .val('#rsOImpresion.OIComiteAmbito#');
			<cfif isdefined("rsOImpresion") and rsOImpresion.OIComiteAmbito EQ 'Ejecutivo Estatal'>
				$('##trOIEntidad').show();
			<cfelse>
				$('##trOIEntidad').hide();
			</cfif>
		<cfelse>
			$('##tdTipoComite').hide();
				$('##tdAmbito').show();
				$('##OIComiteAmbito')
				    .find('option')
				    .remove()
				    .end()
				    .append('<option value="Federal">Federal</option>')
				    .append('<option value="Local">Local</option>')
				    .val('#rsOImpresion.OIComiteAmbito#');
			<cfif isdefined("rsOImpresion") and (rsOImpresion.OIComiteAmbito EQ 'Local' or rsOImpresion.OIComiteAmbito EQ 'Federal')>
				$('##trOIEntidad').show();
			<cfelse>
				$('##trOIEntidad').hide();
			</cfif>
		</cfif>
	</cfif>
</cfoutput>
	function toggle_comiteAmbito(){
		var vOITipoProcesoINE = document.getElementById('OITipoProcesoINE').value;
		if (vOITipoProcesoINE != ''){
			$('#trOIComiteAmbito').show();
			if ( vOITipoProcesoINE == 'Ordinario' ) {
				$('#tdTipoComite').show();
				$('#tdAmbito').hide();
				$('#OIComiteAmbito')
				    .find('option')
				    .remove()
				    .end()
				    .append('<option value="Ejecutivo Nacional">Ejecutivo Nacional</option>')
				    .append('<option value="Ejecutivo Estatal">Ejecutivo Estatal</option>')
				    .val('Ejecutivo Nacional');
			}
			else {
				$('#tdTipoComite').hide();
				$('#tdAmbito').show();
				$('#OIComiteAmbito')
				    .find('option')
				    .remove()
				    .end()
				    .append('<option value="Federal">Federal</option>')
				    .append('<option value="Local">Local</option>')
				    .val('Federal');
			}
		}
		else{
			$('#trOIComiteAmbito').hide();
		}
		toggle_claveEntidad();
	}
	function toggle_claveEntidad(){
		var vclaveEntidad = document.getElementById('OIComiteAmbito').value;
		var vOITipoProcesoINE = document.getElementById('OITipoProcesoINE').value;
		if ( vclaveEntidad == 'Ejecutivo Estatal' || vOITipoProcesoINE == 'Ejecutivo Campaña' || (vOITipoProcesoINE == 'Precampaña' || vOITipoProcesoINE == 'Campaña')) {
			$('#trOIEntidad').show();
		}
		else{
			$('#trOIEntidad').hide();
		}

	}
<cfoutput>
	function PopUp(){

            // Open the new window with ID selector.
            // Pass PopUpHandler() as the data handler
            // to which the popup will broadcast its'
            // data selection.
            window.open(
                "./formAddenda.cfm?data_handler=PopUpHandler&ADDcodigo=#form.ADDcodigo#",
                "",
                "width=300,height=300"
                );

            void( 0 );
        }
</cfoutput>

        function PopUpHandler( strIDs ){
            var objIDList = document.forms[ 0 ].lst_id;

            // Set the ID list.
            objIDList.value = (
                objIDList.value +
                (objIDList.value.length > 0 ? "," : "" ) +
                strIDs
                );
        }



  var _iframe = parent.document.getElementById("frameAddenda"),
      _height = _iframe.contentDocument.getElementById("size").scrollHeight || _iframe.contentWindow.document.getElementById("size").scrollHeight;
      _iframe.height = _height + 40;

</script>
<script language="JavaScript1.2">
	function funGuarda()
	{
		document.form1.modo.value = "GUARDA";
	}
	function funRegresa()
	{
		objForm.TipoPago.required = false;
		document.form1.modo.value = "regresa";
		document.form1.OImpresionID.value = "";
		document.form1.SNcodigo.value = "";
	}
	function funImprime()
	{
		document.form1.modo.value = "IMPRIME";
	}
	function funCancelaOI()
	{
		if (confirm("¿Est&aacute; seguro de que desea Cancelar la Orden de Impresi&oacute;n?")) {
			document.form1.modo.value = "CANCELAOI";
			objForm.TipoPago.required = false;
			objForm.RegFisc.required = false;
			return true;
			}
		else {
			return false;
			}
	}
	function funRegistra()
	{
		if(document.form1.ErrorDoc.checked == true)
			objForm.DocCxC.required = false;
		document.form1.modo.value = "REGISTRA";
	}
	function funCopia()
	{
		objForm.DocCxC.required = false;
		document.form1.modo.value = "COPIA";
	}
		function funFE()
	{
		if (confirm("¿Está seguro de que desea Generar El Folio de Factura Electrónica?")) {
			objForm.DocCxC.required = false;
			document.form1.modo.value = "FacEle";
			}
		else {
			return false;
			}

	}
		function impfunFE()
	{

		objForm.DocCxC.required = false;
		document.form1.modo.value = "impFacEle";

		return false;

	}
		objForm.TipoPago.required = true;
		objForm.TipoPago.description = "Tipo de Pago";

		objForm.RegFisc.required = true;
		objForm.RegFisc.description = "Régimen Fiscal";


	function validaMon(){
		document.form1.OIdiasvencimiento.value = qf(document.form1.OIdiasvencimiento.value);
	}
	<cfoutput>
	function funcOIdiasvencimiento() {
		if (document.form1.OIfecha.value != ''){
			document.form1.OIvencimiento.value = dateadd(qf(document.form1.OIdiasvencimiento.value),document.form1.OIfecha.value); //document.form1.OIfecha.value;
			}else{
				alert('Debe de digitar una la fecha del Documento.');
				return false;
			}
		}
	</cfoutput>
	<cfif rsOImpresion.OIEstado EQ 'R'>
		objForm.DocCxC.required = true;
	</cfif>
</script>