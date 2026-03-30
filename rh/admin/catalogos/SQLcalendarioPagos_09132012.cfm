<!---<cf_dump var="#form#">
---><!-----================= TRADUCCION ===================---->
<cfinvoke key="LB_La_fecha_de_pago_de_este_calendario_no_puede_ser_igual_a_la_fecha_de_pago_de_un_calendario_de_pago_ya_existente" default="La fecha de pago de este calendario no puede ser igual a la fecha de pago de un calendario de pago ya existente" returnvariable="LB_ErrorFechaPago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_No_se_puede_insertar_un_calendario_de_pago_con_un_rango_de_fechas_que_se_encuentran_dentro_de_un_calendario_de_pago_ya_existente" default="No se puede insertar un calendario de pago con un rango de fechas que se encuentran dentro de un calendario de pago ya existente." returnvariable="LB_ErrorFechaExistente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Error_al_intentar_actualizar_CPcodigo_Se_excedio_la_capacidad_del_consecutivo" default="Error al intentar actualizar CPcodigo. Se excedió la capacidad del consecutivo." returnvariable="LB_ErrorActualizarCPcodigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_El_calendario_de_pagos_esta_asociado_a_una_Relacion_de_Calculo_y_no_puede_ser_modificado" default="El calendario de pagos esta asociado a una Relacion de C&aacute;lculo y no puede ser modificado." returnvariable="LB_ErrorModificar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_YaExisteUnCalendarioDePagoAbiertoDeEsteTipoConEsaFechaHasta" default="Ya existe un calendario de pago abierto de este tipo con esta fecha hasta" returnvariable="LB_ErrorCalendarioTipoFHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_El_calendario_de_pagos_esta_asociado_a_una_Relacion_de_Calculo_y_no_puede_ser_Eliminado" default="El calendario de pagos esta asociado a una Relacion de C&aacute;lculo y no puede ser eliminado. " returnvariable="LB_ErrorEliminar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_El_calendario_de_pagos_esta_asociado_a_una_deduccion_elimine_las_deducciones_primero" default="El calendario de pagos esta asociado a una deducci&oacute;n elimine las deducciones primero. " returnvariable="LB_ErrorIntegridadCP" component="sif.Componentes.Translate" method="Translate"/>	


