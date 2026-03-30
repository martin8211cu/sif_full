<!--- Modificacion: Se agregan los campos TESRPTCid, TESRPTCietu
	Justificacion: Se modifica componente para tomar en cuenta el Concepto de cobro por cambio de IETU
	Fecha: 07/07/2009
	Realizo: ABG --->
<!--- Se agrega el  complemento  INE para el SAT Mayo 2016
      Se Agrega el  Catlogo  de Métodos de PAgo del  SAT Junio 2016
	  Se configura el  RFC Generico para Socios Extranjeros 11OCT2016
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


<!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
<cfquery name="rsPCodigoOBJImp" datasource = "#Session.DSN#">
select Pvalor 
from Parametros
where Pcodigo = '17200'
and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset value = "#rsPCodigoOBJImp.Pvalor#">

<!-- Fin Querys AFGM-SPR -->


<cftry>
	<cfquery name="rsVencVentasSN" datasource="#session.DSN#">
		select isnull(SNvenventas,0) as VencVentas 
		from SNegocios
			WHERE 	SNcodigo = #rsOImpresion.SNcodigo#
				AND Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="rsSocioAdenda" datasource="#session.DSN#">
		SELECT 	sa.*, a.ADDnombre, a.ADDcodigo, a.ADDid
		FROM 	SocioAddenda sa
				INNER JOIN Addendas a
					ON  sa.Ecodigo = a.Ecodigo
					AND sa.ADDcodigo = a.ADDcodigo
		WHERE 	SNcodigo = #rsOImpresion.SNcodigo#
			AND sa.Ecodigo = #session.Ecodigo#
			AND StatusSeleccion = 1
	</cfquery>

    <cfset idAddendaAsociada = -1>
	<cfif rsSocioAdenda.recordCount gt 0>
	    <cfset idAddendaAsociada = rsSocioAdenda.ADDid>
	</cfif>

	<cfquery name = "rsAddendasDetalles" datasource = "#session.DSN#">
	    select * from AddendasDetalle
		where ADDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#idAddendaAsociada#">
		and TIPO = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROMPT">
	</cfquery>

	<cfquery name="rsEntidadesFiscales" datasource="#session.DSN#">
		SELECT 	EFcodigo,EFDescripcion
		FROM 	EntidadFiscal
	</cfquery>
<cfcatch>
	<cfthrow message="ERROR: #cfcatch.message# #cfcatch.Detail# ">
</cfcatch>
</cftry>

<!--- ID de Socio de Negocios --->
<cfquery name="rsIDSocio" datasource="#session.DSN#">
	select SNid,usaINE
    from SNegocios
    where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOImpresion.SNcodigo#">
    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsRegimen" datasource="#session.DSN#">
	select IdRegimenFiscal, SNnombreFiscal
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
	Select codigo_RegFiscal,nombre_RegFiscal,ClaveSAT
	from FARegFiscal
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
    order by nombre_RegFiscal
</cfquery>

<cfquery name="rsTipoPago" datasource="#Session.DSN#">
	Select codigo_TipoPago,nombre_TipoPago,TipoPagoSAT
	from FATipoPago
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
    order by nombre_TipoPago
</cfquery>

<cfif value eq "4.0">
	<cfquery name="rsUsoCFDI" datasource="#Session.DSN#">
		select d.CSATcodigo as c_UsoCFDI, d.CSATdescripcion as Descripcion 
		from CSATUsoComp a 
		inner join CSATUsoCFDI d on d.IdUsoCFDI = a.idUsoCfdi
		inner join SNegocios c on c.IdRegimenFiscal = a.idRegFisc
		where c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsOImpresion.SNcodigo#">
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfelse>	
	<cfquery name="rsUsoCFDIv2" datasource="#Session.DSN#">
		select  CSATcodigo as c_UsoCFDI, CSATdescripcion as Descripcion from CSATUsoCFDI
	</cfquery>
</cfif>


<cfquery name="rsMetPago" datasource="sifcontrol">
	select  CSATcodigo as Codigo, CSATdescripcion as Descripcion from CSATMetPago
</cfquery>

