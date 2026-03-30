<!--- Ponga el código de su pantalla aquí --->
<!--- 	Movimiento de Adelantos
		Este proceso permite trasladar uno o más adelantos realizados por un cliente a otro. 
		El Proceso se realiza de la siguiente manera:
		1.	El Usuario ingresa el cliente origen (cliente que tiene el adelanto registrado actualmente) y solicita al sistema la lista 
			de adelantos de dicho cliente.
		2.	El Sistema le muestra la lista de adelantos del cliente con cajas de selección múltiple para marcar los adelantos que se
			desea trasladar a otro cliente.
		3.	El Usuario marca las cajas de selección múltiple correspondientes a los adelantos que desea trasladar y solicita iniciar el 
			traslado al sistema.
		4.	El sistema muestra una lista resumen de los adelantos marcados, y solicita al usuario el cliente destino (cliente a quien se
			le quiere traspasar los adelantos), y solicita que autorice el traslado (botón de aplicar).
		5.	El cliente ingresa el cliente destino, el motivo de traslado, y le pide al sistema aplicar la transacción de traslado (***el
			sistema debe solicitar confirmación al usuario ***).
		6.	El Sistema Realiza la transacción.
		7.	El Sistema informa los resultados del proceso, de ser exitosos, debe mostrar un resumen del traslado realizado. De lo 
			contrario debe mostrar el error.
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
						<cfelseif isdefined("form.CDCcodigo") 
								and len(trim(form.CDCcodigo))
								and not isdefined("form.paso")>
							<cfset nav = nav&"&CDCcodigo=#form.CDCcodigo#">
							<cfset form.paso = 2>
						<cfelse>
							<cfset form.paso = 1>
						</cfif>
						<cfif paso GT 1>
							<cfquery name="rsCliente" datasource="#session.dsn#">
								select CDCnombre
								from ClientesDetallistasCorp 
								where 	CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
									and CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
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
						<!--- Pinta 4 Pantallas, depende de la variable paso. --->
						<cfswitch expression="#form.paso#">
							<!--- Pantalla 1: Selección del Cliente Origen --->
							<cfcase value="1">
								<!--- 
										1.	El Usuario ingresa el cliente origen (cliente que tiene el adelanto registrado 	
											actualmente) y solicita al sistema la lista de adelantos de dicho cliente.
								--->
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
									<tr>
										<td class="TituloSub"> Cliente Origen para el Traslado </td>
									</tr>
									<tr>
										<td class="FileLabel" > Seleccione un Cliente para realizar el Adelanto:  </td>
									</tr>
								</table>
								<table width="100%" border="0" cellspacing="3" cellpadding="3">
									<tr>
										<td>
											<cfoutput>
												<form action="#CurrentPage#" method="post" name="form1" style="margin:0">
													<table width="100%" border="0" cellspacing="0" cellpadding="0" 
															class="" style="margin:0">
														<tr>
															<td nowrap="nowrap" class="fileLabel">
																Cliente Origen:&nbsp;
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
											</cfoutput>
										</td>
									</tr>
								</table>
								<script language="javascript" type="text/javascript">
									<!--//
									function funcTraeAdelantos(){
										if (document.form1.CDCcodigo.value==''){
											alert("Se presentaron los siguientes errores:\n-El Cliente Origen es requerido.");
											return false;
										}
										return true;
									}
									//-->
								</script>
							</cfcase>
							<!--- Pantalla 2: Selección de los Adelantos del Cliente Origen --->
							<cfcase value="2">
								<!--- 
										2.	El Sistema le muestra la lista de adelantos del cliente con cajas de selección múltiple 
											para marcar los adelantos que se desea trasladar a otro cliente.
								--->
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
									<tr>
										<td class="Titulo"> Seleccionando Adelantos por Trasladar </td>
									</tr>
									<tr>
										<td class="TituloSub"> Cliente Origen: <cfoutput>#rsCliente.CDCnombre#</cfoutput> </td>
									</tr>
									<tr>
										<td class="FileLabel" > Seleccione los Adelantos que desea trasladar:  </td>
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
										if (hayseleccionados()){
											//Pura Vida!
											f.CDCCODIGO.value="<cfoutput>#form.CDCcodigo#</cfoutput>";
										} else if (!actionFinished) {
											alert("Se presentaron los siguientes errores:\n-Debe seleccionar al menos un Adelanto.");
											return false;
										}
										return true;
									}
									function funcFiltrar<cfoutput>#form.paso#</cfoutput>(){
										f = document.form1;
										f.CDCCODIGO.value="<cfoutput>#form.CDCcodigo#</cfoutput>";
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
								<cfif isdefined("url.filtro_FAX14TDC") 
										and len(trim(url.filtro_FAX14TDC))>
									<cfset form.filtro_FAX14TDC = url.filtro_FAX14TDC>
								</cfif>
								<cfif isdefined("url.filtro_FAX14DOC") 
										and len(trim(url.filtro_FAX14DOC))>
									<cfset form.filtro_FAX14DOC = url.filtro_FAX14DOC>
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
									<cfset form.filtro_Descripcion = url.filtro_Descripcion>
								</cfif>
								<!--- Agrega Filtros a la Navegación --->
								<cfif isdefined("form.filtro_FAX14CON") 
										and len(trim(form.filtro_FAX14CON))>
									<cfset nav = nav & "&filtro_FAX14CON=" & form.filtro_FAX14CON>
								</cfif>
								<cfif isdefined("form.filtro_FAX14TDC") 
										and len(trim(form.filtro_FAX14TDC))>
									<cfset nav = nav & "&filtro_FAX14TDC=" & form.filtro_FAX14TDC>
								</cfif>
								<cfif isdefined("form.filtro_FAX14DOC") 
										and len(trim(form.filtro_FAX14DOC))>
									<cfset nav = nav & "&filtro_FAX14DOC=" & form.filtro_FAX14DOC>
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
								<cfparam name="form.CDCcodigo" type="integer">
								<cfinvoke 
									component="sif.Componentes.pListas" method="pLista" returnvariable="pLista"
									desplegar="FAX14CON, FAX14TDC, FAX14DOC, FAX14FEC, FAM01CODD, TransExterna, FAX14MON, SALDO, 
											Descripcion"
									etiquetas="Consecutivo, Tipo, No. Doc., Fecha, Caja, T.Ext., Monto, Saldo, Descripci&oacute;n"
									align="left, left, left, center, left, left, right, right, left" 
									formatos="S, S, S, D, S, S, M, M, S"
									checkboxes="S" keys="FAX14CON" botones="#Botones#" showlink="false" formname="form1"
									ira="#CurrentPage#" navegacion="#nav#" pageindex="#form.paso#" mostrar_filtro="true" 
									filtrar_automatico="true"
									columnas="Mnombre, CDCcodigo, FAX14CON, FAX14TDC, FAX14DOC, FAX14FEC, FAX14MON, FAX14MON-FAX14MAP AS SALDO,
											FAM01CODD, TransExterna, '&nbsp;&nbsp;' #_Cat# FATiposAdelanto.Descripcion as Descripcion"
									cortes="Mnombre"
									filtrar_por="FAX14CON, FAX14TDC, FAX14DOC, FAX14FEC, FAM01CODD, TransExterna, FAX14MON, 
											FAX14MON-FAX14MAP, Descripcion" 
									tabla="FAX014
										inner join FAM001
											on FAM001.Ecodigo = FAX014.Ecodigo
											and FAM001.FAM01COD = FAX014.FAM01COD
										inner join FATiposAdelanto
											on FATiposAdelanto.Ecodigo = FAX014.Ecodigo
											and FATiposAdelanto.IdTipoAd = FAX014.IdTipoAd
										inner join Monedas
											on Monedas.Mcodigo = FAX014.Mcodigo" 
									filtro="FAX014.Ecodigo = #session.Ecodigo#
										and FAX014.CDCcodigo = #form.CDCcodigo#
										and FAX014.FAX14TDC in ('NC', 'AD')
										and FAX014.FAX14STS = '1'
										and FAX014.FAX14CLA in ('1','2')
										and FAX014.FAX14MAP = 0
										order by Mnombre, FAX14FEC"
									/>
								<cfoutput>
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
							<!--- Pantalla 3: Selección del Cliente Destino y otros valores --->
							<cfcase value="3">
								<!---	4.	El sistema muestra una lista resumen de los adelantos marcados, y solicita al usuario el 
											cliente destino(cliente a quien se le quiere traspasar los adelantos), y solicita que 
											autorice el traslado (botón de aplicar).
								--->
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
									<tr>
										<td class="Titulo"> 
											Confirmando Adelantos por Trasladar 
										</td>
									</tr>
									<tr>
										<td class="TituloSub"> 
											Cliente Origen: <cfoutput>#rsCliente.CDCnombre#</cfoutput> 
										</td>
									</tr>
									<tr>
										<td class="FileLabel" > 
											Verifique los Adelantos que desea trasladar y defina el Motivo de traslado: 
										</td>
									</tr>
								</table>
								<!--- 	4.1 Consulta de Adelantos --->
								<cfquery name="rsLista" datasource="#session.dsn#">
									select Mnombre, CDCcodigo, FAX14CON, FAX14TDC, FAX14DOC, FAX14FEC, 
											FAX14MON, FAX14MON-FAX14MAP AS SALDO, FAM01CODD, TransExterna, 
											'&nbsp;&nbsp;' #_Cat# FATiposAdelanto.Descripcion as Descripcion
									from 	FAX014
									inner join FAM001
										on FAM001.Ecodigo = FAX014.Ecodigo
										and FAM001.FAM01COD = FAX014.FAM01COD
									inner join FATiposAdelanto
										on FATiposAdelanto.Ecodigo = FAX014.Ecodigo
										and FATiposAdelanto.IdTipoAd = FAX014.IdTipoAd
									inner join Monedas
											on Monedas.Mcodigo = FAX014.Mcodigo
									where   FAX014.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and FAX014.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
										and FAX014.FAX14CON in (<cfqueryparam cfsqltype="cf_sql_numeric" 
												value="#form.chk#" list="yes">)
										and FAX014.FAX14TDC in ('NC', 'AD')
										and FAX014.FAX14STS = '1'
										and FAX014.FAX14CLA in ('1','2')
										and FAX014.FAX14MAP = 0
									order by Mnombre, FAX14FEC
								</cfquery>
								<div style=" width:100%; height:200px; overflow:auto; margin:0px; ">
									<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pLista"
										query="#rsLista#" 
										desplegar="FAX14CON, FAX14TDC, FAX14DOC, FAX14FEC, FAM01CODD, TransExterna, FAX14MON, 
												SALDO, Descripcion"
										cortes="Mnombre"
										etiquetas="Consecutivo, Tipo, No. Doc., Fecha, Caja, T.Ext., Monto, Saldo, Descripci&oacute;n"
										align="left, left, left, center, left, left, right, right, left" 
										formatos="S, S, S, D, S, S, M, M, S"
										showlink="false" formname="form1" pageindex="#form.paso#"/>
								</div>
								<cfoutput>
									<!--- 	5.	El cliente ingresa el cliente destino, el motivo de traslado, y le pide al sistema 
												aplicar la transacción de traslado (***el sistema debe solicitar confirmación al 
												usuario, y el usuario debe confirmar antes de proceder con el proceso***).
									--->
									<form action="#CurrentPage#" method="post" name="form2">
										<input type="hidden" name="CDCcodigo" value="#form.CDCcodigo#"/>
										<input type="hidden" name="FAX14CONLIST" value="#form.chk#"/>
										<fieldset><legend><h3>Trasladar Adelantos A:</h3></legend>
											<table width="100%" border="0" cellspacing="2" cellpadding="2">
												<tr>
													<td class="fileLabel" nowrap="nowrap" width="1%">
														Cliente Destino:
													</td>
													<td >
														<cf_sifClienteDetCorp CDCcodigo="CDCcodigoDest" form='form2'>
													</td>
												</tr>
												<tr>											
													<td class="fileLabel" nowrap="nowrap" width="1%">
														Motivo:
													</td>
													<td>
														<input type="text" name="FABMotivo" size="75" maxlength="80"/>
													</td>
												</tr>
												<tr>
													<td class="fileLabel" nowrap="nowrap" width="1%">
														T. Ext. Destino:
													</td>
													<td width="100%">
														<table width="100%" border="0" cellspacing="0" cellpadding="0">
															<tr>
																<td>
																	<input type="text" name="TransExterna" size="10" maxlength="10"/>
																</td>
																<td width="100%">
																	&nbsp;&nbsp;&nbsp;&nbsp;
																	(Transacci&oacute;n externa asociada a los adelantos destino)
																</td>
															</tr>
														</table>												
													</td>
												</tr>
											</table>
										</fieldset>
										<cf_botones values="Regresar, Aplicar">
									</form>
								</cfoutput>
								<script language="javascript" type="text/javascript">
									<!--//
									document.form2.FABMotivo.focus();
									function funcAplicar(){
										lerror = "";
										if (document.form2.CDCcodigoDest.value==''){
											lerror = lerror + "-El Cliente Destino es requerido.\n";
										}
										/* Un Mismo Cliente Puede Requerir Realizar este proceso para cambiar la Transacción Externa
										if (document.form2.CDCcodigoDest.value==document.form2.CDCcodigo.value){
											lerror = lerror + "-El Cliente Destino debe ser diferente del Cliente Origen.\n";
										}*/
										if (document.form2.FABMotivo.value==''){
											lerror = lerror + "-El Motivo es requerido.\n";
										}
										if (lerror!='') {
											alert("Se presentaron los siguientes errores:\n"+lerror);
											return false;
										}
										if (!confirm("Confirma que desea realizar el traslado de los adelantos en este momento?")){
											return false;
										}
										<!--- 	6.	El Sistema Realiza la transacción. 
										--->
										document.form2.action = "opmovad-sql.cfm";
										return true;
									}
									//-->										
								</script>
							</cfcase>
							<!--- Pantalla 4: Reporte del Proceso Realizado --->
							<cfcase value="4">
								<!--- 	7.	El Sistema informa los resultados del proceso, de ser exitosos, debe mostrar un resumen 
											del traslado realizado. De lo contrario debe mostrar el error.
								--->
								<cfif not isdefined("url.Impresion")>
									<cf_rhimprime datos="/sif/pv/operacion/opmovad-form.cfm" paramsuri="&CDCcodigo=#form.CDCcodigo#&paso=#form.paso#&FABTrasladoAdidList=#url.FABTrasladoAdidList#&Impresion=1"> 								
								<cfelse>
									<br />
								</cfif>
								<table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
									<tr>
										<td class="Titulo"> Traslado de Adelantos Confirmado </td>
									</tr>
									<tr>
										<td class="Titulo"> Cliente Origen: <cfoutput>#rsCliente.CDCnombre#</cfoutput> </td>
									</tr>
									<tr>
										<td class="Titulo"> Cliente Destino: <cfoutput>#rsClienteDest.CDCnombre#</cfoutput> </td>
									</tr>
									<tr>
										<td class="TituloSub"> Motivo: <cfoutput>#rsFABTAd.FABMotivo#</cfoutput>  </td>
									</tr>
									<tr>
										<td class="FileLabel" > 
											Los Adelantos abajo indicados fueron trasladados con &eacute;xito! 
										</td>
									</tr>
								</table>
								<!--- 	7.1 Consulta de Adelantos --->
								<cfquery name="rsLista" datasource="#session.dsn#">
									select Mnombre, CDCcodigo, FAX14CON, FAX14TDC, FAX14DOC, 
									FAX14FEC, FAX14MON, FAX14MON-FAX14MAP AS SALDO, FAM01CODD, 
									TransExterna, '&nbsp;&nbsp;' #_Cat# FATiposAdelanto.Descripcion as Descripcion
									from 	FAX014
									inner join FAM001
										on FAM001.Ecodigo = FAX014.Ecodigo
										and FAM001.FAM01COD = FAX014.FAM01COD
									inner join FATiposAdelanto
										on FATiposAdelanto.Ecodigo = FAX014.Ecodigo
										and FATiposAdelanto.IdTipoAd = FAX014.IdTipoAd
									inner join FABitacoraTrasladoAd
										on FABitacoraTrasladoAd.Ecodigo = FAX014.Ecodigo
										and FABitacoraTrasladoAd.CDCcodigoDest = FAX014.CDCcodigo
										and FABitacoraTrasladoAd.FAX14CONDest = FAX014.FAX14CON
										and FABTrasladoAdid in (<cfqueryparam cfsqltype="cf_sql_numeric" 
												value="#url.FABTrasladoAdidList#" list="yes">)
									inner join Monedas
											on Monedas.Mcodigo = FAX014.Mcodigo
									where   FAX014.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and FAX014.FAX14TDC in ('NC', 'AD')
										and FAX014.FAX14STS = '1'
										and FAX014.FAX14CLA in ('1','2')
										and FAX014.FAX14MAP = 0
									order by Mnombre, FAX14FEC
								</cfquery>
								<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pLista"
									query="#rsLista#" desplegar="FAX14CON, FAX14TDC, FAX14DOC, FAX14FEC, FAM01CODD, TransExterna, 
										FAX14MON, SALDO, Descripcion"
									etiquetas="Consecutivo, Tipo, No. Doc., Fecha, Caja, T.Ext., Monto, Saldo, Descripci&oacute;n"
									cortes="Mnombre"
									align="left, left, left, center, left, left, right, right, left" 
									formatos="S, S, S, D, S, S, M, M, S"
									showlink="false" formname="form1" pageindex="#form.paso#"/>
								<cfif not isdefined("url.Impresion")>
									<cfoutput>
										<table width="100%" border="0" cellspacing="3" cellpadding="3">
											<tr>
												<td>
													<form action="#CurrentPage#" method="post" name="form2">
														<cf_botones values="Terminar">
													</form>
												</td>
											</tr>
										</table>
									</cfoutput>
								<cfelse>
									<br />
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td align="center"> --- Fin del Reporte --- </td>
										</tr>
									</table>
									<br />
								</cfif>
							</cfcase>
						</cfswitch>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>