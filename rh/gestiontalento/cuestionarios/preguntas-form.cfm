			<cfoutput>
			<form name="form3" method="post" action="cuestionario-sql.cfm" onSubmit="return validar(this);" style="margin:0; ">
				<input type="hidden" name="tab" value="3">
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="PCid" value="#pcdata.PCid#">
				</cfif>
				
				<cfif isdefined("form.pageNum_lista")>
					<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#">
				</cfif>
				<cfif isdefined("form.fPCcodigo")>
					<input type="hidden" name="fPCcodigo" value="#form.fPCcodigo#">
				</cfif>
				<cfif isdefined("form.fPCnombre")>
					<input type="hidden" name="fPCnombre" value="#form.fPCnombre#">
				</cfif>
				<cfif isdefined("form.fPCdescripcion")>
					<input type="hidden" name="fPCdescripcion" value="#form.fPCdescripcion#">
				</cfif>
				

				<!--- SECCION DE PREGUNTAS --->
					<table width="99%" cellpadding="0" cellspacing="1" align="center" >
						<tr><td align="center" colspan="2" class="tituloPersona" style="text-align:center; padding:3px;">#trim(cuestionario.PCcodigo)# - #cuestionario.PCnombre#</td></tr>
						<tr>
							<td valign="top" width="40%">
					<cfparam name="pageNum_lista" default="1">
					<cfset navegacion = '' >
					<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista)) >
						<cfset navegacion = navegacion & '&pageNum_lista=#form.pageNum_lista#' >
					</cfif>
					<cfif isdefined("form.fPCcodigo") and len(trim(form.fPCcodigo)) >
						<cfset navegacion = navegacion & '&fPCcodigo=#form.fPCcodigo#' >
					</cfif>
					<cfif isdefined("form.fPCnombre") and len(trim(form.fPCnombre)) >
						<cfset navegacion = navegacion & '&fPCnombre=#form.fPCnombre#' >
					</cfif>
					<cfif isdefined("form.fPCdescripcion") and len(trim(form.fPCdescripcion)) >
						<cfset navegacion = navegacion & '&fPCdescripcion=#form.fPCdescripcion#' >
					</cfif>

								<cfquery name="rsListaPreguntas" datasource="sifcontrol">
									select PPid as _PPid, {fn concat('<cf_translate key="LB_Parte">Parte</cf_translate>', <cf_dbfunction name="to_char" args="PPparte" datasource="sifcontrol"> )} as _PPpartedesc, PPnumero as _PPnumero, PPpregunta as _PPpregunta, PPtipo as _PPtipo, PPvalor as _PPvalor 
									from PortalPregunta
									where PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
									order by PPparte, PPnumero, PPorden
								</cfquery>
								<cfset navegacion = "&PCid=#form.PCid#" >
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Numero"
								Default="Número"
								returnvariable="LB_Numero"/>
								
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Pregunta"
								Default="Pregunta"
								returnvariable="LB_Pregunta"/>								
								
								<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
									<cfinvokeargument name="query" 			value="#rsListaPreguntas#">
									<cfinvokeargument name="desplegar" 		value="_PPnumero,_PPpregunta">
									<cfinvokeargument name="etiquetas" 		value="#LB_Numero#,#LB_Pregunta#">
									<cfinvokeargument name="formatos" 		value="S,S">
									<cfinvokeargument name="align" 			value="left,left">
									<cfinvokeargument name="ira" 			value="cuestionario-tabs.cfm">
									<cfinvokeargument name="keys" 			value="_PPid">
									<cfinvokeargument name="showEmptyListMsg" value="true">
									<cfinvokeargument name="incluyeform" 	value="false">
									<cfinvokeargument name="formname"		value="form3">
									<cfinvokeargument name="ajustar"		value="S">
									<cfinvokeargument name="navegacion"		value="#navegacion#">
									<cfinvokeargument name="cortes"			value="_PPpartedesc">
									<cfinvokeargument name="pageindex"		value="2">
								</cfinvoke>	
							</td>
	
							<td align="center" width="60%" valign="top">

																<cfif isdefined("url.PPid") and not isdefined("form.PPid")>
																	<cfset form.PPid = url.PPid >
																</cfif>
																
																<cfif isdefined("form._PPid") and len(trim(form._PPid))>
																	<cfset form.PPid = form._PPid >
																</cfif>
																
																<cfset modo_pregunta = 'ALTA'>
																<cfif isdefined("form.PPid")>
																	<cfset modo_pregunta = 'CAMBIO'>
																	<cfquery name="ppdata" datasource="sifcontrol">
																		select PPid, PPparte, PPnumero, PPpregunta, PPtipo, PPvalor, PPrespuesta, PPorden, PPmantener
																		from PortalPregunta
																		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
																		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
																	</cfquery>
																	<cfquery name="prdata" datasource="sifcontrol">
																		select PCid, PPid, PRid, PRtexto, PRvalor, PRira, PRorden
																		from PortalRespuesta
																		where PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
																		  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
																	</cfquery>
																</cfif>
																
																<cfquery name="datanumero" datasource="sifcontrol">
																	select coalesce(max(PPnumero),0)+1 as numero
																	from PortalPregunta
																	where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
																</cfquery>
																
																<cfquery name="dataira" datasource="sifcontrol">
																	select PPid, PPnumero 
																	from PortalPregunta
																	where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
																	and PPtipo != 'E'
																	<cfif isdefined("form.PPid")>
																		and PPnumero > ( select PPnumero 
																						 from PortalPregunta 
																						 where PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
																						   and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"> )
																	</cfif>				 
																	order by PPparte, PPnumero				 
																</cfquery>
																
																<cfquery name="partes" datasource="sifcontrol">
																	select PPparte, PCPdescripcion
																	from PortalCuestionarioParte
																	where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
																</cfquery>
																
																<cfoutput>
																<table border="0" cellpadding="0" cellspacing="2" width="100%" align="center" >
																	<cfif modo_pregunta neq 'ALTA'>
																		<input type="hidden" name="PPid" value="#ppdata.PPid#">
																	</cfif>
																	<cfif isdefined("form.pagenum")>
																		<input type="hidden" name="_pagenum" value="#form.pagenum#">
																	</cfif>
																
																	<tr>
																	  <td align="right" width="1%" nowrap ><cf_translate key="LB_parte">Parte</cf_translate>:&nbsp;</td>
																		<td>
																			<select name="PPparte" onFocus="restaurar_color(this);">
																				<option value="">-- seleccionar --</option>
																				<cfloop query="partes">
																					<option value="#partes.PPparte#" <cfif modo_pregunta eq 'CAMBIO' and ppdata.PPparte eq partes.PPparte >selected</cfif> >#partes.PPparte# - #partes.PCPdescripcion#</option>
																				</cfloop>
																			</select>		
																		</td>
																		<td align="right" width="1%" nowrap ><cf_translate key="LB_numero">Número</cf_translate>
																		  :&nbsp;</td>
																		<td>
																			<input type="text" name="PPnumero" size="7" maxlength="3"  style="text-align:right;" value="<cfif modo_pregunta neq 'ALTA'>#trim(ppdata.PPnumero)#<cfelse>#datanumero.numero#</cfif>"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">		
																		</td>
																	</tr>
																	<tr>
																		<td align="right" valign="top" nowrap ><cf_translate key="LB_pregunta">Pregunta</cf_translate>:&nbsp;</td>
																		<td colspan="3">
																			<!---<textarea name="PPpregunta" onClick="this.select()" cols="60" rows="7" onFocus="restaurar_color(this); this.select();"><cfif modo_pregunta neq 'ALTA'>#trim(ppdata.PPpregunta)#</cfif></textarea>--->
																			<cfif modo_pregunta neq 'ALTA'>
																				<cf_sifeditorhtml name="PPpregunta" value="#ppdata.PPpregunta#">
																			<cfelse>
																				<cf_sifeditorhtml name="PPpregunta">
																			</cfif>		</td>	
																	</tr>

																	<tr>
																		<td align="right" ><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</td>
																		<td >
																			<select name="PPtipo" onFocus="restaurar_color(this);">
																				<option value=""><cf_translate key="LB_Seleccione">-- seleccione --</cf_translate></option>
																				<option value="D" <cfif modo_pregunta neq 'ALTA' and ppdata.PPtipo eq 'D'>selected</cfif> ><cf_translate key="CMB_Desarrollo">Desarrollo</cf_translate></option>
																				<option value="E" <cfif modo_pregunta neq 'ALTA' and ppdata.PPtipo eq 'E'>selected</cfif> ><cf_translate key="CMB_Etiqueta">Etiqueta</cf_translate></option>
																				<option value="O" <cfif modo_pregunta neq 'ALTA' and ppdata.PPtipo eq 'O'>selected</cfif> ><cf_translate key="CMB_Ordenamiento">Ordenamiento</cf_translate></option>
																				<option value="M" <cfif modo_pregunta neq 'ALTA' and ppdata.PPtipo eq 'M'>selected</cfif> ><cf_translate key="CMB_SeleccionMultiple">Selecci&oacute;n M&uacute;ltiple</cf_translate></option>
																				<option value="U" <cfif modo_pregunta neq 'ALTA' and ppdata.PPtipo eq 'U'>selected</cfif> ><cf_translate key="CMB_SeleccionUnica">Selecci&oacute;n &Uacute;nica</cf_translate></option>
																				<option value="V" <cfif modo_pregunta neq 'ALTA' and ppdata.PPtipo eq 'V'>selected</cfif> ><cf_translate key="CMB_Valorizacion">Valorizaci&oacute;n</cf_translate></option>
																			</select>		</td>
																		<td colspan="2">
																			<table width="100%">
																				<tr>
																					<td width="1%">
																						<input type="checkbox" style="border:0;" name="PPmantener" <cfif modo_pregunta neq 'ALTA' and ppdata.PPmantener eq 1 >checked</cfif> >					</td>			
																					<td>
																						<cf_translate key="CHK_MantenerEnBloqueDePregunta">Mantener en bloque</cf_translate>					</td>
																				</tr>
																			</table>		</td>
																		</td>		


																	</tr>
																	
																	<!---	
																	<tr>
																		<td align="right" ></td>
																		<td colspan="3">
																			<table width="100%">
																				<tr>
																					<td width="1%">
																						<input type="checkbox" style="border:0;" name="PPmantener" <cfif modo_pregunta neq 'ALTA' and ppdata.PPmantener eq 1 >checked</cfif> >					</td>			
																					<td>
																						<cf_translate key="CHK_MantenerEnBloqueDePregunta">Mantener en bloque de preguntas</cf_translate>					</td>
																				</tr>
																			</table>		</td>
																	</tr>
																	--->

																	<tr>
																		<td align="right" ><cf_translate key="LB_Valor">Valor</cf_translate>:&nbsp;</td>
																		<td >
																			<!---<input type="text" name="PPvalor" size="7" maxlength="7" style="text-align: right;"  onFocus="restaurar_color(this); this.select(); " value="<cfif modo_pregunta neq 'ALTA'>#trim(ppdata.PPvalor)#</cfif>">--->
																			<input type="text" name="PPvalor" size="7" maxlength="7" style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" value="<cfif modo_pregunta neq 'ALTA'>#trim(ppdata.PPvalor)#</cfif>" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">		</td>
																		<td align="right" nowrap><cf_translate key="LB_Orden">Orden</cf_translate>:&nbsp;</td>
																		<td >
																			<input type="text" name="PPorden" size="3" maxlength="3" style="text-align:right;"  value="<cfif modo_pregunta neq 'ALTA'>#ppdata.PPorden#</cfif>" onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">		</td>
																	</tr>


																	<tr>
																		<td align="right" nowrap><cf_translate key="LB_Respuestas">Respuestas</cf_translate>:&nbsp;</td>
																		<td colspan="3">
																			<input type="text" name="PPrespuesta" size="60" maxlength="60"  onFocus="javascript:restaurar_color(this); this.select();" value="<cfif modo_pregunta neq 'ALTA'>#trim(ppdata.PPrespuesta)#</cfif>" >		</td>
																	</tr>

																	
																	<!--- ASI ESTABA ANTES CON HTML DINAMICO NO BORRAR PARA CORREGIR
																		<tr><td colspan="2">&nbsp;</td></tr>
																		<tr>
																			<td></td>
																			<td >
																			<table width="100%" id="myTable" cellpadding="3" cellspacing="0" align="center" style="border:1px solid gray;">
																				<tr>
																					<td bgcolor="##CCCCCC" ><strong>Opciones de Respuesta</strong></td>
																					<td bgcolor="##CCCCCC" ><strong>Valor</strong></td>
																					<td bgcolor="##CCCCCC" ><strong>Ref.</strong></td>
																					<td bgcolor="##CCCCCC" ><strong>Orden</strong></td>	
																					<td bgcolor="##CCCCCC" >&nbsp;</td>				
																				</tr>
																				<cfif modo_pregunta neq 'ALTA'>
																					<cfloop query="prdata">
																						<cfset ira = prdata.PRira >
																						<tr>
																							<td>
																								<cfset expresion = "\<[A-Za-z=\'" >
																								<cfset expresion = expresion & '\"\0-9.\(\)\:\;\-## ]*>' >
																								<input type="text" name="_PRtexto_#prdata.currentrow+50#" size="45" maxlength="255" value="#trim(REReplace(prdata.PRtexto,expresion,'','ALL'))#" onClick="javascript:this.select();" onChange="javascript: setvalor(this);">
																								<input type="hidden" name="PRtexto_#prdata.currentrow+50#" value="#HTMLEditFormat(trim(prdata.PRtexto))#" onClick="this.select();">
																								<input type="hidden" name="PRid_#prdata.currentrow+50#" value="#prdata.PRid#">
																							</td>
																							<td><input type="text" name="PRvalor_#prdata.currentrow+50#" size="7" maxlength="7" value="#prdata.PRvalor#"  style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript: if (trim(this.value) != ''){fm(this,2);}"   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
																							<td>
																								<select name="PRira_#prdata.currentrow+50#">
																									<option value=""></option>
																									<cfloop query="dataira">
																										<option value="#dataira.PPid#" <cfif ira eq dataira.PPid >selected</cfif>>#dataira.PPnumero#</option>
																									</cfloop>
																								</select>
																							</td>
																							<td><input type="text" name="PRorden_#prdata.currentrow+50#" size="3" maxlength="3" value="#prdata.PRorden#"  style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
																							<td><img src="/cfmx/rh/imagenes/iindex.gif" border="0" onClick="javascript:formatear(#prdata.PRid#, #prdata.currentrow+50#);" style="cursor:hand;"></td>
																						</tr>
																					</cfloop>
																				</cfif>
																				<tr>
																					<td><input type="text" name="PRtexto_1" size="45" maxlength="255" value="" onClick="this.select();"></td>
																					<td><input type="text" name="PRvalor_1" size="7" maxlength="7" style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" value="" onBlur="javascript: if (trim(this.value) != ''){fm(this,2);}"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
																					<td>
																						<select name="PRira_1">
																							<option value=""></option>
																							<cfloop query="dataira">
																								<option value="#dataira.PPid#" >#dataira.PPnumero#</option>
																							</cfloop>
																						</select>
																					</td>
																					<td><input type="text" name="PRorden_1" size="3" maxlength="3" value=""  style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
																					<td><input type="button" style="width:25px;" value="+" onClick="javascript:insRow();"></td>
																				</tr>
																				
																			</table>
																		</td>
																		</tr>
																		--->
																
																		<tr><td colspan="4">&nbsp;</td></tr>
																		<tr>
																			<td></td>
																			<td colspan="3" >
																			<table width="100%" id="myTable" cellpadding="3" cellspacing="0" align="center" style="border:1px solid gray;">
																				<tr>
																					<td bgcolor="##CCCCCC" ><strong><cf_translate key="LB_OpcionDeRespuesta">Opciones de Respuesta</cf_translate></strong></td>
																					<td bgcolor="##CCCCCC" ><strong><cf_translate key="LB_Valor">Valor</cf_translate></strong></td>
																					<td bgcolor="##CCCCCC" ><strong><cf_translate key="LB_Ref">Ref.</cf_translate></strong></td>
																					<td bgcolor="##CCCCCC" ><strong><cf_translate key="LB_Orden">Orden</cf_translate></strong></td>	
																					<td bgcolor="##CCCCCC" >&nbsp;</td>				
																				</tr>
																				<cfif modo_pregunta neq 'ALTA'>
																					<cfloop query="prdata">
																						<cfset ira = prdata.PRira >
																						<tr>
																							<td>
																								<cfset expresion = "\<[A-Za-z=\'" >
																								<cfset expresion = expresion & '\"\0-9.\(\)\:\;\-## ]*>' >
																								<input type="text" name="_PRtexto_#prdata.currentrow+4#" size="45" maxlength="400" value="#trim(REReplace(prdata.PRtexto,expresion,'','ALL'))#" onClick="javascript:this.select();" onChange="javascript: setvalor(this);">
																								<input type="hidden" name="PRtexto_#prdata.currentrow+4#" value="#HTMLEditFormat(trim(prdata.PRtexto))#" onClick="this.select();">
																								<input type="hidden" name="PRid_#prdata.currentrow+4#" value="#prdata.PRid#">							</td>
																							<td><input type="text" name="PRvalor_#prdata.currentrow+4#" size="7" maxlength="7" value="#prdata.PRvalor#"  style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript: if (trim(this.value) != ''){fm(this,2);}"   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
																							<td>
																								<select name="PRira_#prdata.currentrow+50#">
																									<option value=""></option>
																									<cfloop query="dataira">
																										<option value="#dataira.PPid#" <cfif ira eq dataira.PPid >selected</cfif>>#dataira.PPnumero#</option>
																									</cfloop>
																								</select>							</td>
																							<td><input type="text" name="PRorden_#prdata.currentrow+4#" size="3" maxlength="3" value="#prdata.PRorden#"  style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
																							<td><img src="/cfmx/rh/imagenes/iindex.gif" border="0" onClick="javascript:formatear(#prdata.PRid#, #prdata.currentrow+4#);" style="cursor:hand;"></td>
																						</tr>
																					</cfloop>
																				</cfif>
																
																
																				<cfloop from="1" to="4" index="i">
																					<tr>
																						<td><input type="text" name="PRtexto_#i#" size="45" maxlength="400" value="" onClick="this.select();"></td>
																						<td><input type="text" name="PRvalor_#i#" size="7" maxlength="7" style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" value="" onBlur="javascript: if (trim(this.value) != ''){fm(this,2);}"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
																						<td>
																							<select name="PRira_#i#">
																								<option value=""></option>
																								<cfloop query="dataira">
																									<option value="#dataira.PPid#" >#dataira.PPnumero#</option>
																								</cfloop>
																							</select>						</td>
																						<td><input type="text" name="PRorden_#i#" size="3" maxlength="3" value=""  style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
																						<!---<td><input type="button" style="width:25px;" value="+" onClick="javascript:insRow();"></td>--->
																					</tr>
																				</cfloop>				
																			</table>		</td>
																		</tr>
																
																
																
																	<tr><td>&nbsp;</td></tr>
																			<cfinvoke component="sif.Componentes.Translate"
																			method="Translate"
																			Key="BTN_Eliminar"
																			Default="Eliminar"
																			XmlFile="/rh/generales.xml"
																			returnvariable="BTN_Eliminar"/>
																	
																			<cfinvoke component="sif.Componentes.Translate"
																			method="Translate"
																			Key="BTN_Nuevo"
																			Default="Nuevo"
																			XmlFile="/rh/generales.xml"
																			returnvariable="BTN_Nuevo"/>
																			
																			<cfinvoke component="sif.Componentes.Translate"
																			method="Translate"
																			Key="BTN_Guardar"
																			Default="Guardar"
																			XmlFile="/rh/generales.xml"
																			returnvariable="BTN_Guardar"/>			
																
																			<cfinvoke component="sif.Componentes.Translate"
																			method="Translate"
																			Key="MSG_EsteProcesoVaAEliminarLaPreguntaSeleccionadaSusPosiblesRespuestasYLasRespuestasDadasPorLosUsuarios"
																			Default="Este proceso va a eliminar la pregunta seleccionada, sus posibles respuestas y las respuestas dadas por los usuarios.\nEsta seguro de continuar?"
																			returnvariable="MSG_EsteProcesoVaAEliminarLaPreguntaSeleccionadaSusPosiblesRespuestasYLasRespuestasDadasPorLosUsuarios"/>
																
																	
																	<tr>
																		<td colspan="4" align="center">
																		<input type="submit" class="btnGuardar" name="<cfif modo_pregunta eq 'ALTA'>PPGuardar<cfelse>PPModificar</cfif>" value="<cfoutput>#BTN_Guardar#</cfoutput>" />
																		<cfif modo_pregunta neq 'ALTA'>
																				<input type="submit" class="btnEliminar" name="PPEliminar" value="<cfoutput>#BTN_Eliminar#</cfoutput>" onClick="javascript:return confirm('<cfoutput>#MSG_EsteProcesoVaAEliminarLaPreguntaSeleccionadaSusPosiblesRespuestasYLasRespuestasDadasPorLosUsuarios#</cfoutput>');">
																				<input type="button" class="btnNuevo" name="NuevaPregunta" value="<cfoutput>#BTN_Nuevo#</cfoutput>" onClick="location.href='cuestionario-tabs.cfm?tab=3&PCid=#form.PCid#';" >
																		</cfif>

																		<cfset params = '' >
																		<cfif isdefined("form.pageNum_lista")>
																			<cfset params = params & '&pageNum_lista=#form.pageNum_lista#' >
																		</cfif>
																		<cfif isdefined("form.fPCcodigo")>
																			<cfset params = params & '&fPCcodigo=#form.fPCcodigo#' >
																		</cfif>
																		<cfif isdefined("form.fPCnombre")>
																			<cfset params = params & '&fPCnombre=#form.fPCnombre#' >
																		</cfif>
																		<cfif isdefined("form.fPCdescripcion")>
																			<cfset params = params & '&fPCdescripcion=#form.fPCdescripcion#' >
																		</cfif>
																		
																		<input type="button" name="PCLista" class="btnAnterior" value="<cfoutput>#BTN_Lista#</cfoutput>" onClick="javascript:location.href='cuestionario-lista.cfm?DUMMY=OK#PARAMS#'">

																
																			<!--- NO BORRAR <input type="hidden" name="filas_total" value="<cfif isdefined("prdata")>#prdata.recordcount+50#<cfelse>1</cfif>"> --->
																			<input type="hidden" name="filas_total" value="<cfif isdefined("prdata")>#prdata.recordcount+4#<cfelse>4</cfif>">
																			<input type="hidden" name="filas_real" value="<cfif isdefined("prdata")>#prdata.recordcount+1#<cfelse>1</cfif>">	  </td>
																	</tr>
																	
																	<tr><td>&nbsp;</td></tr>

																</table>
																
																</cfoutput>
																
																<script language="javascript1.2" type="text/javascript">
																	function delRow(i){
																		document.getElementById('myTable').deleteRow(i)
																		document.form3.filas_real.value = parseInt(document.form1.filas_real.value) - 1;
																	}
																	
																	function insRow(){
																		// este valor es para procesarlo en el sql
																		var j = parseInt(document.form3.filas_total.value)+1;
																		document.form3.filas_total.value = j;
																
																		// este valor es para insertar nuevas filas, se necesita saber por que numero de fila va
																		// Ej: tengo 5 filas (0-4), y borro la numero 2, ahora hay 4 filas. Este dato se necesita
																		// para decirle al insert qu elo haga en la fila siguiente, osea la 5
																		// creo que ya no es necesario porque no se borran filas dinamicas
																		var i = parseInt(document.form3.filas_real.value) + 1;
																		document.form3.filas_real.value = i;
																
																		var input_opcion = '<input type=text name=PRtexto_'+i+' size=45 maxlength=255 onClick="this.select();">';
																		var input_valor  = '<input type=text name=PRvalor_'+i+' size=7 maxlength=7 value="" onClick="this.select();">';
																		var input_orden  = '<input type=text name=PRorden_'+i+' size=3 maxlength=3 value="" style="text-align: right;"  onFocus="javascript:this.value=qf(this); restaurar_color(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)==13) {this.blur();}}"		>';
																		//var input_formato  = '<img src="/cfmx/rh/imagenes/iindex.gif" border="0" onClick="javascript:formatear();" style="cursor:hand;" >';
																		var input_formato  = '';
																		
																		var combo = '<select name=PRira_'+i+'><option value=""></option>';
																		<cfoutput>
																		<cfloop query="dataira">
																			combo += '<option value=#dataira.PPid# >#dataira.PPnumero#</option>';
																		</cfloop>
																		</cfoutput>
																		combo += '</select>';
																		
																		//var img_borrar   =	'<img src="Borrar01_S.gif">';
																		
																		var x = document.getElementById('myTable').insertRow(i)
																		var cell_0 = x.insertCell(0);
																		var cell_1 = x.insertCell(1);
																		var cell_2 = x.insertCell(2);
																		var cell_3 = x.insertCell(3);
																		var cell_4 = x.insertCell(4);
																		//var cell_4 = x.insertCell(4);
																		cell_0.innerHTML = input_opcion;
																		cell_1.innerHTML = input_valor;
																		cell_2.innerHTML = combo;
																		cell_3.innerHTML = input_orden;
																		cell_4.innerHTML = input_formato;
																		//cell_4.innerHTML = img_borrar;
																	}
																	
																	var popUpWin = 0;
																	function popUpWindow(URLStr, left, top, width, height){
																		if(popUpWin){
																			if(!popUpWin.closed) popUpWin.close();
																		}
																		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
																	}
																
																	function formatear(respuesta, indice){
																		var params ="";
																		params = "?PRid="+respuesta+"&indice="+indice;
																		popUpWindow("/cfmx/asp/portal/cuestionarios/formato-respuesta.cfm"+params,250,200,650,300);
																	}
																	
																	function setvalor(obj){
																		name = obj.name.substring(1, obj.name.length);
																		document.form3[name].value = obj.value;
																	}
																
																</script>
							</td>
						</tr>
					</table>
			</form>
			</cfoutput>																