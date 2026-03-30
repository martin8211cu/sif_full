<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		Cat&aacute;logo de Parentesco
	</cf_templatearea>
	<cf_templatearea name="body">
	<br>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" 
								tituloalign="center" titulo='Cat&aacute;logo de Parentesco'>
					<cfset filtro     = "" >
					<cfset navegacion = "&btnFiltrar=Filtrar" >
					<script language="JavaScript1.2" type="text/javascript">
						function filtrar( form ){
							form.action = '';
							form.submit();
						}
						
						function limpiar(){
							
							document.filtro.fEnombre.value = '';
							
							<cfset navegacion = '' >
						}
					</script>
						  
					<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
					<cfset fEnombre = "">
					<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar") >
						<cfset form.btnFiltrar = url.btnFiltrar >
					</cfif>
					<cfif isdefined("url.fEnombre") and not isdefined("form.fEnombre")>
						<cfset form.fEnombre = url.fEnombre >
					</cfif>
					<cfif isdefined("form.fEnombre") AND Len(Trim(form.fEnombre)) GT 0 and isdefined("form.btnFiltrar")>
						<cfset filtro = filtro & " upper(b.Enombre) like upper('%" & Trim(form.fEnombre) & "%')" >
						<cfset filtro = filtro & " and ">
						<cfset fEnombre = Trim(form.fEnombre)>
						<cfset navegacion = navegacion & "&fEnombre=#form.fEnombre#" >
					</cfif>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="3">
								<cfinclude template="/rh/portlets/pNavegacion.cfm">
							</td>
							<tr>
							  <td colspan="3" a align="center">
								 <font size="+2">Seleccione la Empresa a dar manteniniento.</font>
							  </td>
							</tr>
							<tr>
								<td>
									<form style="margin: 0; " name="filtro" method="post" action="Parentesco-Lista.cfm">
										<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
											<!--- Filtros --->
											<cfoutput> 
												<tr> 
													<td  colspan="4" align="right" width="11%">Descripción:&nbsp;</td>
													<td>
														<input type="text" name="fEnombre" value="#fEnombre#" size="35" 
															   maxlength="35" onFocus="this.select();">
													</td>
													<td>
														<div align="right"> 
															<input type="submit" name="btnFiltrar" value="Filtrar"  
																   onClick="javascript:filtrar(this.form)">
															<input type="button" name="btnLimpiar" value="Limpiar"  
																   onClick="javascript:limpiar()">
														</div>
													</td>
												</tr>
											</cfoutput> 
											<tr> 
										</table>
									</form>
								</td>
							</tr>						
							<tr> 
								<td valign="top" colspan="3">  
									<cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaRH"
										returnvariable="pListaRet">
										<cfinvokeargument name="conexion" value="asp"/>
										<cfinvokeargument name="columnas" value="a.Ccache, b.Enombre, c.CEnombre "/>
										<cfinvokeargument name="tabla" value="Caches a, Empresa b, CuentaEmpresarial c"/>
										<cfinvokeargument name="desplegar" value="Enombre"/>
										<cfinvokeargument name="etiquetas" value="Nombre de Empresa"/>
										<cfinvokeargument name="formatos" value="S"/>
										<cfinvokeargument name="align" value="left"/>
										<cfinvokeargument name="irA" value="Parentesco.cfm"/>
										<cfinvokeargument name="filtro" value=" #filtro# a.Cid in 
																				(select Cid from Empresa where Ecodigo != 1)
																				 and a.Cid = b.Cid  and b.CEcodigo = c.CEcodigo 
																				 group by c.CEnombre, b.Enombre, a.Ccache 
																				order by 1,3 "/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="keys" value="Ccache"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="cortes" value="CEnombre"/>
									</cfinvoke>
								</td>
							</tr>
						</table>
					<cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>