<cfset modo="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
		<cfif isDefined("form.CPtipo") and Trim(form.CPtipo) EQ "1">
			<!--- Verificacion de que la fecha de pago de un calendario de pago especial 
				no sea igual al de otro calendario de pago ya creado --->
			<cfquery name="chkExists" datasource="#Session.DSN#">
				select 1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
				and CPfpago = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CPfpago)#">
				<cfif isdefined("Form.Cambio")>
				and CPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
				</cfif>
			</cfquery>
			<cfif chkExists.recordCount>
				<cf_throw message="#LB_ErrorFechaPago#" errorcode="2045">
				<cfabort>
			</cfif>
			<!---============================================================================================--->
			<!----Verifica que no exista otro calendario del mismo tipo de nomina (mensual,quincenal,semanal,etc) 
			abierto con fecha hasta igual a la fecha hasta del que se esta insertando/modificando--->
			<!---============================================================================================--->
			<cfquery name="rsVerificaFHasta" datasource="#session.DSN#">
				select 1
				from CalendarioPagos a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.CPhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CPhasta)#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#"><!---Tipo de nomina---->
					<!----and CPtipo = 1--->
					<!---Calendario abierto---->
					and exists(select 1
								from RCalculoNomina b
								where a.CPid = b.RCNid								
							) 
					<cfif isdefined("Form.Cambio")>
						and CPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
					</cfif>
			</cfquery>	
			<cfif rsVerificaFHasta.recordCount NEQ 0>
				<cf_throw message="#LB_ErrorCalendarioTipoFHasta#:#LSDateFormat(form.CPhasta,'dd/mm/yyyy')#" errorcode="2050">
				<cfabort>
			</cfif>

		<cfelse>

			<!--- Chequear la existencia del calendario de pago antes de insertar o modificar --->
			<cfquery name="chkExists" datasource="#Session.DSN#">
				select 1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
				<!----and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CPdesde)#"> between CPdesde and CPhasta--->
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CPhasta)#"> between CPdesde and CPhasta
				<cfif isdefined("Form.Cambio")>
				and CPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
				</cfif>
				<cfif isdefined('form.CPtipo') and form.CPtipo EQ 0>
				and CPtipo = 0
				<cfelseif isdefined('form.CPtipo') and form.CPtipo EQ 2>
				and CPtipo = 2
				<cfelseif isdefined('form.CPtipo') and form.CPtipo EQ 3>
				and CPtipo = 3
                <cfelseif isdefined('form.CPtipo') and form.CPtipo EQ 4>
				and CPtipo = 4
				</cfif>
			</cfquery>

			<cfif chkExists.recordCount>
				<cf_throw message="#LB_ErrorFechaExistente#" errorcode="2055">
				<cfabort>
			</cfif>

			<!--- Chequear la existencia del calendario de pago antes de insertar o modificar --->
			<cfquery name="chkExists" datasource="#Session.DSN#">
				select 1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CPhasta)#"> between CPdesde and CPhasta
				<cfif isdefined("Form.Cambio")>
				and CPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
				</cfif>
				<cfif isdefined('form.CPtipo') and form.CPtipo EQ 0>
				and CPtipo = 0
				<cfelseif isdefined('form.CPtipo') and form.CPtipo EQ 2>
				and CPtipo = 2
				<cfelseif isdefined('form.CPtipo') and form.CPtipo EQ 3>
				and CPtipo = 3
                <cfelseif isdefined('form.CPtipo') and form.CPtipo EQ 4>
				and CPtipo = 4
				</cfif>
			</cfquery>
			<cfif chkExists.recordCount>
				<cf_throw message="#LB_ErrorFechaExistente#" errorcode="2055">
				<cfabort>
			</cfif>
			
		</cfif>
	</cfif>

	<cftransaction>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_datosCalenPago" datasource="#Session.DSN#">
				insert into CalendarioPagos 
				(Ecodigo, Tcodigo, CPdesde, CPhasta, CPfpago, CPperiodo, CPmes, Usucodigo, Ulocalizacion, CPcodigo, CPdescripcion, 
				CPtipo, CPnorenta, CPnocargasley, CPnocargas, CPnodeducciones 
                <cfif isdefined('form.CPTipoCalRenta') and LEN(TRIM(form.CPTipoCalRenta))>
                ,CPTipoCalRenta
                </cfif>
                ,IRcodigo
                )
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">,										
					<cfif isDefined("form.CPtipo") and Trim(form.CPtipo) EQ "1" or isDefined("form.CPtipo") and Trim(form.CPtipo) EQ "4">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPhasta)#">, <!---SI es ESPECIAL CPdesde = CPhasta--->
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPdesde)#">, 
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPhasta)#">, 
					<!---
					<cfif form.CPtipo NEQ 1 >	
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPdesde)#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPhasta)#">, 
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPfpago)#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPfpago)#">, 
					</cfif>
					---->
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPfpago)#">, 																
					
					<cfif isdefined('form.CPperiodo') and form.CPperiodo NEQ "">
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPperiodo#">, 									
					<cfelse>
						<cfset CPperiodo = DatePart('yyyy',form.CPhasta)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#CPperiodo#">,
					</cfif>
					<cfif isdefined('form.CPmes') and form.CPmes NEQ "">
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPmes#">, 									
					<cfelse>
						<cfset CPmes = DatePart('m',form.CPhasta)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#CPmes#">,
					</cfif>								
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPtipo#">,
					 
					<cfif isDefined("form.CPtipo") and (Trim(form.CPtipo) EQ "1" or TRIM(form.CPtipo) EQ 2)>
						<cfif isDefined("form.CPnorenta")> 1 <cfelse> 0 </cfif>,
						<cfif isDefined("form.CPnocargasley")> 1 <cfelse> 0 </cfif>,
						<cfif isDefined("form.CPnocargas")> 1 <cfelse> 0 </cfif>,	
                    <cfelseif isDefined("form.CPtipo") and form.CPtipo EQ 4>
                    	0,1,1,
					<cfelse>
						0,0,0,					
					</cfif> 
                    <cfif isDefined("form.CPtipo") and form.CPtipo EQ 4>
                    	1
                    <cfelse>
                    	<cfif isDefined("form.CPnodeducciones")> 1 <cfelse> 0 </cfif>	
                    </cfif>
                    <cfif isdefined('form.CPTipoCalRenta') and LEN(TRIM(form.CPTipoCalRenta))>
                    	,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPTipoCalRenta#">
                    </cfif>
					<cfif isdefined("Form.IRcodigo") and len(trim(Form.IRcodigo))>
                        ,<cfqueryparam cfsqltype="cf_sql_char" value="#form.IRcodigo#">
                    <cfelse>
                        ,null
                    </cfif>                    
                )
                <cf_dbidentity1>
			</cfquery>
			  <cf_dbidentity2 name="ABC_datosCalenPago">
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.Baja")>
	
			<cfquery name="rsCountCPid" datasource="#session.DSN#">
				select count(CPid) as cont
				from CalendarioPagos
				where CPfcalculo is null 
					and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
					and CPid not in (select RCNid from RCalculoNomina where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
					and CPid not in (select RCNid from HRCalculoNomina where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
			</cfquery>
	
					<!--- Eliminar calendario de pago -------------------------------------------------------------->		
								<cfif rsCountCPid.cont GT 0> 
									<cftry>
					<!--- inicia transaccion para eliminar el calendario de pago--->	

									<!--- Borrar las deducciones asociadas a los calendarios de pago--->
												<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
													<cfinvokeargument  name="nombreTabla" value="RHExcluirDeduccion">
													<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
													<cfinvokeargument name="condicion" value="CPid = #form.CPid#">
													<cfinvokeargument name="necesitaTransaccion" value="false">
												</cfinvoke>
										<cfquery datasource="#Session.DSN#">
											  delete from RHExcluirDeduccion where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
										</cfquery>
										 <!---Borrar las cargas asociadas a los calendarios de pago--->
												<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
													<cfinvokeargument  name="nombreTabla" value="RHCargasExcluir">
													<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
													<cfinvokeargument name="condicion" value="CPid = #form.CPid#">
													<cfinvokeargument name="necesitaTransaccion" value="false">
												</cfinvoke>

										<cfquery datasource="#Session.DSN#">
											  delete from RHCargasExcluir where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
										</cfquery>
										 <!---Borrar los conceptos asociados a los calendarios de pago--->
												<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
													<cfinvokeargument  name="nombreTabla" value="CCalendario">
													<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
													<cfinvokeargument name="condicion" value="CPid = #form.CPid#">
													<cfinvokeargument name="necesitaTransaccion" value="false">
												</cfinvoke>

										<cfquery datasource="#Session.DSN#">
											  delete from CCalendario where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
										</cfquery>
										 <!---Borrar los creditos fiscales asociados a los calendarios de pago--->
												<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
													<cfinvokeargument  name="nombreTabla" value="RHExcluirCFiscal">
													<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
													<cfinvokeargument name="condicion" value="CPid = #form.CPid#">
													<cfinvokeargument name="necesitaTransaccion" value="false">
												</cfinvoke>

										<cfquery datasource="#Session.DSN#">
											  delete from RHExcluirCFiscal where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
										</cfquery>
									 <!---borra el calendario de pago especificado--->
												<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
													<cfinvokeargument  name="nombreTabla" value="CalendarioPagos">
													<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
													<cfinvokeargument name="condicion" value="CPid = #form.CPid#">
													<cfinvokeargument name="necesitaTransaccion" value="false">
												</cfinvoke>

										<cfquery  datasource="#Session.DSN#">
											delete from CalendarioPagos where CPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#"> 
										</cfquery>
					
					<!--- fin de Eliminar calendario de pago -------------------------------------------------------------->
									
					<cfcatch type="any">
					<cf_throw message="#LB_ErrorIntegridadCP#" errorcode="201">
					</cfcatch>
				</cftry>
				
			<cfelse>
				<cf_throw message="#LB_ErrorEliminar#" errorcode="2065">
			</cfif>
		<cfelseif isdefined("Form.Cambio")>

			<cfparam name="cont" default="">
			<cfquery name="rsCountCPid" datasource="#session.DSN#">
				select count(CPid) as cont
					from CalendarioPagos
					where CPfcalculo is null 
					  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
					  and CPid not in (select RCNid from RCalculoNomina where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
					  and CPid not in (select RCNid from HRCalculoNomina where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
			</cfquery>
			<cfset cont = #rsCountCPid.cont#>

			<cfif (cont GT 0) >
				<cfquery name="Update2" datasource="#session.DSN#">
					update CalendarioPagos set					
						<cfif isDefined("form.CPtipo") and Trim(form.CPtipo) EQ "1">
							CPdesde		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.CPhasta)#">,<!---Si es ESPECIAL CPdesde = CPhasta---->
						<cfelse>
							CPdesde		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.CPdesde)#">,
						</cfif>						
						CPhasta 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.CPhasta)#">,
					<!----
					<cfif form.CPtipo NEQ 1>
						CPdesde		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.CPdesde)#">,
						CPhasta 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.CPhasta)#">,
					<cfelse>
						CPdesde		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPfpago)#">, 
						CPhasta 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPfpago)#">, 
					</cfif>
					---->
						CPfpago 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.CPfpago)#">,
					<cfif isdefined('form.CPperiodo') and form.CPperiodo NEQ "">
						CPperiodo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPperiodo#">, 									
					<cfelse>
						<cfset CPperiodo = DatePart('yyyy',form.CPhasta)>
						CPperiodo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPperiodo#">,
					</cfif>
					<cfif isdefined('form.CPmes') and form.CPmes NEQ "">
						CPmes 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPmes#">, 									
					<cfelse>
					<cfset CPmes = DatePart('m', form.CPhasta)>
						CPmes 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#CPmes#">,								
					</cfif>
					Usucodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					Ulocalizacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
					CPcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">,
					CPdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPdescripcion#">,
					CPtipo 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPtipo#">,

					<cfif isDefined("form.CPtipo") and (Trim(form.CPtipo) EQ "1" or Trim(form.CPtipo) EQ "2")>
						CPnorenta 	  = <cfif isDefined("form.CPnorenta")> 1 <cfelse> 0 </cfif>,
						CPnocargasley = <cfif isDefined("form.CPnocargasley")> 1 <cfelse> 0 </cfif>,
						CPnocargas 	  = <cfif isDefined("form.CPnocargas")> 1 <cfelse> 0 </cfif>,
                    <cfelseif isDefined("form.CPtipo") and form.CPtipo EQ 4>
						CPnorenta 	  = 0,
						CPnocargasley = 1,
						CPnocargas 	  = 1,							
					<cfelse>
						CPnorenta 	  = 0,
						CPnocargasley = 0,
						CPnocargas 	  = 0,							
					</cfif>	
                    <cfif isDefined("form.CPtipo") and form.CPtipo EQ 4>
                    	CPnodeducciones = 1
                  	<cfelse>
                        CPnodeducciones = <cfif isDefined("form.CPnodeducciones")> 1 <cfelse> 0 </cfif>					 								
                    </cfif>	
                     <cfif isdefined('form.CPTipoCalRenta') and LEN(TRIM(form.CPTipoCalRenta))>
						,CPTipoCalRenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPTipoCalRenta#">
                     </cfif>
                     <cfif isDefined("form.CPtipo") and Trim(form.CPtipo) EQ "1">
						<cfif isdefined("Form.IRcodigo") and len(trim(Form.IRcodigo))>
                            ,IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.IRcodigo#">
                        <cfelse>
                            ,IRcodigo=null
                        </cfif>
                     <cfelse>
                     	,IRcodigo=null
                     </cfif>                                         
					where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
				</cfquery>
				
				<!--- limpia la tabla de cargas a excluir si no es tipo especial o si CPnocargasley es 1 o si CPnocargas es 1 --->
				<cfif form.CPtipo EQ 0 or isDefined("form.CPnocargasley") or isDefined("form.CPnocargas") >
						<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
							<cfinvokeargument  name="nombreTabla" value="RHCargasExcluir">
							<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
							<cfinvokeargument name="condicion" value="CPid = #form.CPid#">
							<cfinvokeargument name="necesitaTransaccion" value="false">
						</cfinvoke>
					<cfquery datasource="#session.DSN#">
						delete from RHCargasExcluir
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#"> 
					</cfquery>
				</cfif>
			<cfelse>
				<cf_throw message="#LB_ErrorModificar#" errorcode="2070">
			</cfif>
		<cfelseif isdefined("Form.Generar")>																		
			<cfif isdefined('form.Tcodigo') and isdefined('form.CodTipoPago')>
				<cfif isdefined('form.GenAnticipos')>
					<cfif isdefined('form.CPAdesdeIni') and form.CPAdesdeIni NEQ "">
						<cfset Fdesde = LSParseDateTime(form.CPAdesdeIni)>
					<cfelse>
						<cfset Fdesde = Now()>
					</cfif>
				<cfelse>
					<!---  		El calendario de pagos para la empresa seleccionada esta limpio --->
					<cfif isdefined('form.ultFechaHasta') and form.ultFechaHasta NEQ "">	
						<cfset Fdesde=form.ultFechaHasta>	
					<cfelseif isdefined('form.CPdesdeIni') and form.CPdesdeIni NEQ "">
						<cfset Fdesde=LSParseDateTime(form.CPdesdeIni)>
					<cfelse>
						<cfset Fdesde = Now()>
					</cfif>									
				</cfif>		
				<cfset Fhasta="">																						
				<cfset Fpago="">
				<cfset CPcodigo ="">
				<cfset CPcodtemp="">
				<cfset CPid="">
				<cfset consec="">
				<cfset existe="">
				<cfset CPperiodo="">
				<cfset CPmes="">
					<cfloop index = "LoopCount" from = "1" to = "#form.cantPer#">
						<cfif isdefined('form.GenAnticipos')>
							<cfquery name="VerifTraslape" datasource="#session.DSN#">
								select 1
								from CalendarioPagos
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">
								and <cfqueryparam cfsqltype="cf_sql_date" value="#Fdesde#"> between CPdesde and CPhasta
								and CPtipo = 2 <!--- ANTICIPO DE SALARIO --->
							</cfquery>
							<cfif VerifTraslape.recordCount>
								<cf_throw message="#LB_ErrorFechaExistente#" errorcode="2055">
								<cfabort>
							</cfif>
							<cfset Periodo = DatePart('yyyy',Fdesde)>
							<cfset Mes = DatePart('m',Fdesde)>
						</cfif>
						<cfquery name="ABC_datosCalenPago_insert" datasource="#Session.DSN#">
							insert into CalendarioPagos 
							(Ecodigo, Tcodigo,CPdesde, CPhasta, CPfpago, CPperiodo, CPmes, CPcodigo, CPtipo, 
							<cfif isdefined('form.GenAnticipos')>
							CPnorenta,
							CPnocargasley,
							CPnocargas,
							CPnodeducciones,
							</cfif>
							Usucodigo, Ulocalizacion)
							values (									
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.Tcodigo)#">,								
							<cfif form.CodTipoPago EQ "0"> 		<!--- Semanal --->
								<cfset Lvar_Fdesde = Fdesde>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
								<cfif isdefined('form.GenAnticipos')>
									<cfset Fhasta=DateAdd("d", 2, "#Fdesde#")>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,																												
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
								</cfif>
								<cfset Fhasta=DateAdd("d", 6, "#Fdesde#")>
								<cfset Fdesde=DateAdd("d", 1, "#Fhasta#")>												
								<cfset Fpago=Fhasta>
								<cfif not isdefined('form.GenAnticipos')>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,																												
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fpago#">,
								</cfif>	
							<cfelseif form.CodTipoPago EQ "1">	<!--- Bisemanal --->
								<cfset Lvar_Fdesde = Fdesde>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">, 
								<cfif isdefined('form.GenAnticipos')>
									<cfset Fhasta=DateAdd("d", 6, "#Fdesde#")>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,																												
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
								</cfif>
								<cfset Fhasta=DateAdd("d", 13, "#Fdesde#")>
								<cfset Fdesde=DateAdd("d", 1, "#Fhasta#")>												
								<cfset Fpago=Fhasta>
								<cfif not isdefined('form.GenAnticipos')>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,																												
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fpago#">,
								</cfif>								
							<cfelseif form.CodTipoPago EQ "2">	<!--- Quincenal --->
								<cfset Lvar_Fdesde = Fdesde>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
								<cfif isdefined('form.GenAnticipos')>
									<cfset Fhasta=DateAdd("d", 6, "#Fdesde#")>	
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,																												
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
								</cfif>
								<cfif Day(Fdesde) EQ "01">
									<cfset Fhasta=DateAdd("d", 14, "#Fdesde#")>										
									<cfset Fdesde=Fhasta>																							
									<cfset Fdesde=DateAdd("d", 1, "#Fhasta#")>
								<cfelseif Day(Fdesde) EQ "16">
									<cfset Fhasta = CreateDate(Year(Fdesde), Month(Fdesde), DaysInMonth(Fdesde))>										 																															
									<cfset Fdesde=DateAdd("d", 1, "#Fhasta#")>
								<cfelse>
									<cfif isdefined('form.GenAnticipos')>
										<cfset Fhasta=DateAdd("d", 14, "#Fdesde#")>										
										<cfset Fdesde=DateAdd("d", 1, "#Fhasta#")>
									</cfif>
								</cfif>
								<cfset Fpago=Fhasta>
								<cfif not isdefined('form.GenAnticipos')>											
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fpago#">,
								</cfif>
							<cfelseif form.CodTipoPago EQ "3">	<!--- Mensual --->		
								<cfset Lvar_Fdesde = Fdesde>																	
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">,
								<cfif isdefined('form.GenAnticipos')>
									<cfset Fhasta=DateAdd("d", 14, "#Fdesde#")>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,																												
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
								</cfif>
								<cfset Fhasta=DateAdd("d", (DaysInMonth(Fdesde) - 1), "#Fdesde#")>
								<cfset Fdesde=DateAdd("d", 1, "#Fhasta#")>												
								<cfset Fpago=Fhasta>
								<cfif not isdefined('form.GenAnticipos')>
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fpago#">,
								</cfif>
							</cfif>
								<cfif not isdefined('form.GenAnticipos')>
									<cfset Periodo = DatePart('yyyy',Fhasta)>
									<cfset Mes = DatePart('m',Fhasta)>
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mes#">,
								' ', 	
								<cfif isdefined('form.GenAnticipos')>
									2,
								<cfelse>
									0,
								</cfif>
								<cfif isdefined('form.GenAnticipos')>
									<cfif isDefined("form.CPtipo") and form.CPtipo EQ 4>
                                    	0,1,1,1,
                                    <cfelse>
                                        1,1,1,1,
                                    </cfif>
								</cfif>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">
							)
							  <cf_dbidentity1 datasource="#session.DSN#">
						</cfquery>
						<cf_dbidentity2 datasource="#session.DSN#" name="ABC_datosCalenPago_insert">
							<cfset existe = 1>
							<cfset consec = 0>
							<cfif isdefined('form.GenAnticipos')>
								<cfset CPperiodo = datepart('yyyy',"#Lvar_Fdesde#")>
								<cfset CPmes = datepart('m',"#Lvar_Fdesde#")>
							<cfelse>
								<cfset CPperiodo = datepart('yyyy',"#Fhasta#")>
								<cfset CPmes = datepart('m',"#Fhasta#")>
							</cfif>
							
							<cfset CPcodtemp = '#CPperiodo#' & '-'>
								<cfif CPmes LT 10 >
								<cfset CPcodtemp = CPcodtemp & '0' & '#CPmes#'>
								<cfelse>
								<cfset CPcodtemp = CPcodtemp & '#CPmes#'>
								</cfif>
								<cfset CPcodtemp = CPcodtemp & '-'>
						
							<cfloop condition="(existe eq 1) and (consec LT 999)">
								<cfset consec = consec + 1>
							
							
							<cfset CPcodigo = CPcodtemp >
								<cfif consec LT 10 >
								<cfset CPcodigo = CPcodigo & '00' & '#consec#'>
								<cfelseif consec LT 100>
								<cfset CPcodigo = CPcodigo & '0' & '#consec#'>
								<cfelse>
								<cfset CPcodigo = CPcodigo & '#consec#'>
								</cfif>
								
								<cfquery name="existe1" datasource="#session.DSN#">
									select 1 
											from CalendarioPagos 
											where CPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CPcodigo#">
											and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
											and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Tcodigo)#">
								</cfquery>
								<cfif isdefined("existe1") and  existe1.recordcount EQ 0>
									<cfset existe = 0>
								</cfif>
							</cfloop>
							
							<cfif existe EQ 0>
								<cfquery datasource="#session.DSN#" name="update1">
									update CalendarioPagos 
									set CPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CPcodigo#">
									where CPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ABC_datosCalenPago_insert.identity#">
								</cfquery>
							<cfelse>
								<cf_throw message="#LB_ErrorActualizarCPcodigo#" errorcode="2070">
							</cfif>
					</cfloop>
			</cfif>
		<cfelseif isdefined("Form.btnAgregarTipoDeduccion")>
			<cfquery name="ABC_datosCalenPago" datasource="#Session.DSN#">
				insert into TDCalendario (CPid, TDid)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
				)
			</cfquery>
			<cfset modo = "CAMBIO">
				
		<cfelseif isdefined("Form.btnAgregarConcepto")>
				
			<cfquery name="ABC_datosCalenPago" datasource="#Session.DSN#">
				insert into CCalendario (CPid, CIid)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
				)
			</cfquery>
			<cfset modo = "CAMBIO">
									

		<cfelseif isdefined("Form.btnAgregarCredito")>
				
			<cfquery datasource="#Session.DSN#">
			insert into RHExcluirCFiscal (CPid, CDid)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid#">
				)
			</cfquery>
			<cfset modo = "CAMBIO">
			
		<cfelseif isdefined("Form.btnBorrarTipoDeduccion.X")>
						<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
							<cfinvokeargument  name="nombreTabla" value="TDCalendario">
							<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
							<cfinvokeargument name="condicion" value="CPid = #form.CPid# and TDid = #form.TDid_#">
							<cfinvokeargument name="necesitaTransaccion" value="false">
						</cfinvoke>
			<cfquery name="ABC_datosCalenPago" datasource="#Session.DSN#">
				delete from TDCalendario 
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid_#">
			</cfquery>
			<cfset modo = "CAMBIO">	  
				
		<!----============ Inserta TODAS las deducciones en las deducciones a excluir ============-----> 
		<cfelseif isdefined("form.btnAgregarDeduMasivo") and isdefined("form.CPid") and len(trim(form.CPid))>
			<cfquery name="insertaDeduccionesMasivas" datasource="#session.DSN#">
				insert into RHExcluirDeduccion (CPid, TDid)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">, TDid
				from TDeduccion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and TDid not in(select TDid
									from RHExcluirDeduccion
									where  CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">)
			</cfquery>
		
		<cfelseif isdefined("Form.btnAgregarTipoDeduccionEx")>
			<cfquery name="ABC_datosCalenPago_verifica" datasource="#Session.DSN#">
				select 1
				from RHExcluirDeduccion
				where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.exTDid#">
				and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
			</cfquery>
			<cfif isdefined("ABC_datosCalenPago_verifica") and (ABC_datosCalenPago_verifica.recordcount EQ 0)>				
				<cfquery name="ABC_datosCalenPago_insertar1" datasource="#session.DSN#">
					insert into RHExcluirDeduccion (CPid, TDid)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.exTDid#">)
				</cfquery>
			<cfelse>
				<cfquery name="ABC_datosCalenPago" datasource="#Session.DSN#">
					update RHExcluirDeduccion
						set TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.exTDid#">
						where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.exTDid#">
							and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				</cfquery>
			</cfif>
			<cfset modo = "CAMBIO">
		<cfelseif isdefined("Form.btnBorrarDeduccionEx") and len(trim(Form.btnBorrarDeduccionEx)) gt 0>
		
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
				<cfinvokeargument  name="nombreTabla" value="RHExcluirDeduccion">
				<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
				<cfinvokeargument name="condicion" value="CPid = #form.CPid# and TDid = #form.exTDid_#">
				<cfinvokeargument name="necesitaTransaccion" value="false">
			</cfinvoke>

			<cfquery name="ABC_datosCalenPago" datasource="#Session.DSN#">
				delete from RHExcluirDeduccion 
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.exTDid_#">
			</cfquery>

			<cfset modo = "CAMBIO">	  
		<cfelseif isdefined("Form.btnBorrarConcepto.X")>
				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
					<cfinvokeargument  name="nombreTabla" value="CCalendario">
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="CPid = #form.CPid# and CIid = #form.CIid_#">
					<cfinvokeargument name="necesitaTransaccion" value="false">
				</cfinvoke>
			<cfquery name="ABC_datosCalenPago" datasource="#Session.DSN#">
				delete from CCalendario 
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid_#">
			</cfquery>
			<cfset modo = "CAMBIO">	  

		<cfelseif isdefined("Form.btnBorrarCredito.x") and len(trim(form.CDid_))>
				<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
					<cfinvokeargument  name="nombreTabla" value="RHExcluirCFiscal">
					<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
					<cfinvokeargument name="condicion" value="CPid = #form.CPid# and CDid = #form.CDid_#">
					<cfinvokeargument name="necesitaTransaccion" value="false">
				</cfinvoke>			
			<cfquery datasource="#Session.DSN#">
				delete from RHExcluirCFiscal 
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid_#">
			</cfquery>
			<cfset modo = "CAMBIO">
			
		<cfelseif isdefined("Form.btnAgregarCarga") or (isdefined("Form.btnBorrarCarga.x") and len(trim(form.DClinea_))) >
			<cfquery name="rsCountCPid" datasource="#session.DSN#">
				select count(CPid) as cont
					from CalendarioPagos
					where CPfcalculo is null 
					  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
					  and CPid not in (select RCNid from RCalculoNomina where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
					  and CPid not in (select RCNid from HRCalculoNomina where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
			</cfquery>
			<cfset cont = rsCountCPid.cont>

			<cfif cont GT 0 >
				<cfif isdefined("Form.btnAgregarCarga")>
					<cfquery datasource="#Session.DSN#">
						insert into RHCargasExcluir(CPid, DClinea)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
						)
					</cfquery>
					<cfset modo = "CAMBIO">
		
				<cfelse>
						<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo">
							<cfinvokeargument  name="nombreTabla" value="RHCargasExcluir">
							<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
							<cfinvokeargument name="condicion" value="CPid = #form.CPid# and DClinea = #form.DClinea_#">
							<cfinvokeargument name="necesitaTransaccion" value="false">
						</cfinvoke>	
					<cfquery datasource="#Session.DSN#">
						delete from RHCargasExcluir
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
						  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea_#">
					</cfquery>
					<cfset modo = "CAMBIO">
				</cfif>	
			<cfelse>
				<cf_throw message="#LB_ErrorModificar#" errorcode="2070">
				
			</cfif>					
		</cfif>
	</cftransaction>
</cfif>

<cfparam name="action" default="calendarioPagos.cfm">
<cfif isdefined("form.relacion")>
	<cfset action = "calendarioPagos_relacion.cfm">
</cfif>

<cfoutput>
<cfif isdefined('ABC_datosCalenPago.identity')>
	<cfset modo 	 = 'CAMBIO'>
    <cfset form.CPid = ABC_datosCalenPago.identity>
</cfif>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#<cfelseif isdefined("form.relacion")>CAMBIO</cfif>">
	<input name="Tcodigo" type="hidden" value="<cfif isdefined("form.Tcodigo")>#Trim(form.Tcodigo)#</cfif>">
	<cfif isdefined("Form.CPid") and not isdefined('form.BAJA')>
	<input name="CPid" type="hidden" value="<cfif isdefined("form.CPid")>#form.CPid#</cfif>">			
	</cfif>
	<cfif isdefined("Form.PageNum2")>
	<input type="hidden" name="PageNum2" id="PageNum2" value="#Form.PageNum2#">
	</cfif>

	<cfif isdefined("form.fCPdesde") and Len(Trim(form.fCPdesde)) NEQ 0>
		<input type="hidden" name="fCPdesde" value="#form.fCPdesde#" />
	</cfif>
	<cfif isdefined("form.fCPhasta") and Len(Trim(form.fCPhasta)) NEQ 0>
		<input type="hidden" name="fCPhasta" value="#form.fCPhasta#" />
	</cfif>
	<cfif isdefined("form.fCPfpago") and Len(Trim(form.fCPfpago)) NEQ 0>
		<input type="hidden" name="fCPfpago" value="#form.fCPfpago#" />
	</cfif>
	<cfif isdefined("form.fCPcodigo") and Len(Trim(form.fCPcodigo)) NEQ 0>
		<input type="hidden" name="fCPcodigo" value="#form.fCPcodigo#" />
	</cfif>
	<cfif isdefined("form.f_estado") and Len(Trim(form.f_estado)) NEQ 0>
		<input type="hidden" name="f_estado" value="#form.f_estado#" />
	</cfif>
	<cfif isdefined("form.f_tipo") and Len(Trim(form.f_tipo)) NEQ 0>
		<input type="hidden" name="f_tipo" value="#form.f_tipo#" />
	</cfif>
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
