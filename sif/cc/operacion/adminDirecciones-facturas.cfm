<!--- NAVEGACION --->
<cfif isdefined("url.fSNcodigo") and not isdefined("form.fSNcodigo")>
	<cfset form.fSNcodigo = url.fSNcodigo >
</cfif>
<cfif isdefined("url.fDdocumento") and not isdefined("form.fDdocumento")>
	<cfset form.fDdocumento = url.fDdocumento >
</cfif>
<cfif isdefined("url.fCCTcodigo") and not isdefined("form.fCCTcodigo")>
	<cfset form.fCCTcodigo = url.fCCTcodigo >
</cfif>
<cfif isdefined("url.fid_direccion") and not isdefined("form.fid_direccion")>
	<cfset form.fid_direccion = url.fid_direccion >
</cfif>
<cfif isdefined("url.fDfechadesde") and not isdefined("form.fDfechadesde")>
	<cfset form.fDfechadesde = url.fDfechadesde >
</cfif>
<cfif isdefined("url.fDfechahasta") and not isdefined("form.fDfechahasta")>
	<cfset form.fDfechahasta = url.fDfechahasta >
</cfif>
<cfif isdefined("url.fDusuario") and not isdefined("form.fDusuario")>
	<cfset form.fDusuario = url.fDusuario >
</cfif>