<!--- busca los datos de la factura electronica --->
<cfquery name="rsfacele" datasource="#Session.DSN#">
        select foliofacele, factura,ltrim(rtrim(seriefacele)) as seriefacele,b.NumOrdenCompra,b.PFDocumento,c.PFTtipo
          from FAEOrdenImpresion a, FAPreFacturaE b, FAPFTransacciones c  
		 where b.DdocumentoREF = a.OIdocumento
		   and b.CCTcodigoREF = a.CCTcodigo
           and b.TipoDocumentoREF = 1
           and b.Ecodigo = a.Ecodigo
           and b.Ecodigo = c.Ecodigo and b.PFTcodigo = c.PFTcodigo
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
					<cf_loadingSIF>
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
															<cf_inputNumber name="OIdiasvencimiento" value="#rsVencVentasSN.VencVentas#" size="20" enteros="4" decimales="0" tabindex="6">
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
                        	<td  colspan="2" valign="bottom"> <strong>Orden de Compra</strong>:
                        	<cfif rsfacele.NumOrdenCompra NEQ "">
                  				<strong>#rsfacele.NumOrdenCompra#</strong>
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
									<!---<cfif session.Ecodigo EQ 3>
									<tr>
                                        <td align="left" nowrap="nowrap" width="25%">
                                            <strong>Empresa que Factura:</strong>
										</td>
										<td align="left" width="25%">
                                        <select name="EmpFact" id="EmpFact" tabindex="12">
                                        	<option value="">- Selecionar Empresa -</option>
                                            <option value=1>Clear Channel Outdoor Mexico S.A. de C.V.</option>
                                            <option value=2>OUTDOOR MEXICO SERVICIOS PUBLICITARIOS S. DE R.L. DE C.V.</option>
										</select>
                                        </td>
									</tr>
									</cfif>	--->
                                	<tr>
                                        <td align="left" nowrap="nowrap" width="25%">
                                            <strong>Forma de Pago</strong>
                                        </td>
                                        <td align="left" width="25%">
                                        <select name="TipoPago" id="TipoPago" tabindex="12" onchange="setMpago();">
                                        	<option value="">- Selecionar Forma de Pago -</option>
                                            <cfloop query="rsTipoPago">
                                              <option value="#rsTipoPago.codigo_TipoPago#" <cfif isdefined("rsOImpresion") and rsOImpresion.codigo_TipoPago EQ rsTipoPago.codigo_TipoPago>selected</cfif>>#HTMLEditFormat(rsTipoPago.nombre_tipopago)#</option>
                                            </cfloop>
                                        </select>
                                        </td>
                                	</tr>
                                    <tr>
                                    	<td align="left" nowrap="nowrap" width="25%">
                                            <strong>Uso CFDI</strong>
                                        </td>
                                    	<!---<td align="left"  width="25%">
                                        	<input type="text" name="cuentaB"  onchange="alert('Debe Guardar antes de Generar FE')" value="#rsOImpresion.Cta_tipoPago#"/>
                                    	</td>--->
										
										<cfif value eq "4.0">
											<cfset usoCFDI = rsUsoCFDI.c_UsoCFDI>
											<td align="left" width="25%">
												<select name="UsoCFDI" id="UsoCFDI" tabindex="12" >
													<option value="">- Selecionar Uso del CFDI -</option>
													<cfloop query="rsUsoCFDI">
													<option value="#rsUsoCFDI.c_UsoCFDI#" <cfif isdefined("rsOImpresion") and rsOImpresion.Cta_tipoPago EQ rsUsoCFDI.c_UsoCFDI>selected</cfif>>#HTMLEditFormat(rsUsoCFDI.descripcion)#</option>
													</cfloop>
													
												</select>
											
												<cfif rsRegimen.IdRegimenFiscal eq ''>
													<strong> <br><p style="color:red;"> Su cliente no cuenta con Regimen Fiscal </p></strong>
												</cfif>
												<cfif rsRegimen.SNnombreFiscal eq ''>
													<strong> <br><p style="color:red;"> Su cliente no cuenta con Nombre Fiscal </p></strong>
												</cfif>
												
											</td>

										<cfelseif value eq "3.3">
											
											<cfset usoCFDI = rsUsoCFDIv2.c_UsoCFDI>
											<td align="left" width="25%">
											<select name="UsoCFDI" id="UsoCFDI" tabindex="12" >
													<option value="">- Selecionar Uso del CFDI -</option>
													<cfloop query="rsUsoCFDIv2">
													<option value="#rsUsoCFDIv2.c_UsoCFDI#" <cfif isdefined("rsOImpresion") and rsOImpresion.Cta_tipoPago EQ rsUsoCFDIv2.c_UsoCFDI>selected</cfif>>#HTMLEditFormat(rsUsoCFDIv2.descripcion)#</option>
													</cfloop>
													
												</select>
												<input name="IdIngresa" id="IdIngresa" type="hidden" value="INGRESA SOCIO NEGOCIO">
											
											</td>
										<!---	
										<cfelseif value eq "3.3">
											<cfif rsRegimen.IdRegimenFiscal eq ''>
											<td align="left" width="25%">
												<select name="UsoCFDI" id="UsoCFDI" tabindex="12" >
													<option value="">- Selecionar Uso del CFDI -</option>
													<cfloop query="rsUsoCFDI">
													<option value="#rsUsoCFDI.c_UsoCFDI#" <cfif isdefined("rsOImpresion") and rsOImpresion.Cta_tipoPago EQ rsUsoCFDI.c_UsoCFDI>selected</cfif>>#HTMLEditFormat(rsUsoCFDI.descripcion)#</option>
													</cfloop>
													
												</select>
													<input name="IdIngresa" id="IdIngresa" type="hidden" value="INGRESA SOCIO NEGOCIO">
													<strong> <br><p style="color:red;">  Su cliente no cuenta con Regimen Fiscal </p></strong>
												<cfelse>
											<td align="left" width="25%">
											<select name="UsoCFDI2" id="UsoCFDI2" tabindex="12" >
												<option value="">- Selecionar Uso del CFDI -</option>
												<cfloop query="rsUsoCFDIv2">
												<option value="#rsUsoCFDIv2.c_UsoCFDI#">#HTMLEditFormat(rsUsoCFDIv2.Descripcion)#</option>
												</cfloop>
											</select>
												<input name="IdIngresa" id="IdIngresa" type="hidden" value="INGRESA SOCIO NEGOCIO">
											</cfif>
											</td>
											--->
										</cfif>

										<td style="width: 100%;">&nbsp;</td>
                                        <!--- Genera FE --->
                                        <td align="left" colspan="3" nowrap="nowrap">
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
                                            <strong>Metodo de Pago</strong>
                                        </td>
                                    	<!---<td align="left"  width="25%">
                                        	<input type="text" name="cuentaB"  onchange="alert('Debe Guardar antes de Generar FE')" value="#rsOImpresion.Cta_tipoPago#"/>
                                    	</td>--->
										<td align="left" width="25%">
										<input type="hidden"  name="metPago" id="metPago" value="<cfif isdefined("rsOImpresion")>#rsOImpresion.c_metPago#</cfif>"/>
                                        <select name="metPagoS" id="metPagoS" tabindex="12" onchange="" disabled="disabled">
                                        	<option value="">- Seleciona un Metodo de Pago -</option>
                                        	<cfloop query="rsmetPago">
                                              <option value="#rsMetPago.codigo#" <cfif isdefined("rsOImpresion") and rsOImpresion.c_metPago EQ rsMetPago.codigo>selected</cfif>>#HTMLEditFormat(rsMetPago.descripcion)#</option>
                                            </cfloop>
                                        </select>
                                        </td>
										<!--- <td style="width: 100%;">&nbsp;</td> --->
										<td>&nbsp;</td>
										<!--- Sustitución de facturas RDF 070322--->
										<cfquery name="rsDocsRel" datasource="#session.dsn#">
											SELECT DocumentoRelacionado,
											       c.Dsaldo,
											       dr.TimbreDocRel,
											       dr.OImpresionID,
											       '<img width = "18px" height = "18" border="0" src="/cfmx/sif/imagenes/delete.small.png" title="Eliminar" style="cursor:pointer" onclick = "javascript:eliminarDoc(' + cast(dr.IdCFDIRel as varchar) +','+  cast(dr.OImpresionID as varchar) +');"/>' AS Eliminar
											FROM FA_CFDI_Relacionado dr
											INNER JOIN Documentos c ON dr.DocumentoRelacionado = c.Ddocumento
											WHERE c.Ecodigo = #session.Ecodigo#
											AND dr.OImpresionID = #form.OImpresionID#
										</cfquery>

										<cfif value eq '4.0'>
											<cfif IsDefined('rsOImpresion')>																
												<td align="left" colspan="3" nowrap="nowrap">												
													<cfif #rsfacele.factura# eq 1>
														<!--- <input type="checkbox" onChange="sust: funcST(this.checked);"  name="sust" id="sust" checked="checked" disabled/>--->
														<input type="checkbox" name="sust" id="sust" value="checkbox" onclick="javascript:funcSust(this.checked);" <cfif rsOImpresion.OIsustitucion EQ 1 and rsOImpresion.OItipoRel neq '07'> checked</cfif>>
													<cfelse>
														<input type="checkbox" onclick="javascript:funcSust(this.checked);" name="sust" id="sust"  <cfif rsOImpresion.OIsustitucion EQ 1 and rsOImpresion.OItipoRel neq '07'> checked</cfif>>
													</cfif>
													<strong> Sustituci&oacute;n de Facturas</strong>
												</td>
											</cfif>
										</cfif>

									</tr>
									
									<tr>
                                    	<td align="left" nowrap="nowrap" width="25%">
                                            <!---<strong>R&eacute;gimen Fiscal</strong>--->
                                        </td>
                                        <td align="left" width="25%">
                                        <!---<select name="RegFisc" id="RegFisc" tabindex="13" onchange="alert('Debe Guardar antes de Generar FE')">
                                        	<option value="">- Seleccionar R&eacute;gimen Fiscal -</option>
                                            <cfloop query="rsRegFiscal">
                                              <option value="#rsRegFiscal.codigo_RegFiscal#" <cfif isdefined("rsOImpresion") and rsOImpresion.codigo_RegFiscal EQ rsRegFiscal.codigo_RegFiscal>selected</cfif>>#HTMLEditFormat(rsRegFiscal.nombre_RegFiscal)#</option>
                                            </cfloop>
                                        </select>--->
										<input type="hidden" name="RegFisc" id="RegFisc" value="#rsRegFiscal.ClaveSAT#"/>
                                        </td>

										<!--- ADENDA CHECK --->
										<td></td>
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
                                    <td></td>
									
									<!--- Checkbox para Anticipos Factura --->
									<cfif IsDefined('rsOImpresion') AND rsOImpresion.CCTcodigo NEQ 'NC'>																
										<td align="left" colspan="3" nowrap="nowrap">												
											<cfif #rsfacele.factura# eq 1>
												<!--- <input type="checkbox" onChange="sust: funcST(this.checked);"  name="sust" id="sust" checked="checked" disabled/>--->
												<input type="checkbox" name="anticipo" id="anticipo" value="checkbox" onclick="javascript:funcSust(this.checked, 'anticipo');" <cfif rsOImpresion.OIsustitucion EQ 1 and rsOImpresion.OItipoRel eq '07'> checked</cfif>>
											<cfelse>
												<input type="checkbox" name="anticipo" id="anticipo"  onclick="javascript:funcSust(this.checked, 'anticipo');"  <cfif rsOImpresion.OIsustitucion EQ 1 and rsOImpresion.OItipoRel eq '07'> checked</cfif>>
											</cfif>
											<strong> Anticipos factura</strong>
										</td>
									<cfelse>
										<input name="anticipo" id="anticipo" type="hidden" value="0">
									</cfif>
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
								
								
								<cfif IsDefined('rsOImpresion')>
									<cfif value eq '4.0'>
																	
									<tr id="tr_relacion">
										<td>
											<strong>Tipo de Relaci&oacute;n:&nbsp;</strong>
										</td>

										<cfquery name="rsTipoR" datasource="#session.dsn#">
											select CSATcodigo,CSATdescripcion,CSATdefault from CSATTipoRel
										</cfquery>
										<cfquery name="rsTIPORdefault" dbtype = "query">
											select CSATcodigo,CSATdescripcion from rsTipoR where CSATdefault = 1
										</cfquery>
										<cfquery name="rsTipoPorAnticipo" dbtype = "query">
											select CSATcodigo,CSATdescripcion from rsTipoR where CSATcodigo = '07'
										</cfquery>
										<td>
										<cfquery name="rsCatalogo" datasource="#session.dsn#">
											select *
											from FA_CFDI_Relacionado
											where OImpresionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOImpresion.OImpresionID#">
										</cfquery>
											<cfset varCSATcodigo = "">
											<cfif isDefined("rsTIPORdefault") and rsTIPORdefault.recordcount GT 0>
												<cfset varCSATcodigo = "#rsTIPORdefault.CSATcodigo#">
											</cfif>
											<cfset varCSATcodigoAnticipo = "">
											<cfif isDefined("rsTipoPorAnticipo") and rsTipoPorAnticipo.recordcount GT 0>
												<cfset varCSATcodigoAnticipo = "#rsTipoPorAnticipo.CSATcodigo#">
											</cfif>
											<input type="hidden" name="CSATdefault" id="CSATdefault" value="#varCSATcodigo#" >
											<input type="hidden" name="CSATanticipo" id="CSATanticipo" value="#varCSATcodigoAnticipo#" >
											<input type="hidden" name="PFTtipo" id="PFTtipo" value="#rsfacele.PFTtipo#" >
											<input type="hidden" name="hdTipoRelac" id="hdTipoRelac" value="">
											
											<select id="cmbTipoRel" name="cmbTipoRel" onChange="javascript:mostrarConlis(this); setRel_Docs();">
												<option value="00" <cfif rsCatalogo.TipoRelacion eq '00'>selected</cfif>>--- Seleccione una opcion ---</option>
												<cfloop query="rsTipoR">
													<option value="#CSATcodigo#"<cfif (rsOImpresion.OItipoRel eq rsTipoR.CSATcodigo) or (rsCatalogo.TipoRelacion eq #CSATcodigo#)>selected</cfif>>#CSATdescripcion#</option>
												</cfloop>
											</select>
										</td>
										</cfif>
										<cfset valuesArray = ArrayNew(1)>
										<!--- <cfquery name="rsDocs" datasource="#session.dsn#">
											select
												Ddocumento,Dsaldo,TimbreFiscal
											from Documentos
											where CCTcodigo = 'FC'
											and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											and Dsaldo > 0.0
											 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOImpresion.SNCODIGO#">
											order by Dfecha desc
										</cfquery> --->
										<!--- <cfset foliosDocs= ''>
										<cfset count = 0>
										<cfloop query="rsCatalogo">
											<cfif count eq 0>
												<cfset foliosDocs = '#trim(DocumentoRelacionado)#'>
											<cfelse>
												<cfset foliosDocs &= ',#trim(DocumentoRelacionado)#'>
											</cfif>
											<cfset count++>
										</cfloop>
										<cfset ArrayAppend(valuesArray, #foliosDocs#)> --->
										<!--- valuesArray="#valuesArray#" --->
										<td colspan = "2" id="tit" align="right">
											<div id ="divRelDocs">
											</div>
										</td>
										
										<!---<cfif value eq '4.0'>
											<cfset filtrar = "t.CCTcodigoRef = '#rsOImpresion.CCTcodigo#' and a.Ecodigo = #session.Ecodigo# and a.Dsaldo > 0.0
											 			and a.SNcodigo = #rsOImpresion.SNCODIGO# and a.Dsaldo >= a.Dtotal">
										<cfelse>
											<cfset filtrar = "a.Ecodigo = #session.Ecodigo# and a.Dsaldo > 0.0
															and a.SNcodigo = #rsOImpresion.SNCODIGO# and a.Dsaldo >= a.Dtotal">
										</cfif>--->
 
										<!---<td id="miConlis">---> <!--- <cfif rsDocsRel.recordCount GT 0> style="display: none;" </cfif> --->
											<!--- <cf_conlis
												campos="Ddocumento,Dsaldo,TimbreFiscal"
												size="20"
												desplegables="S,N,N"
												modificables="S,N,N"
												title="Documentos"
												tabla="Documentos a inner join FA_CFDI_Emitido fae on a.TimbreFiscal = fae.timbre
													inner join FAPreFacturaE fpe on fae.Folio = fpe.foliofacele
													inner join FAPFTransacciones t on fpe.PFTcodigo = t.PFTcodigo and fpe.Ecodigo = t.Ecodigo
													inner join Monedas m on a.Mcodigo = m.Mcodigo
													inner join SNegocios s on a.SNcodigo = s.SNcodigo"
												columnas="Ddocumento,Dsaldo,TimbreFiscal"
												filtrar_por="Ddocumento"
												desplegar="Ddocumento,Dsaldo,TimbreFiscal"
												etiquetas="Documento,Saldo,Timbre"
												formatos="S,S,S"
												align="left,left,left"
												form="form1"
												showEmptyListMsg="true"
												EmptyListMsg=" --- No hay registros --- "
												alt="Documento,Saldo"
												funcion="funcAgregar"
												fparams="Ddocumento"
												filtro="#filtrar#" 
												/> --->
										<!---</td>--->
									</tr>
									

									<tr>
										<td colspan="2">&nbsp;</td>
										<td colspan="2">&nbsp;
											<div id="docsRelacionados">
												<cfif rsDocsRel.recordCount gt 0>
													<div id="scrollD" <cfif rsDocsRel.recordCount gt 6> style="height: 150px; overflow-y: scroll;"</cfif>>
														<table border="0" align="left" cellspacing="3" width="95%">
															<!--- Encabezados --->
															<tr><td colspan="3">&nbsp;</td></tr>
															<tr>
																<td><strong>&nbsp;Documento</strong></td>
																<td><strong>&nbsp;Saldo</strong></td>
																<td width="50%"><strong>&nbsp;Timbre</strong></td>
																<td width="9%">&nbsp;</td>
															</tr>
															<cfloop query="rsDocsRel">
																<tr>
																	<td>&nbsp;#rsDocsRel.DocumentoRelacionado#</td>
																	<td align="right">#LSNumberFormat(rsDocsRel.Dsaldo,',9.00')#</td>
																	<td nowrap="true">&nbsp;&nbsp;#rsDocsRel.TimbreDocRel#</td>
																	<td align="center">#rsDocsRel.Eliminar#</td>
																</tr>
															</cfloop>
															<cfif rsDocsRel.recordCount gt 10>
																<tr><td colspan="4" align="center"></br><a><img width = "18px" height = "18" border="0" src="/cfmx/sif/imagenes/delete.small.png" title="Eliminar Todos" style="cursor:pointer" onclick = "javascript:eliminarTodos();"/></a>&nbsp;Quitar todos</td></tr>
															</cfif>
														</table>
														<input name="cFactura" id="cFactura" type="hidden" value="#rsfacele.PFDocumento#">
													</div>
												</cfif>
											</div>
										</td>
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
								<!--- En esta seccion se imprime si el socio tiene una addenda asociada, ademas esta adenda
								      contiene datos tipo prompt, para crear una seccion que capture dichos datos --->
								<tr>
								    <td align="left" colspan="3" nowrap="nowrap">
										<cfif rsSocioAdenda.recordCount gt 0>
										    <p style = "font-weight: 800;">
											    <cfoutput>Este socio tiene asignada la addenda : #rsSocioAdenda.ADDNombre#</cfoutput>
											</p>
										</cfif>
										<input type = "hidden" name = "ADDcodigo" id = "ADDcodigo"
										    value = "<cfoutput>#rsSocioAdenda.ADDcodigo#</cfoutput>">
	                                </td>
								</tr>
								<tr>
								    <td>
									    <cfif isdefined ("rsAddendasDetalles") and rsAddendasDetalles.recordCount gt 0>
											<p>Se encontraron detalles de addenda para configurar</p>
											<table>
												<cfloop index = "ida" from = "1" to = "#rsAddendasDetalles.recordCount#">
												    <tr>
														<td>
															<label><cfoutput>#rsAddendasDetalles.CODIGO[ida]#</cfoutput></label>
														</td>
														<td>
															<input type = "text" id = "add_#rsAddendasDetalles.CODIGO[ida]#"
															    name = "addendaDetallePrompt_#rsAddendasDetalles.CODIGO[ida]#"<cfif rsAddendasDetalles.CODIGO[ida] EQ 'OBSERVACIONES'>class="validEsp"</cfif> />
														</td>
													</tr>
												</cfloop>
											</table>
										</cfif>
									</td>
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
<!---  <script type="text/javascript" src="/jquery/librerias/jquery-1.11.1.min.js"></script>--->
<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>

<cf_qforms form="form1" objForm="objForm">
<script type="text/javascript">

	$( document ).ready(function() {
		hideLoading();
		/*alert("ready");*/
    	$( ".validEsp" ).bind('keypress',function(event) {
    		var regex = new RegExp ("^[a-zA-Z0-9]+$");
    		var key = String.fromCharCode (!event.charCode ? event.which : event.charCode);
    		if (!regex.test(key)){
    			event.preventDefault();
    			return false;
    		}

    	});

    	funcOIdiasvencimiento();
	});

	function setMpago()	{
    		/*alert("Mpagooo");*/
			var Control    = "ajaxFacturacion.cfc";
			var parametros = "";
			parametros += "method=getMet_Pago";
			parametros += "&TipoPago="+$("#TipoPago").val();
			parametros=encodeURI(parametros);
			/*Peticion AJAX*/
			$.ajax ({
		        url: Control + "?" + parametros,
		        type: "post",
		        dataType: "json",
		        async: false,
		        beforeSend: function() {},
		        success: function(data) {
		        	var obj = $.parseJSON(data);
		        	/*alert("Resultado"+obj.CODIGO);*/
		        	if ( obj.CODIGO == -1 ) {
		        		alert("No hay Metodo de Pago Parametrizado!!.");
		        	}
		        	else{
		        		$("#metPagoS").val(obj.CODIGO).change();
		        		$("#metPago").val(obj.CODIGO);
		        	}
		        },
		        error: function() {
		           alert("Error al obtener el Metodo de Pago!!.");
		        }
	    	});
	}

	function setRel_Docs()	{
			
			//var varTipoRelac = cbox.options[cbox.selectedIndex].value;
			//var varTipoRelacD = $("#CSATdefault").val().toString();

			var varTipoMovimiento = $("#PFTtipo").val();
			var varSNcodigo = $("#SNcodigo").val();
			var varOImpresionID = $("#OImpresionID").val();

			var varSust = 0;
			if($("#sust").prop('checked') || $("#anticipo").prop('checked')){
				varSust = 1;
			}
			
			var Control    = "ajaxFacturacion.cfc";
			var parametros = "";
			parametros += "method=getRel_Documento";
			parametros += "&Sustitucion="+varSust+"&TipoMovimiento="+varTipoMovimiento+"&OImpresionID="+varOImpresionID+"&SNcodigo="+varSNcodigo;
			parametros=encodeURI(parametros);
			/*Peticion AJAX*/
			$.ajax ({
		        url: Control  + "?" + parametros,
		        type: "post",
		        /*dataType: "array",
		        async: false,
		        beforeSend: function() {},*/
		        success: function(data) {
					$("#divRelDocs").html(data);
		        },
		        error: function(XMLHttpRequest, textStatus, errorThrown) {
					alert("Status: " + textStatus); alert("Error: " + errorThrown);
				}
	    	});
	}
	

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
				    .append('<option value="Directivo Estatal">Directivo Estatal</option>')
				    .val('#rsOImpresion.OIComiteAmbito#');
			<cfif isdefined("rsOImpresion") and rsOImpresion.OIComiteAmbito EQ 'Ejecutivo Estatal'>
				$('##trOIEntidad').show();
			<cfelseif isdefined("rsOImpresion") and rsOImpresion.OIComiteAmbito EQ 'Directivo Estatal'>
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

	function ChangeFormaPago(){
		var vOITipoProcesoINE = document.getElementById('TipoPago').value;
	}

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
				    .append('<option value="Directivo Estatal">Directivo Estatal</option>')
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
		if ( vclaveEntidad == 'Ejecutivo Estatal'  || vclaveEntidad == 'Directivo Estatal' || vOITipoProcesoINE == 'Ejecutivo Campaña' || (vOITipoProcesoINE == 'Precampaña' || vOITipoProcesoINE == 'Campaña')) {
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

<cfif rsSocioAdenda.recordCount gt 0>

  var _iframe = parent.document.getElementById("frameAddenda"),
      _height = _iframe.contentDocument.getElementById("size").scrollHeight || _iframe.contentWindow.document.getElementById("size").scrollHeight;
      _iframe.height = _height + 40;
</cfif>

</script>
<script language="JavaScript1.2">
	mostrarConlis(document.getElementById('cmbTipoRel'));
	<cfif rsDocsRel.recordCount EQ 0>
		setRel_Docs();
	</cfif>
	<!---<cfif value eq '4.0'>
		<cfif IsDefined('rsfacele') and rsfacele.PFTtipo eq 'D'>
			mostrarConlis(document.getElementById('cmbTipoRel'));
		<cfelse>
			mostrarConlis(document.getElementById('cmbTipoRel'));
		</cfif>
	<cfelse>
		<cfif value eq '3.3' and IsDefined('rsfacele') and rsfacele.PFTtipo neq 'C'>
			mostrarConlis(document.getElementById('cmbTipoRel'));
		</cfif>
	</cfif>--->

	function funcAgregar(Ddocumento)//conlis funcion de check
	{
		
		var arrFol = Ddocumento.split('|');
		for(i = 0;i<arrFol.length;i++)
		{
			arrFol[i] = arrFol[i].trim();
		}
		insertDocRel(arrFol);
		setRel_Docs();
		document.getElementById('cmbTipoRel').style.visibility = 'visible';
		document.getElementById('tr_relacion').style.visibility = 'visible';
		var foliosIn = document.form1.ValuesChecked.value;
		//document.form1.Ddocumento.value = arrFol; 
	}

	function mostrarConlis(cmb)
	{
		var varSust = document.getElementById('sust').checked;
		var varAnticipo = document.getElementById('anticipo').checked;
		var valSel = cmb.options[cmb.selectedIndex].value;
		document.getElementById("hdTipoRelac").value = valSel;
		var varTipoRel = document.getElementById("CSATdefault").value;
		var varPFTtipo = document.getElementById('PFTtipo').value;
		var HayDocumentosRelacionados = document.getElementById('scrollD');
		
		if (varSust||varAnticipo){
			if(varPFTtipo == 'C'){
				document.getElementById('tit').style.visibility = 'visible';
				/* document.getElementById('miConlis').style.visibility = 'visible'; */
				document.getElementById("cmbTipoRel").disabled = true;
				document.getElementById('tr_relacion').style.visibility = 'visible';
				document.getElementById('cmbTipoRel').style.visibility = 'visible';					
			}
			else{
				document.getElementById('tit').style.visibility = 'visible';
				/* document.getElementById('miConlis').style.visibility = 'visible'; */
				document.getElementById("cmbTipoRel").disabled = true;
				document.getElementById('tr_relacion').style.visibility = 'visible';
				document.getElementById('cmbTipoRel').style.visibility = 'visible';		
			} 
		}
		else{
			if(varPFTtipo == 'C'){
				if (valSel != varTipoRel && valSel != '00'){
					document.getElementById('tit').style.visibility = 'visible';
					/* document.getElementById('miConlis').style.visibility = 'visible'; */
				}
				else{
					document.getElementById('tit').style.visibility = 'hidden';
					/* document.getElementById('miConlis').style.visibility = 'hidden'; */
				}
				
				document.getElementById("cmbTipoRel").disabled = false;
				document.getElementById('tr_relacion').style.visibility = 'visible';
				document.getElementById('cmbTipoRel').style.visibility = 'visible';	
			}
			else{
				document.getElementById('tit').style.visibility = 'hidden';
				/* document.getElementById('miConlis').style.visibility = 'hidden'; */
				document.getElementById("cmbTipoRel").disabled = true;
				document.getElementById('tr_relacion').style.visibility = 'hidden';
				document.getElementById('cmbTipoRel').style.visibility = 'hidden';				
			} 
		}
	}

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

		//var addp = document.getElementsByName("addendaDetallePrompt");
		//console.log(addp.length);
		/*for(var i = 0; i < x.length; i++) {
			if (x[i].type == "checkbox") {
				x[i].checked = true;
			}
		}*/
		if (confirm("¿Está seguro de que desea Generar El Folio de Factura Electrónica?")) {
			objForm.DocCxC.required = false;
			document.form1.modo.value = "FacEle";
			showLoading();
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
		objForm.UsoCFDI.requiered = true;
		objForm.UsoCFDI.description = "Uso de Regimen";

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

	function eliminarDoc(idDoc, OImpresionID){
		if (confirm('Desea quitar el documento?')) {
			$.ajax({
				method: "post",
			    url: "ajaxFacturacion.cfc",
			    async:false,
			    data: {
			    	method: "deleteDoc",
			        returnFormat: "JSON",
			        idDocR: idDoc,
			        OImpresionID: OImpresionID,
			    },
			    dataType: "json",
			    success: function(obj) {
					if(obj.MSG == 'DeleteOK'){
						setRel_Docs();
						<!--- Refresca tabla --->
						refreshTable();
					} else {
						alert(obj.MSG);
					}
			     }
			 });
		}
	}

	function eliminarTodos(){
		var OImpresionID = document.getElementById("OImpresionID").value;
		if (confirm('Desea quitar todos los documentos?')) {
			$.ajax({
				method: "post",
			    url: "ajaxFacturacion.cfc",
			    async:false,
			    data: {
			    	method: "deleteAllDocs",
			        returnFormat: "JSON",
			        OImpresionID: OImpresionID,
			    },
			    dataType: "json",
			    success: function(obj) {
					if(obj.MSG == 'DeleteOK'){
						<!--- Refresca tabla --->
						refreshTable();
					} else {
						alert(obj.MSG);
					}
			     }
			 });
		}
	}

	function refreshTable(){
		var OImpresionID = document.form1.OImpresionID.value;
		$.ajax({
			 type:"post",
			 url:"ajaxFacturacion.cfc",
			 async:false,
			 data: {
		        method: "refreshDocs",
		        OImpresionID: OImpresionID,
		     },
			 cache:false,
			 success: function(msg) {
			 	document.getElementById("docsRelacionados").innerHTML =  msg;
				mostrarConlis(document.getElementById('cmbTipoRel'));
				}
			});
	}
<!---RDF 100322--->
	function funcSust(chkd, tipo='sustitucion'){		
		if(document.getElementById('sust').checked && tipo == 'anticipo')
			document.getElementById('sust').checked = false;
		else if(document.getElementById('anticipo').checked && tipo == 'sustitucion')
			document.getElementById('anticipo').checked = false;
		/* var tr_relacion = document.getElementById("tr_relacion");*/
		if(chkd){						
			var elemento = document.getElementById("CSATdefault").value;	
			var elemAnticipo = 	document.getElementById("CSATanticipo").value;
			if(elemento!='' && tipo == 'sustitucion'){
				document.getElementById('cmbTipoRel').value =  elemento;
				//document.getElementById("cmbTipoRel").disabled = true;	
				mostrarConlis(document.getElementById('cmbTipoRel'));
			}else if( elemAnticipo != '' && tipo == 'anticipo'){
				document.getElementById('cmbTipoRel').value = elemAnticipo;
				mostrarConlis(document.getElementById('cmbTipoRel'));
			}
		}else{
			mostrarConlis(document.getElementById('cmbTipoRel'));
			/* document.getElementById("cmbTipoRel").disabled = true;
			document.getElementById('miConlis').style.visibility = 'hidden';
			document.getElementById('tit').style.visibility = 'hidden';
			document.getElementById('cmbTipoRel').style.visibility = 'hidden';
			document.getElementById('tr_relacion').style.visibility = 'hidden';	*/
		} 
		setRel_Docs();
	}

	function insertDocRel(DocsRelac){
		$.ajax({
				method: "post",
			    url: "ajaxFacturacion.cfc",
			    async:false,
			    data: {
			    	method: "insertDoc",
			        returnFormat: "JSON",
			        docsRel: DocsRelac.toString(),
			        CmbTipoRel: document.getElementById("cmbTipoRel").value,
		  <cfoutput>OImpresionID: '#form.OImpresionID#',</cfoutput>
			        SNcodigo: document.getElementById("SNcodigo").value,
			    },
			    dataType: "json",
			    success: function(obj) {
					if(obj.MSG == 'InsertOK'){
						<!--- Refresca tabla --->
						refreshTable();
					} else {
						alert(obj.MSG);
					}
			     }
			 });
	}
</script>