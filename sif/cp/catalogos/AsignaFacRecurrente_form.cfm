<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 17-1-2006.
		Motivo: Nuevo proceso de Asignación de Facturas Recurrentes.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Lbl_SelSoc = t.Translate('Lbl_SelSoc','Seleccione un Socio')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset LB_TrDoctos = t.Translate('LB_TrDoctos','Traer Documentos')>
<cfset LB_SelDocReq = t.Translate('LB_SelDocReq','Seleccionando Documentos Recurrentes')>
<cfset LB_SelDocqsReq = t.Translate('LB_SelDocqsReq','Seleccione los Documentos que serán recurrentes')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
 
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	<tr>
		
		<td>
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<!--- Define nav: variable que maneja la navegación de la lista --->
						<cfset nav = "">
						<!--- Pasa parámetros del url al form --->
						<cfif isdefined("url.SNcodigo") 
								and len(trim(url.SNcodigo))>
							<cfset form.SNcodigo = url.SNcodigo>
						</cfif>
						<cfif isdefined("url.SNnumero") 
								and len(trim(url.SNnumero))>
							<cfset form.SNnumero = url.SNnumero>
						</cfif>
						<cfif isdefined("url.chk") 
								and len(trim(url.chk))>
							<cfset form.chk = url.chk>
						</cfif>
						<cfif isdefined("form.SNcodigo") 
								and len(trim(form.SNcodigo))
								and not isdefined("form.paso")>
							<cfset nav = nav&"&SNcodigo=#form.SNcodigo#">
							<cfset form.paso = 2>
						<cfelse>
							<cfset form.paso = 1>
						</cfif>
						<cfif paso GT 1>
							<cfquery name="rsSocio" datasource="#session.dsn#">
								select SNnombre, SNidentificacion, SNcodigo, SNid
									from SNegocios
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
							</cfquery>
						</cfif>
						<!--- Pinta 2 Pantallas, depende de la variable paso. --->
						<cfswitch expression="#form.paso#">
							<!--- Pantalla 1: Selección de los parámetros --->
							<cfcase value="1">
								<cfoutput>
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
									<tr>
										<td align="left"> #Lbl_SelSoc#:</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="3" cellpadding="3">
									<tr>
										<td>
											<form action="#CurrentPage#" method="post" name="form1" style="margin:0">
												<table width="100%" border="0" cellspacing="0" cellpadding="0" 
														class="" style="margin:0">
													<tr>
														<td nowrap="nowrap" class="fileLabel" align="right">
															<strong>#LB_Socio#:&nbsp;&nbsp;</strong>
														</td>
														<td nowrap="nowrap" width="100%">
															<cf_sifsociosnegocios2>
														</td>
													</tr>
													<tr>
														<td>&nbsp;</td>
														<td>&nbsp;</td>
													</tr>
													<tr>
														<td>&nbsp;</td>
														<td align="left">
															<!--- Debe válidar CDCcodigo en el onSubmit --->
															<cf_botones values = "#LB_TrDoctos#" names = "TraeDocumentos">
														</td>
													</tr>
												</table>
											</form>
										</td>
									</tr>
								</table>
								<script language="javascript" type="text/javascript">
									<!--//
									function funcTraeDocumentos(){
										if (document.form1.SNnombre.value==''){
											<cfset MSG_PrError	= t.Translate('MSG_PrError','Se presentaron los siguientes errores')>
											<cfset MSG_SocReq	= t.Translate('MSG_SocReq','El Socio es requerido.')>
											alert('#MSG_PrError#:\n-#MSG_SocReq#');
											return false;
										}
										return true;
									}
									//-->
								</script>
                                </cfoutput>
							</cfcase>
							<!--- Pantalla 2: Selección de los Documentos Recurrentes --->
							<cfcase value="2">
								<!--- <cfdump var="#form#">
								<cfdump var="#url#"> --->
								<cfquery name="rsSocio" datasource="#session.DSN#">
									select SNnombre, SNidentificacion, SNnumero
									from SNegocios
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
								</cfquery>
								
								<!--- 
										2.	El Sistema muestra la lista de las Documentos históricos seleccionables para la recurrencia.
								--->
                                
								<form name="form1" action="#CurrentPage#" method="post">
								<table width="100%" border="0" cellspacing="1" cellpadding="1" class="">
									<tr>
										<td class="Titulo"><cfoutput> #LB_SelDocReq#</cfoutput></td>
									</tr>
									<tr>
										<td class="TituloSub"><cfoutput> #LB_Socio#:&nbsp;#trim(rsSocio.SNnombre)#&nbsp;&nbsp;#rsSocio.SNnumero#</cfoutput></td>
										<input type="hidden" name="SNcodigo" value="<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cfoutput>#form.SNcodigo#</cfoutput></cfif>">
										<input type="hidden" name="SNnumero" value="<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))><cfoutput>#form.SNnumero#</cfoutput></cfif>">
									</tr>
									<tr>
										<td class="FileLabel" ><cfoutput> #LB_SelDocqsReq#:&nbsp;</cfoutput></td>
									</tr>
								</table>
								<!--- 	2.1 Consulta de Documentos --->							
								<!--- 	3.	El Usuario marca las cajas de selección múltiple correspondientes a las Facturas que 
											desea hacer Recurrentes. 
								--->
								<!--- 	3.1 Botón para solicitar guardar el cambio. --->
								<cfset Botones = "Guardar">
								<!--- Validación para que no permita pasar al siguiente paso sin seleccionar ningún item. --->
								<cfoutput>
								<script language="javascript" type="text/javascript">
									<!--//
									/*Funcion que verifica si algun seleccionado en la lista de checkboxes*/
									var actionFinished = false;
									function hayseleccionados(){ 
										f = document.form1;
										if (f.chk != null) {
											//hay al menos un item
											if (f.chk.value != null) {
												//hay un item
												if (f.chk.checked) {
													return true;
												}
											} else {
												//hay mas de un item
												for (var i=0; i<f.chk.length; i++) {
													if (f.chk[i].checked) {
														return true;
													}
												}
											}
										}
										return false;
									}
									function funcGuardar(){
										f = document.form1; 
										<cfset MSG_AsDocSel	= t.Translate('MSG_AsDocSel','¿Está seguro de asignar los Documentos seleccionados como recurrentes?')>
										if (confirm('#MSG_AsDocSel#')){
											<!--- Yu 14/02/2006
												Codigo para averiguar los documentos en pantalla dentro de la lista, eso para averiguar cuales hay que resetear el bit de EDrecurrente en 0 
											--->
											f["IDDOCUMENTO"].value = '';
											for (var i=0; i < f.length; i++) {
												if (f[i].name.indexOf('IDDOCUMENTO_') != -1) {
													if (f["IDDOCUMENTO"].value.length==0)
													f["IDDOCUMENTO"].value = f["IDDOCUMENTO"].value + f[i].value;
													else
													f["IDDOCUMENTO"].value = f["IDDOCUMENTO"].value + ',' + f[i].value;
												}
											}
											<!--- FIN de llenado de IDDOCUMENTO --->
											//Pura Vida!
											<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
												f.SNcodigo.value="<cfoutput>#form.SNcodigo#</cfoutput>";
											</cfif>
											document.form1.action = 'AsignaFacRecurrente_sql.cfm';
											document.form1.submit();
											return true;
										}
										else {
											return false;
										}
									}
									function funcFiltrar<cfoutput>#form.paso#</cfoutput>(){
										f = document.form1;
										<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
											f.SNcodigo.value="<cfoutput>#form.SNcodigo#</cfoutput>";
										</cfif>
										actionFinished = true;
										return true;
									}
									//-->
								</script>
								</cfoutput>
								<!--- Pasa Filtros del Url al Form --->
								<cfif isdefined("url.filtro_SNnombre") 
										and len(trim(url.filtro_SNnombre))>
									<cfset form.filtro_SNnombre = url.filtro_SNnombre>
								</cfif>
								<cfif isdefined("url.filtro_Ddocumento") 
										and len(trim(url.filtro_Ddocumento))>
									<cfset form.filtro_Ddocumento = url.filtro_Ddocumento>
								</cfif>
								<cfif isdefined("url.filtro_Dfecha") 
										and len(trim(url.filtro_Dfecha))>
									<cfset form.filtro_Dfecha = url.filtro_Dfecha>
								</cfif>
								<cfif isdefined("url.filtro_Dtotal") 
										and len(trim(url.filtro_Dtotal))>
									<cfset form.filtro_Dtotal = url.filtro_Dtotal>
								</cfif>
								<cfif isdefined("url.filtro_EDsaldo") 
										and len(trim(url.filtro_EDsaldo))>
									<cfset form.filtro_EDsaldo = url.filtro_EDsaldo>
								</cfif>

								<!--- Agrega Filtros a la Navegación --->
								<cfif isdefined("form.filtro_SNnombre") 
										and len(trim(form.filtro_SNnombre))>
									<cfset nav = nav & "&filtro_SNnombre=" & form.filtro_SNnombre>
								</cfif>
								<cfif isdefined("form.filtro_Ddocumento") 
										and len(trim(form.filtro_Ddocumento))>
									<cfset nav = nav & "&filtro_Ddocumento=" & form.filtro_Ddocumento>
								</cfif>
								<cfif isdefined("form.filtro_Dfecha") 
										and len(trim(form.filtro_Dfecha))>
									<cfset nav = nav & "&filtro_Dfecha=" & form.filtro_Dfecha>
								</cfif>
								<cfif isdefined("form.filtro_Dtotal") 
										and len(trim(form.filtro_Dtotal))>
									<cfset nav = nav & "&filtro_Dtotal=" & form.filtro_Dtotal>
								</cfif>
								<cfif isdefined("form.filtro_EDsaldo") 
										and len(trim(form.filtro_EDsaldo))>
									<cfset nav = nav & "&filtro_EDsaldo=" & form.filtro_EDsaldo>
								</cfif>

								<!--- 	2.2, 3.2 Lista de Documentos c/ Botón de Guardar. --->
								
								<cfset filtro = "">
									<cfset filtro="and sn.Ecodigo= #session.Ecodigo# and cp.CPTtipo = 'C'"> <!--- Solo para los documentos de CxP de tipo Crédito --->
								<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) and not isdefined("filtro_SNcodigo")>
									<cfset filtro= filtro & " and sn.SNcodigo = #form.SNcodigo#">
								</cfif>
								
								<cfinvoke 
									component="sif.Componentes.pListas" method="pLista" returnvariable="pLista"
									desplegar="Ddocumento, Dfecha, Dtotal, EDsaldo"
									etiquetas="#LB_Documento#, #LB_Fecha#, #LB_Monto#, #LB_Saldo#"
									align="left, center, left, left" 
									formatos="S, D, M, M"
									checkboxes="S" 
									checkedcol = "llave" 
									keys="IDdocumento" 
									botones="#Botones#" 
									showlink="false"
									formname="form1"
									MaxRowsQuery= "150"
									incluyeform="false"
									ira="AsignaFacRecurrente_sql.cfm" 
									navegacion="#nav#" 
									pageindex="#form.paso#" 
									mostrar_filtro="true" 
									filtrar_automatico="true"
									columnas="he.IDdocumento, sn.SNnombre, he.Ddocumento, he.Dfecha, he.Dtotal, he.EDsaldo, sn.SNcodigo, case when EDrecurrente = 1 then IDdocumento else EDrecurrente end as llave"
									cortes="SNnombre"
									filtrar_por="he.Ddocumento, he.Dfecha, he.Dtotal, he.EDsaldo" 
									tabla = "HEDocumentosCP he
												inner join SNegocios sn
													on sn.Ecodigo = he.Ecodigo
													and sn.SNcodigo = he.SNcodigo
												inner join CPTransacciones cp
													on cp.Ecodigo = he.Ecodigo
													and cp.CPTcodigo = he.CPTcodigo"
									filtro = " 1 = 1
									#filtro#
									order by he.Dfecha desc"								
									/><!--- EDrecurrente = 0 --->
								<cfoutput>
								</form>
									<table width="100%" border="0" cellspacing="3" cellpadding="3">
										<tr>
											<td>
												<form action="#CurrentPage#" method="post" name="form2">
													<cf_botones values="Regresar">
												</form>
											</td>
										</tr>
									</table>
								</cfoutput>
							</cfcase>
						</cfswitch>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>