<cf_templateheader title="SIF - Cuentas por Cobrar">
	
		<cfquery name="rsPeriodo" datasource="#session.DSN#">
			select Pvalor 
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 50
		</cfquery>
		<cfquery name="rsMes" datasource="#session.DSN#">
			select Pvalor 
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 60
		</cfquery>
		<cfset vDias = daysinmonth(createdate(rsperiodo.pvalor,rsmes.pvalor, 01)) >

	<cfif len(trim(form.fDfechadesde)) eq 0>
		<cfset vDfechadesde = createdate(rsPeriodo.Pvalor, rsmes.Pvalor, 01)>
	<cfelse>
		<cfset vDfechadesde = LSParsedatetime(form.fDfechadesde) >
	</cfif>
	<cfif len(trim(form.fDfechahasta)) eq 0>
		<cfset vDfechahasta = createdate(rsPeriodo.Pvalor, rsmes.pvalor, vDias)>
	<cfelse>
		<cfset vDfechahasta = LSParsedatetime(form.fDfechahasta) >
	</cfif>
	
	<cfif vDfechadesde gt vDfechahasta>
		<cfset tmp = vDfechadesde>
		<cfset vDfechadesde = vDfechahasta >
		<cfset vDfechahasta = tmp >	
	</cfif>

	<cfquery name="rsSocio" datasource="#session.DSN#">
		select SNnumero, SNnombre
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fSNcodigo#">
	</cfquery>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cambiar Direcciones'>
		<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
							<tr><td>&nbsp;</td></tr>
							
							<tr><td>
									<cfset vId = '' >
									<cfif isdefined("form.fSNcodigo") and len(trim(form.fSNcodigo))>
										<cfset vId = form.fSNcodigo >
									</cfif>
									<form name="form1" method="post" action="adminDirecciones-facturas.cfm" >
									<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
										<tr>
											<td nowrap="nowrap" width="1%"><strong>Socio de Negocios:</strong></td>
											<td width="1%"><cf_sifsociosnegocios2 idquery="#vId#" SNcodigo="fSNcodigo" tabindex="1"></td>
											<td nowrap="nowrap" width="1%"><strong>Direcci&oacute;n:</strong></td>
											<td width="1%">
												<select style="width:347px" name="fid_direccion" id="fid_direccion" tabindex="2">
													<cfif isdefined("form.fSNcodigo") and len(trim(form.fSNcodigo))>
														<cfquery name="data_direcciones" datasource="#session.DSN#">
															select b.id_direccion, coalesce(c.direccion1, c.direccion2) as direccion
															from SNegocios a
																join SNDirecciones b
																	on a.SNid = b.SNid
																join DireccionesSIF c
																	on c.id_direccion = b.id_direccion
															where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
															  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fSNcodigo#"> 
														</cfquery>
														<option value="">-Todos-</option>
														<cfloop query="data_direcciones">
															<option value="#data_direcciones.id_direccion#" <cfif isdefined("form.fid_direccion") and form.fid_direccion eq data_direcciones.id_direccion >selected="selected"</cfif>>#data_direcciones.direccion#</option>
														</cfloop>
													</cfif>
												</select>
											</td>
										</tr>
										<tr>
											<td nowrap="nowrap" width="1%"><strong>Documento:</strong></td>
											<td width="1%"><input type="text" name="fDdocumento" value="<cfif isdefined('form.fDdocumento')>#trim(form.fDdocumento)#</cfif>"></td>
											<td nowrap="nowrap" width="1%"><strong>Tipo de Transacci&oacute;n:</strong></td>
											<td width="1%">
												<cfquery name="rsTipoTran" datasource="#session.DSN#">
													select CCTcodigo, CCTdescripcion
													from CCTransacciones
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												</cfquery>
												<select  name="fCCTcodigo" id="fCCTcodigo" tabindex="2">
													<option value="">- Todos -</option>
													<cfloop query="rsTipoTran">
														<option value="#rsTipoTran.CCTcodigo#" <cfif isdefined("form.fCCTcodigo") and form.fCCTcodigo eq rsTipoTran.CCTcodigo >selected="selected"</cfif>>#trim(rsTipoTran.CCTcodigo)# - #HTMLEditFormat(rsTipoTran.CCTdescripcion)#</option>
													</cfloop>
												</select>
											</td>
										</tr>
										<tr>
											<td nowrap="nowrap" width="1%"><strong>Fecha desde:</strong></td>
											<td><cf_sifcalendario name="fDfechadesde" value="01/#repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#/#rsPeriodo.Pvalor#"></td>
											<td nowrap="nowrap" width="1%"><strong>Fecha hasta:</strong></td>
											<td><cf_sifcalendario name="fDfechahasta" value="#vDias#/#repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#/#rsPeriodo.Pvalor#" ></td>
										</tr>
										
										<cfquery name="rsusuario" datasource="#session.DSN#" >
											select distinct Dusuario
											from Documentos a
											where a.Dsaldo=a.Dtotal		<!--- solo documentos sin transacciones aplicadas --->
												and a.Dtotal > 0
											order by Dusuario
										</cfquery>										
										<tr>
											<td ><strong>Usuario:</strong></td>
											<td >
												<select name="fDusuario">
													<option value="" >-Todos-</option>
													<cfloop query="rsusuario">
														<option value="#rsusuario.Dusuario#" <cfif isdefined("form.fDusuario") and form.fDusuario eq rsusuario.Dusuario >selected="selected"</cfif> >#rsusuario.Dusuario#</option>
													</cfloop>
												</select>
											</td>
											<td colspan="2" ><input class="btnFiltrar" type="submit" name="btnTraerDocumentos" value="Traer Documentos" maxlength="20" size="25"></td>
										</tr>
									</table>
										<input type="hidden" name="dia_inicio" value="#rsPeriodo.Pvalor##repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#01" />
										<input name="dia_final" type="hidden" value="#rsPeriodo.Pvalor##repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor##vDias#" />
										<input type="hidden" name="tdia_inicio" value="01/#repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#/#rsPeriodo.Pvalor#" />
										<input type="hidden" name="tdia_final" value="#vDias#/#repeatstring('0', 2-len(rsMes.Pvalor) )##rsMes.Pvalor#/#rsPeriodo.Pvalor#" />
									</form>
							
							</td></tr>
			

							<!---
							<tr><td style="padding:2px;"><strong>Proceso para cambiar direcciones a documentos</strong></td></tr>
							<tr><td style="padding:2px;"><strong>Socio de Negocios:</strong> #rsSocio.SNnumero# - #rsSocio.SNnombre#</td></tr>
							<tr><td style="padding:2px;"><strong>Rango de Fechas:</strong> #LSDateformat(vDfechadesde, 'dd/mm/yyyy')# al #LSDateformat(vDfechahasta,'dd/mm/yyyy')#</td></tr>
							--->
							<tr><td>&nbsp;</td></tr>							
							<tr>
								<td valign="top">
										<cfset navegacion = '' >
										<cfset campos_extra = '' >
										<!--- NAVEGACION --->
										<cfif isdefined("form.fSNcodigo")>
											<cfset navegacion = navegacion & "&fSNcodigo=#form.fSNcodigo#" >
											<cfset campos_extra = campos_extra & ",'#form.fSNcodigo#' as fSNcodigo" >
										</cfif>
										<cfif isdefined("form.fDdocumento")>
											<cfset navegacion = navegacion & "&fDdocumento=#form.fDdocumento#" >
											<cfset campos_extra = campos_extra & ",'#form.fDdocumento#' as fDdocumento" >
										</cfif>
										<cfif isdefined("form.fCCTcodigo")>
											<cfset navegacion = navegacion & "&fCCTcodigo=#form.fCCTcodigo#" >
											<cfset campos_extra = campos_extra & ",'#form.fCCTcodigo#' as fCCTcodigo" >
										</cfif>
										<cfif isdefined("form.fid_direccion")>
											<cfset navegacion = navegacion & "&fid_direccion=#form.fid_direccion#" >	
											<cfset campos_extra = campos_extra & ",'#form.fid_direccion#' as fid_direccion" >
										</cfif>
										<cfif isdefined("form.fDfechadesde")>
											<cfset navegacion = navegacion & "&fDfechadesde=#LSDateFormat(vDfechadesde,'dd/mm/yyyy')#" >
											<cfset tmp = LSDateFormat(vDfechadesde,'dd/mm/yyyy') >	
											<cfset campos_extra = campos_extra & ",'#tmp#' as fDfechadesde" >
										</cfif>
										<cfif isdefined("form.fDfechahasta")>
											<cfset navegacion = navegacion & "&fDfechahasta=#LSDateFormat(vDfechahasta,'dd/mm/yyyy')#" >
											<cfset tmp = LSDateFormat(vDfechahasta,'dd/mm/yyyy') >	
											<cfset campos_extra = campos_extra & ",'#tmp#' as fDfechahasta" >
										</cfif>
										<cfif isdefined("form.fDusuario")>
											<cfset navegacion = navegacion & "&fDusuario=#form.fDusuario#" >
											<cfset campos_extra = campos_extra & ",'#form.fDusuario#' as fDusuario" >
										</cfif>
										<cfinclude template="../../Utiles/sifConcat.cfm">
										<cfquery name="data" datasource="#session.DSN#">
											select 	a.CCTcodigo,
													a.CCTcodigo #_Cat# ' - '#_Cat# b.CCTdescripcion as CCTcodigodesc,
													a.Ddocumento, 
													a.SNcodigo, 
													a.Mcodigo,
													c.Miso4217,
													c.Mnombre, 
													a.Dtotal, 
													a.Dfecha, 
													a.id_direccionFact, 
													'Dirección: '#_Cat#coalesce((	select coalesce( coalesce(c.direccion1, c.direccion2), 'Sin definir')
														from DireccionesSIF c
														where c.id_direccion = a.id_direccionFact), 'Sin definir') as direccionFact,
													a.id_direccionEnvio,
													(	select c.direccion1 #_Cat# ' / ' #_Cat# c.direccion2
														from DireccionesSIF c
														where c.id_direccion = a.id_direccionEnvio) as direccionEnvio,
														Dusuario
														#preservesinglequotes(campos_extra)#
											from Documentos a
											
											inner join CCTransacciones b
											on b.Ecodigo=a.Ecodigo
											and b.CCTcodigo=a.CCTcodigo
											
											inner join Monedas c
											on c.Mcodigo=a.Mcodigo
											
											where a.Dsaldo=a.Dtotal		<!--- solo documentos sin transacciones aplicadas --->
												and a.Dtotal > 0
												and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fSNcodigo#">
												
												<cfif isdefined("form.fDusuario") and len(trim(form.fDusuario)) >
													and a.Dusuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fDusuario#">
												</cfif>
										
												<cfif isdefined("form.fCCTcodigo") and len(trim(form.fCCTcodigo))>
													and a.CCTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fCCTcodigo#">
												</cfif>
												<cfif isdefined("form.fDdocumento") and len(trim(form.fDdocumento))>
													and a.Ddocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fDdocumento#">
												</cfif>
												<cfif isdefined("form.fid_direccion") and len(trim(form.fid_direccion))>
													and a.id_direccionFact = #form.fid_direccion# 
												</cfif>
										
												and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#vDfechadesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#vDfechahasta#">
											
											order by direccionFact, a.CCTcodigo, a.Dfecha, a.Ddocumento
										</cfquery>

										<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#data#"/>
											<cfinvokeargument name="desplegar" value="CCTcodigodesc,Ddocumento,Dfecha,Dusuario,Dtotal"/>
											<cfinvokeargument name="etiquetas" value="Tipo, Documento, Fecha,Usuario, Monto"/>
											<cfinvokeargument name="formatos" value="V,V,D,V,M"/>
											<cfinvokeargument name="align" value="left,left,left,left,right"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="irA" value="adminDirecciones-modificar.cfm"/>
											<cfinvokeargument name="keys" value="CCTcodigo,Ddocumento,Mcodigo"/>
											<cfinvokeargument name="showemptylistmsg" value="true"/>
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="cortes" value="direccionFact"/>
										</cfinvoke><br />
								</td>
							</tr>
						</table>
				</td>
			</tr>	
		</table>
		</cfoutput>	
		<cf_web_portlet_end>
		<iframe id="fr_direccion" name="fr_direccion" style="visibility:hidden;" width="0" height="0" frameborder="0" src=""></iframe>
		
		<script type="text/javascript" language="javascript1.2">
			window.document.form1.SNnumero.onblur = prueba;

			function funcSNnumero(){
				//document.getElementById('fr_direccion').src = 'adminDirecciones-direccion.cfm?SNcodigo='+document.form1.fSNcodigo.value;
				
				<cfset params = '' >
				<cfif isdefined("form.fDdocumento")>
					<cfset params = params & "&fDdocumento=#form.fDdocumento#" >
				</cfif>
				<cfif isdefined("form.fCCTcodigo")>
					<cfset params = params & "&fCCTcodigo=#form.fCCTcodigo#" >
				</cfif>
				<cfif isdefined("form.fid_direccion")>
					<cfset params = params & "&fid_direccion=#form.fid_direccion#" >	
				</cfif>
				<cfif isdefined("form.fDfechadesde")>
					<cfset params = params & "&fDfechadesde=#LSDateFormat(vDfechadesde,'dd/mm/yyyy')#" >
				</cfif>
				<cfif isdefined("form.fDfechahasta")>
					<cfset params = params & "&fDfechahasta=#LSDateFormat(vDfechahasta,'dd/mm/yyyy')#" >
				</cfif>
				<cfif isdefined("form.fDusuario")>
					<cfset params = params & "&fDusuario=#form.fDusuario#" >
				</cfif>
				
				
				if (document.form1.fSNcodigo.value == ''){
					location.href = '/cfmx/sif/cc/operacion/adminDirecciones-lista.cfm';
				}
				else{
					location.href = '/cfmx/sif/cc/operacion/adminDirecciones-facturas.cfm?dummy=ok&fSNcodigo='+document.form1.fSNcodigo.value+'<cfoutput>#params#</cfoutput>';
				}
			}
			
			function prueba(){ 
				if (document.form1.SNnumero.value == ''){
					location.href = '/cfmx/sif/cc/operacion/adminDirecciones-lista.cfm';
				}
				else{
					TraeSociofSNcodigo(document.form1.SNnumero.value);
				}
			 }
			 
			function validafecha(fecha){
				var vFecha = fecha.split('/');
				var sFecha = vFecha[2] + vFecha[1] + vFecha[0]

				if ( sFecha > document.form1.dia_final.value || sFecha < document.form1.dia_inicio.value){
					return true;	
				}
				return false;
			}
			function validafechadesde(){
				if (validafecha(document.form1.fDfechadesde.value) ){
					this.error = 'La Fecha desde debe estar entre el primer y ultimo día del mes y año actual';
				}
			}
			function validafechahasta(){
				if (validafecha(document.form1.fDfechahasta.value) ){
					this.error = 'La Fecha hasta debe estar entre el primer y ultimo día del mes y año actual';
				}
			}
			
		</script>
		
		<cf_qforms >
			<cf_qformsrequiredfield args="fSNcodigo,Socio de Negocios">
			<cf_qformsrequiredfield args="fDfechadesde,Fecha Desde,validafechadesde">
			<cf_qformsrequiredfield args="fDfechahasta,Fecha Hasta,validafechahasta">
		</cf_qforms>

	<cf_templatefooter>