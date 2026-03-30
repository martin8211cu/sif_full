
<cfparam name="form.AyudaCabId" default="">
<cfparam name="form.SScodigo" default="">
<cfparam name="form.SMcodigo" default="">
<cfparam name="form.SPcodigo" default="">
<cfset regresar = "/cfmx/sif/ad/MenuAD.cfm">
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>

		<cfquery name="rsLanguagesCode" datasource="sifcontrol">
			SELECT DISTINCT (LTRIM(RTRIM(Icodigo))) AS Icodigo
			FROM Idiomas
		</cfquery>

		<!--- Creacion de tabla temporal --->
		<cf_dbtemp name="TabLanguajesTemp" returnvariable="TabLanguajesTemp" datasource="#session.dsn#">
			<cf_dbtempcol name="IdLanguage" type="numeric" identity="true" mandatory="true">
			<cf_dbtempcol name="Codigo" type="varchar(20)">
			<cf_dbtempcol name="Description" type="varchar(250)">
		</cf_dbtemp>
		<cfset LvarTablaTemp = TabLanguajesTemp>

		<cfif rsLanguagesCode.recordCount GT 0>
			<cfoutput query="rsLanguagesCode">
				<cfquery name="rsLanguagesDescrip" datasource="#session.dsn#">
					SELECT MIN(Descripcion) as Descripcion FROM Idiomas WHERE Icodigo = <cf_jdbcquery_param value='#Icodigo#' cfsqltype="cf_sql_varchar">
				</cfquery>
			<cfquery name="rsInsertTempCode" datasource="#session.dsn#">
				INSERT INTO #LvarTablaTemp# (Codigo, Description)
				values (<cf_jdbcquery_param value='#Icodigo#' cfsqltype="cf_sql_varchar">,
				<cf_jdbcquery_param value='#rsLanguagesDescrip.Descripcion#' cfsqltype="cf_sql_varchar">)
			</cfquery>
			</cfoutput>
		</cfif>

		<cfquery name="rsLanguages" datasource="#session.dsn#">
			SELECT *
			FROM #LvarTablaTemp#
			ORDER BY Description
		</cfquery>

		<cfquery name="rsModulos" datasource="asp">
			select  SScodigo, SMcodigo, SMdescripcion
			from SModulos
			order by SMdescripcion
		</cfquery>

		<cfquery name="rsMenues" datasource="asp">
			select  SScodigo, SMcodigo, SMNcodigo, SMNtitulo
			from SMenues
			where SPcodigo is null
			order by SScodigo, SMcodigo, SMNpath, SMNorden
		</cfquery>
		<cfquery datasource="asp" name="lista_query">
			select distinct
				ac.AyudaCabId as AyudaCabId, ac.AyudaCabTitulo as AyudaCabTitulo, ss.SSdescripcion as SSdescripcion,
				sm.SMdescripcion as SMdescripcion,  sp.SPdescripcion as SPdescripcion, ac.SScodigo, ac.SMcodigo, ac.SPcodigo, isnull(ac.AyudaIdioma,'es') AyudaIdioma
				,'<i class=''fa fa-edit fa-lg'' style=''cursor:pointer;'' onclick=''editarWid(' + cast(ac.AyudaCabId as varchar) + ');''></i>&nbsp;',
				'<i class=''fa fa-exchange'' title=''Traducir cabecera'' style=''cursor:pointer;'' onclick=''translateCabecera(' + cast(ac.AyudaCabId as varchar) + ');''></i> &nbsp;
				<i class=''fa fa-edit fa-lg'' title=''Editar'' style=''cursor:pointer;'' onclick=''VerCabecera(' + cast(ac.AyudaCabId as varchar) + ');''></i>'as Acciones
			from AyudaCabecera ac
			inner join SSistemas ss on ac.SScodigo = ss.SScodigo
			inner join SModulos sm on ac.SMcodigo = sm.SMcodigo
			left join SProcesos sp on ac.SPcodigo = sp.SPcodigo and sp.SScodigo=ac.SScodigo and sp.SMcodigo=ac.SMcodigo
			where 1 = 1
			<cfif len(trim(form.AyudaCabId)) gt 0  and isdefined("form.BTNFILTRAR") >
				and upper(ac.AyudaCabTitulo) like upper('%#form.AyudaCabId#%')
			</cfif>

			<!--- sistema filtro --->
			<cfif len(trim(form.SScodigo)) and form.SScodigo NEQ "-1" >
				and ac.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value='#form.SScodigo#'>
			</cfif>

			<!--- modulo filtro --->
			<cfif len(trim(form.SMcodigo)) and form.SMcodigo NEQ "-1" >
				and ac.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value='#form.SMcodigo#'>
			</cfif>

				<!--- proceso filtro --->
			<cfif len(trim(form.SPcodigo)) and form.SPcodigo NEQ "" >
				and upper(sp.SPdescripcion) like upper('%#form.SPcodigo#%')
			</cfif>

				<!--- idioma filtro --->
			<cfif isdefined("form.Idioma") and len(trim(form.Idioma)) and form.Idioma NEQ "-1" >
				and ac.AyudaIdioma = <cfqueryparam cfsqltype="cf_sql_varchar" value='#form.Idioma#'>
			</cfif>
		</cfquery>
		<cfquery name="rsListaCompleta" dbtype="query">
			select lista_query.*, rsLanguages.* from lista_query, rsLanguages
			where rsLanguages.Codigo = lista_query.AyudaIdioma
		</cfquery>
		<cfquery name="rsTipos" datasource="asp">
			select distinct ac.SScodigo, ss.SSdescripcion
			from AyudaCabecera ac
			inner join SSistemas ss
				on ac.SScodigo = ss.SScodigo
				order by ss.SSdescripcion
		</cfquery>

		<cfquery name="rsTiposSM" datasource="asp">
			select distinct ac.SMcodigo, ss.SMdescripcion
			from AyudaCabecera ac
			inner join SModulos ss
				on ac.SScodigo = ss.SScodigo
				and ac.SMcodigo = ss.SMcodigo
				order by ss.SMdescripcion
		</cfquery>

		<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
			<script type="text/javascript" src="/cfmx/jquery/librerias/jquery.bootstrap.wizard.min.js"></script>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Ayuda'>
				<cfinclude template="/home/menu/pNavegacion.cfm">

					<div class="container-fluid">
					<div class="row">
						<div class="col-md-12">
								<form name="filtroAlta" id="filtroAlta" action=""  method="post"><!---	--->

										<table width="100%" class="areaFiltro">
											<tr>
												<td width="3%"></td>
												<td>
													<b>Cabecera</b>
												</td>
												<td >
													<input name="AyudaCabId" type="text" size="10" maxlength="10"
														<cfoutput>
															<cfif len(trim(#form.AyudaCabId#)) gt 0>
																value="#form.AyudaCabId#"
															</cfif>
														</cfoutput>
													>
												</td>
												<td>
													<b>Sistema:</b>
												</td>
												<td>
													<select name="SScodigo">
														<option value="-1">--- Todos ---</option>
														<cfoutput query="rsTipos">
															<option value="#rsTipos.SScodigo#"
																<cfif isdefined("form.SScodigo") and form.SScodigo eq rsTipos.SScodigo>
																	selected
																</cfif>
															>#rsTipos.SSdescripcion#
															</option>
														</cfoutput>
													</select>
												</td>
												<td>
													<b>M&oacute;dulo:</b>
												</td>
												<td>
													<select name="SMcodigo">
														<option value="-1">--- Todos ---</option>
														<cfoutput query="rsTiposSM">
															<option value="#rsTiposSM.SMcodigo#"
																<cfif isdefined("form.SMcodigo") and form.SMcodigo eq rsTiposSM.SMcodigo>
																	selected
																</cfif>
															>#rsTiposSM.SMdescripcion#
															</option>
														</cfoutput>
													</select>
												</td>

												<td>
													<b>Proceso:</b>
												</td>
												<td>
													<input name="SPcodigo"
														<cfoutput>
															<cfif len(trim(#form.SPcodigo#)) gt 0>
																value="#form.SPcodigo#"
															</cfif>
														</cfoutput>
													</select>
												</td>
												<td>
													<b>Idioma:</b>
												</td>
												<td>
													<select name="Idioma">
														<option value="-1">--- Todos ---</option>
														<cfoutput query="rsLanguages">
															<!--- <cfif len(trim(#rsTiposSP.SPcodigo#)) gt 0> --->
																<option value="#Codigo#"
																	<!--- <cfif isdefined("form.SPcodigo") and form.SPcodigo eq rsTiposSP.SPcodigo>
																		selected
																	</cfif> --->
																>#Description#
																</option>
															<!--- </cfif> --->
														</cfoutput>
													</select>
												</td>
												<td>
													<input type="submit" name="btnFiltrar" value="Filtrar" class="btnFiltrar">
													<input type="button" name="btnlimpiar" value="Limpiar" onClick="javascript:limpiar();" class="btnlimpiar">
												</td>

											</tr>
										</table>
								</form>
								<div class="row">
									<div class="col-md-12">
										<cfset navegacion = "o=1">
												<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet" query="#rsListaCompleta#">
													<cfinvokeargument name="desplegar" 	value="AyudaCabId, SSdescripcion, SMdescripcion, SPdescripcion, AyudaCabTitulo, Description, Acciones"/>
													<cfinvokeargument name="etiquetas" 	value="C&oacute;digo, Sistema, M&oacute;dulo, Proceso, Cabecera, Idioma, Acciones"/>
													<cfinvokeargument name="formatos" 	value="V, V, V, V, V, V, V"/>
													<cfinvokeargument name="align" 		value="left, left, left, left, left, left, center"/>
													<cfinvokeargument name="ajustar" 	value="S"/>,
													<cfinvokeargument name="checkboxes" value="N"/>
													<cfinvokeargument name="cortes"  	value="SSdescripcion" />
													<cfinvokeargument name="Nuevo" 		value="AltaAyuda.cfm"/>
													<cfinvokeargument name="irA" 		value="AltaAyuda.cfm"/>
													<cfinvokeargument name="navegacion" value="#navegacion#"/>
													<cfinvokeargument name="maxRows" value="20"/>
													<cfinvokeargument name="showlink" value="false"/>
													<cfinvokeargument name="keys" value="AyudaCabId"/>
													<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
													<cfinvokeargument name="debug" value="N"/>
													<cfinvokeargument name="Conexion" 		  value="asp"/>
												</cfinvoke>
									</div>
								</div>
								<div class="row">&nbsp;</div>
								<div class="row">
									<div class="col-md-12">
										<div class="text-center">
											<form action="" method="get" name="form_exportar" id="form_exportar" >
												<input type="button" name="Nuevo" class="btnNuevo" onClick="javascript:nuevo();" value="Nuevo" >
											</form>
										</div>
									</div>
								</div>
						</div>
					</div>
					</div>

					<div id="popupEditar" style="display: none;">
					</div>
					<div id="dialog-confirmEli"></div>

			<cf_web_portlet_end>
		<cf_templatefooter>

		<script language="JavaScript1.2" type="text/javascript">
			function translateCabecera(AyudaCabId){
				$.ajax({
					type: "GET",
					url: "/cfmx/asp/ayudas/ayuda/ModalTranslateCab.cfm?AyudaCabId="+AyudaCabId,
					success: function(result){
						$("#popupEditar").html(result);
					}
				});

				$("#popupEditar").dialog({
					width: 520,
					modal:true,
					title:"Traducir cabecera",
					height: 280,
					resizable: "false",
				});
			}

			function VerCabecera(AyudaCabId){
				document.lista.action = "AltaAyuda.cfm?modo=CAMBIO&AyudaCabIdVar="+AyudaCabId;
				document.lista.submit();
			}

			function nuevo(){
				document.lista.action = "AltaAyuda.cfm?modo=ALTA";
				document.lista.submit();
			}

			function limpiar(){
				document.filtroAlta.AyudaCabId.value = "";
				document.filtroAlta.SScodigo.value = -1;
				document.filtroAlta.SMcodigo.value = -1;
				document.filtroAlta.SPcodigo.value = -1;
			}

			function editarWid(WidID)
			{
				$.ajax({
					type: "GET",
					url: "/cfmx/asp/ayudas/ayuda/ModalAlta.cfm?WidID="+WidID,
					success: function(result){
						$("#popupEditar").html(result);
					}
				});

				$("#popupEditar").dialog({
					width: 960,
					modal:true,
					title:"Editar Sección de Ayuda",
					height: 550,
					resizable: "false",
				});
			}

			function eliminarWid(WidID)
			{
				$("#dialog-confirmEli").html("Deseas eliminar el widget??");

				// Define the Dialog and its properties.
				$("#dialog-confirmEli").dialog({
					resizable: false,
					modal: true,
					title: "Eliminar Widgets",
					height: 120,
					width: 250,
					buttons: {
						"Si": function () {
							var url = "widgets-sql.cfm?imgEliminar=1&WidID="+WidID;
							$(location).attr('href',url);
							$(this).dialog('close');
							callback(true);
						},
							"No": function () {
							$(this).dialog('close');
							callback(false);
						}
					}
				});
			}
		</script>





