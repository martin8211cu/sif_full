<cfinvoke key="LB_Antes_de_borrar_el_tipo_de_accion_debe_eliminar_los_permisos" default="Antes de borrar el tipo de acci&oacute;n debe eliminar los permisos. " returnvariable="LB_ErrorTipoAcc" component="sif.Componentes.Translate" method="Translate"/>
<cfparam name="action" default="TipoAccion.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<!---
	<cftry>
		<cfquery name="ABC_TipoAccion" datasource="#session.DSN#">
			set nocount on
	--->
			<!--- Caso 1: Agregar Tipo de Accion --->
			<cfif isdefined("form.Alta")>
				<cfquery name="Insert" datasource="#session.DSN#">
					insert into RHTipoAccion ( Ecodigo, RHTcodigo, RHTdesc,RHTnopagaincidencias, RHTpaga, RHTpfijo, RHTpmax, RHTcomportam, RHTposterior, RHTautogestion,
										  RHTindefinido, RHTcempresa, RHTctiponomina, RHTcregimenv, RHTcoficina, RHTcdepto, RHTcplaza, RHTcpuesto, RHTccomp,
										  RHTcsalariofijo, RHTcjornada, RHTvisible, RHTidtramite, RHTnorenta, RHTnocargas, RHTnodeducciones, RHTcuentac,
										  CIncidente1, CIncidente2, RHTnoretroactiva, RHTcantdiascont, RHTccatpaso, RHTliquidatotal, RHTnocargasley,RHTNoMuestraCS,
										  RHTdatoinforme, RHTpension, RHTnoveriplaza, RHTalerta, RHTdiasalerta,
										  RHTtiponomb,RHTafectafantig,RHTafectafvac,RHTespecial,RHTporc,RHTporcsal,RHTporcPlazaCHK,
										  RHTsubcomportam,RHCatParcial,RHAcumAnualidad, RHTfactorfalta,BMUsucodigo,RHIncapid,RHTnomarca,RHTAplicaVaca,RHTIncluirFactorNomina)
								 values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#form.RHTcodigo#"  cfsqltype="cf_sql_char">,
										  <cfqueryparam value="#form.RHTdesc#"    cfsqltype="cf_sql_varchar">,
										 <cfif isdefined("form.RHTnoretroactiva")>
										  	0
										  <cfelse>
											<cfif isdefined("form.RHTnopagaincidencias")>1<cfelse>0</cfif>
										  </cfif>,
										  <cfif isdefined("form.RHTnoretroactiva")>
										  	0
										  <cfelse>
											<cfif isdefined("form.RHTpaga")>1<cfelse>0</cfif>
										  </cfif>,
										  <cfif isdefined("form.RHTpfijo")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTpmax")><cfqueryparam value="#form.RHTpmax#" cfsqltype="cf_sql_integer"><cfelse>0</cfif>,
										  <cfqueryparam value="#form.RHTcomportam#" cfsqltype="cf_sql_integer">,
										  <cfif isdefined("form.RHTposterior")>0<cfelse>1</cfif>,
										  <cfif isdefined("form.RHTautogestion")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTpfijo")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcempresa")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTctiponomina")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcregimenv")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcoficina")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcdepto")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcpuesto")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcpuesto")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTccomp")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcsalariofijo")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcjornada")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTvisible")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTidtramite") and form.RHTidtramite NEQ 'N'>
											  <cfqueryparam value="#form.RHTidtramite#" cfsqltype="cf_sql_numeric">
										  <cfelse>
											null
										  </cfif>,
										  <cfif isdefined("form.RHTnorenta")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTnocargas")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTnodeducciones")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTcuentac")><cfqueryparam value="#form.RHTcuentac#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
										  <cfif isdefined("form.CIid1") and len(trim(form.CIid1)) gt 0><cfqueryparam value="#form.CIid1#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
										  <cfif isdefined("form.CIid2") and len(trim(form.CIid2)) gt 0><cfqueryparam value="#form.CIid2#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
										  <cfif isdefined("form.RHTnoretroactiva")>1<cfelse>0</cfif>,
										  <cfif form.RHTcomportam EQ 5>
											  <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHTcantdiascont#">
										  <cfelse>
											  0
										  </cfif>,
										  <cfif isdefined("form.RHTccatpaso")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTliquidatotal")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTnocargasley")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTNoMuestraCS")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTdatoinforme") and len(trim(form.RHTdatoinforme)) gt 0><cfqueryparam value="#form.RHTdatoinforme#" cfsqltype="cf_sql_char"><cfelse>null</cfif>,
										  <cfif isdefined("form.RHTpension")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTnoveriplaza")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTalerta")>1<cfelse>0</cfif>,
										  <cfif isdefined("form.RHTalerta")>
											<cfif isdefined("form.RHTdiasalerta") and len(trim(form.RHTdiasalerta))>
												<cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(form.RHTdiasalerta, ',', '', 'all')#">
											<cfelse>
												0
											</cfif>
										  <cfelse>
										  	null
										  </cfif>
										  <cfif isdefined('form.RHTcomportam') and form.RHTcomportam EQ 1>
										  	, <cfqueryparam value="#form.RHTtiponomb#" cfsqltype="cf_sql_integer">
										  <cfelse>
										  	, null
										  </cfif>
										 <cfif isdefined('form.RHTcomportam') and form.RHTcomportam GT 2 and isdefined('form.RHTpfijo')>
										   , <cfif isdefined("form.RHTafectafantig")>1<cfelse>0</cfif>
										   , <cfif isdefined("form.RHTafectafvac")>1<cfelse>0</cfif>
										 <cfelse>
										   , null
										   , null
										 </cfif>
										   ,0
										  ,<cfqueryparam value="#form.RHTporc#"      cfsqltype="cf_sql_float">
										  ,<cfqueryparam value="#form.RHTporcsal#"   cfsqltype="cf_sql_float">
										  ,<cfif isdefined("form.RHTporcPlazaCHK")>1<cfelse>0</cfif>
										   <cfif isdefined('form.RHTcomportam') and form.RHTcomportam EQ 5>
										  	, <cfqueryparam value="#form.RHTsubcomportam#" cfsqltype="cf_sql_integer">
										  <cfelse>
										  	, null
										  </cfif>
										  , <cfif isdefined("form.RHCatParcial")>1<cfelse>0</cfif>
										  , <cfif isdefined("form.RHAcum")>1<cfelse>0</cfif>
                                          , <cfif isdefined("form.RHTfactorfalta")>
                                          		<cfqueryparam value="#form.RHTfactorfalta#" cfsqltype="cf_sql_float">
                                          <cfelse>1</cfif>
										  ,	<cfif isdefined("session.usucodigo")><!---se agrega para conocer el usuario que creo el tipo de accion--->
                                          		<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
                                          <cfelse>null</cfif>
                    					  ,<cfif isdefined("form.IncapacidadSAT") and form.IncapacidadSAT neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#form.IncapacidadSAT#">
                                          <cfelseif isdefined("form.ConceptoSAT") and form.ConceptoSAT neq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#">
                                          <cfelse>0</cfif>,0,0,#(IsDefined('form.chkIncluirFactor') ? 1 : 0)#
									   )
				</cfquery>

			<!--- Caso 2: Modificar Tipo de Accion --->
			<cfelseif isdefined("form.Cambio")>
				<cf_dbtimestamp datasource="#session.dsn#"
					table="RHTipoAccion"
					redirect="TipoAccion.cfm"
					timestamp="#form.ts_rversion#"
					field1="RHTid"
					type1="numeric"
					value1="#form.RHTid#"
					<!---field2="Ecodigo"
					type2="integer"
					value2="#Session.Ecodigo#"--->
				>

				<cfquery name="Update" datasource="#session.DSN#">
					update RHTipoAccion
					set RHTcodigo 		= <cfqueryparam value="#form.RHTcodigo#"  cfsqltype="cf_sql_char">,
						RHTdesc 		= <cfqueryparam value="#form.RHTdesc#"    cfsqltype="cf_sql_varchar">,
						RHTpaga 		= <cfif isdefined("form.RHTnoretroactiva")>
										  	0
										  <cfelse>
											<cfif isdefined("form.RHTpaga")>1<cfelse>0</cfif>
										  </cfif>,
						RHTpfijo 		= <cfif isdefined("form.RHTpfijo")>1<cfelse>0</cfif>,
						RHTpmax 		= <cfif isdefined("form.RHTpmax")><cfqueryparam value="#form.RHTpmax#" cfsqltype="cf_sql_integer"><cfelse>0</cfif>,
						RHTcomportam    = <cfqueryparam value="#form.RHTcomportam#" cfsqltype="cf_sql_integer">,
						RHTposterior    = <cfif isdefined("form.RHTposterior")>0<cfelse>1</cfif>,
						RHTautogestion  = <cfif isdefined("form.RHTautogestion")>1<cfelse>0</cfif>,
						RHTindefinido   = <cfif isdefined("form.RHTpfijo")>1<cfelse>0</cfif>,
						RHTcempresa  	= <cfif isdefined("form.RHTcempresa")>1<cfelse>0</cfif>,
						RHTctiponomina  = <cfif isdefined("form.RHTctiponomina")>1<cfelse>0</cfif>,
						RHTcregimenv    = <cfif isdefined("form.RHTcregimenv")>1<cfelse>0</cfif>,
						RHTcoficina     = <cfif isdefined("form.RHTcoficina")>1<cfelse>0</cfif>,
						RHTcdepto       = <cfif isdefined("form.RHTcdepto")>1<cfelse>0</cfif>,
						RHTcplaza       = <cfif isdefined("form.RHTcpuesto")>1<cfelse>0</cfif>,
						RHTcpuesto      = <cfif isdefined("form.RHTcpuesto")>1<cfelse>0</cfif>,
						RHTccomp        = <cfif isdefined("form.RHTccomp")>1<cfelse>0</cfif>,
						RHTcsalariofijo = <cfif isdefined("form.RHTcsalariofijo")>1<cfelse>0</cfif>,
						RHTcjornada     = <cfif isdefined("form.RHTcjornada")>1<cfelse>0</cfif>,
						RHTNoMuestraCS  = <cfif isdefined("form.RHTNoMuestraCS")>1<cfelse>0</cfif>,
						RHTvisible      = <cfif isdefined("form.RHTvisible")>1<cfelse>0</cfif>,
						RHTccatpaso     = <cfif isdefined("form.RHTccatpaso")>1<cfelse>0</cfif>,
						RHTporc			= <cfqueryparam value="#form.RHTporc#"      cfsqltype="cf_sql_float">,
						RHTporcsal		= <cfqueryparam value="#form.RHTporcsal#"   cfsqltype="cf_sql_float">,
                        RHTnopagaincidencias     = 	<cfif isdefined("form.RHTnoretroactiva")>
										  				0
										  			<cfelse>
														<cfif isdefined("form.RHTnopagaincidencias")>1<cfelse>0</cfif>
										 			 </cfif>,
						RHTcuentac      = <cfif isdefined("form.RHTcuentac")><cfqueryparam value="#form.RHTcuentac#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
						<cfif isdefined("form.RHTidtramite") and form.RHTidtramite NEQ 'N'>
							,RHTidtramite = <cfqueryparam value="#form.RHTidtramite#" cfsqltype="cf_sql_numeric">
						<cfelse>
							,RHTidtramite = NULL
						</cfif>
						,RHTnorenta       = <cfif isdefined("form.RHTnorenta")>1<cfelse>0</cfif>
						,RHTnocargas      = <cfif isdefined("form.RHTnocargas")>1<cfelse>0</cfif>
						,RHTnodeducciones = <cfif isdefined("form.RHTnodeducciones")>1<cfelse>0</cfif>
						,CIncidente1 = <cfif isdefined("form.CIid1") and len(trim(form.CIid1)) gt 0><cfqueryparam value="#form.CIid1#" cfsqltype="cf_sql_numeric">	<cfelse>null </cfif>
						,CIncidente2 = <cfif isdefined("form.CIid2") and len(trim(form.CIid2)) gt 0><cfqueryparam value="#form.CIid2#" cfsqltype="cf_sql_numeric">	<cfelse>null </cfif>
						,RHTnoretroactiva = <cfif isdefined("form.RHTnoretroactiva")>1<cfelse>0</cfif>
						,RHTporcPlazaCHK  = <cfif isdefined("form.RHTporcPlazaCHK")>1<cfelse>0</cfif>
						<cfif form.RHTcomportam EQ 5>
						,RHTcantdiascont = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHTcantdiascont#">
						<cfelse>
						,RHTcantdiascont = 0
						</cfif>
						,RHTliquidatotal = <cfif isdefined("form.RHTliquidatotal")>1<cfelse>0</cfif>
						,RHTnocargasley = <cfif isdefined("form.RHTnocargasley")>1<cfelse>0</cfif>
						, RHTdatoinforme = <cfif isdefined("form.RHTdatoinforme") and len(trim(form.RHTdatoinforme)) gt 0><cfqueryparam value="#form.RHTdatoinforme#" cfsqltype="cf_sql_char"><cfelse>null</cfif>
						, RHTpension = <cfif isdefined("form.RHTpension")>1<cfelse>0</cfif>
						, RHTnoveriplaza = <cfif isdefined("form.RHTnoveriplaza")>1<cfelse>0</cfif>
						, RHTalerta = <cfif isdefined("form.RHTalerta")>1<cfelse>0</cfif>
						,RHCatParcial = <cfif isdefined("form.RHCatParcial")>1<cfelse>0</cfif>
						,RHAcumAnualidad = <cfif isdefined("form.RHAcum")>1<cfelse>0</cfif>
						, RHTdiasalerta =
							<cfif isdefined("form.RHTalerta")>
								<cfif isdefined("form.RHTdiasalerta") and len(trim(form.RHTdiasalerta))>
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(form.RHTdiasalerta, ',', '', 'all')#">
								<cfelse>
									0
								</cfif>
							<cfelse>
								null
							</cfif>
						<cfif isdefined('form.RHTcomportam') and form.RHTcomportam EQ 1 and isdefined('form.RHTtiponomb')>
						, RHTtiponomb = <cfqueryparam value="#form.RHTtiponomb#" cfsqltype="cf_sql_integer">
						<cfelse>
						, RHTtiponomb = null
						</cfif>
						<cfif isdefined('form.RHTcomportam') and form.RHTcomportam GT 2 and isdefined('form.RHTpfijo')>
						  , RHTafectafantig = <cfif isdefined("form.RHTafectafantig")>1<cfelse>0</cfif>
						  , RHTafectafvac = <cfif isdefined("form.RHTafectafvac")>1<cfelse>0</cfif>
						<cfelse>
						  , RHTafectafantig = null
						  , RHTafectafvac = null
						</cfif>
						<cfif isdefined('form.RHTcomportam') and form.RHTcomportam EQ 5>
							,RHTsubcomportam = <cfqueryparam value="#form.RHTsubcomportam#" cfsqltype="cf_sql_integer">
						  <cfelse>
							,RHTsubcomportam = null
						  </cfif>

                         <cfif isdefined('form.RHTfactorfalta') and form.RHTcomportam EQ 13>
							,RHTfactorfalta = <cfqueryparam value="#form.RHTfactorfalta#" cfsqltype="cf_sql_float">
						  <cfelse>
							,RHTfactorfalta = 1
						  </cfif>
                          ,BMUsucodigo=<cfif isdefined("session.usucodigo")><!---se agrega para conocer el usuario que creo el tipo de accion--->
                                          		<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
                                          <cfelse>null</cfif>
                          <cfif isdefined("form.IncapacidadSAT")  and form.IncapacidadSAT neq 0>
                    	  	,RHIncapid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.IncapacidadSAT#">
                          <cfelseif isdefined("form.ConceptoSAT")  and form.ConceptoSAT neq 0>
                          	,RHIncapid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ConceptoSAT#">
                          </cfif>
						  ,RHTIncluirFactorNomina = #(IsDefined('form.chkIncluirFactor') ? 1 : 0)#
						  
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHTid = <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">
					  <!---and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)---->
				</cfquery>
				  <cfset modo = 'CAMBIO'>

			<!--- Caso 3: Eliminar Tipo de Accion --->
			<cfelseif isdefined("form.Baja")>
				<cftry>
						<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
							<cfinvokeargument  name="nombreTabla" value="RHCargasPeriodoEspecial">
							<cfinvokeargument name="condicion" value="RHTid = #form.RHTid#">
							<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
							<cfinvokeargument name="necesitaTransaccion" value="false">
						</cfinvoke>

						<cfquery name="Delete0" datasource="#session.DSN#">
							delete from RHCargasPeriodoEspecial
							where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
						</cfquery>

						<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
							<cfinvokeargument  name="nombreTabla" value="ConceptosTipoAccion">
							<cfinvokeargument name="condicion" value="RHTid = #form.RHTid#">
							<cfinvokeargument name="necesitaTransaccion" value="false">
						</cfinvoke>

						<cfquery name="Delete1" datasource="#session.DSN#">
							delete from ConceptosTipoAccion
							where RHTid = <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">
						</cfquery>

						<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
							<cfinvokeargument  name="nombreTabla" value="RHTipoAccion">
							<cfinvokeargument name="condicion" value="RHTid = #form.RHTid#">
							<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
							<cfinvokeargument name="necesitaTransaccion" value="false">
						</cfinvoke>

						<cfquery name="Delete2" datasource="#session.DSN#">
							delete from RHTipoAccion
							where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and RHTid =  <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">
						 </cfquery>

					 <cfcatch type="any">
					 <cf_throw message="#LB_ErrorTipoAcc#" errorcode="232">
					 </cfcatch>

				</cftry>

			<!--- Caso 4: Agregar ConceptoTipoAccion --->
			<cfelseif isdefined("form.CTAAlta")>
				<cfquery name="InsertConcepto" datasource="#session.DSN#">
					insert into ConceptosTipoAccion ( CIid, RHTid, CTAsalario, Usucodigo, Ulocalizacion )
					values ( <cfqueryparam value="#form.CIid#" cfsqltype="cf_sql_numeric">,
							 <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">,
							 <cfqueryparam value="#form.CTAsalario#" cfsqltype="cf_sql_integer">,
							 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
							 <cfqueryparam value="#Session.Ulocalizacion#" cfsqltype="cf_sql_char">
						   )
				</cfquery>

				<cfset modo = 'CAMBIO'>

			<!--- Caso 5: Eliminar ConceptoTipoAccion --->
			<cfelseif isdefined("form.CTAAccion") and form.CTAAccion eq "BAJA">

				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
							<cfinvokeargument  name="nombreTabla" value="ConceptosTipoAccion">
							<cfinvokeargument name="condicion" value="CIid = #form.CIid# and RHTid = #form.RHTid#">
				</cfinvoke>

				<cfquery name="DeleteConcepto" datasource="#session.DSN#">
					delete from ConceptosTipoAccion
					where CIid = <cfqueryparam value="#form.CIid#" cfsqltype="cf_sql_numeric">
					and RHTid = <cfqueryparam value="#form.RHTid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo = 'CAMBIO'>

			<!--- Caso 6. Agregar carga periodo especial--->
			<cfelseif isdefined("form.btn_agregarcarga") and isdefined("form.DClinea") and len(trim(form.DClinea))>
				<!---Verificar que no se haya agregado--->
				<cfquery name="rsVerifica" datasource="#session.DSN#">
					select 1
					from RHCargasPeriodoEspecial
					where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
						and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
				</cfquery>
				<cfif rsVerifica.RecordCount EQ 0>
					<cfquery datasource="#session.DSN#">
						insert into RHCargasPeriodoEspecial(RHTid,DClinea,RHCPEporcentaje,BMUsucodigo)
						values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#form.RHCPEporcentaje#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.DSN#">
						update RHCargasPeriodoEspecial
						set RHCPEporcentaje = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#form.RHCPEporcentaje#">
						where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
						  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
					</cfquery>
				</cfif>
				<cfset modo = 'CAMBIO'>
			<!----Caso 7. Eliminar carga periodo especial--->
			<cfelseif isdefined("form.CargaAccion") and form.CargaAccion EQ 'BAJA' and isdefined("form.DClineaEliminar") and len(trim(form.DClineaEliminar))>

				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
							<cfinvokeargument  name="nombreTabla" value="RHCargasPeriodoEspecial">
							<cfinvokeargument name="condicion" value="RHTid = #form.RHTid# and DClinea = #form.DClineaEliminar#">
							<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
				</cfinvoke>


				<cfquery datasource="#session.DSN#">
					delete from RHCargasPeriodoEspecial
					where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
						and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClineaEliminar#">
				</cfquery>
				<cfset modo = 'CAMBIO'>
			</cfif>
<!----
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
--->
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHTid" type="hidden" value="#form.RHTid#"></cfif>

	<cfif not isdefined("form.Nuevo")>
		<input name="pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
		<input name="pagenum" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#<cfelse>0</cfif>">
	<cfelse>
		<input type="hidden" name="nuevo" value="nuevo">
	</cfif>

</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>