<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Distribucion de Obras
	</cf_templatearea>
	<cf_templatearea name="body">
		<table width="100%"  border="0" cellspacing="2" cellpadding="0">
		  <tr>
			<td valign="top" nowrap>
				<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Grupos de Distribucion'>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr> 
							<td valign="top" width="45%">
								<cfif isdefined("url.Id") and len(trim(url.Id))>
									<cfset form.Id = url.Id>
								</cfif>

								<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
									tabla="DOGDistribucion a, DODistribucion b, DOCtasDistribuir c, Oficinas d"
									columnas="c.Id,	c.IDdistribucion,c.Ocodigo, d.Oficodigo, a.DOdescripcion, c.CDformato, c.CDporcentaje, c.CDexcluir"
									desplegar="Oficodigo, DOdescripcion, CDformato, CDporcentaje, CDexcluir"
									etiquetas="Oficina, Descripcion, Cuenta, Porcentaje, Excluir"
									formatos="S,S,S,S,S"
									filtro="Ecodigo=#session.Ecodigo# Order By Id"
									align="left,left,left,left,left"
									checkboxes="N"
									keys="Id"
									MaxRows="6"
									pageindex="1"
									filtrar_automatico="true"
									mostrar_filtro="true"
									filtrar_por="d.Oficodigo, a.DOdescripcion, c.CDformato, c.CDporcentaje, c.CDexcluir"
									ira="formCtasDistribucion.cfm"
									showEmptyListMsg="true">
						
							</td>					
						  	<td valign="top" width="55%">

								<cfset modo="ALTA">
								<cfif isdefined("form.IDgd") and form.IDgd GT 0>
									<cfset modo="CAMBIO">
								</cfif>
								
								<cfquery datasource="#Session.DSN#" name="rsOrigenes">
								select Oorigen,Odescripcion from Origenes 
								</cfquery>
								
								<cfif modo neq "ALTA">
									<cfquery name="rsForm" dbtype="query">
										select IDgd, DOdescripcion, DOorigen, ts_rversion
										from DOGDistribucion
										where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
									</cfquery>
								</cfif>
								<cfquery name="rsGD" dbtype="query">
									select IDgd, DOdescripcion, DOorigen, ts_rversion
									from DOGDistribucion
									<cfif modo neq "ALTA">
									where GAruta not like '#rsForm.GAruta#%'
									</cfif>	
									order by GAruta
								</cfquery>
								
								<cfoutput>
								<form action="sql.cfm" method="post" name="form1">
									<cfif modo neq "ALTA">
										<input type="hidden" name="IDgd" value="#rsForm.IDgd#">
										<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" arTimeStamp = "#rsForm.ts_rversion#"/>
										<input type="hidden" name="ts_rversion" value="#ts#">
									</cfif>
									<br>
									<table width="100%"  border="0" cellspacing="2" cellpadding="0">
									<tr>
										<td colspan="2" class="subTitulo">Cuentas a Distribuir</td>
									</tr>
									<tr>
										<td><strong> Oficina&nbsp;:&nbsp;</strong></td>
										<td>
											<input type="text" name="DOdescripcion" maxlength="60" <cfif modo neq "ALTA">value="#rsForm.DOdescripcion#"</cfif>>
										</td>
									</tr>
									<tr>
										<td><strong> Cuenta&nbsp;:&nbsp;</strong></td>
										<td>	

											<cfif modo EQ "ALTA">
									
												<table width="100%" cellpadding="0" cellspacing="0" border="0">
												<tr>
													<td nowrap>
														<input type="text" name="txt_Cmayor" maxlength="4" size="4" width="100%" 
																onfocus="this.select();"
																onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajas(this.value);"
														>
													</td>
													<td>
														<iframe marginheight="0" 
																marginwidth="0" 
																scrolling="no" 
																name="cuentasIframe" 
																id="cuentasIframe" 
																width="100%" 
																height="25" 
																frameborder="0"></iframe>
														<input type="hidden" name="CtaFinal">
													</td>
												</tr>	
												</table>
												
											<cfelse>	
													<cfif find("-",rsCuenta.Cformato,1) eq 0>
														<cfset Param_Cmayor ="#rsCuenta.Cformato#">
													<cfelse>
														<cfset Param_Cmayor ="#Mid(rsCuenta.Cformato,1,find("-",rsCuenta.Cformato,1)-1)#">
													</cfif>
													<table width="100%" cellpadding="0" cellspacing="0" border="0">
													<tr>
														<td nowrap>
															<input type="text" name="txt_Cmayor" maxlength="4" size="4" width="100%" 
																	onfocus="this.select()"	
																	onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajas(this.value)" 
																	value="<cfif modo neq "ALTA"><cfoutput>#Param_Cmayor#</cfoutput></cfif>"
															>
														</td>
														<td>
															<iframe marginheight="0" 
																	marginwidth="0" 
																	scrolling="no" 
																	name="cuentasIframe" 
																	id="cuentasIframe" 
																	width="100%" 
																	height="25" 
																	frameborder="0" 
																	src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&MODO=#modo#&formatocuenta=#rsCuenta.Cformato#</cfoutput>">
																	</iframe>
															<input type="hidden" name="CtaFinal" value="<cfoutput>#rsCuenta.Cformato#</cfoutput>">
														</td>
													</tr>	
													</table>
											</cfif>
		


										</td>
									</tr>
									<tr>
										<td><strong> Procentaje&nbsp;:&nbsp;</strong></td>
										<td>	
											<input type="text" name="CDporcentaje">
										</td>
									</tr>
									<tr>
										<td><strong> Excluir&nbsp;:&nbsp;</strong></td>
										<td>	
											<input type="checkbox" name="chkexcluir">
										</td>
									</tr>																		
									</table>
									<br>
									<cf_botones modo="#modo#">
								</form>
								<cf_qforms>
								<script language="javascript" type="text/javascript">
								<!--//
									objForm.DOdescripcion.description = "#JSStringFormat('Nombre')#";
									objForm.DOorigen.description = "#JSStringFormat('Descripcin')#";
									function habilitarValidacion(){		
										objForm.DOdescripcion.required = true;
										objForm.DOorigen.required = true;
									}
									function desahabilitarValidacion(){
										objForm.DOdescripcion.required = false;
										objForm.DOorigen.required = false;
									}
									habilitarValidacion();
									objForm.DOdescripcion.obj.focus();
								//-->
									function fnRight(LprmHilera, LprmLong)
									{
										var LvarTot = LprmHilera.length;
										return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
									}
									function CargarCajas(Cmayor)
									{				
										var fr = document.getElementById("cuentasIframe");					
										fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&MODO=ALTA"<!--- <cfoutput>#modo#</cfoutput> --->
									}
									//Dispara la funcion del iframe que retorna los datos de la cuenta
									function FrameFunction()
									{
										// RetornaCuenta2() retorna máscara completa, rellena con comodin
										window.parent.cuentasIframe.RetornaCuenta2();
										
									}											
								</script>
								</cfoutput>	


								
							</td>
						</tr>
					</table>
				</cf_web_portlet>
			</td>	
		  </tr>
		</table>
	</cf_templatearea>
</cf_template>
