<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 30 Mayo del 2005
		Motivo: Se agrega el campo Línea de Orden de Compra en el detalle. 
	Modificado por Gustavo Fonseca H.
		Fecha: 24-6-2005.
		Motivo: Se agreaga el campo SNidentificacion al form.
	Modificado por Gustavo Fonseca H.
		Fecha: 6-7-2005.
		Motivo: Se utiliza el cftransaction para ejecutar el sp.		
	Modificado por Gustavo Fonseca H.
		Fecha: 4-8-2005
		Motivo: - Se modifica para arreglar la seguridad de CxP en los procesos de facturas y notas de crédito, para que seguridad sepa 
				con cual de los dos procesos está trabajando. Esto porque se estaba trabajando con un archivo para los dos procesos.
				- Se agrega el botón nuevo en el form para que no tenga que salir hasta la lista para hacer uno nuevo (CHAVA).
	Modificado por Gustavo Fonseca H.
		Fecha: 10-1-2006.
		Motivo: Se corre la sumatoria del total hacia la derecha en la lista.

	Modificado por Óscar Bonilla
		Fecha: 17-5-2006.
		Motivo: Se sustituye la llamada al store procedure por un componente para aplicacion de documentos.
--->

<cf_templateheader title="SIF - Cuentas por Pagar">

	<cfif isdefined ("LvarIDdocumento")>
		<cfparam name="form.IDdocumento" default="">
	</cfif>
	<cfif isdefined('Url.tipo') and not isdefined('Form.tipo')>
		<cfset form.tipo = url.tipo>
	</cfif>
	<cfif isdefined('LvarTipo') and not isdefined('Form.tipo')>
		<cfset form.tipo = LvarTipo>
	</cfif>
	<cfif isdefined("url.modo") and len(trim(url.modo)) and not isdefined("form.modo")>
		<cfset form.modo = url.modo>
	</cfif>
	<cfif isdefined("url.datos") and len(trim(url.datos)) and not isdefined("form.datos")>
		<cfset form.datos = url.datos>
	</cfif>
	
	<cfif isDefined("url.Fecha") and len(Trim(url.Fecha)) gt 0>
		<cfset form.Fecha = url.Fecha>
	</cfif>
	<cfif isDefined("url.Transaccion") and len(Trim(url.Transaccion)) gt 0>
		<cfset form.Transaccion = url.Transaccion>
	</cfif>
	<cfif isDefined("url.Documento") and len(Trim(url.Documento)) gt 0>
		<cfset form.Documento = url.Documento>
	</cfif>
	<cfif isDefined("url.Usuario") and len(Trim(url.Usuario)) gt 0>
		<cfset form.Usuario = url.Usuario>
	</cfif>
	<cfif isDefined("url.Moneda") and len(Trim(url.Moneda)) gt 0>
		<cfset form.Moneda = url.Moneda>
	</cfif>
	<cfif isDefined("url.Registros") and len(Trim(url.Registros)) gt 0>
		<cfset form.Registros = url.Registros >
	</cfif>
	<cfif isDefined("url.pageNum_lista") and len(Trim(url.pageNum_lista)) gt 0>
		<cfset form.pageNum_lista = url.pageNum_lista>
	</cfif>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">					
					<cf_templatecss>
					<cfset titulo = "Registro de ">					
					<cfif form.tipo NEQ "D">
						<cfset titulo = titulo & "Facturas">
					<cfelse>
						<cfset titulo = titulo & "Notas de Cr&eacute;dito">
					</cfif>					
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#titulo#'>
						<cfif isdefined("Form.Cambio")>
							<cfset modo="CAMBIO">
						<cfelse>
							<cfif not isdefined("Form.modo")>
								<cfset modo="ALTA">
							<cfelseif Form.modo EQ "CAMBIO">
								<cfset modo="CAMBIO">
							<cfelse>
								<cfset modo="ALTA">
							</cfif>
						</cfif>
						
						<cfif not isdefined("Form.modoDet")>
							<cfset modoDet = "ALTA">
						</cfif>
						
						<cfif isDefined("Form.NuevoE")>
							<cfset modo = "ALTA">
							<cfset modoDet = "ALTA">
						</cfif>
						
						<cfif isDefined("Form.datos") and Form.datos NEQ "">
							<cfset modo = "CAMBIO">
							<cfset modoDet = "ALTA">
						</cfif>
						
						<cfif isdefined("Form.Nuevo")>
							<cfset modo = "ALTA">
						</cfif>	
						
						<cfset IDdocumento = "">
						<cfset Linea = "">
						
						<cfset params = '' >
						<cfif isdefined('form.fecha') and len(trim(form.fecha))>
							<cfset params = params & '&fecha=#form.fecha#' >
						</cfif>
						<cfif isdefined('form.transaccion') and len(trim(form.transaccion))>
							<cfset params = params & '&transaccion=#form.transaccion#' >
						</cfif>
						<cfif isdefined('form.documento') and len(trim(form.documento))>
							<cfset params = params & '&documento=#form.documento#' >
						</cfif>
						<cfif isdefined('form.usuario') and len(trim(form.usuario))>
							<cfset params = params & '&usuario=#form.usuario#' >
						</cfif>
						<cfif isdefined('form.moneda') and len(trim(form.moneda))>
							<cfset params = params & '&moneda=#form.moneda#' >
						</cfif>
						<cfif isdefined('form.pageNum_lista') and len(trim(form.pageNum_lista))>
							<cfset params = params & '&pageNum_lista=#form.pageNum_lista#' >
						</cfif>
						<cfif isdefined('form.registros') and len(trim(form.registros))>
							<cfset params = params & '&registros=#form.registros#' >
						</cfif>
						<cfif isdefined('form.tipo') and len(trim(form.tipo))>
							<cfset params = params & '&tipo=#form.tipo#' >
						</cfif>

						<cfif not isDefined("Form.NuevoE")>
							<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
								<cfset arreglo = ListToArray(Form.datos,"|")>
								<cfset IDdocumento = Trim(arreglo[1])>
							<cfelse>
								<cfif not isDefined("Form.IDdocumento")>
									<cflocation addtoken="no" url="listaDocumentosCP.cfm?sqlDone=ok#params#">	
								<cfelse>
									<cfif Len(Trim(Form.IDdocumento)) NEQ 0 and Trim(Form.IDdocumento) NEQ "">
										<cfset IDdocumento = Form.IDdocumento>
									</cfif>
								</cfif>
								
							</cfif>
						</cfif>

						<cfif isDefined("Form.btnAplicar")>
							<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
							<cfif isdefined("Form.IDdocumento") and len(trim(Form.IDdocumento))>
								<cfparam name="Form.chk" default="#Form.IDdocumento#">
							</cfif>
							<cfif isDefined("Form.chk")>
								<cfset chequeados = ListToArray(Form.chk)>
								<cfset cuantos = ArrayLen(chequeados)>

								<!--- mismo doc.recurrente en varias facturas --->
								<cfquery name="parametroRec" datasource="#session.DSN#">
									select coalesce(Pvalor, '1') as Pvalor
									from Parametros
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and Pcodigo=880
								</cfquery>

								<!--- mes auxiliar --->
								<cfquery name="mes" datasource="#session.DSN#">
									select Pvalor
									from Parametros
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and Pcodigo = 60
								</cfquery>
								<!--- periodo auxiliar --->
								<cfquery name="periodo" datasource="#session.DSN#">
									select Pvalor
									from Parametros
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and Pcodigo = 50
								</cfquery>
								<cfif len(trim(mes.pvalor)) and len(trim(periodo.pvalor))>
									<cfset fecha = createdate(periodo.pvalor, mes.pvalor , 1) >
									<cfset fechaaplic = createdate( periodo.pvalor, mes.pvalor, DaysInMonth(fecha) ) >
								</cfif>	

								<cfloop index="CountVar" from="1" to="#cuantos#">
									<cfset valores = ListToArray(chequeados[CountVar],"|")>
									<!--- Valida las garantias, si la factura lo requiere--->
									<cfinvoke component="conavi.Componentes.garantia" method="fnProcesarGarantias" returnvariable="LvarAccion"
										Ecodigo	= "#session.Ecodigo#"
										tipo 	= "C"
										ID		= "#valores[1]#"
									/>
									<cfif parametroRec.Pvalor neq 0>
										<cfquery name="recurrente" datasource="#session.DSN#">
											select IDdocumentorec
											from EDocumentosCxP
											where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
											  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">			  
										</cfquery>
										<cfif len(trim(recurrente.IDdocumentorec))>
											<cfquery name="rsFechaUltima" datasource="#session.DSN#">
												select HEDfechaultaplic
												from HEDocumentosCP
												where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
												  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">			  
											</cfquery>
											<cfif len(trim(rsFechaUltima.HEDfechaultaplic)) and datecompare(fechaaplic, rsFechaUltima.HEDfechaultaplic) lte 0>
												<cfset request.Error.backs = 1 >
												<cf_errorCode	code = "50344"
																msg  = "El documento no puede ser aplicado, pues ya existe un documento aplicado con el mismo documento recurrente para el mes @errorDat_1@ y período @errorDat_2@."
																errorDat_1="#month(fechaaplic)#"
																errorDat_2="#year(fechaaplic)#"
												>
											</cfif>
										</cfif>
									</cfif>
									<cfquery name="rsSQL" datasource="#session.dsn#">
										select 
											a.EDdocumento as Ddocumento, 
											b.DDcantidad, 
											round(b.DDtotallinea * a.EDtipocambio,2)	as TotalLineaUnitLocal,
											b.DOlinea 
										from EDocumentosCxP a
											inner join DDocumentosCxP b
											 on b.IDdocumento = a.IDdocumento
										where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
										  and a.IDdocumento = #valores[1]#
										  and b.DDtipo = 'F' 
									</cfquery>
									<!--- ejecuta el proc.--->
									<cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP"
											  method="PosteoDocumento"
												IDdoc = "#valores[1]#"
												Ecodigo = "#Session.Ecodigo#"
												usuario = "#Session.usuario#"
												debug = "N"
									/>
									<!--- INTERFAZ --->
									<cfquery name="rsDatos" datasource="#Session.Dsn#">
										select CPTcodigo as CXTcodigo, EDdocumento as Ddocumento, SNcodigo
										from EDocumentosCxP
										where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
										and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">		
									</cfquery>
									<cfset LobjInterfaz.fnProcesoNuevoSoin(110,"CXTcodigo=#rsDatos.CXTcodigo#&Ddocumento=#rsDatos.Ddocumento#&SNcodigo=#rsDatos.SNcodigo#&MODULO=CP","R")>

									<!--- modifica la ultima fecha de aplicacion --->
									<cfif parametroRec.Pvalor neq 0>
										<cfif len(trim(recurrente.IDdocumentorec))>
											<cfif isdefined("fechaaplic")>
												<cfquery datasource="#session.DSN#">
													update HEDocumentosCP
													set HEDfechaultaplic = <cfqueryparam cfsqltype="cf_sql_date" value="#fechaaplic#">
													where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
													  and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">			  
												</cfquery>
											</cfif>
										</cfif>
									</cfif>
								</cfloop>
							</cfif>
							<cflocation addtoken="no" url="listaDocumentosCP.cfm?sqlDone=ok#params#">
						</cfif>
						
						<cfif Len(Trim(IDdocumento)) NEQ 0 >
							<cfquery name="rsLineas" datasource="#Session.DSN#">
								select 
								c.EOnumero, a.DOlinea,
								a.IDdocumento as IDdocumento, 
								a.Linea as Linea,
								a.Aid as Aid,
								a.Cid as Cid,
								a.DDdescripcion,
								a.DDdescalterna,
								a.DDcantidad,
								#LvarOBJ_PrecioU.enSQL_AS("a.DDpreciou")#,
								a.DDdesclinea,
								a.DDporcdesclin,
								a.DDtotallinea,
								a.DDtipo,
								a.Ccuenta as Ccuenta,
								a.Alm_Aid as Alm_Aid,
								a.Dcodigo,
								a.ts_rversion,
								b.DOconsecutivo,
								a.Icodigo
								from DDocumentosCxP a
									left outer join DOrdenCM b
										inner join EOrdenCM c
											on c.EOidorden = b.EOidorden
										on a.DOlinea = b.DOlinea
										and a.Ecodigo = b.Ecodigo 
								where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
								order by Linea
							</cfquery>
							
							<cfquery name="rsTotalLineas" dbtype="query">
								select sum(DDpreciou) as PrecioUnit, sum(DDtotallinea) as TotalLinea
								from rsLineas
							</cfquery>
						</cfif>
						
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr> 
								<td><cfset regresar = "listaDocumentosCP.cfm?tipo=#form.tipo#">
								<cfinclude template="/sif/portlets/pNavegacionCP.cfm"></td>
							</tr>
							<tr> 
								<td><cfinclude template="formRegistroDocumentosCP.cfm">&nbsp;</td>
							</tr>
							<cfif Len(Trim(IDdocumento)) NEQ 0 and not isDefined("Form.btnAplicar")>
								<tr> 
									<td class="subTitulo">
										
										<!--- registro seleccionado --->
										<cfif isDefined("Linea") and Len(Trim(Linea)) GT 0 ><cfset seleccionado = Linea ><cfelse><cfset seleccionado = "" ></cfif>
											
											<form action="<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'D'>RegistroNotasCreditoCP.cfm<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo EQ 'C'>RegistroFacturasCP.cfm</cfif>" method="post" name="form2">
												<input name="datos" type="hidden" value="">
												<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
													<input name="SNnumero" type="hidden" value="<cfoutput>#form.SNnumero#</cfoutput>">
												</cfif>

												<cfif isdefined("form.SNidentificacion") and len(trim(form.SNidentificacion))>
													<input name="SNidentificacion" type="hidden" value="<cfoutput>#form.SNidentificacion#</cfoutput>">
												</cfif>

												<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento))>
													<input name="IDdocumento" type="hidden" value="<cfoutput>#form.IDdocumento#</cfoutput>">
												</cfif>
												
												<!--- Para Borrado desde la lista --->
												<input type="hidden" name="IDdocumento" value="">
												<input type="hidden" name="Linea" value="">
												<input type="hidden" name="BorrarD" value="BorrarD">
												<!--- --------------------------- --->
												
												<input name="tipo" type="hidden" value="<cfoutput>#form.tipo#</cfoutput>">
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr bgcolor="E2E2E2" class="subTitulo">
														<td width="1%">&nbsp;</td> 

														<td width="4%" valign="bottom"><strong>&nbsp;L&iacute;nea</strong></td>
														<td width="4%" valign="bottom"><strong>&nbsp;Item</strong></td>
														<td width="40%" valign="bottom"><strong>&nbsp;Descripci&oacute;n</strong></td>
														<td width="4%" align="center" nowrap><strong>&nbsp;OrdenCM-Lin.</strong></td>
														<td width="4%" align="center" nowrap><strong>&nbsp;Imp.</strong></td>
														<td width="13%" valign="bottom"> <div align="right"><strong>Cantidad</strong></div></td>
														<td width="13%" valign="bottom"> <div align="right"><strong>Precio</strong></div></td>
														<td width="13%" valign="bottom"><div align="right"><strong>Descuento</strong></div></td>
														<td width="13%" valign="bottom"> <div align="right"><strong>&nbsp;&nbsp;&nbsp;Subtotal</strong></div></td>
														<td width="3%" valign="bottom">&nbsp;</td>
														
													</tr>
													
													<cfoutput query="rsLineas"> 
														<tr onClick="javascript:Editar('#rsLineas.IDdocumento#|#rsLineas.Linea#');" 
															style="cursor: pointer;"
															onMouseOver="javascript: style.color = 'red'" 
															onMouseOut="javascript: style.color = 'black'"
															<cfif rsLineas.CurrentRow MOD 2>
																class="listaNon"
															<cfelse>
																class="listaPar"
															</cfif>>
															
															<td>&nbsp;
																<cfif modoDet NEQ 'ALTA' and rsLineas.Linea EQ seleccionado>
																	<img src="/cfmx/sif/imagenes/addressGo.gif" height="12" 
																	 width="12" border="0">
																</cfif>
															</td> 
															
															<td align="center">#CurrentRow#</td>
															<td align="center">#rsLineas.DDtipo#</td>
															<td>#rsLineas.DDdescripcion#</td>
															<td align="center"><cfif rsLineas.DOlinea NEQ "">#rsLineas.EOnumero#-#rsLineas.DOconsecutivo#</cfif><!----#rsLineas.DOlinea#-----></td>
															<td align="left" nowrap="nowrap">#rsLineas.Icodigo#</td>
															<td align="right">#LSCurrencyFormat(rsLineas.DDcantidad,'none')#</td>
															<td align="right">#LvarOBJ_PrecioU.enCF_RPT(rsLineas.DDpreciou)#</td>
															<td align="right">#LSCurrencyFormat(rsLineas.DDdesclinea,'none')#</td>
															<td align="right">#LSCurrencyFormat(rsLineas.DDtotallinea,'none')#</td>
															<td align="right" width="3%">
															<a tabindex="-1" href="javascript:borrar('#rsLineas.IDdocumento#','#rsLineas.Linea#');">
																<img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" 
																 alt="Eliminar Detalle">
															</a>
															</td>
														</tr>
													</cfoutput> 
													
													<cfif rsLineas.Recordcount GT 0>
														<tr>
															<td colspan="8">&nbsp;</td> 
															<td><div align="right"><font size="1"><strong>Subtotal:</strong></font></div></td>
															<td>
																<div align="right">
																	<font size="1">
																		<strong>
																		<cfoutput>
																			&nbsp;&nbsp;#LSCurrencyFormat(rsTotalLineas.TotalLinea,'none')#
																		</cfoutput>
																		</strong>
																	</font>
																</div>
															</td>
															<td width="3%">&nbsp;</td>
														</tr>
													</cfif>
												</table>
												<!--- ======================================================================= --->
												<!--- NAVEGACION --->
												<!--- ======================================================================= --->
												<cfoutput>
												<input type="hidden" name="fecha" value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) >#form.fecha#</cfif>" />
												<input type="hidden" name="transaccion" value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion))>#form.transaccion#</cfif>" />
												<input type="hidden" name="documento" value="<cfif isdefined('form.documento') and len(trim(form.documento))>#form.documento#</cfif>" />
												<input type="hidden" name="usuario" value="<cfif isdefined('form.usuario') and len(trim(form.usuario))>#form.usuario#</cfif>" />
												<input type="hidden" name="moneda" value="<cfif isdefined('form.moneda') and len(trim(form.moneda))>#form.moneda#</cfif>" />
												<input type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista') >#form.pageNum_lista#</cfif>" />
												<input type="hidden" name="registros" value="<cfif isdefined('form.registros')>#form.registros#</cfif>" />
												</cfoutput>
												<!--- ======================================================================= --->
												<!--- ======================================================================= --->

											</form>
										 </td>
									</tr>
								</cfif>			  
							</table>
							<script language="JavaScript1.2">

								function Editar(data) {
									if (data!="") {
										//document.form2.action='RegistroDocumentosCP.cfm?tipo=<cfoutput>#form.tipo#</cfoutput>';
										<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'D'> <!--- Notas de Crédito --->
											document.form2.action='RegistroNotasCreditoCP.cfm';
										<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'C'> <!--- Facturas --->
											document.form2.action='RegistroFacturasCP.cfm';
										</cfif>
										document.form2.datos.value=data;
										document.form2.submit();
									}
									return false;
								}
							
								
								function borrar(documento, linea){
									if ( confirm('¿Desea borrar esta línea del documento?') ) {
									document.form2.action = "SQLRegistroDocumentosCP.cfm";	
									document.form2.IDdocumento.value = documento;
									document.form2.Linea.value = linea;
									document.form2.submit();
								}
							}
						</script>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>


