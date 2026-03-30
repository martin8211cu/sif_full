<!--- 
	Modificado por: Ana Villavicencio+
	Fecha: 10 de marzo del 2006
	Motivo: Se agrego la funcionalidad de volver a la pantalla de regitro de notas de credito para el caso de que el documento
			vengo desde notas de credito (Aplicar y Relacionar la Nota de Credito).
			Validacion de variables url.

	Modificado por: Ana Villavicencio
	Fecha: 02 de marzo del 2006
	Motivo: Proceso para relacionar documentos a una nota de credito, se agregaron instrucciones para 
			verificar si hay varibles que se pasan por URL que son pasadas desde el proceso de  
			creacion de una nota de credito.
	
	Modificado por: Ana Villavicencio
	Fecha: 08 de diciembre del 2005
	Motivo: Cambio en la forma del despliegue de datos. 
			
	Creado por: desconocido
	Fecha: desconocida
 --->

<cf_templateheader title="SIF - Cuentas por Cobrar">
		<cfif isdefined('url.modo') and LEN(TRIM(url.modo))>
			<cfset modo = url.modo>
			<cfset form.Cambio = 'Cambio'>
		</cfif>
		<cfif isdefined('url.AplicaRel') and not isdefined('form.AplicaRel')>
			<cfset form.AplicaRel = url.AplicaRel>
		</cfif>
		<cfif isdefined('url.CCTcodigo') and not isdefined('form.CCTcodigo')>
			<cfset form.CCTcodigo = url.CCTcodigo>
		</cfif>
		<cfif isdefined('url.Ddocumento') and not isdefined('form.Ddocumento')>
			<cfset form.Ddocumento = url.Ddocumento>
		</cfif>
		

		<cfif isdefined("Url.pageNum_rsDocumentos") and not isdefined("Form.pageNum_rsDocumentos")>
			<cfparam name="Form.pageNum_rsDocumentos" default="#Url.pageNum_rsDocumentos#">
		</cfif>
		<cfif isdefined("Url.descripcion") and not isdefined("Form.descripcion")>
			<cfparam name="Form.descripcion" default="#Url.descripcion#">
		</cfif>
		<cfif isdefined("Url.Fecha") and not isdefined("Form.Fecha")>
			<cfparam name="Form.Fecha" default="#Url.Fecha#">
		</cfif>
		<cfif isdefined("Url.Transaccion") and not isdefined("Form.Transaccion")>
			<cfparam name="Form.Transaccion" default="#Url.Transaccion#">
		</cfif>
		<cfif isdefined("Url.Usuario") and not isdefined("Form.Usuario")>
			<cfparam name="Form.Usuario" default="#Url.Usuario#">
		</cfif>
		<cfif isdefined("Url.Moneda") and not isdefined("Form.Moneda")>
			<cfparam name="Form.Moneda" default="#Url.Moneda#">
		</cfif>
		<cfif not isdefined('form.regresa')>
		<cfset regresa = ''>
		<cfif isdefined('url.tipo')>
			<cfset regresa = regresa & 'tipo=#url.tipo#'>
		</cfif>
		<cfif isdefined('url.Filtro_CCTdescripcion')>
			<cfset regresa = regresa & '&Filtro_CCTdescripcion=#url.Filtro_CCTdescripcion#'>
		</cfif>
		<cfif isdefined('url.Filtro_EDdocumento')>
			<cfset regresa = regresa & '&Filtro_EDdocumento=#url.Filtro_EDdocumento#'>
		</cfif>
		<cfif isdefined('url.Filtro_EDFecha')>
			<cfset regresa = regresa & '&Filtro_EDFecha=#url.Filtro_EDFecha#'>
		</cfif>
		<cfif isdefined('url.Filtro_EDUsuario')>
			<cfset regresa = regresa & '&Filtro_EDUsuario=#url.Filtro_EDUsuario#'>
		</cfif>
		<cfif isdefined('url.Filtro_Mnombre')>
			<cfset regresa = regresa & '&Filtro_Mnombre=#url.Filtro_Mnombre#'>
		</cfif>
		<cfif isdefined('url.Filtro_CCTdescripcion')>
			<cfset regresa = regresa & '&hFiltro_CCTdescripcion=#url.Filtro_CCTdescripcion#'>
		</cfif>
		<cfif isdefined('url.Filtro_EDdocumento')>
			<cfset regresa = regresa & '&hFiltro_EDdocumento=#url.Filtro_EDdocumento#'>
		</cfif>
		<cfif isdefined('url.Filtro_EDFecha')>
			<cfset regresa = regresa & '&hFiltro_EDFecha=#url.Filtro_EDFecha#'>
		</cfif>
		<cfif isdefined('url.Filtro_EDUsuario')>
			<cfset regresa = regresa & '&hFiltro_EDUsuario=#url.Filtro_EDUsuario#'>
		</cfif>
		<cfif isdefined('url.Filtro_Mnombre')>
			<cfset regresa = regresa & '&hFiltro_Mnombre=#url.Filtro_Mnombre#'>
		</cfif>
		<cfif isdefined('url.Filtro_FechasMayores')>
			<cfset regresa = regresa & '&Filtro_FechasMayores=#url.Filtro_FechasMayores#'>
		</cfif>
		<cfif isdefined('url.Pagina')>
			<cfset regresa = regresa & '&Pagina=#url.Pagina#'>
		</cfif>
		</cfif>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">	
					<cfparam name="PageNum_rsLineas" default="1">						
					<cfif isDefined("Form.Aplicar") and Len(Trim(Form.CCTcodigo)) NEQ 0 and Len(Trim(Form.Ddocumento)) NEQ 0>
						<!--- La fecha en EFavor no puede ser menor a la fecha del documento asociado en la tabla Documentos --->
						<cfquery name="rsValidaA" datasource="#session.DSN#" maxrows="1">
							select 
								(case when 
								(e.EFfecha) < (select d.Dfecha 
												from Documentos d 
												where d.Ecodigo = e.Ecodigo 
													and d.CCTcodigo = e.CCTcodigo
													and d.Ddocumento = e.Ddocumento)
								then 1 else 2 end) as diferencia
							from EFavor e
							where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and e.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#" >
								and e.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
								order by 1
						</cfquery>
						<cfif isdefined("rsValidaA") and rsValidaA.diferencia eq 1>
							<cf_errorCode	code = "50175" msg = "No se puede aplicar el Documento al ser la fecha del Encabezado menor a la fecha del Documento Relacionado.">
							<cfabort>
						</cfif> 
						
						<!--- La fecha en EFavor no puede ser menor a la fecha del documento relacionado en la tabla Documentos via la tabla DFavor --->
						<cfquery name="rsValidaB" datasource="#session.DSN#" maxrows="1">
							select 
								(case when 
								(e.EFfecha) < (select d.Dfecha 
												from Documentos d 
												where d.Ecodigo = df.Ecodigo 
													and d.CCTcodigo = df.CCTRcodigo
													and d.Ddocumento = df.DRdocumento)
								then 1 else 2 end) as diferencia
							from EFavor e
								inner join DFavor df
									on df.Ecodigo = e.Ecodigo
										and df.CCTcodigo = e.CCTcodigo
										and df.Ddocumento  = e.Ddocumento
							where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and e.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#" >
								and e.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
								order by 1
						</cfquery>
						<cfif isdefined("rsValidaB") and rsValidaB.diferencia eq 1>
							<cf_errorCode	code = "50176" msg = "No se puede aplicar un Documento del detalle con fecha mayor a la Fecha del Encabezado.">
							<cfabort>
						</cfif>

						<cfif isdefined("form.disponible")>
							<cfset LvarDisponible = replace(form.disponible, ",","","all")>
						<cfelse>
							<cfset LvarDisponible = 0.00>
						</cfif>
						<cfif LvarDisponible LTE -0.01>
								<cf_errorCode	code = "50177"
												msg  = "El monto del documento @errorDat_1@ a aplicar: @errorDat_2@ es MAYOR que el saldo del documento: @errorDat_3@. Proceso Cancelado!"
												errorDat_1="#form.ddocumento#"
												errorDat_2="#NumberFormat(form.aplicado, ",9.00")#"
												errorDat_3="#form.SaldoEncabezado#"
								>
						</cfif>

						<!--- Invoca el componente de posteo --->
						<cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC"
						  method = "CC_PosteoDocsFavorCxC"
							Ecodigo    = "#Session.Ecodigo#"
							CCTcodigo  = "#Form.CCTcodigo#"
							Ddocumento = "#Form.Ddocumento#"
							usuario    = "#Session.usuario#"
							Usucodigo  = "#Session.usucodigo#"
							fechaDoc   = "S"
							debug      = "NO"
							/>

						<cfset params = '?pageNum_rsDocumentos=1' >
						<cfif isdefined('form.pageNum_rsDocumentos') and len(trim(form.pageNum_rsDocumentos))>
							<cfset params = '?pageNum_rsDocumentos=#form.pageNum_rsDocumentos#' >
						</cfif>
						<cfif isdefined('form.descripcion') and len(trim(form.descripcion)) >
							<cfset params = params & '&descripcion=#form.descripcion#' >
						</cfif>
						<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >
							<cfset params = params & '&fecha=#form.fecha#' >
						</cfif>
						<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >
							<cfset params =  params & '&transaccion=#form.transaccion#' >
						</cfif>
						<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >
							<cfset params =  params & '&usuario=#form.usuario#' >
						</cfif>
						<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >
							<cfset params =  params & '&moneda=#form.moneda#' >
						</cfif>

						<cfif isdefined('form.AplicaRel')>
							<cflocation url="RegistroNotasCredito.cfm?#regresa#">
						<cfelse>
							<cflocation url="listaDocsAfavorCC.cfm#params#" addtoken="no">
						</cfif>
					</cfif>
					<cfset IDpago = "">
					<cfset CCTcodigo = "">
					<cfset Ddocumento = "">						
					<cfset CCTRcodigo = "">						
					<cfset DRdocumento = "">
					<cfif not isDefined("Form.NuevoE")>
						<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
							<cfset arreglo = ListToArray(Form.datos,"|")>
							<cfset IDpago = Trim(arreglo[1])>
							<cfset CCTcodigo = Trim(arreglo[2])>
							<cfset Ddocumento = Trim(arreglo[3])>
							
						<cfelseif isdefined("Form.CCTcodigo") and isdefined("Form.Ddocumento")>
							<cfif isdefined("Form.CCTcodigo")>
								<cfset CCTcodigo  = Form.CCTcodigo >
							</cfif>
							<cfif isdefined("Form.Ddocumento")>
								<cfset Ddocumento = Form.Ddocumento>
							</cfif>
						</cfif>
					</cfif>
					<cfif Len(Trim(CCTcodigo)) NEQ 0>
						<cfquery name="rsDocumento" datasource="#Session.DSN#">
							select
								Ecodigo,
								CCTcodigo,
								Ddocumento,
								SNcodigo,
								Mcodigo,
								EFtipocambio,
								EFtotal,
								EFselect,
								EFfecha,
								Ccuenta,
								ts_rversion 
							from EFavor 
							where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CCTcodigo#">
							  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ddocumento#">
						</cfquery>
						<cfquery name="rsLineas" datasource="#Session.DSN#">
							select 
								a.Ecodigo,
								rtrim(ltrim(a.CCTcodigo)) as CCTcodigo,
								rtrim(ltrim(a.Ddocumento)) as Ddocumento,
								rtrim(ltrim(a.CCTRcodigo)) as CCTRcodigo,
								rtrim(ltrim(a.DRdocumento)) as DRdocumento,
								coalesce(rtrim(ltrim((select (b.Dfecha) 
												from Documentos b
													where b.Ecodigo = a.Ecodigo 
														and b.CCTcodigo = a.CCTRcodigo 
														and b.Ddocumento = a.DRdocumento ))),'0') as EFfecha,
								a.SNcodigo,
								a.DFmonto,
								a.Ccuenta,
								a.DFtipocambio,
								a.Mcodigo,
								b.Mnombre,
								a.DFmontodoc,
								a.ts_rversion ,
								<cf_dbfunction name="concat" args="rtrim(ltrim(a.CCTcodigo)),rtrim(ltrim(a.Ddocumento))"> as IDpago
							from DFavor a, Monedas b
							where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CCTcodigo#">
							  and a.Ddocumento=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ddocumento#">
							  and a.Mcodigo = b.Mcodigo
						</cfquery>
						<cfquery name="rsTotalLineas" dbtype="query">
							select sum(DFmonto) as DFmonto
							from rsLineas
						</cfquery>
						
						<cfset MaxRows_rsLineas=2>
						<cfset StartRow_rsLineas=Min((PageNum_rsLineas-1)*MaxRows_rsLineas+1,Max(rsLineas.RecordCount,1))>
						<cfset EndRow_rsLineas=Min(StartRow_rsLineas+MaxRows_rsLineas-1,rsLineas.RecordCount)>
						<cfset TotalPages_rsLineas=Ceiling(rsLineas.RecordCount/MaxRows_rsLineas)>
					</cfif>



	                <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aplicaci&oacute;n de documentos'>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr> 
								<td valign="top"><cfset regresar = "listaDocsAfavorCC.cfm"><cfinclude template="../../portlets/pNavegacionCC.cfm"></td>
							</tr>
							<tr> 
								<td width="77%" valign="top"> <cfinclude template="formDocsAfavorCC.cfm"></td>
							</tr>
							<cfif Len(Trim("CCTcodigo")) NEQ 0>
								<cfif modo NEQ "ALTA">
									<cfif rsLineas.recordCount GT 0>
										<tr> 
											<td> 
												<form action="AplicaDocsAfavorCC.cfm" method="post" name="form2">
													<input name="datos" type="hidden" value="">
													<cfif isdefined('form.AplicaRel')>
													<input name="AplicaRel" type="hidden" value="<cfoutput>#form.AplicaRel#</cfoutput>">
													</cfif>
													<table width="98%" border="0" cellspacing="0" align="center">
														<tr> 
															<td width="10%" height="21" bgcolor="#E2E2E2" class="subTitulo">&nbsp;Transacci&oacute;n</td>
															<td width="36%" bgcolor="#E2E2E2" class="subTitulo">&nbsp;Documento</td>
															<td width="36%" bgcolor="#E2E2E2" class="subTitulo">&nbsp;Fecha</td>
															<td width="10%" bgcolor="#E2E2E2" class="subTitulo">&nbsp;Moneda</td>
															<td width="20%" bgcolor="#E2E2E2" class="subTitulo"> 
																<div align="right">&nbsp;Monto en Moneda de Pago</div>
															</td>
														</tr>
														<cfoutput query="rsLineas"> 
															<tr class="<cfif #rsLineas.CurrentRow# MOD 2>listaPar<cfelse>listaNon</cfif>"
																style="cursor: pointer;"
																onClick="javascript:Editar('#rsLineas.IDpago#|#rsLineas.CCTcodigo#|#rsLineas.Ddocumento#|#rsLineas.CCTRcodigo#|#rsLineas.DRdocumento#');"
																onMouseOver="javascript: style.color = 'red'" 
																onMouseOut="javascript: style.color = 'black'"> 
																<cfset punto = "">
																<td nowrap>
																	<cfif Len(Trim(#rsLineas.CCTRcodigo#)) GT 30>
																		<cfset punto = " ...">
																	</cfif>
																	&nbsp;#Mid(rsLineas.CCTRcodigo,1,30)#
																</td>
																<td>#rsLineas.DRdocumento#</td>
																<td>#dateformat(rsLineas.EFfecha, 'dd/mm/yyyy')#</td>
																<td nowrap>#rsLineas.Mnombre#</td>
																<td><div align="right">#LSCurrencyFormat(rsLineas.DFmonto,'none')#</div></td>
															</tr>
														</cfoutput> 
														<cfif rsTotalLineas.RecordCount GT 0 >
															<tr> 
																<td colspan="3" style="border-top:solid 1px ##CCCCCC">&nbsp;</td>
																<td colspan="2" align="right" style="border-top:solid 1px ##CCCCCC">
																			<strong>
																			Total:&nbsp;&nbsp;&nbsp;
																			<cfoutput>#LSCurrencyFormat(rsTotalLineas.DFmonto,'none')#</cfoutput> 
																			</strong>
																</td>
															</tr>
														</cfif>
													</table>
														<cfoutput>
														<input type="hidden" name="pageNum_rsDocumentos" value="<cfif isdefined('form.pageNum_rsDocumentos') and len(trim(form.pageNum_rsDocumentos))>#form.pageNum_rsDocumentos#<cfelse>1</cfif>" />
														<input type="hidden" name="descripcion" 			value="<cfif isdefined('form.descripcion') and len(trim(form.descripcion))>#form.descripcion#</cfif>" />
														<input type="hidden" name="fecha" 			value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >#form.fecha#<cfelse>-1</cfif>" />
														<input type="hidden" name="transaccion" 	value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >#form.transaccion#<cfelse>-1</cfif>" />	
														<input type="hidden" name="usuario" 		value="<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >#form.usuario#<cfelse>-1</cfif>" />	
														<input type="hidden" name="moneda" 			value="<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >#form.moneda#<cfelse>-1</cfif>" />	
														</cfoutput>


												</form>
											</td>
										</tr>
									<cfelse>
										<tr><td class="listaCorte" align="center">El documento no tiene l&iacute;neas de detalle</td></tr>
										<tr><td>&nbsp;</td></tr>
									</cfif>
								</cfif>
							</cfif>
						</table>

						<script language="JavaScript1.2">
						function Editar(data) {
							if (data!="") {
								document.form2.action='AplicaDocsAfavorCC.cfm';
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

