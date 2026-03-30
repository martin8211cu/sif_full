
<cfcomponent output="true" >

	<cffunction name="set" access="remote">
		<cfargument name="nombre">
		<cfargument name="cantidad">
		<cfif trim(arguments.nombre) NEQ "" and trim(arguments.cantidad) NEQ "" and arguments.cantidad GT 0>
			<cfset newItem = structNew()>
			<cfset newItem.nombre = #arguments.nombre#>
			<cfset newItem.cantidad = #arguments.cantidad#>
			<cfset arrayAppend(session.listaCarrito, newItem)>
		</cfif>
	</cffunction>

	<cffunction name="getPage" access="remote" returnformat="plain">
		<cfargument name="page">
		<cfargument name="codigo" default="#Session.rtp_Codigo#">
		<cfargument name="versionId" default="">
		<cfset Session.rtp_vid = Arguments.versionId>
		<cfset Session.rtp_Codigo = Arguments.codigo>

		<cfquery name="rsIdReporte" datasource="#Session.DSN#">
			select top 1 RPTId from RT_Reporte where RPCodigo = '#Session.rtp_Codigo#'
		</cfquery>
		<cfset Session.rtp_Id = rsIdReporte.RPTId>
		<cfsavecontent variable="result">





			<!--- #Session.rtp_vid# --->
			<div id="rootwizard" class="tabbable tabs-left" style="height:100%;">
				<div class="tab-content wizContent row" style="height:80%;">
					<cfif arguments.page neq 0>
						<div class="col-md-3">
							#showNav(arguments.page)#
						</div>
					</cfif>
					<div class="col-md-<cfoutput><cfif arguments.page neq 0>9<cfelse>12</cfif></cfoutput>">
					<cfswitch expression="#arguments.page#">
						    <cfcase value="1">
						    	<cfquery name="rsVersion" datasource="#Session.dsn#">
									select * from RT_ReporteVersion
									where RPTVId = #Session.rtp_vid#
						    	</cfquery>
						    	<div>
						    		<div class="row">&nbsp;</div>
						    			<h4>
								                 	Seleccionar un tipo de gr&aacute;fica para la generaci&oacute;n del reporte
								        </h4><br/><br/>
					        		<div id="tabC" class="row cont">
								        <div class="col col-md-3 col-sm-6">
								      		<div>
								      			<i class="fa fa-ban fa-5x"></i>
								      		</div>
								      		<label>
							                  <input name="optionsRadios" id="optionsRadios1" value="" <cfif trim(rsVersion.RPTVTipoGrafica) EQ "ND">checked=""</cfif> type="radio">
							                  Sin Graficas
							                </label>
								      	</div>
								      	<div class="col col-md-3 col-sm-6">
								      		<div>
								      			<i class="fa fa-bar-chart fa-5x"></i>
								      		</div>
								      		<label>
							                  <input name="optionsRadios" id="optionsRadios1" value="B" <cfif trim(rsVersion.RPTVTipoGrafica) EQ "B">checked=""</cfif> type="radio">
							                  Grafica de Barras
							                </label>
								      	</div>
								      	<div class="col col-md-3 col-sm-6">
								      		<div>
								      			<i class="fa fa-line-chart fa-5x"></i>
								      		</div>
								      		<label>
							                  <input name="optionsRadios" id="optionsRadios1" value="L"  <cfif trim(rsVersion.RPTVTipoGrafica) EQ "L">checked=""</cfif> type="radio">
							                  Grafica de Linea
							                </label>
								      	</div>
								      	<div class="col col-md-3 col-sm-6">
								      		<div>
								      			<i class="fa fa-pie-chart fa-5x"></i>
								      		</div>
								      		<label>
						                      <input name="optionsRadios" id="optionsRadios1" value="P" <cfif trim(rsVersion.RPTVTipoGrafica) EQ "P">checked=""</cfif> type="radio">
						                      Grafica de Pastel
						                    </label>
							      		</div>
									</div>
								    <div class="row">&nbsp;</div>
								    <div class="row">
								        <div class="col col-md-12">
								        	<input id="btnInicio"  name="btnInicio" class="btnLimpiar btnInicio" value="Anterior" tabindex="0"
								      		onclick="regresar(0,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
								      		<cfif rsVersion.RPTVActivo eq 1>
												<input id="btnGuardaGrafica"  name="btnGuardaGrafica" class="btnGuardar btnGuardaGrafica" value="Guardar" tabindex="0" type="button"
								        			onclick="salvaGrafica(#trim(Session.rtp_vid)#,1)">
									        	<input id="btnImprimeGrafica"  name="btnImprimeGrafica" class="btnImprimir btnImprimeGrafica" value="Imprimir" tabindex="0" type="button"
									        		onclick="salvaGrafica(#trim(Session.rtp_vid)#,1,true)">
											</cfif>
								        	<input id="btnGraficaRPT"  name="btnGraficaRPT" class="btnGuardar btnGraficaRPT" value="Siguiente" tabindex="0" type="button"
								        	onclick="salvaGrafica(#trim(Session.rtp_vid)#)">
								      	</div>
								    </div>
								</div>

								<script type="text/javascript">

								</script>
						    </cfcase>
						    <!--- Columnas --->
							<cfcase value="2">
								<!--- Verificamos el estatus de la version de reporte --->
								<cfquery  name="rsValVerRe1" datasource="#session.DSN#">
									select RPTVActivo from RT_ReporteVersion
									WHERE RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
								</cfquery>
								<!--- Si es ReporteNuevo se inserta --->
								<cfif rsValVerRe1.RPTVActivo neq 1>

									<cfquery name="evalRPTVId" datasource="#session.dsn#"> <!---	selecciona RPTVId	--->
										select count(*) as eval from RT_ReporteVerColumna where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
									</cfquery>

									<cfif evalRPTVId.eval gt 0><!---	si RPTVId ya existe selecciona los valores	--->
									<!---	esta validación se creó para evitar inserciones duplicadas cuando se usa el boton regresar a
									la pantalla anterior	--->

											<cfquery name="evalRPTVId" datasource="#session.dsn#">
												select top 1 RPTId from RT_ReporteVersion
												where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Session.rtp_vid)#">
											</cfquery>

											<cfelse><!---	si RPTVId aún no existe inserta un nuevo campo en RT_ReporteVerColumna	--->

											<cfquery datasource="#session.dsn#">
												insert into RT_ReporteVerColumna
												(RPTVId,ODId,ODCampo,RTPCAlias,RTPCOrdenColumna,RTPCOrdenDato,RPTCCalculo)
												select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#"> as RPTVId,ODId,ODCampo,RTPCAlias,RTPCOrdenColumna,RTPCOrdenDato,RPTCCalculo
												from RT_ReporteColumna
												where RPTId = (select RPTId
												from RT_ReporteVersion
												where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">)
											</cfquery>
									</cfif>

								</cfif>
								<cfquery  name="rsIdRe" datasource="#session.dsn#">
									select top 1 RPTId from RT_ReporteVersion
									where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Session.rtp_vid)#">
								</cfquery>
									<br/>
										<h4>
								       		Listado de campos que conformar&aacute;n el reporte
								    	</h4>
								    <br/>
								<div id="Cols">
										<cfinvoke component="commons.GeneraReportes.Componentes.ReporteCOlumna"
										method="getColumnasVer"
										rtpvid="#session.rtp_vid#"
										returnvariable="strHTML"
									/>
									<cfoutput>#strHTML#</cfoutput>
								</div><br>
								<div class="row" id="IdBtn">
							        <div class="col col-md-12">
							        	<input id="btnInicio"  name="btnInicio" class="btnLimpiar btnInicio" value="Anterior" tabindex="0"
							      		onclick="regresar(1,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
							      		<cfif rsValVerRe1.RPTVActivo eq 1>
											<input id="btnImprimeCampos"  name="btnImprimeCampos" class="btnImprimir btnImprimeCampos" value="Imprimir" tabindex="0" type="button"
								        		onclick="fastimprimir(#trim(Session.rtp_vid)#,false)">
										</cfif>
							        	<input id="btnGraficaRPT"  name="btnGraficaRPT" class="btnGuardar btnGraficaRPT" value="Siguiente" tabindex="0" type="button"
							        	onclick="loadPage(3,#trim(Session.rtp_vid)#)">
							      	</div>
								</div>
							</cfcase>
							<cfcase value="3">
								<cfform>
									<br/>
										<h4>
								       		Agrupaci&oacute;n de campos del reporte
								    	</h4>
								    <br/>
									<div>
	  									<div class="row">
											<br/><br/>
											<div class="row col-md-12">
	   											<div class="col-sm-5">
	   													<span>
								       						Columnas para agrupar:
								    					</span><br/>
	   												<cfset RecordCountColReporteOrigen=0>
		   													<cfquery name = "resgetColReporteOrigen" datasource="#session.DSN#"> 		<!---	Selecciona los valores de RT_ReporteColumna que no existen en RT_ReporteVersionAgrupacion  --->
																select ODCampo as Columna
																from RT_ReporteVerColumna rc
																where NOT EXISTS (
																					select RVAColAgrupacion
																					from RT_ReporteVersionAgrupacion ra
																where ( rc.ODCampo = RVAColAgrupacion)
																					and RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#trim(Session.rtp_vid)#'>
																				)
																and RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#trim(Session.rtp_vid)#'>
																order by ODId
		   													</cfquery>
	   												<cfif resgetColReporteOrigen.RecordCount GT 0>		<!---	En caso que RT_ReporteColumna tenga valores popula el select resgetColReporteOrigen --->
	   													<cfset RecordCountColReporteOrigen='#resgetColReporteOrigen.RecordCount#'>		<!---  Agrega la suma de las columnas a la variable RecordCountColReporteOrigen --->
		   															<cfif resgetColReporteOrigen.RecordCount eq 0 or resgetColReporteOrigen.RecordCount eq 1>
															 			<cfset sizeSelect="2">
																	<cfelse>
															 			<cfset sizeSelect="#resgetColReporteOrigen.RecordCount#">
																	</cfif>

			   													<cfselect name="resgetColReporteOrigen" class="form-control ColReporteOrigen" multiple="no" size=#sizeSelect#>
																	<cfloop query="resgetColReporteOrigen">
																		<option value="<cfoutput>#currentrow#</cfoutput>"><cfoutput>#Columna#</cfoutput></option>
																	</cfloop>
																</cfselect>
	   											    <cfelse>		<!---  En caso contrario obtiene todos los valores de RT_ReporteColumna  --->

	   											    	<cfset RecordCountColReporteOrigen='#resgetColReporte.RecordCount#'>		<!---  Agrega la suma de las columnas a la variable RecordCountColReporteOrigen --->
														<cfquery name = "resgetColReporte" datasource="#session.DSN#">
															select ODCampo as Columna
															from RT_ReporteVerColumna
															where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#trim(Session.rtp_vid)#'>
															order by ODId
														</cfquery>

															<cfif resgetColReporte.RecordCount eq 0 or resgetColReporte.RecordCount eq 1>
															 	<cfset sizeSelect="2">
															<cfelse>
															 	<cfset sizeSelect="#resgetColReporte.RecordCount#">
															</cfif>

														<cfselect name="ColReporteOrigen" class="form-control ColReporteOrigen" multiple="yes" size=#sizeSelect#>
															<cfloop query="resgetColReporte">		<!---  Itera en el datasource para popular el Seleccion destino --->
																<option value="<cfoutput>#currentrow#</cfoutput>"><cfoutput>#Columna#</cfoutput></option>
															</cfloop>
														</cfselect>
	   												</cfif>
	   											</div>

	    										<div class="col-sm-2 text-center">

	   											<cfset ColNumber=Round('#RecordCountColReporteOrigen#'\3)>		<!---  Optine el valor vlaor maximo de columnas del select y las divide para que los DIV de fechas esten centrados con proporcion al tamaño del Select--->

		   											<cfloop from='1' to='#ColNumber#' index="i" step='1'>
														<div >&nbsp;</div>
													</cfloop>

	    										<div class="col-sm-12">
	    											<i class="fa fa-long-arrow-right fa-3x MovDestino" style="cursor: pointer;" onclick="MovDestinoFunc()"></i>
	    										</div>

	    										<div class="col-sm-12">
	    											<i class="fa fa-long-arrow-left fa-3x MovOrigen" style="cursor: pointer;" onclick="MovOrigenFunc()"></i>
	    										</div>
									      		<!---<input type="button" class="AgregarTodos" value="Agregar Todos" 		******* Botones comentados, selecciondar todos   ********
									      		onclick="javascript:AgregarTodosFunc()">
									      		<input type="button" class="QuitarTodos" value="Quitar Todos"
									      		onclick="javascript:QuitarTodosFunc()">--->
	    										</div>
	    										<div class="col-sm-5">
	    												<span>
								       						Columnas agrupadas:
								    					</span><br/>
	    											<cfif resgetColReporteOrigen.RecordCount GT 0>		<!---   Popula el Select de destino, en caso que exitan valores con el valor RPTVId --->
	    												<cfquery name = "resgetColReporteDestino" datasource="#session.DSN#">
	    													select RVAColAgrupacion
	    													from RT_ReporteVersionAgrupacion
	    													where  RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#trim(Session.rtp_vid)#'>
	    													ORDER BY RVAColAgrupacion,RVAId
														</cfquery>

															<cfif #resgetColReporteDestino.RecordCount# eq 0 or #resgetColReporteDestino.RecordCount# eq 1>
															 	<cfset sizeSelect="2">
															<cfelse>
															 	<cfset sizeSelect="#resgetColReporteDestino.RecordCount#">
															</cfif>

														<cfselect name="ColReporteDestino" class="form-control ColReporteDestino" multiple="no" size=#sizeSelect#>
															<cfloop query="resgetColReporteDestino">		<!---  Itera en el datasource para popular el Seleccion destino "#resgetColReporteDestino.RecordCount#"--->
																<option value="<cfoutput>#currentrow#</cfoutput>"><cfoutput>#RVAColAgrupacion#</cfoutput></option>
															</cfloop>
														</cfselect>
	    											<cfelse>		<!---   En caso contrario se carga el Select vacio --->

	    													<cfif #RecordCountColReporteOrigen# eq 0 or #RecordCountColReporteOrigen# eq 1>
															 	<cfset sizeSelect="2">
															<cfelse>
															 	<cfset sizeSelect="#RecordCountColReporteOrigen.RecordCount#">
															</cfif>

	    											<cfselect name="ColReporteDestino" class="form-control ColReporteDestino" multiple="no" size=#sizeSelect#>	<!---#RecordCountColReporteOrigen#	--->
														</cfselect>
	    											</cfif>
	    										</div>
	    									</div>
										</div>
										<br>
										<div class ="row col-sm-4 text-right" >

											<strong>Mostrar:  &nbsp;</strong>

											<cfquery name = "chkValue" datasource="#session.DSN#">		<!---	Selecciona los valores de los checkbox Total y Subtotales--->
	    										select RPTVActivo,RVAAgrupacionTotal, RVAAgrupacionSubTotal,RPTVTipoGrafica from RT_ReporteVersion where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#Session.rtp_vId#'>
											</cfquery>

											<cfif chkValue.RVAAgrupacionTotal EQ 1>		<!---	Agrega el valor de los checkbox Total como activo en relaciona al query chkValue --->
												Total &nbsp;<cfinput type="checkbox" class="chkTotal" name="chkTotal" value="total" checked = "yes" >    &nbsp;
											<cfelse>	<!---	Caso contrario agrega el valor de los checkbox Total como inactivo en relaciona al query chkValue --->
												Total &nbsp;<cfinput type="checkbox" class="chkTotal" name="chkTotal" value="total" checked = "no" >    &nbsp;
											</cfif>

											<cfif chkValue.RVAAgrupacionSubTotal EQ 1>		<!---	Agrega los valores de los checkbox SubTotal como activo en relaciona al query chkValue --->
												Subtotales &nbsp;<cfinput type="checkbox" class="chkSubtotal" name="chkSubtotal" value="subtotal" checked = "yes" >
											<cfelse>	<!---	Caso contrario agrega el valor de los checkbox SubTotal como inactivo en relaciona al query chkValue --->
												Subtotales &nbsp;<cfinput type="checkbox" class="chkSubtotal" name="chkSubtotal" value="subtotal" checked = "no" >
											</cfif>

										</div>
										<br>
										<cfset vpage = 4>
										<cfquery  name="rsVerVariables" datasource="#session.DSN#">
											select count(1) as cuenta
											from RT_ReporteVersionVariable rv
											where Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
												and rv.VFormula = 'ND'
										</cfquery>
										<cfif chkValue.RPTVTipoGrafica eq "ND">
											<cfset vpage = vpage + 1>
												<cfif rsVerVariables.cuenta eq 0>
												<cfset vpage = vpage + 1>
											</cfif>
										</cfif>
										<div class="row">
								        	<div class="col col-md-12">
								        		<input id="btnACamposRPT"  name="btnACamposRPT" class="btnLimpiar btnACamposRPT" value="Anterior" tabindex="0"
								      			onclick="regresar(2,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
								      			<cfif chkValue.RPTVActivo eq 1>
									      			<input id="btnGuardaST"  name="btnGuardaST" class="btnGuardar btnGuardaST" value="Guardar" tabindex="0"
								      					onclick="saveColReporte(2,#trim(Session.rtp_vid)#);" type="button">
													<input id="btnImprimeAgr"  name="btnImprimeAgr" class="btnImprimir btnImprimeAgr" value="Imprimir" tabindex="0" type="button"
										        		onclick="fastimprimir(#trim(Session.rtp_vid)#,false)">
												</cfif>
								        		<input id="btnCamposRPT"  name="btnCamposRPT" class="btnGuardar btnCamposRPT" value="Siguiente" tabindex="0"
								      			onclick="saveColReporte(#vpage#,#trim(Session.rtp_vid)#);" type="button">
								      		</div>
								      	</div>
									</div>
								</cfform>
							</cfcase>

						    <cfcase value="4">
						    	<cfset error = 0>
						    	<!--- Verificamos tipo de grafica del reporte  --->
								<cfquery name="rsVeGra" datasource="#Session.dsn#">
									select RPTVActivo,RPTVTipoGrafica, MostrarTotal from RT_ReporteVersion where RPTVId = #Session.rtp_vId#
								</cfquery>

									<!--- Reseteamos los campos al elegir algun tipo de grafica --->
									<cfif rsVeGra.RPTVTipoGrafica neq "ND">
										<cfquery name="rsNumCam" datasource="#Session.dsn#">
											select * from RT_ReporteVersionDetalle
											WHERE RPTVTipo = 'X' AND RPTVId = #Session.rtp_vId#
										</cfquery>
										<cfif rsNumCam.RecordCount GT 1>
											<cfquery datasource="#Session.dsn#">
												delete RT_ReporteVersionDetalle
												WHERE RPTVTipo = 'X' AND RPTVId = #Session.rtp_vId#
											</cfquery>
										</cfif>
									</cfif>

							    	<cfinvoke component="commons.GeneraReportes.Componentes.GeneraReporte"
										method="getSQL"
										varRPCodigo="#Session.rtp_Codigo#"
										varIdver="#Session.rtp_vId#"
										returnvariable="strSQL"
									/>

									<cfset strSQL = Replace(strSQL, "SELECT", "SELECT TOP 1" ,"one")>

								<cftry>
										<cftransaction isolation="read_committed">
											<cfquery name="rsQRes" datasource="#session.DSN#">
												#PreserveSingleQuotes(strSQL)#
											</cfquery>
											<cftransaction action="rollback" />
										</cftransaction>

										<cfset arrCol = GetMetadata(rsQRes)>

										<cfquery name="rsColumnas" datasource="#Session.dsn#">
											SELECT  * FROM RT_ReporteVersionDetalle where RPTVId = #Session.rtp_vId#
										</cfquery>

										<cfset listOfColumnValues = ValueList( rsColumnas.RPVDCampo,"," )>
								        <div><br/>
								        		<h4>
									               	Seleccionar campos para agregar a la gr&aacute;fica
									            </h4>
									            <br/>
								        	<div class="row">
											</div>
									        <div class="row cont">
									        	<div class="col col-md-6">
										      		<br/><table class="table">
													    <thead>
													        <tr>
													            <th data-field="id">Campos</th>
													            <th data-field="name"></th>
													        </tr>
													    </thead>
													    <tbody>
													    	<cfloop array="#arrCol#" index="col">
													    		<cfif ListFind(listOfColumnValues, #col.Name#) eq 0>
															     	<tr>
															    		<td>#col.Name#</td>
															    		<td>
															    			<!--- <i class='fa fa-table fa-lg' style='cursor:pointer;' onclick='agregaCampo("#col.Name#","Y",#Session.rtp_vid#);'></i>&nbsp; --->
															    			<i class='fa fa-table fa-rotate-270 fa-lg' style='cursor:pointer;' onclick='agregaCampo("#col.Name#","X",#Session.rtp_vid#,"#rsVeGra.RPTVTipoGrafica#");'></i>&nbsp;
																		<cfif rsVeGra.RPTVTipoGrafica neq "ND" and rsVeGra.RPTVTipoGrafica neq "">
															    			<i class='fa fa-info fa-lg' style='cursor:pointer;' onclick='agregaCampo("#col.Name#","V",#Session.rtp_vid#,"#rsVeGra.RPTVTipoGrafica#");'></i>
																		</cfif>
																		</td>
															    	</tr>
														    	</cfif>
													    	</cfloop>
													    </tbody>
													</table>
												</div>
										      	<div class="col col-md-6">
										      		<!--- <div class="row">
										      			<div class="col col-md-12">
															<table class="table">
															    <thead>
															        <tr>
															            <th data-field="id" width="70%">
																			<label>
															                	<i class="fa fa-table"></i>
															                 	Campos de Leyenda o Series
															                </label>
															            </th>
															            <th data-field="name"></th>
															        </tr>
															    </thead>
															    <tbody>
															    	<cfloop query="rsColumnas">
															    		<cfif RPTVTipo EQ "Y">
																    		<tr>
																	    		<td>#RPVDCampo#</td>
																	    		<td>
																	    			<i class='fa fa-trash fa-lg' style='cursor:pointer;' onclick='eliminaCampo("#RPTVDId#",#Session.rtp_vId#);'></i>
																	    		</td>
																	    	</tr>
																    	</cfif>
															    	</cfloop>
															    </tbody>
															</table>
										      			</div>
										      		</div> --->
										      		<div class="row">
										      			<div class="col col-md-12">
															<br/><table class="table">
															    <thead>
															        <tr>
															            <th data-field="id" width="70%">
															            	<label>
																				<i class="fa fa-table fa-rotate-270"></i>
																				<cfif rsVeGra.RPTVTipoGrafica neq "ND">
															                 		Campos de Eje (Max 1 campos)
															                 	<cfelse>
															                 		Campos de Eje (Max 3 campos)
															                 	</cfif>
															                </label>
															            </th>
															            <th data-field="name"></th>
															        </tr>
															    </thead>
															    <tbody>
															    	<cfloop query="rsColumnas">
															    		<cfif RPTVTipo EQ "X">
																    		<tr>
																	    		<td>#RPVDCampo#</td>
																	    		<td>
																	    			<i class='fa fa-trash fa-lg' style='cursor:pointer;' onclick='eliminaCampo("#RPTVDId#",#Session.rtp_vId#);'></i>
																	    		</td>
																	    	</tr>
																    	</cfif>
															    	</cfloop>
															    </tbody>
															</table>
										      			</div>
										      		</div>
										      		<div class="row">
										      			<div class="col col-md-12">
															<br/><table class="table">
															    <thead>
															        <tr>
															            <th data-field="id" width="70%">
															            	<label>
																				<i class="fa fa-info"></i>
																				<cfif rsVeGra.RPTVTipoGrafica neq "ND">
															                 		Valores (Ilimitados)
															                 	<cfelse>
															                 		Valores (Sin valores)
															                 	</cfif>
															                </label>
															            </th>
															            <th data-field="name"></th>
															        </tr>
															    </thead>
															    <tbody>
															    	<cfloop query="rsColumnas">
															    		<cfif RPTVTipo EQ "V">
																    		<tr>
																	    		<td>#RPVDCampo#</td>
																	    		<td>
																	    			<i class='fa fa-trash fa-lg' style='cursor:pointer;' onclick='eliminaCampo("#RPTVDId#",#Session.rtp_vId#);'></i>
																	    		</td>
																	    	</tr>
																    	</cfif>
															    	</cfloop>
															    </tbody>
															</table>
														</div>
										      		</div>
										      	</div>
									        </div><br>


									        <cfcatch type="database">

												<div >&nbsp;</div>
												<div >&nbsp;</div>
												<div >&nbsp;</div>
												<div >&nbsp;</div>

	   												<div>
	   													<strong>La ventana de Listado de Campos contiene valores ambiguos, elimine</br> los campos repetidos para continuar con la creaci&oacuten del reporte.<strong>
	   												</div>

												<div >&nbsp;</div>
	   												<cfset error = 1>
 											</cfcatch>

									</cftry>
											<cfquery  name="rsVerVariables" datasource="#session.DSN#">
												select count(1) as cuenta
												from RT_ReporteVersionVariable rv
												where Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
													and rv.VFormula = 'ND'
											</cfquery>
											<cfset vpage = 5>
											<cfif rsVerVariables.cuenta eq 0>
												<cfset vpage = vpage + 1>
											</cfif>
										    <div class="row">
										        <div class="col col-md-12">
										        	<input id="btnACamposRPT"  name="btnACamposRPT" class="btnLimpiar btnACamposRPT" value="Anterior" tabindex="0"
										      		onclick="regresar(3,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">

													<cfif rsVeGra.RPTVActivo eq 1>
														<input id="btnImprimeAgr"  name="btnImprimeAgr" class="btnImprimir btnImprimeAgr" value="Imprimir" tabindex="0" type="button"
											        		onclick="fastimprimir(#trim(Session.rtp_vid)#,false)">
													</cfif>
										        	<cfif #error# neq 1>
										        		<input id="btnCamposRPT"  name="btnCamposRPT" class="btnGuardar btnCamposRPT" value="Siguiente" tabindex="0"
										      			onclick="UpdateMostrarTotal(<cfoutput>#vpage#</cfoutput>,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
										        	</cfif>

										      	</div>
										    </div>
										</div>

						    </cfcase>
						    <cfcase value="5">
							    <div>
							    	<!--- Verificamos el estatus de la version de reporte --->
									<cfquery  name="rsValVerRe" datasource="#session.DSN#">
										select RPTVActivo from RT_ReporteVersion
										WHERE RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
									</cfquery>

									<cfif rsValVerRe.RPTVActivo neq 1>
										<cfquery datasource="#session.DSN#">
								    		delete from RT_ReporteVersionVariable where Vid_Ref = #Session.rtp_vid#
							    		</cfquery>
										<cfquery datasource="#session.DSN#">
									    	insert into RT_ReporteVersionVariable
											(VVar,VFormula,ODId,VValor,Vid_Ref)
											SELECT  rv.VVar, rv.VFormula,rv.ODId,rv.VValor, #Session.rtp_vid#
											FROM RT_ReporteOrigen ro
											inner join RT_Variable rv
												on ro.ODId = rv.ODId
											where RPTId = #Session.rtp_id#
							    		</cfquery>
									</cfif>

							    	<div class="row">
										<div class="col-md-12">
											<br/>
												<h4>
								       				Variables del reporte
								    			</h4>
										</div>
									<!--- 	<div class="col-md-3">
											<input id="btnActualizarVar"  name="btnActualizarVar" class="btnActualizarVar" value="Actualizar Variables" tabindex="0"
								      		onclick="" type="button">
										</div> --->
									</div>
						        	<div class="row cont">
						        		<div class="col col-md-12">
							        		<div class="row">
												<!--- Contador --->
												<cfset LvarAux = 1>
												<cfset LvarArraySal=ArrayNew(1)>

												<cfquery  name="rsVerVariables" datasource="#session.DSN#">
													select *,(SELECT ODCodigo FROm RT_OrigenDato where ODId = rv.ODId) as ODCodigo
													from RT_ReporteVersionVariable rv
													where Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
														and rv.VFormula = 'ND'
													order by ODId desc
												</cfquery>

												<form name="FormSaveVar" id="FormSaveVar" method="POST">
													<cfif rsVerVariables.RecordCount GT 0>
														<cfoutput query="rsVerVariables">
															<div class="row">
																<cfif ListFind(ArrayToList(LvarArraySal), rsVerVariables.ODCodigo) eq 0>
																	<cfset ArrayAppend(LvarArraySal, rsVerVariables.ODCodigo)>
																	<div class="row">
																		<div class="col-md-6 col-md-offset-3">
																			<br>
																			<strong>#rsVerVariables.ODCodigo#</strong>
																		</div>

																	</div><br>
																	<div class="row">
																		<div class="col-md-4">
																			<strong>Variable</strong>
																		</div>
																		<div class="col-md-4">
																			<strong>Formula</strong>
																		</div>
																		<div class="col-md-4">
																			<strong>Valor</strong>
																		</div>
																	</div>
																	</cfif>
																	<div class="row">
																		<div class="col-md-4">
																			#rsVerVariables.VVar#
																			<!--- Campos ocultos --->
																			<input name="VVar#LvarAux#" id="VVar#LvarAux#" type="hidden"   value="#rsVerVariables.VVar#">
																			<input name="ODId#LvarAux#" id="ODId#LvarAux#" type="hidden"   value="#rsVerVariables.ODId#">
																		</div>
																		<div class="col-md-4">
																			 <select name="Formula#LvarAux#" id ="Formula#LvarAux#" <!--- onchange="ShowInput(#LvarAux#)" --->>
																				<option value="ND" <cfif rsVerVariables.VFormula eq "ND"> selected </cfif>>Valor personalizado</option>
																				<option value="Ecodigo"<cfif rsVerVariables.VFormula eq "Ecodigo"> selected </cfif>>Codigo de la empresa</option>
																				<option value="Parametros"<cfif rsVerVariables.VFormula eq "Parametros"> selected </cfif>>Parametro</option>
																				<option value="Usuario"<cfif rsVerVariables.VFormula eq "Usuario"> selected </cfif>>Usuario actual</option>
																			</select>
																		</div>
																		<div class="col-md-4">
																			<input name="ValorForm#LvarAux#" id="ValorForm#LvarAux#"
																				value="#rsVerVariables.VValor#" type="text" <!--- style="display:none" --->>
																		</div>
																	</div>

															<cfset LvarAux += 1>
														</cfoutput>
													<div class="">
														<!--- Campos ocultos --->
														<input name="LvarContador"  id="LvarContador"   type="hidden"  value="<cfoutput>#rsVerVariables.RecordCount#</cfoutput>">
													</div>
												<cfelse>

												</cfif>
											</div><br>
						        			<input id="btnAImprimeRPT"  name="btnAImprimeRPT" class="btnLimpiar btnAImprimeRPT" value="Anterior" tabindex="0"
								      		onclick="regresar(4,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
								      		<cfif rsValVerRe.RPTVActivo eq 1>
									      		<input id="btnGuardaVariable"  name="btnGuardaVariable" class="btnGuardar btnGuardaVariable" value="Guardar" tabindex="0"
								      				onclick="saveVar(5,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
												<input id="btnImprimeAgr"  name="btnImprimeAgr" class="btnImprimir btnImprimeAgr" value="Imprimir" tabindex="0" type="button"
									        		onclick="fastimprimir(#trim(Session.rtp_vid)#,false)">
											</cfif>
								        	<input id="btnCamposRPT"  name="btnCamposRPT" class="btnGuardar btnCamposRPT" value="Siguiente" tabindex="0"
								      		onclick="saveVar(6,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
								      	</div>
								      	</form>
						        	</div>
							    </div>
						    </cfcase>
						   <cfcase value="6">
						    	<cfform name="frmCondicion">
						    	<cfquery name="rsVersion" datasource="#Session.dsn#">
							    	SELECT  RPTVActivo,RPTVDescripcion FROM RT_ReporteVersion where RPTVId = #Session.rtp_vid#
						    	</cfquery>

						        <div>
						        	<div class="row">&nbsp;</div>
						        	<div class="row cont">
						        		<div class="col col-md-12">
											<div class="form-group">
												<h4>Condiciones del reporte</h4>
												<br/>
															<input type="hidden" name="rptvcidHidden" id="rptvcidHidden" >
																<cfquery name = "ReporteVersionCondicion" datasource="#session.DSN#">
						    											select *
						    											from RT_ReporteVersionCondicion where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#Session.rtp_vId#'>
						    											and 1=2
																</cfquery>

															<div class="row">&nbsp;</div>

	   													<cfquery name = "resgetColReporteOrigenCondicion" datasource="#session.DSN#">
															select ODCampo as Columna
																from RT_ReporteVerColumna rc
																where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#trim(Session.rtp_vid)#'>
																order by ODId
			   											</cfquery>

			   										<div class="row">
														<cfif ReporteVersionCondicion.recordcount GT 0>
															<strong>Modificador: &nbsp;</strong><cfinput type="Radio" name="RdioModificador"  value="y" checked="checked"><span>Y  &nbsp;</span>
														       <cfinput type="Radio" name="RdioModificador"  value="o"><span>O</span>
														<cfelse>
															<strong>Modificador: &nbsp;</strong><cfinput type="Radio" name="RdioModificador" value="y" checked="checked"><span>Y  &nbsp;</span>
														       <cfinput type="Radio" name="RdioModificador" value="o"><span>O</span>
														</cfif>
													</div>
															<div class="row">&nbsp;</div>

													<div class="row">
													    <div class="col-md-1"></div>
													    <div class="col-md-5">

												       		<strong>Campo</strong>
												       			<cfselect name="resgetColReporteOrigenCondicion" class="form-control" multiple="no">
																	<option value="0">Seleccionar una opci&oacuten</option>
																		<cfloop query="resgetColReporteOrigenCondicion">
																	<option value="<cfoutput>#Columna#</cfoutput>"><cfoutput>#Columna#</cfoutput></option>
																		</cfloop>
																</cfselect>
														</div>
												   		<div class="col-md-5">

												   			<strong>Condici&oacuten</strong>
												   				<cfselect name="resgetColCondicion" class="form-control" multiple="no">
																    <option value="0">Seleccionar una opci&oacuten</option>
																    <option value="=">Igual</option>
																    <option value=">">Mayor</option>
																    <option value="<">Menor</option>
																    <option value="!=">Diferente</option>
																    <option value="Like">Contiene</option>
																    <option value=">=">Mayor igual</option>
																    <option value="<=">Menor igual</option>
																    <option value="LikeInicio">Comienza por</option>
																    <option value="LikeFinal">Termina en</option>
																</cfselect>
												    	</div>

													    <div class="col-md-1"></div>
													</div>
															<div class="row">&nbsp;</div>

													<div class="row">
														<div class="col-md-1"></div>
													    <div class="col-md-5"><strong>Valor</strong></div>
													    <div class="col-md-5"><strong>Grupo</strong></div>
													    <div class="col-md-1"></div>
													</div>
													<div class="row">
													    <div class="col-md-1"></div>
													       <div class="col-md-5">
																	<input type="text" id="resgetColValor" name="resgetColValor" size="35" value="#ReporteVersionCondicion.RPTVCValor#">
													       </div>
													       <div class="col-md-5">
																	<input type="text" id="resgetColGrupo" name="resgetColGrupo" size="35" value="#ReporteVersionCondicion.RPTVCGrupo#">
													       </div>
													    <div class="col-md-1"></div>
													</div>
															<div class="row">&nbsp;</div>
		   											 	<div id="Cols">
															<cfinvoke component="commons.GeneraReportes.Componentes.ReporteCOlumna"
															method="getColumnasCondicion"
															rtpvid="#session.rtp_vid#"
															returnvariable="strHTML"/>
															<cfoutput>#strHTML#</cfoutput>
														</div>
											</div>
						        		</div>
						        	</div>
						        	<div class="row">&nbsp;</div>
						        	<div class="row cont">
						        		<div class="col col-md-12">
							        		<cfset vpage = 5>
											<cfquery  name="rsVerVariables" datasource="#session.DSN#">
												select count(1) as cuenta
												from RT_ReporteVersionVariable rv
												where Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
													and rv.VFormula = 'ND'
											</cfquery>
											<cfif rsVerVariables.cuenta eq 0>
												<cfset vpage = 4>
											</cfif>
						        			<input id="btnAImprimeRPT"  name="btnAImprimeRPT" class="btnLimpiar btnAImprimeRPT" value="Anterior" tabindex="0"
								      		onclick="regresar(<cfoutput>#vpage#</cfoutput>,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
								      		<cfif rsVersion.RPTVActivo eq 1>
												<input id="btnImprimeAgr"  name="btnImprimeAgr" class="btnImprimir btnImprimeAgr" value="Imprimir" tabindex="0" type="button"
									        		onclick="fastimprimir(#trim(Session.rtp_vid)#,false)">
											</cfif>
								        	<input id="btnCamposCondicionRPT"  name="btnCamposCondicionRPT" class="btnGuardar btnCamposCondicionRPT" value="Siguiente" tabindex="0"
								      		onclick="saveVar(7,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">

								      	</div>
						        	</div>
						        </div>
						       </cfform>
						    </cfcase>

						    <cfcase value="7">
						    	<cfquery name="rsVersion" datasource="#Session.dsn#">
							    	SELECT  RPTVDescripcion FROM RT_ReporteVersion where RPTVId = #Session.rtp_vid#
						    	</cfquery>
						    	<div>
						        	<div class="row">&nbsp;</div>
						        	<div class="row cont">
						        		<div class="col col-md-12">
											<div class="form-group">
												<h4>Descripci&oacute;n del reporte</h4>
												<br/>
												<div class="col-lg-12 col-centered">
													<span class="help-block text-left">Escriba una descripci&oacute;n para esta configuraci&oacute;n del Reporte.</span>
													<textarea class="form-control txtDesc" rows="3" id="txtDesc">#trim(rsVersion.RPTVDescripcion)#</textarea>
												</div>
											</div>
						        		</div>
						        	</div>
						        	<div class="row">&nbsp;</div>
						        	<div class="row cont">
						        		<div class="col col-md-12">
						        			<input id="btnAImprimeRPT"  name="btnAImprimeRPT" class="btnLimpiar btnAImprimeRPT" value="Anterior" tabindex="0"
								      		onclick="regresar(6,<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
								        	<input id="btnImprimeRPT"  name="btnImprimeRPT" class="btnImprimir btnImprimeRPT" value="Imprimir" tabindex="0"
								      		onclick="imprimir(<cfoutput>#Session.rtp_vid#</cfoutput>);" type="button">
								      	</div>
						        	</div>
						        </div>
						    </cfcase>
						    <cfdefaultcase>
						    	<cf_dbfunction name="op_concat" returnvariable="concat">
						    	<cfquery name="rsVersiones" datasource="#Session.dsn#">
							    	SELECT  b.RPTId,
											a.RPTVId, a.RPTVCodigo, a.RPTVDescripcion, a.RPTVTipoGrafica,
											case a.RPTVTipoGrafica
												when 'B' then 'Gr&aacute;fica de Barra'
												when 'L' then 'Gr&aacute;fica de Linea'
												when 'P' then 'Gr&aacute;fica de Pastel'
												else 'No Mostrar'
											end DescRPTVTipoGrafica,
											'<i title=''Imprimir'' class=''fa fa-print fa-lg'' style=''cursor:pointer;'' onclick=''fastimprimir(' #concat# <cf_dbfunction name="to_char" args="a.RPTVId"> #concat# ');''></i>&nbsp;
											 <i title=''Editar'' class=''fa fa-edit fa-lg'' style=''cursor:pointer;'' onclick=''editar(' #concat# <cf_dbfunction name="to_char" args="a.RPTVId"> #concat# ');''></i>&nbsp;
											 <i title=''Eliminar'' class=''fa fa-trash fa-lg'' style=''cursor:pointer;'' onclick=''eliminar(' #concat# <cf_dbfunction name="to_char" args="a.RPTVId"> #concat# ');''></i>&nbsp;
											 <i title=''Duplicar'' class=''fa fa-copy fa-lg'' style=''cursor:pointer;'' onclick=''copiarVersion(' #concat# <cf_dbfunction name="to_char" args="a.RPTVId"> #concat# ');''></i>&nbsp;
											 <i title=''Compartir'' class=''fa fa-share-alt fa-lg'' style=''cursor:pointer;'' onclick=''compartir(' #concat# <cf_dbfunction name="to_char" args="a.RPTVId"> #concat# ');''></i>' as acciones
									FROM RT_ReporteVersion a
									inner join RT_Reporte b
										on b.RPTId = a.RPTId
									where b.RPCodigo = '#Session.rtp_Codigo#'
										and a.Ecodigo = #Session.Ecodigo#
										and a.Usucodigo = #Session.Usucodigo#
										and a.RPTVActivo = 1
									order by a.RPTVCodigo desc
						    	</cfquery>
								<div id="popupUsuarios" style="display: none;"></div>
						        <div>
						        	<div class="row">&nbsp;</div>
					        		<div class="row cont">
								        <div class="col col-md-12">
								      		<h4>Versiones del Reporte</h4>
								      	</div>
								    </div>
								    <cfif rsVersiones.recordCount GT 0 >
								    	<div class="row cont">
									        <div class="col col-md-12">
									      		<table class="table">
									      			<thead>
									      				<th>C&oacute;digo</th>
									      				<th>Descripci&oacute;n</th>
									      				<th>Mostrar grafica</th>
									      				<th></th>
									      			</thead>
									      			<tbody>
									      				<cfloop query="rsVersiones">
									      					<tr>
										      					<td>#RPTVCodigo#</td>
										      					<td>#RPTVDescripcion#</td>
										      					<td>#DescRPTVTipoGrafica#</td>
										      					<td nowrap>#acciones#</td>
										      				</tr>
									      				</cfloop>
									      			</tbody>
									      		</table>
									      	</div>
									    </div>
								    </cfif>
								    <div class="row">&nbsp;</div>
								    <div class="row">
								        <div class="col col-md-12">
								      		<input id="btnNuevoRPT"  name="btnNuevoRPT" class="btnNuevo btnNuevoRPT" value="Nuevo" tabindex="0" type="button"
								      		onclick="javascript:creaNuevo()">
								      	</div>
								    </div>
								</div>
						    </cfdefaultcase>
						</cfswitch>
					</div>
				</div>
			</div>
		</cfsavecontent>
		<cfreturn result>
	</cffunction>

	<cffunction name="creaVersion" access="remote" returnformat="plain">
		<cfquery datasource="#session.DSN#">
			INSERT INTO RT_ReporteVersion
		           (RPTVCodigo
		           ,RPTVDescripcion
		           ,Usucodigo
		           ,Ecodigo
		           ,RPTId
		           ,RPTVTipoGrafica
		           ,RPTVActivo)
		     VALUES
		           (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.rtp_Codigo#_#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#">
		           ,NULL
		           ,#Session.Usucodigo#
		           ,#Session.Ecodigo#
		           ,#Session.rtp_Id#
		           ,NULL
		           ,0)
		</cfquery>
		<cfquery name="rsGetInsert" datasource="#session.DSN#">
			select max(RPTVId) RPTVId
			from  RT_ReporteVersion
		    where Usucodigo = #Session.Usucodigo#
		        and Ecodigo = #Session.Ecodigo#
		        and RPTId = #Session.rtp_Id#
		</cfquery>

		<cfset Session.rtp_vid =  rsGetInsert.RPTVId>

		<cfquery datasource="#session.DSN#">
	    	insert into RT_ReporteVersionVariable
			(VVar,VFormula,ODId,VValor,Vid_Ref)
			SELECT  rv.VVar, rv.VFormula,rv.ODId,rv.VValor, #Session.rtp_vid#
			FROM RT_ReporteOrigen ro
			inner join RT_Variable rv
				on ro.ODId = rv.ODId
			where RPTId = #Session.rtp_id#
   		</cfquery>

		<cfreturn Session.rtp_vid>
	</cffunction>

	<cffunction name="doCompartir" access="remote" returnformat="plain">
		<cfargument name="versionid" type="numeric" required="true">

		<cfif isdefined("form.datosform") and len(trim(form.datosform))
			and isdefined("form.versionid") and len(trim(form.versionid))>
			<cfset arrSUsers = listToArray(form.datosform,"&")>
			<cfloop index="checkU" array="#arrSUsers#">
				<cfset arrUsers = listToArray(checkU,"=")>
				<cfset copiaVersion(form.versionid, arrUsers[2])>
			</cfloop>
		</cfif>

	</cffunction>

	<cffunction name="copiaVersion" access="remote" returnformat="plain">
		<cfargument name="versionid" type="numeric" required="true">
		<cfargument name="usuario" required="false" default="#Session.Usucodigo#">

		<!--- copiando version --->
		<cfquery datasource="#session.DSN#">
			INSERT INTO RT_ReporteVersion
	           (RPTVCodigo
	           ,RPTVDescripcion
	           ,Usucodigo
	           ,Ecodigo
	           ,RPTId
	           ,RPTVTipoGrafica
	           ,RPTVActivo
	           ,MostrarTotal
	           ,RVAAgrupacionTotal
	           ,RVAAgrupacionSubTotal)
			SELECT
			      <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.rtp_Codigo#_#DateFormat(now(),'yyyy-mm-dd-')##TimeFormat(now(),'HH-mm-ss-lll')#">
			      ,RPTVDescripcion
			      ,#Arguments.usuario#
			      ,Ecodigo
			      ,RPTId
			      ,RPTVTipoGrafica
			      ,RPTVActivo
			      ,MostrarTotal
			      ,RVAAgrupacionTotal
			      ,RVAAgrupacionSubTotal
			  FROM RT_ReporteVersion
			  WHERE RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.versionid#">
		</cfquery>
		<cfquery name="rsGetInsert" datasource="#session.DSN#">
			select max(RPTVId) RPTVId
			from  RT_ReporteVersion
		    where Usucodigo = #Arguments.usuario#
		        and Ecodigo = #Session.Ecodigo#
		        and RPTId = #Session.rtp_Id#
		</cfquery>

		<cfset rtp_vid =  rsGetInsert.RPTVId>
		<!--- copiando configuracion --->
		<!--- columnas --->
		<cfquery datasource="#Session.dsn#">
			INSERT INTO RT_ReporteVerColumna
	           (RPTVId
	           ,ODId
	           ,ODCampo
	           ,RTPCAlias
	           ,RTPCOrdenColumna
	           ,RTPCOrdenDato
	           ,RPTCCalculo)
			SELECT #rtp_vid#
			      ,ODId
			      ,ODCampo
			      ,RTPCAlias
			      ,RTPCOrdenColumna
			      ,RTPCOrdenDato
			      ,RPTCCalculo
			  FROM RT_ReporteVerColumna
			  WHERE RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.versionid#">
		</cfquery>
		<!--- agrupacion --->
		<cfquery datasource="#session.dsn#">
			INSERT INTO RT_ReporteVersionAgrupacion
	           (RPTVId
	           ,RVAColAgrupacion)
			SELECT #rtp_vid#
			      ,RVAColAgrupacion
			  FROM dbo.RT_ReporteVersionAgrupacion
			  WHERE RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.versionid#">
		</cfquery>
		<!--- Grafica --->
		<cfquery datasource="#session.dsn#">
			INSERT INTO RT_ReporteVersionDetalle
	           (RPTVId
	           ,RPVDCampo
	           ,RPTVTipo)
			SELECT #rtp_vid#
			      ,RPVDCampo
			      ,RPTVTipo
			FROM RT_ReporteVersionDetalle
			WHERE RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.versionid#">
		</cfquery>
		<!--- Condiciones --->
		<cfquery datasource="#session.dsn#">
			INSERT INTO RT_ReporteVersionCondicion
	           (RPTVCCampo
	           ,RPTVCCondicion
	           ,RPTVCValor
	           ,RPTVId
	           ,RPTVCY_O
	           ,RPTVCGrupo)
			SELECT RPTVCCampo
			      ,RPTVCCondicion
			      ,RPTVCValor
			      ,#rtp_vid#
			      ,RPTVCY_O
			      ,RPTVCGrupo
			  FROM RT_ReporteVersionCondicion
			WHERE RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.versionid#">
		</cfquery>
		<!--- Variables --->
		<cfquery datasource="#session.dsn#">
			INSERT INTO RT_ReporteVersionVariable
	           (VVar
	           ,ODId
	           ,VValor
	           ,Vid_Ref
	           ,VFormula)
			SELECT VVar
			      ,ODId
			      ,VValor
			      ,#rtp_vid#
			      ,VFormula
			  FROM RT_ReporteVersionVariable
			WHERE Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.versionid#">
		</cfquery>
		<cfreturn rtp_vid>
	</cffunction>

	<cffunction name="actualizaVersion" access="remote">
		<cfargument name="grafica" required="false">
		<cfargument name="descripcion" default="">
		<cfquery datasource="#session.DSN#">
			update RT_ReporteVersion
		        set
		        	Usucodigo = #Session.Usucodigo#
		        <cfif isdefined("Arguments.grafica")>
			    	,RPTVTipoGrafica = '#Arguments.grafica#'
			    </cfif>
			    <cfif isdefined("Arguments.descripcion") and trim(Arguments.descripcion) NEQ "">
			    	,RPTVDescripcion = '#trim(Arguments.descripcion)#'
			    	,RPTVActivo = 1
		        </cfif>
		    where RPTVId = #Session.rtp_vid#
		</cfquery>
	</cffunction>

	<cffunction name="eliminaVersion" access="remote">
		<cfargument name="rtp_vid" default="">
		<cftransaction>
			<cfquery datasource="#session.DSN#">
				delete from  RT_ReporteVersionAgrupacion
			    where RPTVId = #Arguments.rtp_vid#
			</cfquery>

			<cfquery datasource="#session.DSN#">
				delete from  RT_ReporteVersionDetalle
		    	where RPTVId = #Arguments.rtp_vid#
			</cfquery>

			<cfquery datasource="#session.DSN#">
				delete from  RT_ReporteVersionCondicion
		    	where RPTVId = #Arguments.rtp_vid#
			</cfquery>

			<cfquery datasource="#session.DSN#">
				delete from  RT_ReporteVerColumna
		   	 	where RPTVId = #Arguments.rtp_vid#
			</cfquery>

			<cfquery datasource="#session.DSN#">
				delete from  RT_ReporteVersion
		   	 where RPTVId = #Arguments.rtp_vid#
			</cfquery>
	    </cftransaction>

	</cffunction>

	<cffunction name="agregaCampo" access="remote">
		<cfargument name="campo" default="">
		<cfargument name="tipo" default="">
		<cfargument name="LvarGrafica" default="">

		<cfset flagInserta = 'true'>

		<cfquery name="rsCuentaX" datasource="#session.DSN#">
			select RPTVDId from RT_ReporteVersionDetalle
		     Where RPTVId = #Session.rtp_vid#
		        and RPTVTipo ='X'
		</cfquery>
		<cfif Arguments.tipo EQ 'X' and Arguments.LvarGrafica NEQ 'ND'>
			<cfif rsCuentaX.recordCount GT 0>
				<cfset flagInserta = 'false'>
			</cfif>
		</cfif>
		<cfif Arguments.tipo EQ 'X' and Arguments.LvarGrafica EQ 'ND'>
			<cfif rsCuentaX.recordCount EQ 3>
				<cfset flagInserta = 'false'>
			</cfif>
		</cfif>

		<cfif flagInserta>
			<cfquery datasource="#session.DSN#">
				INSERT INTO RT_ReporteVersionDetalle
			           (RPTVId
			           ,RPVDCampo
			           ,RPTVTipo)
			     VALUES
			           (#Session.rtp_vid#
			           ,'#Arguments.campo#'
			           ,'#Arguments.tipo#')
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="eliminaCampo" access="remote">
		<cfargument name="idcampo" default="">
		<cfquery datasource="#session.DSN#">
			Delete from  RT_ReporteVersionDetalle
		    where RPTVDId = #Arguments.idcampo#
		</cfquery>
	</cffunction>
	<!--- Actualizar variables de reportes --->
	<cffunction name="saveVariables" access="remote">
		<!--- sabemso el numero de variables --->
		<cfset LvarContador="#form.LvarContador#">

		<cfloop index = "Count" from = "1" to = "#LvarContador#" step = "1">
			<cfset LvarVVarAux 		= FORM["VVar"&Count]>
			<cfset LvarFormulaAux 	= FORM["Formula"&Count]>
			<cfset LvarValorFormAux = FORM["ValorForm"&Count]>
			<cfset LvarODIdAux 		= FORM["ODId"&Count]>

			<cfif LvarFormulaAux eq "Ecodigo">
				<cfquery datasource="#session.DSN#">
					update RT_ReporteVersionVariable
						set VFormula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFormulaAux#">,
							VValor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarValorFormAux#">
					where VVar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarVVarAux#">
					and Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
					and ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarODIdAux#">
				</cfquery>
			<cfelse>
				<cfif LvarValorFormAux neq "" and LvarFormulaAux neq "">
					<cfquery datasource="#session.DSN#">
					update RT_ReporteVersionVariable
						set VFormula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFormulaAux#">,
							VValor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarValorFormAux#">
					where VVar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarVVarAux#">
					and Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
					and ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarODIdAux#">
				</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>

	<!--- Actualizamos --->
	<cffunction name="UpMosTotal" access="remote">
		<cfargument name="IdV" default="">
		<cfargument name="LvarMT" default="">

		<cfif arguments.LvarMT  eq 'true'>
			<cfquery datasource="#session.DSN#">
				update RT_ReporteVersion set MostrarTotal = 1 where RPTVId = #Session.rtp_vid#
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update RT_ReporteVersion set MostrarTotal = 0 where RPTVId = #Session.rtp_vid#
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="saveColReporte" access="remote">		<!---  Funcion que inserta y actuliza datos de tabla Agrupamiento --->

		<cfargument name="chkTotalValue" default="required" >
		<cfargument name="chkSubtotalValue" default="required" >
		<cfargument name="optionValue" default="0" type="string" />

			<cfif '#Arguments.optionValue#' NEQ "0">	<!---  En caso que el arreglo tenga valores itera en la insercion de estos en RT_ReporteVersionAgrupacion --->

				<cfquery datasource="#session.dsn#">
					delete from RT_ReporteVersionAgrupacion
					where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#trim(Session.rtp_vid)#'>
				</cfquery>
					<cfloop index = "ListElement" list = '#Arguments.optionValue#' delimiters=",">

					    <cfquery datasource="#session.dsn#">
						    insert into RT_ReporteVersionAgrupacion
								(RPTVId, RVAColAgrupacion)
								VALUES(<cfqueryparam cfsqltype="cf_sql_numeric" value='#Session.rtp_vid#'>,
							<cfoutput>'#ListElement#'</cfoutput>)
						</cfquery>

					</cfloop>
				<cfelse>

					<cfquery datasource="#session.dsn#">
			    		delete from RT_ReporteVersionAgrupacion
						where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#trim(Session.rtp_vid)#'>
					</cfquery>
			</cfif>

			<cfquery datasource="#session.dsn#">		<!---  Actuliza los valores de los check Total y Subtotal,  --->
				UPDATE RT_ReporteVersion SET RVAAgrupacionTotal=<cfqueryparam cfsqltype="cf_sql_numeric" value='#Arguments.chkTotalValue#'>,
				RVAAgrupacionSubTotal = <cfqueryparam cfsqltype="cf_sql_numeric" value='#Arguments.chkSubtotalValue#'> where
				RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value='#Session.rtp_vId#'>
			</cfquery>

	</cffunction>

	<cffunction name="showNav" access="private" returntype="string">
		<cfargument name="page" default="">
		<cfquery name="rsVersionTG" datasource="#session.dsn#">
			select RPTVTipoGrafica from RT_ReporteVersion where RPTVId = #Session.rtp_vId#
		</cfquery>
		<cfquery  name="rsVerVariables" datasource="#session.DSN#">
			select count(1) as cuenta
			from RT_ReporteVersionVariable rv
			where Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.rtp_vid#">
				and rv.VFormula = 'ND'
		</cfquery>
		<cfsavecontent variable="result">
			<cfoutput>
				<div class="list-group">
				  <a href="##" class="list-group-item <cfif arguments.page eq 1>active</cfif>" onclick="loadPage(1,#trim(Session.rtp_vid)#)">Tipo de Gr&aacute;fica</a>
				  <a href="##" class="list-group-item <cfif arguments.page eq 2>active</cfif>" onclick="loadPage(2,#trim(Session.rtp_vid)#)">Columnas</a>
				  <a href="##" class="list-group-item <cfif arguments.page eq 3>active</cfif>" onclick="loadPage(3,#trim(Session.rtp_vid)#)">Agrupaci&oacute;n</a>
				  <cfif rsVersionTG.RPTVTipoGrafica neq "ND">
				  	<a href="##" class="list-group-item <cfif arguments.page eq 4>active</cfif>" onclick="loadPage(4,#trim(Session.rtp_vid)#)">Campos Gr&aacute;fica</a>
				  </cfif>
				  <cfif rsVerVariables.cuenta gt 0>
				  	<a href="##" class="list-group-item <cfif arguments.page eq 5>active</cfif>" onclick="loadPage(5,#trim(Session.rtp_vid)#)">Variables</a>
				  </cfif>
				  <a href="##" class="list-group-item <cfif arguments.page eq 6>active</cfif>" onclick="loadPage(6,#trim(Session.rtp_vid)#)">Condiciones</a>
				  <a href="##" class="list-group-item <cfif arguments.page eq 7>active</cfif>" onclick="loadPage(7,#trim(Session.rtp_vid)#)">Imprimir</a>
				</div>
			</cfoutput>
		</cfsavecontent>
		<cfreturn result>
	</cffunction>

	<cffunction name="ListDeleteDuplicates"access="private" returntype="string">
		<cfargument name="list">
		 <cfset returnValue = ''>
	     <cfset arrList = listToArray(arguments.list)>
	     <cfif ArrayLen(arrList) GTE 1>
	          <cfloop index = "LoopCount" from="1" to="#ArrayLen(arrList)#">
	          		<cfif ListFind(returnValue, arrList[LoopCount]) eq 0>
	                    <cfset ListAppend(returnValue, arrList[LoopCount])>
	               </cfif>
	          </cfloop>
	     </cfif>
	     <cfreturn returnValue>
	</cffunction>

	<cffunction name="showUsers" access="remote" returntype="string">
		<cf_dbfunction name="op_concat" returnvariable="concat">
    	<cfquery name="rsUsuarios" datasource="#Session.dsn#">
	    	SELECT distinct u.Usucodigo, u.Usulogin, UPPER(b.Pnombre) #concat# ' ' #concat# UPPER(b.Papellido1) #concat# ' ' #concat# UPPER(b.Papellido2) as usuario
			FROM Usuario u
				INNER JOIN DatosPersonales b on u.datos_personales = b.datos_personales
				INNER JOIN vUsuarioProcesos a ON a.Usucodigo = u.Usucodigo
				INNER JOIN Empresas d ON d.EcodigoSDC = a.Ecodigo
				AND d.Ecodigo = #session.Ecodigo#
			WHERE CEcodigo = #session.CEcodigo#
				AND Uestado = 1
				and u.Usucodigo <> #Session.Usucodigo#
			order by u.Usulogin
    	</cfquery>
        <div>
        	<div class="row cont">
		        <div class="col col-md-12">
		      		<h4>Compartir con:</h4>
		      	</div>
		    </div>

		    <cfif rsUsuarios.recordCount GT 0 >
		    	<div class="row cont">
			        <div id="tusers" class="col col-md-12">
				        <cfform name="frmUsuarios">
			      		<table class="table">
			      			<thead>
			      				<th>
				      				<input name="chkAllUser" id="chkAllUser" value="all" class="chkAllUser" type="checkbox" onchange="toogleUsers(this)">
								</th>
			      				<th>Usuario</th>
			      				<th>Nombre</th>
			      				<th></th>
			      			</thead>
			      			<tbody>
			      				<cfloop query="rsUsuarios">
			      					<tr>
				      					<td><cfinput type="checkbox" class="chkUser" name="chkUser" value="#Usucodigo#" ></td>
				      					<td>#Usulogin#</td>
				      					<td>#usuario#</td>
				      				</tr>
			      				</cfloop>
			      			</tbody>
			      		</table>
			      		</cfform>
			      	</div>
			    </div>
		    </cfif>
		    <div class="row">&nbsp;</div>
		    <div class="row">
		        <div class="col col-md-12">
		      		<input id="btnCompartirRPT"  name="btnCompartirRPT" class="btnGuardar btnCompartirRPT" value="Compartir" tabindex="0" type="button"
		      		onclick="javascript:doCompartir(#url.idVer#)">
		      	</div>
		    </div>
		</div>
	</cffunction>
</cfcomponent>