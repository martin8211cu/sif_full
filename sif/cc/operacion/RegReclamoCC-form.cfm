<cfif isdefined('url.CCTcodigoE') and not isdefined('form.CCTcodigoE')>
	<cfset form.CCTcodigoE = url.CCTcodigoE>
</cfif>
<cfif isdefined('url.PAGENUM_LISTA') and not isdefined('form.PAGENUM_LISTA')>
	<cfset form.PAGENUM_LISTA = url.PAGENUM_LISTA>
</cfif>
<cfif isdefined('url.SNcodigo') and not isdefined('form.SNcodigo')>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined('url.Agregar') and not isdefined('form.Agregar')>
	<cfset form.Agregar = url.Agregar>
</cfif>

<cfif isdefined('url.Consultar') and not isdefined('form.Consultar')>
	<cfset form.Consultar = url.Consultar>
</cfif>
<cfif isdefined('url.Corte') and not isdefined('form.Corte')>
	<cfset form.Corte = url.Corte>
</cfif>
<cfif isdefined('url.Corte2') and not isdefined('form.Corte2')>
	<cfset form.Corte2 = url.Corte2>
</cfif>
<cfif isdefined('url.CCTcodigoE1') and not isdefined('form.CCTcodigoE1')>
	<cfset form.CCTcodigoE1 = url.CCTcodigoE1>
</cfif>
<cfif isdefined('url.CCTcodigoE2') and not isdefined('form.CCTcodigoE2')>
	<cfset form.CCTcodigoE2 = url.CCTcodigoE2>
</cfif>
<cfif isdefined('url.CCTcodigo') and not isdefined('form.CCTcodigo')>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>

<cfif isdefined('url.Documento') and not isdefined('form.Documento')>
	<cfset form.Documento = url.Documento>
</cfif>
<cfif isdefined('url.Mcodigo') and not isdefined('form.Mcodigo')>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<cfparam name="form.Pagina" default="1">
<br />

