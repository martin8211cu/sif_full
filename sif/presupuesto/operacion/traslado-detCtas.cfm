<cfflush interval="64">
<table>
	<tr>
	  <td colspan="3" class="tituloAlterno">Detalle de Documento de Traslado de Presupuesto</td>
	</tr>
	<tr>
	  <td width="10%" align="right">
	  	<strong>Cuenta:</strong>&nbsp;
	  </td>
	  <td width="45%">
	  	<input name="cuenta" type="text" style="font-weight: bold; border: none; color:#0000FF; width:100%" readonly>
	  </td>
	  <td width="45%">
	  	<input name="mensaje" type="text" style="font-weight: bold; border: none; color:#FF0000; width:100%" readonly>
	  </td>
	</tr>
	<tr>
	  <td colspan="4">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
				    <td colspan="6" nowrap>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td width="50%" style="padding-right: 2px; " valign="top">
							  <cf_web_portlet_start titulo="Partidas Origen">
								<table width="100%" border="0" cellspacing="0" cellpadding="2">
								  <tr>
								  	<td width="1%">&nbsp;</td>
								    <td nowrap><strong>Cuenta Presupuesto</strong></td>
								    <td align="right" nowrap><strong>Monto</strong></td>
							      </tr>
								  <cfset i = 1>
								  <cfloop query="rsPartidasOrigen">
								  <tr>
								  	<td height="25" align="right"><cfoutput>#i#.</cfoutput></td>
									<td height="25" nowrap>
                                    	<cfoutput>
										<input type="hidden" name="O_CPcuenta#i#" value="<cfif modo EQ 'CAMBIO'>#rsPartidasOrigen.CPcuenta#</cfif>">
										<input type="text" name="O_CPformato#i#" size="25" value="<cfif modo EQ 'CAMBIO'>#trim(rsPartidasOrigen.CPformato)#</cfif>" tabindex="-1" readonly>
										<input type="text" name="O_CPdescripcion#i#" size="30" value="<cfif modo EQ 'CAMBIO'>#rsPartidasOrigen.CPdescripcion#</cfif>" tabindex="-1" readonly>
                                        </cfoutput>
								<cfif LvarCPformTipo EQ "registro">
                                		<cfoutput>
									    <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas de Presupuesto" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCuentasOrigen(#i#);"></a>
										<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Borrar01_S.gif" align="absmiddle" alt="Eliminar Cuenta" border="0" onClick="javascript: if (mensajeAlert) { alert('Para actualizar los cambios debe oprimir el botón de Guardar'); mensajeAlert = false; } LimpiarCuenta('#i#','O_');"></a>
                                        </cfoutput>
								</cfif>
									</td>
									<td height="25" nowrap>
										<cfinvoke component="sif.Componentes.PRES_Presupuesto" 
											method="CalculoDisponible"
											returnvariable="LvarDisponible">
											<cfinvokeargument name="CPPid" value="#rsPartidasOrigen.CPPid#">
											<cfinvokeargument name="CPCano" value="#rsPartidasOrigen.CPCano#">
											<cfinvokeargument name="CPCmes" value="#rsPartidasOrigen.CPCmes#">
											<cfinvokeargument name="CPcuenta" value="#rsPartidasOrigen.CPcuenta#">
											<cfinvokeargument name="Ocodigo" value="#rsTraslado.OcodigoOrigen#">
											<cfinvokeargument name="TipoMovimiento" value="T">
											
											<cfinvokeargument name="Conexion" value="#Session.DSN#">
											<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
										</cfinvoke>
										<input type="hidden" name="O_disponible#i#" value="#LvarDisponible.Disponible#">
										<cfif LvarDisponible.CPCPtipoControl EQ "0">
											<cfoutput>
											<input type="hidden" name="O_validarDisponible#i#" value="0">
											<input type="hidden" name="O_mensaje#i#" value="Control Abierto, Disponible: #LSNumberFormat(LvarDisponible.Disponible, ',9.00')#">
                                            </cfoutput>
										<cfelseif LvarDisponible.Disponible LTE 0>
                                        	<cfoutput>
											<input type="hidden" name="O_validarDisponible#i#" value="1">
											<input type="hidden" name="O_mensaje#i#" value="No tiene Presupuesto Disponible: #LSNumberFormat(LvarDisponible.Disponible, ',9.00')#">
                                            </cfoutput>
										<cfelse>
                                        	<cfoutput>
											<input type="hidden" name="O_validarDisponible#i#" value="1">
											<input type="hidden" name="O_mensaje#i#" value="Máximo Disponible: #LSNumberFormat(LvarDisponible.Disponible, ',9.00')#">
                                            </cfoutput>
										</cfif>
										<cfoutput>
        									<input type="text" name="O_CPDDmonto#i#" size="20" maxlength="18" 
												onFocus="this.value=qf(this); this.select(); this.form.mensaje.value = this.form.O_mensaje#i#.value; this.form.cuenta.value = this.form.O_CPformato#i#.value + ' ' + this.form.O_CPdescripcion#i#.value;" 
												onBlur="javascript: fm(this,2);" 
												onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
												style="text-align: right;" 
												value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsPartidasOrigen.CPDDmonto,',9.00')#<cfelse>0.00</cfif>">
                                        </cfoutput>
									</td>
								  </tr>
								  <cfset i = i + 1>
								  </cfloop>
								  <cfloop index="i" from="#MaxOrigen + 1#" to="#MaxElements#">
								  <tr>
									<cfoutput>
								  	<td height="25" align="right">#i#.</td>
									<td height="25" nowrap>
										<input type="hidden" name="O_CPcuenta#i#">
										<input type="text" name="O_CPformato#i#" size="25" tabindex="-1" readonly>
										<input type="text" name="O_CPdescripcion#i#" size="30" tabindex="-1" readonly>
										<cfif LvarCPformTipo EQ "registro">
                                                <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas de Presupuesto" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCuentasOrigen(#i#);"></a>					
                                                <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Borrar01_S.gif" align="absmiddle" alt="Eliminar Cuenta" border="0" onClick="javascript: if (mensajeAlert) { alert('Para actualizar los cambios debe oprimir el botón de Guardar'); mensajeAlert = false; } LimpiarCuenta('#i#','O_');"></a>
                                        </cfif>
									</td>
									<td height="25" nowrap>
										<input type="hidden" name="O_disponible#i#" value="">
										<input type="hidden" name="O_validarDisponible#i#" value="0">
										<input type="hidden" name="O_mensaje#i#" value="">
										<input type="text" name="O_CPDDmonto#i#" size="20" maxlength="18" 
												onFocus="this.value=qf(this); this.select(); this.form.mensaje.value = this.form.O_mensaje#i#.value; this.form.cuenta.value = this.form.O_CPformato#i#.value + ' ' + this.form.O_CPdescripcion#i#.value;" 
												onBlur="javascript: fm(this,2);" 
												onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
												style="text-align: right;" 
												value="0.00">
									</td>
									</cfoutput>
								  </tr>
								  </cfloop>
								</table>
							  <cf_web_portlet_end>
							</td>
							<td style="padding-left: 2px; " valign="top">
							  <cf_web_portlet_start titulo="Partidas Destino">
								<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								  <tr>
								  	<td width="1%">&nbsp;</td>
								    <td nowrap><strong>Cuenta Presupuesto</strong></td>
								    <td align="right" nowrap id="tdDestEt" style="display: none;"><strong>Peso</strong></td>
								    <td align="right" id="etiquetaMonto" nowrap><strong>Monto</strong></td>
							      </tr>
								  <cfset i = 1>
								  <cfloop query="rsPartidasDestino">
								  <tr>
                                  	<cfoutput>
								  	<td height="25" align="right">#i#.</td>
									<td height="25" nowrap>
										<input type="hidden" name="D_CPcuenta#i#" value="<cfif modo EQ 'CAMBIO'>#rsPartidasDestino.CPcuenta#</cfif>">
										<input type="text" name="D_CPformato#i#" size="25" value="<cfif modo EQ 'CAMBIO'>#rsPartidasDestino.CPformato#</cfif>" tabindex="-1" readonly>
										<input type="text" name="D_CPdescripcion#i#" size="30" value="<cfif modo EQ 'CAMBIO'>#rsPartidasDestino.CPdescripcion#</cfif>" tabindex="-1" readonly>
										<cfif LvarCPformTipo EQ "registro">
                                                <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas de Presupuesto" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCuentasDestino(#i#);"></a>					
                                                <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Borrar01_S.gif" align="absmiddle" alt="Eliminar Cuenta" border="0" onClick="javascript: if (mensajeAlert) { alert('Para actualizar los cambios debe oprimir el botón de Guardar'); mensajeAlert = false; } LimpiarCuenta(#i#,'D_');"></a>
                                        </cfif>
									</td>
									<td id="tdDest#i#" height="25" style="display: none;" nowrap>
										<input type="text" name="D_CPDDpeso#i#" size="8" maxlength="8" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#rsPartidasDestino.CPDDpeso#<cfelse>0</cfif>">
									</td>
									<td height="25" align="right" nowrap>
										<input type="text" name="D_CPDDmonto#i#" size="20" maxlength="18" 
												onFocus="this.value=qf(this); this.select(); this.value=qf(this); this.select(); this.form.mensaje.value = ''; this.form.cuenta.value = '';" 
												onBlur="javascript: fm(this,2);" 
												onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
												style="text-align: right;" 
												value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsPartidasDestino.CPDDmonto,',9.00')#<cfelse>0.00</cfif>">
									</td>
									</cfoutput>
								  </tr>
								  <cfset i = i + 1>
								  </cfloop>
								  <cfloop index="i" from="#MaxDestino + 1#" to="#MaxElements#">
								  <tr>
                                  	<cfoutput>
								  	<td height="25" align="right">#i#.</td>
									<td height="25" nowrap>
										<input type="hidden" name="D_CPcuenta#i#">
										<input type="text" name="D_CPformato#i#" size="25" tabindex="-1" readonly>
										<input type="text" name="D_CPdescripcion#i#" size="30" tabindex="-1" readonly>
										<cfif LvarCPformTipo EQ "registro">
                                                <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Cuentas de Presupuesto" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCuentasDestino(#i#);"></a>					
                                                <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Borrar01_S.gif" align="absmiddle" alt="Eliminar Cuenta" border="0" onClick="javascript: if (mensajeAlert) { alert('Para actualizar los cambios debe oprimir el botón de Guardar'); mensajeAlert = false; } LimpiarCuenta(#i#,'D_');"></a>
                                        </cfif>
									</td>
									<td id="tdDest#i#" height="25" style="display: none;" nowrap>
										<input type="text" name="D_CPDDpeso#i#" size="8" maxlength="8" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0">
									</td>
									<td height="25" align="right" nowrap>
										<input type="text" name="D_CPDDmonto#i#" size="20" maxlength="18" 
												onFocus="this.value=qf(this); this.select(); this.value=qf(this); this.select(); this.form.mensaje.value = ''; this.form.cuenta.value = '';" 
												onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0.00">
									</td>
									</cfoutput>
								  </tr>
								  </cfloop>
								</table>
							  <cf_web_portlet_end>
							</td>
						  </tr>
						</table>
					</td>
				  </tr>
				</table>
			</td>
		  </tr>
		</table>
	  </td>
	</tr>
</table>