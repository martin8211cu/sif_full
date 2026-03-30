<!---	Creado: Rebeca Corrales Alfaro --->
<!---	Fecha:  12/08/2005 			   --->
<!---	Modificado por: 			   --->
<!--- 	Fecha: 		 				   --->

<cfquery name="rsEmpleado" datasource="#Session.DSN#">
	select a.DEid, 
		   a.NTIcodigo, 
		   a.DEidentificacion, 
		   a.DEnombre, 
		   a.DEapellido1, 
		   a.DEapellido2, 
		   n.NTIdescripcion
	from DatosEmpleado a, NTipoIdentificacion n
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	and a.NTIcodigo = n.NTIcodigo
</cfquery>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Control de Marcas-Autorizaci&oacute;n Pago de Horas
</cf_templatearea>
<cf_templatecss>
	<cf_templatearea name="body">
		<!----================ TRADUCCION ===================--->
		<cfinvoke component="sif.Componentes.TranslateDB"
			method="Translate"
			VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
			Default="Autorizaci&oacute;n Pago de Horas"
			VSgrupo="103"
			returnvariable="nombre_proceso"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Fecha"
			Default="Fecha"	
			returnvariable="LB_Fecha"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Concepto_de_Incidencias"
			Default="Concepto de Incidencias"	
			returnvariable="LB_Concepto_de_Incidencias"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Signo"
			Default="Signo"	
			returnvariable="LB_Signo"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Horas_Autorizadas"
			Default="Horas Autorizadas"	
			returnvariable="LB_Horas_Autorizadas"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Grabar"
			Default="Grabar"
			returnvariable="BTN_Grabar"/>
		
		<cf_web_portlet_start titulo="#nombre_proceso#" border="true" skin="#Session.Preferences.Skin#">
			<cfoutput>
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				  <tr>
					<td align="right"> 
						<label id="letiqueta1"><a href="Javascript:Retornar()"><cf_translate key="LB_Seleccione_un_empleado">Seleccione un empleado: </cf_translate><img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"></a></label>
					</td>
				  </tr>
				  <tr>
					<td>
						<cfinclude template="../../expediente/consultas/frame-infoEmpleado.cfm">
					</td>
				  </tr>
				  <tr>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						 <tr>
							<td valign="top" width="100%">
								<cfquery name="rsListaDetIncidencias" datasource="#Session.DSN#">
									select a.CIid, a.RHDMhorasautor,b.CIdescripcion, c.Iid, c.JustificacionNoPago,
										   c.RetenerPago, d.RHCMfcapturada, d.RHCMfregistro, d.RHCMhoraentrada, 
										   d.RHCMhorasalida, d.RHCMhoraentradac, d.RHCMhorasalidac,
										   d.RHCMhorasadicautor, d.RHCMhorasrebajar, d.RHCMdialibre, d.RHCMjustificacion,
										   
										case b.CInegativo
											when 1 then '+'
											else '-' 
											end as sumaresta,
										c.RHCMid as RHCMid, c.DEid as DEid, c.RHDMid as RHDMid, c.RHPMid as RHPMid
									from IncidenciasMarcas c

									inner join RHDetalleIncidencias a
										on a.RHDMid = c.RHDMid
										and a.RHPMid = c.RHPMid
										and a.RHCMid = c.RHCMid
																																
									inner join CIncidentes b
										on  b.CIid  = a.CIid
									
									inner join RHControlMarcas d
										on d.RHCMid = c.RHCMid
								</cfquery>
									
								<cfif isdefined('form.Iid') and form.Iid NEQ ''
										and isdefined('rsListaDetIncidencias') and rsListaDetIncidencias.recordCount GT 0>
									<cfquery name="rsJustifIncid" dbtype="query">
										Select JustificacionNoPago,RetenerPago
										from rsListaDetIncidencias
										where Iid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#">
									</cfquery>
								</cfif>					
								
								<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaQuery"
								 returnvariable="pListaEmpl">
									<cfinvokeargument name="query" value="#rsListaDetIncidencias#"/>
									<cfinvokeargument name="desplegar" value="RHCMfcapturada, CIdescripcion, sumaresta, RHDMhorasautor"/>
									<cfinvokeargument name="etiquetas" value="#LB_Fecha#, #LB_Concepto_de_Incidencias#, #LB_Signo#, #LB_Horas_Autorizadas#"/>
									<cfinvokeargument name="formatos" value="D, V, V, V"/>
									<cfinvokeargument name="formName" value="listaEmpleados"/>	
									<cfinvokeargument name="align" value="left, left,center, center"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="maxRows" value="0"/>
									<cfinvokeargument name="irA" value="AutPagoHora-form.cfm"/>
									<cfinvokeargument name="keys" value="Iid"/>
								</cfinvoke>
							</td>
							<td>
								<cfif isdefined("Form.RHDMid")>
									<cfquery name="rsDatosMarca" datasource="#Session.DSN#">
										select 
										   a.RHCMfcapturada,a.RHCMfregistro, a.RHCMhoraentrada, a.RHCMhorasalida,
										   a.RHCMhoraentradac, a.RHCMhorasalidac, a.RHCMhorasadicautor, a.RHCMhorasrebajar,
										   a.RHCMdialibre, a.RHCMjustificacion, a.RHJid, b.RHJdescripcion
										from RHControlMarcas a
											inner join RHJornadas b
												on b.RHJid = a.RHJid
										where RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
											and RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
									</cfquery>
								<cfelse>
									<cfset rsDatosMarca = QueryNew("dato") >
								</cfif>
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								  <tr>
									<td width="100%" valign="top" >
										<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border: 1px solid black;">
										  <tr>
											<td class="tituloAlterno" colspan="4" align="center" style="border-bottom: 1px solid black;" nowrap><cf_translate key="LB_Datos_de_Marca">Datos de Marca</cf_translate></td>
										  </tr>
										  <tr>
											<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Fecha_de_Captura">Fecha de Captura:</cf_translate></td>
											<td nowrap><cfif isdefined("rsDatosMarca.RHCMfcapturada")>#LSDateFormat(rsDatosMarca.RHCMfcapturada, 'dd/mm/yyyy')#</cfif></td>
											<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Fecha_de_Marca">Fecha de Marca:</cf_translate></td>
											<td nowrap><cfif isdefined ("rsDatosMarca.RHCMfregistro") and Len(Trim(rsDatosMarca.RHCMfregistro))>#LSDateFormat(rsDatosMarca.RHCMfregistro, 'dd/mm/yyyy')#</cfif></td>
										  </tr>
										  <tr>
											<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Hora_Entrada">Hora Entrada:</cf_translate></td>
											<td nowrap><cfif isdefined ("rsDatosMarca.RHCMhoraentradac") and Len(Trim(rsDatosMarca.RHCMhoraentradac))>#LSTimeFormat(rsDatosMarca.RHCMhoraentradac, 'hh:mm tt')#</cfif></td>
											<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Marca_Entrada">Marca Entrada:</cf_translate></td>
											<td nowrap><cfif isdefined ("rsDatosMarca.RHCMhoraentrada") and Len(Trim(rsDatosMarca.RHCMhoraentrada))>#LSTimeFormat(rsDatosMarca.RHCMhoraentrada, 'hh:mm tt')#</cfif></td>
										  </tr>
										  <tr>
											<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Hora_Salida">Hora Salida:</cf_translate></td>
											<td nowrap><cfif isdefined ("rsDatosMarca.RHCMhorasalidac") and Len(Trim(rsDatosMarca.RHCMhorasalidac))>#LSTimeFormat(rsDatosMarca.RHCMhorasalidac, 'hh:mm tt')#</cfif></td>
											<td class="fileLabel" align="right" nowrap><cf_translate key="LB_Marca_Salida">Marca Salida:</cf_translate></td>
											<td nowrap><cfif isdefined ("rsDatosMarca.RHCMhorasalida") and Len(Trim(rsDatosMarca.RHCMhorasalida))>#LSTimeFormat(rsDatosMarca.RHCMhorasalida, 'hh:mm tt')#</cfif></td>
										  </tr>
										<tr>
											<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Jornada">Jornada:</cf_translate></td>
											<td colspan="3" nowrap><cfif isdefined ("rsDatosMarca.RHJdescripcion") and Len(Trim(rsDatosMarca.RHJdescripcion))>#rsDatosMarca.RHJdescripcion#</cfif></td>
										  </tr>
										  <tr>
											<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Horas_Adicionales">Horas Adicionales: </cf_translate></td>
											<td nowrap><cfif isdefined ("rsDatosMarca.RHCMhorasadicautor")>#LSNumberFormat(rsDatosMarca.RHCMhorasadicautor, '9.00')#</cfif></td>
											<td align="right" nowrap><span class="fileLabel"><cf_translate key="LB_Horas_a_Rebajar">Horas a Rebajar:</cf_translate></span></td>
											<td nowrap><cfif isdefined ("rsDatosMarca.RHCMhorasrebajar")>#LSNumberFormat(rsDatosMarca.RHCMhorasrebajar, '9.00')#</cfif></td>
										  </tr>
										  <tr>
											<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Dia_libre">D&iacute;a Libre:</cf_translate></td>
											<td colspan="3" nowrap>
												<cfif rsListaDetIncidencias.RHCMdialibre EQ 1>
													<img src="/cfmx/rh/imagenes/checked.gif">
												<cfelse>
													<img src="/cfmx/rh/imagenes/unchecked.gif">
												</cfif>
											</td>
										  </tr>
										  <tr>
											<td align="right" valign="top" nowrap class="fileLabel"><cf_translate key="LB_Justificacion">Justificaci&oacute;n:</cf_translate></td>
											<td colspan="3" nowrap>
												<textarea name="RHCMjustificacion" cols="45" rows="5" id="RHCMjustificacion" style="border:none;" readonly><cfif isdefined('rsJustifIncid') and rsJustifIncid.recordCount GT 0>#rsJustifIncid.JustificacionNoPago#</cfif></textarea>
											</td>
										  </tr>
										</table>
									</td>
								</tr><br>
								<cfif isdefined("form.Iid")>
									<tr>
										<td>
											<form name="form1" method="post" action="AutPagoHoraGrabar.cfm">
												<input type="hidden" name="Iid" value="<cfif isdefined("form.Iid")><cfoutput>#form.Iid#</cfoutput></cfif>">
												<input type="hidden" name="DEid" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">
												<input type="hidden" name="RHDMid" value="<cfif isdefined("form.RHDMid")><cfoutput>#form.RHDMid#</cfoutput></cfif>">
												<input type="hidden" name="RHPMid" value="<cfif isdefined("form.RHPMid")><cfoutput>#form.RHPMid#</cfoutput></cfif>">
												<input type="hidden" name="RHCMid" value="<cfif isdefined("form.RHCMid")><cfoutput>#form.RHCMid#</cfoutput></cfif>">
												
												<table cellpadding="0" cellspacing="0" border="0" width="100%">
												  <tr>
													<td align="right" nowrap><cf_translate key="LB_Rechazar_Pago">Rechazar Pago:</cf_translate></td>
													<td align="left" width="87%">
														<input name="RetenerPago" type="checkbox" value="1" onClick="javascript: cambio(this);" <cfif isdefined('rsJustifIncid') and rsJustifIncid.recordCount GT 0 and rsJustifIncid.RetenerPago EQ 1> checked</cfif>>
													</td>
													<td width="2%" valign="top" nowrap class="fileLabel">
												  </tr>
												  
												  <tr id="idJustificacion" style="display: none;">
													  <td nowrap align="right"><cf_translate key="LB_Justificacion">Justificaci&oacute;n:</cf_translate></td> 
														<td nowrap align="right">
															<input type="text" size="100" maxlength="80" name="JustificacionNoPago" id="JustificacionNoPago" style="width:100%;" value="<cfif isdefined('rsJustifIncid') and rsJustifIncid.recordCount GT 0>#rsJustifIncid.JustificacionNoPago#</cfif>">
														</td>
														<td>&nbsp;
														</td>
													</tr>
													<tr>&nbsp;</tr>
													<tr>
													  <td align="right">&nbsp;</td>
													  <td align="center">
														<span class="fileLabel">
															<input type="submit" name="Grabar" value="#BTN_Grabar#">
														</span> 
													  </td>
													</tr> 
												</table>
											</form>	
									    </td>
									</tr>
							    </cfif> 
							</table>
						</td>
					</tr>
				</table>
			</td>
			</tr>
			<tr>
				<td valign="top" nowrap class="fileLabel">&nbsp;</td>
			</tr>
			</table>					  
			</cfoutput>	
			<script language="JavaScript">
				function cambio(cb){
					if(cb.checked){
						document.getElementById("idJustificacion").style.display = '';
					}	
					else{
						document.getElementById("idJustificacion").style.display = 'none';
					}	
				}				
				<cfif isdefined("form.Iid")>
					cambio(document.form1.RetenerPago)	
				</cfif>
				function Retornar(){
					location.href="AutPagoHora.cfm"
				}
			
			</script>
			
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
 