<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="2" class="subTitulo" style="text-transform:uppercase" align="center">Registro de Reclamos</td>
	</tr>
	<tr>
		<td colspan="2">
			<cfquery name="rsTransacciones" datasource="#session.dsn#">
				select CCTcodigo, CCTdescripcion
				from CCTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CCTtipo = 'D' 
				order by 1
			</cfquery>
			<cfoutput>
			<form action="RegReclamoCC.cfm" name="form1" method="post" >
				<!--- <cfif isdefined('form.Pagina')>
				<input name="Pagina" type="hidden" value="#form.Pagina#">
				</cfif> --->
			<table width="1%" align="center"  border="0" cellspacing="2" cellpadding="2">
				<tr>
					<td width="42%"></td>
					<td width="7%"></td>
				</tr>
				<tr> 
					<td align="right" nowrap><strong>Socio&nbsp;de&nbsp;Negocios:&nbsp;</strong></td>
					<td nowrap colspan="3"> <!--- Como es una consulta nunca va a cambiar de modo. --->
						<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
							<cfquery name="rsconlisSN2" datasource="#session.DSN#">
								select SNcodigo, SNnombre,SNnumero,SNtiposocio
								from SNegocios
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and SNcodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
							</cfquery>
								<cf_sifsociosnegocios2 form="form1" idquery="#form.SNcodigo#" tabindex="1"> 
							<cfelse>
								<cf_sifsociosnegocios2 form="form1" tabindex="1"> 
						</cfif>
					</td>
				</tr>
				<tr>
					<td align="right" valign="top" nowrap><p><strong>Desde:&nbsp;</strong></p></td>
					<td>
						<cfif isdefined("form.Corte") >
							<cf_sifcalendario form="form1" value="#form.Corte#" name="Corte" tabindex="1">	
						<cfelse>
							<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="Corte" tabindex="1">	
						</cfif>
					</td>	
					<td width="17%" align="right" valign="top" nowrap><p><strong>Hasta:&nbsp;</strong></p></td>
					<td width="34%">
						<cfif isdefined("form.Corte2") and len(trim(form.Corte2))>
							<cf_sifcalendario form="form1" value="#form.Corte2#" name="Corte2" tabindex="1">	
						<cfelse>
							<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="Corte2" tabindex="1">	
						</cfif>
					</td>	
				</tr>		  
				<tr>
					<td align="right"valign="top" nowrap><p><strong>Transacci&oacute;n&nbsp;Inicial:&nbsp; </strong></p></td>
					<td colspan="3">
						<select name="CCTcodigoE1" tabindex="1">
							<cfloop query="rsTransacciones">
								<option value="#rsTransacciones.CCTcodigo#" <cfif isdefined('Form.CCTcodigoE1') and #rsTransacciones.CCTcodigo# EQ #Form.CCTcodigoE1#>selected</cfif>>#rsTransacciones.CCTcodigo#</option>
							</cfloop>
						</select>	
					</td>
				</tr>
				<tr>
					<td align="right"valign="top" nowrap><p><strong>Transacci&oacute;n&nbsp;Final:&nbsp;</strong></p></td>
					<td colspan="3">
						<select name="CCTcodigoE2" tabindex="1">
							<cfloop query="rsTransacciones">
								<option value="#rsTransacciones.CCTcodigo#" <cfif isdefined('Form.CCTcodigoE2') and #rsTransacciones.CCTcodigo# EQ #Form.CCTcodigoE2#>selected</cfif>>#rsTransacciones.CCTcodigo#</option>
							</cfloop>
						</select>	
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td colspan="4" align="center">
						<!--- <input name="Corte" type="hidden" value="<cfif isdefined("form.Corte") and len(trim(form.Corte))>#form.Corte#</cfif>"> 
						<input name="Corte2" type="hidden" value="<cfif isdefined("form.Corte2") and len(trim(form.Corte2))>#form.Corte2#</cfif>"> 
						<input name="CCTcodigoE1" type="hidden" value="<cfif isdefined("form.CCTcodigoE1") and len(trim(form.CCTcodigoE1))>#form.CCTcodigoE1#</cfif>">
						<input name="CCTcodigoE2" type="hidden" value="<cfif isdefined("form.CCTcodigoE2") and len(trim(form.CCTcodigoE2))>#form.CCTcodigoE2#</cfif>"> --->
						<!--- <input type="hidden" name="SNcodigo" value="<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cfoutput>#form.SNcodigo#</cfoutput></cfif>"> --->
						<!--- <input name="Consultar" type="submit" value="Consultar" >		onClick="javascript: funcAgregar();" --->
						<!--- <input name="Limpiar" type="button" value="Limpiar" onClick="javascript: funcLimpiar();"> --->
						<cf_botones include="Consultar,Limpiar" exclude="Alta,Limpiar"  tabindex="1">
					</td>
				</tr>
			</table>
			</form> 
			</cfoutput>
			</td>
		</tr>
		<tr>
			<td colspan="2">
			
			<!--- ***************************************************  Lista   ***************************************************************** --->
			<cfif isdefined("form.Consultar") and len(trim(form.Consultar)) or isdefined("form.PAGENUM_LISTA") and form.PAGENUM_LISTA gt 0>
				<fieldset><legend>Lista&nbsp;de&nbsp;Documentos</legend> 
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top">			
							<script language="JavaScript" type="text/javascript">
								function LimpiarFiltros(f) {
								f.CCTcodigo.selectedIndex = 0;
								f.Documento.value = "";
								f.Mcodigo.selectedIndex = 0;
								}
							</script>		  
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cfset navegacion = "">
										<cfif isdefined('Form.Agregar')>
										<cfset navegacion = "&Agregar=#Form.Agregar#">
										</cfif>
										<!--- <form style="margin: 0" name="lista" action="RegistroInteresMoratorioCxC.cfm" method="post"> --->
										<cfset Transaccion = "Todos">
										<cfset Documento = "">
										
										<cfif isdefined("Form.Corte")>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Corte=" & #form.Corte#>				
										</cfif>
										<cfif isdefined("Form.Corte2")>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Corte2=" & #form.Corte2#>				
										</cfif>
										<cfif isdefined("Form.CCTcodigoE1")>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CCTcodigoE1=" & #form.CCTcodigoE1#>				
										</cfif>
										<cfif isdefined("Form.CCTcodigoE2")>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CCTcodigoE2=" & #form.CCTcodigoE2#>				
										</cfif>
										<cfif isdefined("Form.SNcodigo")>
											<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigo=" & #form.SNcodigo#>				
										</cfif>
										
										<form action="RegReclamoCC.cfm" name="form2" method="post" >
											<!--- <input name="Pagina" type="hidden" value="#form.Pagina#"> --->
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
											<tr> 
												<td width="4%">&nbsp;</td>
												<td><strong>Transacci&oacute;n</strong></td>
												<td><strong>Documento</strong></td>
												<td><strong>Moneda</strong></td>
												<td>&nbsp;</td>
											</tr>
											<tr> 
												<td>&nbsp;</td>
												<td> 
													<cfquery name="rsTransacciones" datasource="#Session.DSN#">
														select CCTcodigo, CCTdescripcion
														from CCTransacciones
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
														and CCTtipo = 'D' 
														order by 1
													</cfquery> 
													<select name="CCTcodigo" tabindex="1">
														<option value="-1" >(Todos)</option>
														<cfoutput query="rsTransacciones"> 
															<option value="#rsTransacciones.CCTcodigo#" 
																<cfif isdefined('Form.CCTcodigo') and trim(rsTransacciones.CCTcodigo) EQ trim(Form.CCTcodigo)>selected</cfif>>	
																#rsTransacciones.CCTcodigo#
															</option>
														</cfoutput> 
													</select> 
													<cfif isdefined("form.CCTcodigo")>
														<script language="javascript1.2" type="text/javascript">
															<cfoutput>
															document.form2.CCTcodigo.value = '#trim(form.CCTcodigo)#'
															</cfoutput>			
														</script>
													</cfif>
												</td>
												<td> 
													<input name="Documento" type="text" tabindex="1" 
													value="<cfif isDefined("Form.Documento") and Trim(Form.Documento) NEQ ""><cfoutput>#Form.Documento#</cfoutput></cfif>" 
													size="20" maxlength="20">	
												</td>
												<td>
													<cfquery name="rsMonedas" datasource="#Session.DSN#">
														select Mcodigo,Mnombre
														from Monedas
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													</cfquery> 
													<select name="Mcodigo" tabindex="1">
														<cfoutput query="rsMonedas"> 
															<option value="#rsMonedas.Mcodigo#" 
																<cfif isdefined('Form.Mcodigo') and rsMonedas.Mcodigo EQ Form.Mcodigo>selected</cfif>>	
																#rsMonedas.Mnombre#
															</option>
														</cfoutput> 
													</select> 
												</td>	
												<td nowrap> 
													<cfoutput>
													<input name="Filtrar" type="submit" value="Filtrar" tabindex="1"> 
													<input name="Limpiar" type="button" value="Limpiar" tabindex="1" 
													onClick="javascript: LimpiarFiltros(this.form);"> 
													<input type="hidden" name="tipo" value="D">
													<input name="Consultar" type="hidden" value="Consultar" > 
													<input name="Corte" type="hidden" value="<cfif isdefined("form.Corte") and len(trim(form.Corte))>#form.Corte#</cfif>"> 
													<input name="Corte2" type="hidden" value="<cfif isdefined("form.Corte2") and len(trim(form.Corte2))>#form.Corte2#</cfif>"> 
													<input name="CCTcodigoE1" type="hidden" value="<cfif isdefined("form.CCTcodigoE1") and len(trim(form.CCTcodigoE1))>#form.CCTcodigoE1#</cfif>">
													<input name="CCTcodigoE2" type="hidden" value="<cfif isdefined("form.CCTcodigoE2") and len(trim(form.CCTcodigoE2))>#form.CCTcodigoE2#</cfif>">
													<input type="hidden" name="SNcodigo" value="<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cfoutput>#form.SNcodigo#</cfoutput></cfif>">
													</cfoutput>
												</td>
											</tr>
										</table>
										</form>
									</td>
								</tr>
								<tr>
									<td>
										<cfoutput>
										<cfquery name="rsLista" datasource="#session.DSN#">
											select  a.HDid, b.SNnombre, a.SNcodigo, a.CCTcodigo , a.Ddocumento, a.Dfecha, a.Dsaldo, a.Dtotal, c.Mnombre
													<cfif isdefined("Form.CCTcodigoE1") and Len(Trim(Form.CCTcodigoE1))>
													, '#Form.CCTcodigoE1#' as CCTcodigoE1
													</cfif>
													<cfif isdefined("Form.CCTcodigoE2") and Len(Trim(Form.CCTcodigoE2))>
													, '#Form.CCTcodigoE2#' as CCTcodigoE2
													</cfif>
													<cfif isdefined("Form.Corte") and Len(Trim(Form.Corte))>
													, '#Form.Corte#' as Corte
													</cfif>
													<cfif isdefined("Form.Corte2") and Len(Trim(Form.Corte2))>
													, '#Form.Corte2#' as Corte2
													</cfif>
													<cfif isdefined("Form.Documento") and Len(Trim(Form.Documento))>
													, '#Form.Documento#' as Documento
													</cfif>
													<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo))>
													, '#Form.Mcodigo#' as Mcodigo
													</cfif>
													<!--- <cfif isdefined('form.Pagina') and LEN(TRIM(form.Pagina))>
														,'#form.Pagina#' as Pagina
													</cfif> --->
													
											from HDocumentos a
												inner join SNegocios b
													on a.Ecodigo = b.Ecodigo
													and a. SNcodigo = b.SNcodigo
													and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
													<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
														and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
													</cfif>
													<cfif isdefined("form.Corte") and len(trim(form.Corte)) and isdefined("form.Corte2") and len(trim(form.Corte2))>
														and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.Corte,"dd/mm/yyyy")#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.Corte2,"dd/mm/yyyy")#">
													<cfelseif isdefined("form.Corte") and len(trim(form.Corte))>
														and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.Corte,"dd/mm/yyyy")#">
													<cfelseif isdefined("form.Corte2") and len(trim(form.Corte2))>
														and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.Corte2,"dd/mm/yyyy")#"> 
													</cfif>									
													<cfif isdefined("form.Documento") and len(trim(form.Documento))>
														and upper(rtrim(a.Ddocumento)) like '%#ucase(trim(form.Documento))#%'
													</cfif>
													<cfif isdefined("form.CCTcodigoE1") and len(trim(form.CCTcodigoE1)) and isdefined("form.CCTcodigoE2") and len(trim(form.CCTcodigoE2)) >
														<cfif isdefined("form.CCTcodigo") and form.CCTcodigo NEQ -1>
															and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
														<cfelseif not isdefined("form.CCTcodigo")>
															and a.CCTcodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoE1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoE2#">
														</cfif>
													</cfif>
												inner join Monedas c
													on a.Mcodigo = c.Mcodigo
													and a.Ecodigo = b. Ecodigo
													<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
														and c.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mcodigo#">
													</cfif>
											order by a.CCTcodigo, a.Dfecha
										</cfquery>
										</cfoutput>
										
										<!--- <cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
										<cfset Pagenum_lista = Form.Pagina>
										</cfif>  --->
										
										<cfinvoke 
										component="sif.Componentes.pListas"
										method="pListaQuery"
										returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsLista#"/>
                                        <cfinvokeargument name="usaAJAX" value="NO"/>
										<cfinvokeargument name="desplegar" value="CCTcodigo,Ddocumento,Dfecha,Dtotal,Mnombre"/>
										<cfinvokeargument name="etiquetas" value="Transacci&oacute;n,Documento,Fecha,Monto,Moneda"/>
										<cfinvokeargument name="formatos" value="S,S,D,M,S"/>				
										<cfinvokeargument name="align" value="left,left,left,left,left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="debug" value="N"/>
										<cfinvokeargument name="keys" value="HDid,CCTcodigo,Ddocumento,SNcodigo"/> 
										<cfinvokeargument name="showEmptyListMsg" value= "1"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="MaxRows" value="15"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="irA" value= "RegReclamoModCC.cfm"/>
										</cfinvoke>
										&nbsp; 
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
						</td>	
					</tr>
				</table>
				</fieldset>		
			</cfif>			
		</td>
	</tr>
</table>
<br>
<!--- </form> --->


<!--- <cf_qforms  objForm="objForm1" form="form1"> --->
<cfoutput><!--- objForm="objform1" --->
<!--- objform1.CCTcodigo.description = "Transacci#JSStringFormat('ó')#n";
		objform1.required("CCTcodigo"); --->
<script language="javascript" type="text/javascript">
	function funcLimpiar(){
		document.form1.SNnumero.value ="";
		document.form1.SNnombre.value ="";
		document.form1.Corte.value ="#dateformat(now(), "dd/mm/yyyy")#";
		document.form1.Corte2.value ="#dateformat(now(), "dd/mm/yyyy")#";
		document.form1.CCTcodigoE1.value ="CO";
		document.form1.CCTcodigoE2.value ="CO";
	}
</script>
</cfoutput>