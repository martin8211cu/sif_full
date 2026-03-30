
	<cf_templateheader title="Registro de Documentos Contables">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfparam name="PageNum_rsLineas" default="1">					
          <cfset IDcontable = "">
					<cfif not isDefined("Form.NuevoE")>
						<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
							<cfset arreglo = ListToArray(Form.datos,"|")>
							<cfset IDcontable = Trim(arreglo[1])>
						<cfelse>
							<cfif not isdefined("Form.IDcontable")>
								<cflocation addtoken="no" url="listaDocumentosContables.cfm">
							</cfif>
							<cfset IDcontable = Trim(Form.IDcontable)>	
						</cfif>
         	</cfif>
          <cfif Len(Trim(IDcontable)) NEQ 0>
						<cfquery name="rsDocumento" datasource="#Session.DSN#">
							select IDcontable, 
								Ecodigo, 
								Cconcepto, 
								Eperiodo, 
								Emes, 
								Edocumento, 
								Efecha, 
								Edescripcion, 
								Edocbase, 
								Ereferencia, 
								ECauxiliar, 
								ECusuario, 
								ECselect, 
								ts_rversion
							from EContables
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
						</cfquery>
						<cfquery name="rsLineas" datasource="#Session.DSN#">
							select a.Dlinea, 
								a.IDcontable,
								a.Ddescripcion,
								b.Cformato,
								c.Mnombre,
								case when a.Dmovimiento = 'D' then a.Dlocal else 0 end as Debitos,
								case when a.Dmovimiento = 'C' then a.Dlocal else 0 end as Creditos
							from DContables a, 
								CContables b, 
								Monedas c
							where a.Ccuenta = b.Ccuenta
								and a.Mcodigo = c.Mcodigo 
								and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
							order by a.Dlinea
						</cfquery>
						<cfquery name="rsTotalLineas" dbtype="query">
								select sum(Debitos) as Debitos, sum(Creditos) as Creditos
								from rsLineas
						</cfquery>
						<cfset MaxRows_rsLineas=10>
						<cfset StartRow_rsLineas=Min((PageNum_rsLineas-1)*MaxRows_rsLineas+1,Max(rsLineas.RecordCount,1))>
						<cfset EndRow_rsLineas=Min(StartRow_rsLineas+MaxRows_rsLineas-1,rsLineas.RecordCount)>
						<cfset TotalPages_rsLineas=Ceiling(rsLineas.RecordCount/MaxRows_rsLineas)>
					</cfif>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Documentos Contables'>
						<cfoutput>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="##DFDFDF">
							<tr align="left"> 
								<td>
								<cfinclude template="../../portlets/pNavegacion.cfm">
								</td>
							</tr>
						</table>
						</cfoutput>
			
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<!--- form --->
							<tr><td width="77%" valign="top"><cfinclude template="formDocumentosContables.cfm"></td></tr>
			
							<!--- lista de datos --->
							<cfif Len(Trim("#IDcontable#")) NEQ 0 and not isDefined("Form.Aplicar")>
								<tr> 
									<td align="center"> 
										<form action="DocumentosContables.cfm" method="post" name="form2">
											<input name="datos" type="hidden" value="">
											<table width="90%" border="0" cellpadding="2" cellspacing="0" align="center">
												<!--- etiquetas --->
												<tr> 
													<td width="1%"  class="tituloListas">&nbsp;</td>
													<td width="5%"  class="tituloListas">L&iacute;nea</td>
													<td width="31%" class="tituloListas">Descripci&oacute;n</td>
													<td width="25%" class="tituloListas">Formato</td>
													<td width="10%" class="tituloListas">Moneda</td>
													<td width="14%" class="tituloListas"><div align="right">D&eacute;bitos</div></td>
													<td width="15%" class="tituloListas"><div align="right">Cr&eacute;ditos</div></td>
												</tr>
			
												<!--- datos --->
												<cfoutput query="rsLineas"> 
													<tr class="<cfif rsLineas.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif rsLineas.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>'" onClick="javascript:Editar('#rsLineas.IDcontable#|#rsLineas.Dlinea#');" >  
														<cfset llave = trim(rsLineas.IDcontable) & "|" & trim(rsLineas.Dlinea) >
														<td width="1%" >
															<cfif isdefined("form.datos") and len(trim(form.datos)) and form.datos eq llave >
																<img src="../../imagenes/addressGo.gif">
															</cfif>
														</td>
			
													<!---<tr <cfif rsLineas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> > --->
														<cfset punto = "">
														<td><a href="javascript:Editar('#rsLineas.IDcontable#|#rsLineas.Dlinea#');">#rsLineas.CurrentRow#</a></td>
														<td nowrap>
															<a href="javascript:Editar('#rsLineas.IDcontable#|#rsLineas.Dlinea#');" title="#rsLineas.Ddescripcion#"> 
																<cfif Len(Trim(rsLineas.Ddescripcion)) GT 30><cfset punto = " ..."></cfif>
																#Mid(rsLineas.Ddescripcion,1,30)##punto#
															</a>
														</td>
														<td nowrap><a href="javascript:Editar('#rsLineas.IDcontable#|#rsLineas.Dlinea#');">#rsLineas.Cformato#</a></td>
														<td nowrap><a href="javascript:Editar('#rsLineas.IDcontable#|#rsLineas.Dlinea#');">#rsLineas.Mnombre#</a></td>
														<td nowrap align="right"><a href="javascript:Editar('#rsLineas.IDcontable#|#rsLineas.Dlinea#');">#LSCurrencyFormat(rsLineas.Debitos,'none')#</a></td>
														<td nowrap align="right"><a href="javascript:Editar('#rsLineas.IDcontable#|#rsLineas.Dlinea#');">#LSCurrencyFormat(rsLineas.Creditos,'none')#</a></td>
													</tr>
												</cfoutput> 
			
												<cfif rsTotalLineas.RecordCount GT 0 >
													<tr> 
														<td colspan="4">&nbsp;</td>
														<td align="left">
															<font size="1"><strong>Totales:</strong></font>
														</td>
				
														<td align="right">
															<font size="1"><strong><cfoutput>#LSCurrencyFormat(rsTotalLineas.Debitos,'none')#</cfoutput></strong></font>
														</td>
				
														<td align="right">
															<font size="1"><strong><cfoutput>#LSCurrencyFormat(rsTotalLineas.Creditos,'none')#</cfoutput></strong></font>
														</td>
													</tr>
												</cfif>
											</table>
										</form>
									</td>
								</tr>
							</cfif>
						</table>
						<script language="JavaScript1.2">
							function Editar(data) {
								if (data!="") {
									document.form2.action='DocumentosContables.cfm';
									document.form2.datos.value=data;
									document.form2.submit();
								}
								return false;
							}
						</script>
           <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>