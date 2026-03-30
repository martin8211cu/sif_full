<cf_templateheader title="Lista de cotizaciones de una orden de compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de cotizaciones'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">				
				<cfif isdefined ("url.EOidorden") and len(trim(url.EOidorden))>
					<cfset form.EOidorden = url.EOidorden>
				</cfif>
                <cfinclude template="../../Utiles/sifConcat.cfm">
				<!----Cotizaciones de la orden de compra---->
				<cfquery name="rsCotizaciones" datasource="#session.DSN#">					
					select 	distinct b.CMPid, 
									d.ECid,
									d.ECtotal,
									d.ECnumero, 
									e.SNidentificacion#_Cat#' - '#_Cat#e.SNnombre as rsSocio, 
									f.CMFPplazo,
									g.EOnumero,
									z.NotaGlobal
					from DOrdenCM a
						inner join EOrdenCM g
							on a.EOidorden = g.EOidorden
							and a.Ecodigo = g.Ecodigo

						inner join DCotizacionesCM b
							on a.DClinea = b.DClinea
							<!--- and a.Ecodigo = b.Ecodigo --->												
							
							inner join CMProcesoCompra c
								on b.CMPid = c.CMPid
								and b.Ecodigo = c.Ecodigo
								and c.CMPestado = 50
								
							inner join ECotizacionesCM d
									on b.CMPid = d.CMPid
									and b.Ecodigo = d.Ecodigo
									and d.ECtotal != 0	
									
								inner join CMResultadoEval z
									on d.ECid = z.ECid
									and d.CMPid = z.CMPid
									and d.Ecodigo = z.Ecodigo
							
								left outer join SNegocios e
									on d.SNcodigo = e.SNcodigo
									and d.Ecodigo = e.Ecodigo
						
								left outer join CMFormasPago f
									on d.CMFPid = f.CMFPid
									and d.Ecodigo = f.Ecodigo	

					where <!--- a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and ---> a.EOidorden =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
				</cfquery>
										
				<table width="100%" cellpadding="1" cellspacing="0">
					<tr><td colspan="9">&nbsp;</td></tr>
					<tr><td colspan="9" align="center" class="tituloAlterno"><strong>Lista de Cotizaciones</strong></td></tr>										
					<cfif rsCotizaciones.RecordCount NEQ 0>		
						<tr>
							<td width="1%" class="tituloListas">&nbsp;</td>
							<td class="tituloListas" colspan="2"><font style=" font-size:11"><strong>No. Orden :&nbsp;<cfoutput>#rsCotizaciones.EOnumero#</cfoutput></strong></font></td>											
							<td nowrap class="tituloListas"><strong>Criterios de Evaluaci&oacute;n</strong></td>
							<td colspan="5" class="tituloListas">&nbsp;</td>
						</tr>
						<cfquery name="rsCondiciones" datasource="#session.DSN#"><!---Obtener las condiciones del proceso de compra---->
							select CPpeso,CCdesc
							from CMCondicionesProceso a
								inner join CCriteriosCM b
									on a.CCid = b.CCid
							where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCotizaciones.CMPid#">
						</cfquery>
						<tr>
							<td width="1%">&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>						
							<td colspan="8">					 
								<table width="100%">
									<cfoutput query="rsCondiciones">
										<tr>
											<td width="10%" nowrap>#rsCondiciones.CCdesc#</td>
											<td width="90">#rsCondiciones.CPpeso#</td>
										</tr>
									</cfoutput>
								</table>
							</td>
						</tr>	
						<tr><td colspan="9">&nbsp;</td></tr>
						<tr>
							<td width="1%" class="listaCorte">&nbsp;</td>
							<td class="listaCorte" width="13%"><strong>Elecci&oacute;n del Sistema</strong></td>
							<td class="listaCorte" width="10%"><strong>No. Cotizaci&oacute;n</strong></td>
							<td class="listaCorte" width="30%"><strong>Proveedor</strong></td>
							<td class="listaCorte" width="10%"><strong>Total Cotizaci&oacute;n</strong></td>
							<td class="listaCorte" width="10%" align="center"><strong>Plazo Cr&eacute;dito</strong></td>
							<td class="listaCorte" width="7%"><strong>Nota Global</strong></td>
							<td class="listaCorte" width="15%"><strong>Elecci&oacute;n manual</strong></td>
							<td width="1%" class="listaCorte">&nbsp;</td>
						</tr>
						<cfoutput query="rsCotizaciones">
							<cfset vnECid = rsCotizaciones.ECid><!---Variable con el Id de la cotizacin---->
							<cfset vnCMPid = rsCotizaciones.CMPid><!---Variable con el Id del proceso en que esta la cotizacin---->
							<cfset vnSugerido =''>	<!---Variable con ECid sugerido por el sistema--->
							<cfset vnSeleccionado=''><!---Variable con el ECid que fue seleccionado por el usuario---->
							<cfquery name="rsSugerido" datasource="#Session.DSN#"><!----Cotizacin sugerida por el sistema--->							
								select CMRseleccionado, CMRsugerido, ECid
								from CMResultadoEval 
								where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnCMPid#">
									and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnECid#">
									and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and CMRsugerido = 1							
							</cfquery>	
							<cfset vnSugerido = rsSugerido.ECid>
							<cfquery name="rsSeleccionado" datasource="#session.DSN#"><!----Cotizacin donde una lnea fue seleccionada por el usuario---->
								select CMRseleccionado, CMRsugerido, ECid
								from CMResultadoEval 	
								where CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnCMPid#">		
									and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnECid#">
									and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									and CMRseleccionado = 1
									and CMRsugerido = 0								
							</cfquery>
							<cfset vnSeleccionado = rsSeleccionado.ECid>
							<tr  onClick="javascript: funcDetalleCotizacion(#rsCotizaciones.ECid#,#rsCotizaciones.CMPid#)" class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif currentRow>listaNon<cfelse>listaPar</cfif>';" style="cursor: hand;">		
								<td width="1%">&nbsp;</td>
								<td align="center" width="13%">
									<cfif isdefined("vnSugerido") and trim(vnECid) EQ trim(vnSugerido)>
										<img src="../../imagenes/checked.gif">
									<cfelse>
										<img src="../../imagenes/unchecked.gif">
									</cfif>
								</td>
								<td>#rsCotizaciones.ECnumero#</td>
								<td>#rsCotizaciones.rsSocio#</td>
								<td align="right">#LSCurrencyFormat(rsCotizaciones.ECtotal,'none')#</td>
								<td align="center">#rsCotizaciones.CMFPplazo#</td>
								<td width="7%">#LSNumberFormat(rsCotizaciones.NotaGlobal,',9.00')#</td>
								<td>
									<cfif isdefined("vnSeleccionado") and trim(vnECid) EQ trim(vnSeleccionado)>
										Existe justificaci&oacute;n asociada</td>
									</cfif>
								<td width="1%">&nbsp;</td>
							</tr>							
						</cfoutput>
					<cfelse>
						<tr><td colspan="9">&nbsp;</td></tr>
						<tr><td colspan="9" align="center"><strong>-------- No se encontraron registros --------</strong></td></tr>
					</cfif>								
					<tr><td colspan="9">&nbsp;</td></tr>
					<tr><td colspan="9">&nbsp;</td></tr>
					<tr>
						<td colspan="9" align="center">
							<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: location.href='autorizaOrden.cfm';">
						</td>
					</tr>
					<tr><td colspan="9">&nbsp;</td></tr>
				</table>
				<script language="javascript1.2" type="text/javascript">
					var popUpWin = 0;
					function popUpWindow(URLStr, left, top, width, height){
						if(popUpWin){
							if(!popUpWin.closed) popUpWin.close();
						}
						popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
					}

					function funcDetalleCotizacion(paramIDcotizacion,paramProceso){
						var parametros = '?CMPid='+paramProceso+'&ECid='+paramIDcotizacion;
						<cfoutput>
							popUpWindow("/cfmx/sif/cm/operacion/autorizaOrden-detallecotizacion.cfm"+parametros,10,10,950,600);
						</cfoutput>
					}
				</script>
			<cf_web_portlet_end>
	<cf_templatefooter>


