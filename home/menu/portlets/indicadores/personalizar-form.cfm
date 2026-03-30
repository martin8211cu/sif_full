					<table width="98%" cellpadding="0" cellspacing="0" align="center">
						<tr>
							<td valign="top" width="50%">
								<cfquery name="rsLista" datasource="asp">
									select a.Usucodigo, a.indicador, b.nombre_indicador
									from IndicadorUsuario a
									
									inner join Indicador b
									on a.indicador=b.indicador
									
									where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
									order by b.nombre_indicador, a.posicion
								</cfquery>
								<cfif rsLista.recordCount eq 0 and not IsDefined('url.redirected') >
									<cflocation url="personalizar-sql.cfm?insertar_default=true">
								</cfif>
								
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td class="tituloListas" align="left" width="18" height="17" nowrap></td>
										<td class="tituloListas" colspan="3" nowrap><strong>Indicadores seleccionados para an&aacute;lisis</strong></td>
									</tr>
									
									<cfif rsLista.recordCount gt 0 >
										<cfoutput query="rsLista">
											<form method="post" action="agregarIndicador.cfm" style="margin:0;">
												<input type="hidden" name="indicador" value="#rsLista.indicador#">
												<tr style="padding-top:3px; padding-bottom:3px; " class="<cfif rsLista.currentRow mod 2>listaNon<cfelse>listaPar</cfif>" onmouseover="this.className='listaParSel';" onmouseout="<cfif rsLista.currentRow mod 2>this.className='listaNon';<cfelse>this.className='listaPar';</cfif>">
													<td align="left" width="18" height="17" nowrap></td>
													<td align="left" width="350"  nowrap onmouseover="javascript: window.status = ''; return true;" onmouseout="javascript: window.status = ''; return true;">#rsLista.nombre_indicador#</td>
													<td width="1"><input type="submit" name="btnModificar" value="Modificar"></td>
													<td width="1"><input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript:procesar(this);"></td>
												</tr>
											</form>
										</cfoutput>
									<cfelse>
										<tr><td>- No se han definido Indicadores -</td></tr>
									</cfif>
								</table>
							</td>
						</tr>
						
						<tr><td align="center">&nbsp;</td></tr>
							<tr><td align="center">
								<form method="post" name="formAgregar" action="agregarIndicador.cfm" style="margin:0;">
									<input type="submit" value="Agregar Indicador" >
									&nbsp;<input type="submit" value="Cancelar" onClick="javascript:document.formAgregar.action='../../portal.cfm';" >
								</form>
							</td></tr>
							<tr><td align="center">&nbsp;</td></tr>
					</table>	