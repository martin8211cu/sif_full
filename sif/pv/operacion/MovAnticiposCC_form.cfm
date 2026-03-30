<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 16-1-2006.
		Motivo: Nuevo proceso de Movimiento de anticipos de PV a CxC.
 --->

<cfinclude template="../../Utiles/sifConcat.cfm">
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
	<tr>
		<td>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<!--- Define nav: variable que maneja la navegación de la lista --->
						<cfset nav = "">
						<!--- Pasa parámetros del url al form --->
						<cfif isdefined("url.CDCcodigo") 
								and len(trim(url.CDCcodigo))>
							<cfset form.CDCcodigo = url.CDCcodigo>
						</cfif>
						<cfif isdefined("url.FAX14DOC") 
								and len(trim(url.FAX14DOC))>
							<cfset form.FAX14DOC = trim(url.FAX14DOC)>
						</cfif>
						<cfif isdefined("url.SNcodigo") 
								and len(trim(url.SNcodigo))>
							<cfset form.SNcodigo = url.SNcodigo>
						</cfif>
						<cfif isdefined("url.SNnumero") 
								and len(trim(url.SNnumero))>
							<cfset form.SNnumero = url.SNnumero>
						</cfif>
						<cfif isdefined("url.CCTcodigo") 
								and len(trim(url.CCTcodigo))>
							<cfset form.CCTcodigo = url.CCTcodigo>
						</cfif>
						<cfif isdefined("url.chk") 
								and len(trim(url.chk))>
							<cfset form.chk = url.chk>
						</cfif>
						<!--- Define el Paso --->
						<cfif isdefined("url.FABTrasladoAdidList")
								and len(trim(url.FABTrasladoAdidList))>
							<cfset form.paso = 4>
						<cfelseif isdefined("form.CDCcodigo") 
								and len(trim(form.CDCcodigo))
								
								and isdefined("form.chk") 
								and len(trim(form.chk))
								and not isdefined("form.paso")>
							<cfset form.paso = 3>
							<cfset nav = nav&"&CDCcodigo=#form.CDCcodigo#&chk=#form.chk#">
						<cfelseif isdefined("form.FAX14DOC") 
								and len(trim(form.FAX14DOC))
								and isdefined("form.CDCcodigo") 
								and len(trim(form.CDCcodigo))
								and not isdefined("form.paso")>
							<cfset nav = nav&"&FAX14DOC=#trim(form.FAX14DOC)#&CDCcodigo=#form.CDCcodigo#&SNcodigo=#form.SNcodigo#&CCTcodigo=#form.CCTcodigo#">
							<cfset form.paso = 2>
						<cfelseif isdefined("form.CDCcodigo") 
								and len(trim(form.CDCcodigo))
								and not isdefined("form.paso")>
							<cfset nav = nav&"&CDCcodigo=#form.CDCcodigo#&SNcodigo=#form.SNcodigo#&CCTcodigo=#form.CCTcodigo#">
							<cfset form.paso = 2>
						<cfelseif isdefined("form.FAX14DOC") 
								and len(trim(form.FAX14DOC))
								and not isdefined("form.paso")>
							<cfset nav = nav&"&FAX14DOC=#trim(form.FAX14DOC)#&SNcodigo=#form.SNcodigo#&CCTcodigo=#form.CCTcodigo#">
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
						<cfif paso GT 3>
							<cfquery name="rsFABTAd" datasource="#session.dsn#">
								select distinct CDCcodigoDest, FABMotivo 
								from FABitacoraTrasladoAd
								where FABTrasladoAdid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FABTrasladoAdidList#" list="yes">)
							</cfquery>
							<cfquery name="rsClienteDest" datasource="#session.dsn#">
								select CDCnombre
								from ClientesDetallistasCorp 
								where 	CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFABTAd.CDCcodigoDest#">
									and CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							</cfquery>
						</cfif>
						<!--- Pinta 2 Pantallas, depende de la variable paso. --->
						<cfswitch expression="#form.paso#">
							<!--- Pantalla 1: Selección de los parámetros --->
							<cfcase value="1">
								<!--- 
										1.	El Usuario ingresa un Socio y transacción destino y un documento o un Cliente para mostrar los Anticipos a mover.
								--->
								<cfquery name="rsTransacciones" datasource="#Session.DSN#">
									select CCTcodigo, CCTdescripcion , 
										case when len(rtrim(ltrim(CCTcodigo#_Cat#' - '#_Cat#CCTdescripcion))) > 10  then 
											CCTcodigo#_Cat#'-'#_Cat#substring(rtrim(ltrim(CCTdescripcion)),1,10)
										else 
											rtrim(ltrim(CCTcodigo#_Cat#'-'#_Cat#CCTdescripcion)) 
										end as Transaccion
									
										from CCTransacciones  
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
										and CCTtipo = 'C' 
										and isnull(CCTpago,0) = 1
										order by CCTcodigo 
								</cfquery>

								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
									<tr>
										<td class="FileLabel" > Seleccione un Socio y transacci&oacute;n destino y un documento o  un Cliente para mostrar los Anticipos a mover:</td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="3" cellpadding="3">
									<tr>
										<td>
											<form action="#CurrentPage#" method="post" name="form1" style="margin:0">
												<table width="100%" border="0" cellspacing="0" cellpadding="0" 
														class="" style="margin:0">
													<tr>
														<td nowrap="nowrap" class="fileLabel">
															<strong>Socio:&nbsp;</strong>
														</td>
														<td nowrap="nowrap" width="100%">
															<cf_sifsociosnegocios2>
														</td>
														<td nowrap="nowrap" class="fileLabel">
															<strong>Transacc&oacute;n</strong>
														</td>	
														<td>
														<select name="CCTcodigo" tabindex="1">
															<cfoutput query="rsTransacciones"> 
															  <option value="#CCTcodigo#">#Transaccion#</option>
															</cfoutput> 
														</select>	
														</td>
													<tr>
													<tr>
														<td nowrap="nowrap" class="fileLabel">
															<strong>Documento:&nbsp;</strong>
														</td>
														<td nowrap="nowrap" width="100%">
															<input type="text" name="FAX14DOC" value="">
														</td>	
													<tr>
														<td nowrap="nowrap" class="fileLabel">
															<strong>Cliente:&nbsp;</strong>
														</td>
														<td nowrap="nowrap" width="100%">
															<cf_sifClienteDetCorp form='form1'>
														</td>
														<td>
															<!--- Debe válidar CDCcodigo en el onSubmit --->
															<cf_botones values = "Traer Adelantos" names = "TraeAdelantos">
														</td>
													</tr>
												</table>
											</form>
										</td>
									</tr>
								</table>
								<script language="javascript" type="text/javascript">
									<!--//
									function funcTraeAdelantos(){
										if (document.form1.SNnombre.value==''){
											alert('Se presentaron los siguientes errores:\n-El Socio es requerido');
											return false;
										}
										if ((document.form1.FAX14DOC.value=='') && (document.form1.CDCidentificacion.value=='')){
											alert('Se presentaron los siguientes errores:\n-Se debe digitar un Documento o un Cliente');
											return false;
										}
										
										return true;
									}
									
									//-->
								</script>
							</cfcase>
							<!--- Pantalla 2: Selección de los Adelantos del Cliente Origen --->
							<cfcase value="2">
								<cfquery name="rsSocio" datasource="#session.DSN#">
									select SNnombre, SNidentificacion, SNnumero
									from SNegocios
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
								</cfquery>
								<cfquery name="rsTransacciones" datasource="#Session.DSN#">
									select CCTcodigo, CCTdescripcion , 
										case when len(rtrim(ltrim(CCTcodigo#_Cat#' - '#_Cat#CCTdescripcion))) > 10  then 
											CCTcodigo#_Cat#'-'#_Cat#substring(rtrim(ltrim(CCTdescripcion)),1,10)
										else 
											rtrim(ltrim(CCTcodigo#_Cat#'-'#_Cat#CCTdescripcion)) 
										end as Transaccion
									
										from CCTransacciones  
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										
										and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
										and CCTtipo = 'C' 
										and isnull(CCTpago,0) = 1
										order by CCTcodigo 
								</cfquery>
								<!--- 
										2.	El Sistema muestra la lista de adelantos por trasladar.
								--->
								<form name="form1" action="#CurrentPage#" method="post">
								<table width="100%" border="0" cellspacing="1" cellpadding="1" class="">
									<tr>
										<td class="Titulo"> Seleccionando Anticipos por Trasladar </td>
									</tr>
									<tr>
										<td class="TituloSub"> Socio:&nbsp;<cfoutput>#trim(rsSocio.SNnombre)#&nbsp;&nbsp;#rsSocio.SNnumero#</cfoutput></td>
										<input type="hidden" name="SNcodigo" value="<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cfoutput>#form.SNcodigo#</cfoutput></cfif>">
										<input type="hidden" name="SNnumero" value="<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))><cfoutput>#form.SNnumero#</cfoutput></cfif>">
										<input type="hidden" name="LvarCDCcodigo" value="<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))><cfoutput>#form.CDCcodigo#</cfoutput></cfif>">
									</tr>
									<tr>
										<td class="TituloSub"> Transacci&oacute;n:&nbsp;<cfoutput>#rsTransacciones.CCTdescripcion#</cfoutput></td>
										<input type="hidden" name="CCTcodigo" value="<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))><cfoutput>#form.CCTcodigo#</cfoutput></cfif>">
									</tr>
									<tr>
										<td class="FileLabel" > Seleccione los Anticipos que desea trasladar:  </td>
									</tr>
								</table>
								<!--- 	2.1 Consulta de Adelantos --->							
								<!--- 	3.	El Usuario marca las cajas de selección múltiple correspondientes a los adelantos que 
											desea trasladar y solicita iniciar el traslado al sistema. 
								--->
								<!--- 	3.1 Botón para solicitar adelanto --->
								<cfset Botones = "Trasladar">
								<!--- Validación para que no permita pasar al siguiente paso sin seleccionar ningún item. --->
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
									function funcTrasladar(){
										f = document.form1; 
										if (confirm('Está seguro de trasladar los registros seleccionados?')){
											if (hayseleccionados()){
												//Pura Vida!
												<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
													f.CDCCODIGO.value="<cfoutput>#form.CDCcodigo#</cfoutput>";
												</cfif>
												<cfif isdefined("form.FAX14DOC") and len(trim(form.FAX14DOC))>
													f.FAX14DOC.value="<cfoutput>#trim(form.FAX14DOC)#</cfoutput>";
												</cfif>
												document.form1.action = 'MovAnticiposCC_sql.cfm';
												document.form1.submit();
											} else if (!actionFinished) {
												alert("Se presentaron los siguientes errores:\n-Debe seleccionar al menos un Adelanto.");
												return false;
											} 
											return true;}
										else {
										return false;}
									}
									function funcFiltrar<cfoutput>#form.paso#</cfoutput>(){
										f = document.form1;
										<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
											f.CDCCODIGO.value="<cfoutput>#form.CDCcodigo#</cfoutput>";
										</cfif>
										<cfif isdefined("form.FAX14DOC") and len(trim(form.FAX14DOC))>
											f.FAX14DOC.value="<cfoutput>#trim(form.FAX14DOC)#</cfoutput>";
										</cfif>
										actionFinished = true;
										return true;
									}
									//-->
								</script>
								<!--- Pasa Filtros del Url al Form --->
								<cfif isdefined("url.filtro_FAX14CON") 
										and len(trim(url.filtro_FAX14CON))>
									<cfset form.filtro_FAX14CON = url.filtro_FAX14CON>
								</cfif>
								<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo)) and not isdefined("filtro_CDCnombre")>
									<cfquery name="rsClientes" datasource="#session.DSN#">
										select CDCnombre from ClientesDetallistasCorp
										where CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
									</cfquery>
									<cfset form.filtro_CDCnombre = rsClientes.CDCnombre>
								</cfif>
								
								<cfif isdefined("url.filtro_CDCnombre") 
										and len(trim(url.filtro_CDCnombre))>
									<cfset form.filtro_CDCnombre = url.filtro_CDCnombre>
								</cfif>
								<cfif isdefined("url.filtro_FAX14TDC") 
										and len(trim(url.filtro_FAX14TDC))>
									<cfset form.filtro_FAX14TDC = url.filtro_FAX14TDC>
								</cfif>
								<cfif isdefined("url.filtro_FAX14DOC") 
										and len(trim(url.filtro_FAX14DOC))>
									<cfset form.filtro_FAX14DOC = trim(url.filtro_FAX14DOC)>
								</cfif>
								
								<cfif isdefined("url.filtro_FAX14FEC") 
										and len(trim(url.filtro_FAX14FEC))>
									<cfset form.filtro_FAX14FEC = url.filtro_FAX14FEC>
								</cfif>
								<cfif isdefined("url.filtro_FAX14MON") 
										and len(trim(url.filtro_FAX14MON))>
									<cfset form.filtro_FAX14MON = url.filtro_FAX14MON>
								</cfif>
								<cfif isdefined("url.filtro_SALDO") 
										and len(trim(url.filtro_SALDO))>
									<cfset form.filtro_SALDO = url.filtro_SALDO>
								</cfif>
								<cfif isdefined("url.filtro_FAM01CODD") 
										and len(trim(url.filtro_FAM01CODD))>
									<cfset form.filtro_FAM01CODD = url.filtro_FAM01CODD>
								</cfif>
								<cfif isdefined("url.filtro_Descripcion") 
										and len(trim(url.filtro_Descripcion))>
									<cfset form.filtro_Descripcion = trim(url.filtro_Descripcion)>
								</cfif>
								<!--- Agrega Filtros a la Navegación --->
								<cfif isdefined("form.filtro_FAX14CON") 
										and len(trim(form.filtro_FAX14CON))>
									<cfset nav = nav & "&filtro_FAX14CON=" & form.filtro_FAX14CON>
								</cfif>
								<cfif isdefined("form.filtro_CDCnombre") 
										and len(trim(form.filtro_CDCnombre))>
									<cfset nav = nav & "&filtro_CDCnombre=" & form.filtro_CDCnombre>
								</cfif>
								<cfif isdefined("form.filtro_FAX14TDC") 
										and len(trim(form.filtro_FAX14TDC))>
									<cfset nav = nav & "&filtro_FAX14TDC=" & form.filtro_FAX14TDC>
								</cfif>
								<cfif isdefined("form.filtro_FAX14DOC") 
										and len(trim(form.filtro_FAX14DOC))>
									<cfset nav = nav & "&filtro_FAX14DOC=" & trim(form.filtro_FAX14DOC)>
								</cfif>
								<cfif isdefined("form.filtro_FAX14FEC") 
										and len(trim(form.filtro_FAX14FEC))>
									<cfset nav = nav & "&filtro_FAX14FEC=" & form.filtro_FAX14FEC>
								</cfif>
								<cfif isdefined("form.filtro_FAX14MON") 
										and len(trim(form.filtro_FAX14MON))>
									<cfset nav = nav & "&filtro_FAX14MON=" & form.filtro_FAX14MON>
								</cfif>
								<cfif isdefined("form.filtro_SALDO") 
										and len(trim(form.filtro_SALDO))>
									<cfset nav = nav & "&filtro_SALDO=" & form.filtro_SALDO>
								</cfif>
								<cfif isdefined("form.filtro_FAM01CODD") 
										and len(trim(form.filtro_FAM01CODD))>
									<cfset nav = nav & "&filtro_FAM01CODD=" & form.filtro_FAM01CODD>
								</cfif>
								<cfif isdefined("form.filtro_Descripcion") 
										and len(trim(form.filtro_Descripcion))>
									<cfset nav = nav & "&filtro_Descripcion=" & form.filtro_Descripcion>
								</cfif>									
								<!--- 	2.2, 3.2 Lista de Adelantos c/ Botón de Trasladar. --->
								
								<!--- <cfparam name="form.CDCcodigo" type="integer"> --->
								<cfset filtro = "">
								<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo)) and not isdefined("filtro_FAX14DOC")>
									<cfset filtro="and FAX014.CDCcodigo = #form.CDCcodigo#">
								</cfif>
								<cfif isdefined("form.FAX14DOC") and len(trim(form.FAX14DOC)) and not isdefined("filtro_FAX14DOC")>
									<cfset filtro="and rtrim(ltrim(upper(FAX014.FAX14DOC))) like '%#trim(Ucase(form.FAX14DOC))#%'">
								</cfif>
								<cfif isdefined("url.FAX14DOC") 
										and len(trim(url.FAX14DOC)) and not isdefined("form.filtro_FAX14DOC")>
									<cfset form.filtro_FAX14DOC = trim(url.FAX14DOC)>
								</cfif>
								<cfif isdefined("Form.FAX14DOC") and len(trim(Form.FAX14DOC)) and not isdefined("form.filtro_FAX14DOC")>
									<cfset form.filtro_FAX14DOC = trim(Form.FAX14DOC)>
								</cfif>
								<cfinvoke 
									component="sif.Componentes.pListas" method="pLista" returnvariable="pLista"
									desplegar="CDCnombre, FAX14DOC, FAX14FEC, FAX14MON, FAX14MAP, Saldo"
									etiquetas="Cliente, Documento, Fecha, Monto, Monto Aplicado, Saldo"
									align="left, left, center, left, left, left" 
									formatos="S, S, D, M, M, M"
									checkboxes="S" 
									keys="FAX14CON, CDCcodigo" 
									botones="#Botones#" 
									showlink="false"
									formname="form1"
									incluyeform="false"
									ira="MovAnticiposCC_sql.cfm" 
									navegacion="#nav#" 
									pageindex="#form.paso#" 
									mostrar_filtro="true" 
									filtrar_automatico="true"
									columnas="ClientesDetallistasCorp.CDCnombre, ClientesDetallistasCorp.CDCidentificacion, FAX014.FAX14DOC, FAX014.FAX14FEC, FAX014.FAX14MON, FAX014.FAX14MAP, FAX014.FAX14MON - FAX014.FAX14MAP as Saldo, FAX014.CDCcodigo, FAX14CON"
									cortes="CDCnombre, CDCidentificacion"
									filtrar_por="ClientesDetallistasCorp.CDCnombre, FAX014.FAX14DOC, FAX014.FAX14FEC, FAX014.FAX14MON, FAX014.FAX14MAP, FAX014.FAX14MON - FAX014.FAX14MAP" 
									tabla = "FAX014
												inner join ClientesDetallistasCorp
														on ClientesDetallistasCorp.CDCcodigo = FAX014.CDCcodigo"
									filtro = "FAX014.FAX14MON > FAX014.FAX14MAP
									
									#filtro#
									and FAX014.FAX14CLA = '2'
									and FAX014.FAX14TDC = 'AD'
									and FAX014.FAX14STS = '1'"
									/>
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