<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ArticuloInventario"
Default="Articulo de Inventario "
returnvariable="LB_ArticuloInventario"/>

<cf_templateheader title="#LB_ArticuloInventario#">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ArticuloInventario#">		
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
					<cfquery datasource="#session.DSN#" name="rsAlmacen">
						select  Aid, Bdescripcion 
						from Almacen 
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by 2
					</cfquery> 
				
						<form action="ArticuloInvImpr.cfm" method="post" name="consulta">
							<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
								<tr><td><cfinclude template="../../portlets/pNavegacionIV.cfm"></td></tr>
							
								<tr><td> 
									<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
										<tr>
											<td align="center" colspan="4"><strong>Art&iacute;culo de Inventario</strong></td>
										</tr>
										<tr>
											<td colspan="4">&nbsp;</td>
										</tr>
									
										<!--- Almacen --->
										<tr>
											<td valign="baseline" align="right" nowrap><cf_translate  key="LB_AlmacenDesde">Almac&eacute;n Desde</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
											<td valign="baseline" nowrap>
												<select name="almini">
													<cfoutput query="rsAlmacen">
														<option value="#rsAlmacen.Aid#">#rsALmacen.Bdescripcion#</option>
													</cfoutput>
												</select>							
											</td>
											<td valign="baseline" align="right" nowrap><cf_translate  key="LB_AlmacenHasta">Almac&eacute;n Hasta</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
											<td valign="baseline" nowrap>
												<cfset ultimo = "">
												<select name="almfin">
													<cfoutput query="rsAlmacen">
														<cfset ultimo = #rsAlmacen.Aid# >
														<option value="#rsAlmacen.Aid#">#rsALmacen.Bdescripcion#</option>
													</cfoutput>
												</select>
												<script language="JavaScript1.2" type="text/javascript">
													//document.consulta.almfin.value = '<cfoutput>#ultimo#</cfoutput>'
												</script>	 						
											</td>
										</tr>
										
										<tr>
										<td valign="baseline" align="right" nowrap>Estado:</td>
										<td valign="baseline" nowrap>
											<select name="estado" tabindex="1" value="<cfif isdefined('form.estado')>#form.estado#</cfif>">
												<option value="">--Todos--</option>
												<option value="1"<cfif isdefined ('form.estado') and form.estado EQ "1"> selected</cfif>>Activo</option>
												<option value="0"<cfif isdefined ('form.estado') and form.estado EQ "0"> selected</cfif>>Inactivo</option>
											</select>
										</td>
										
										
										
										<tr> 
											<td>&nbsp;</td>
											<td  colspan="3" align="left" nowrap> 
												<input type="checkbox" name="SinExistencia"><cf_translate  key="LB_ListarArticulossinExistencia">Listar Articulos sin Existencia</cf_translate>
											</td>
										</tr>
										<tr> 
											<td>&nbsp;</td>
											<td  colspan="3" align="left" nowrap> 
												<input type="checkbox" name="toExcel"><cf_translate  key="LB_ExpotarAExcel">Exportar a Excel</cf_translate>
											</td>
										</tr>
										<tr><td colspan="4">&nbsp;</td></tr>	
										<tr>
											<td colspan="4" align="center" nowrap>
												<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Consultar"
												Default="Consultar"
												returnvariable="BTN_Consultar"/>
												<cfoutput>
													<input name="btnConsultar" type="submit" value="#BTN_Consultar#">
												</cfoutput>
											</td>	
										<tr>
									</table>
								</td>
							</tr>
						</table>
					</form>
				</td>	
			</tr>
		</table>	
		<cf_web_portlet_end>
	<cf_templatefooter>