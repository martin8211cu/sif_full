<cfif (isdefined("form.submitMenu") and form.submitMenu EQ 1) or isdefined("form.Guardar") or isdefined("form.GuardarContinuar")>
	<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>
		<!--- Datos de la Cuenta --->
		<cfquery name="rsCuenta" datasource="#Session.DSN#">
			select a.CTtipoUso
			from ISBcuenta a
			where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			and a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
		</cfquery>
	
		<!--- Si la cuenta que se está modificando es de tipo acceso para agente, averiguar la cuenta de tipo facturacion del agente --->	
		<cfif rsCuenta.CTtipoUso EQ 'A'>
			<cfquery name="rsDatosAgente" datasource="#Session.DSN#">
				select a.CTidFactura
				from ISBagente a
				where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
				and a.CTidAcceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			</cfquery>
			<cfif rsDatosAgente.recordCount GT 0>
				<cfset LvarFacturacionAgente = rsDatosAgente.CTidFactura>
			</cfif>
		</cfif>
	</cfif>

	<!------------------------------ Obtener el nombre y barrio de la persona --------------------------------->
	<cfinvoke component="saci.comp.ISBpersona" method="Get" returnvariable="persona">
		<cfinvokeargument name="Pquien" value="#form.Pquien#">
	</cfinvoke>
	
	<cfif persona.Ppersoneria EQ 'J'>
		<cfset realname = Trim(persona.PrazonSocial)>
	<cfelse>
		<cfset realname = Trim(Trim(persona.Pnombre) & ' ' & Trim(persona.Papellido & ' ' & persona.Papellido2))>
	</cfif>

	<cfset barrio ="">
	<cfif len(trim(persona.Pbarrio))>	<cfset barrio = Trim(persona.Pbarrio)>	</cfif>
	
	<!--- Obtener la cantidad máxima de logines que se pueden asignar por paquete --->
	<cfinvoke component="saci.ws.intf.base" method="servpaq" returnvariable="maxlogines">
	</cfinvoke>
	
	<cfquery name="maxServicios" datasource="#session.dsn#">
		select max(cant) as cantidad
		from (
			select coalesce(sum(SVcantidad), 0) as cant
			from ISBservicio
			where Habilitado = 1
			group by PQcodigo
		) temporal
	</cfquery>
	
	<cfset maxServicios.cantidad = maxlogines>
	
	<cfquery name="rsServiciosDisponibles" datasource="#session.dsn#">
		select TScodigo
		from ISBservicioTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by TScodigo
	</cfquery>
		
		
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="VendedorGenerico"
	Pcodigo="222" />	
	
	<cfquery name="rsAgenteGenerico" datasource="#session.dsn#">
		select a.AGid
		from ISBagente a
		  inner join ISBvendedor b
			on a.AGid = b.AGid
		Where b.Vid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#VendedorGenerico#">
	</cfquery>
		
	<cftransaction>

		<!------------------------------------ CAMBIO DE DATOS DE CUENTA -------------------------------->
		<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>

			<cfinvoke component="saci.comp.ISBcuenta" method="Cambio">
				<cfinvokeargument name="CTid" value="#form.CTid#">
				<cfinvokeargument name="Pquien" value="#form.Pquien#">
				<cfinvokeargument name="CTdesde" value="#LSParseDateTime(form.CTapertura)#">
				<cfinvokeargument name="CCclaseCuenta" value="#form.CCclaseCuenta#">
				<cfinvokeargument name="GCcodigo" value="#form.GCcodigo#">
				<cfinvokeargument name="CTobservaciones" value="#UCase(form.CTobservaciones)#">
				<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
			</cfinvoke>
			
			<!--- Cambio de Datos en la cuenta de Facturacion --->
			<cfif isdefined("LvarFacturacionAgente") and Len(Trim(LvarFacturacionAgente))>
				<cfinvoke component="saci.comp.ISBcuenta" method="Cambio">
					<cfinvokeargument name="CTid" value="#LvarFacturacionAgente#">
					<cfinvokeargument name="Pquien" value="#form.Pquien#">
					<cfinvokeargument name="CTdesde" value="#LSParseDateTime(form.CTapertura)#">
					<cfinvokeargument name="CCclaseCuenta" value="#form.CCclaseCuenta#">
					<cfinvokeargument name="GCcodigo" value="#form.GCcodigo#">
				</cfinvoke>
			</cfif>

		<!------------------------------------- ALTA DE DATOS DE CUENTA --------------------------------->
		<cfelse>

			<cfinvoke component="saci.comp.ISBcuenta" method="Alta" returnvariable="cuenta">
				<cfinvokeargument name="Pquien" value="#form.Pquien#">
				<cfinvokeargument name="CUECUE" value="0">
				<cfinvokeargument name="CTapertura" value="#LSParseDateTime(form.CTapertura)#">
				<cfinvokeargument name="CTdesde" value="#LSParseDateTime(form.CTapertura)#">
				<cfinvokeargument name="CTcobrable" value="C">
				<cfinvokeargument name="CCclaseCuenta" value="#form.CCclaseCuenta#">
				<cfinvokeargument name="GCcodigo" value="#form.GCcodigo#">
				<cfinvokeargument name="CTpagaImpuestos" value="false">
				<cfinvokeargument name="Habilitado" value="false">
				<cfinvokeargument name="CTobservaciones" value="#form.CTobservaciones#">
				<cfinvokeargument name="CTcomision" value="0">
				<cfinvokeargument name="CTtipoUso" value="U">
			</cfinvoke>			
			<cfset Form.CTid = cuenta>
			
			<!------------------------------- ALTA DE MECANISMOS DE ENVIO -------------------------------->
			<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Alta">
				<cfinvokeargument name="CTid" value="#form.CTid#">
				<cfinvokeargument name="CTbarrio" value="#barrio#">
				<cfinvokeargument name="CTcopiaModo" value="S">
			</cfinvoke>

			<!--------------------------------- ALTA DE FORMAS DE COBRO ---------------------------------->
			<cfinvoke component="saci.comp.ISBcuentaCobro" method="Alta">
				<cfinvokeargument name="CTid" value="#form.CTid#">
				<cfinvokeargument name="CTcobro" value="2">
			</cfinvoke>
		
		</cfif>
		
		
		<!--- Registro de Localizacion de la cuenta --->
		<cfif isdefined("form.CTid")>
			<cfif isdefined("form.Lid") and len(trim(form.Lid))>	
					
				<!--- Modifica los datos de la ISBlocalizacion --->
				<cfinvoke component="saci.comp.ISBlocalizacion" method="Cambio">
					<cfinvokeargument name="Lid" value="#form.Lid#">
					<cfinvokeargument name="RefId" value="#form.CTid#">
					<cfinvokeargument name="Ltipo" value="C">
					
					<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
						<cfinvokeargument name="CPid" value="#form.CPid#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form.Papdo#">
					<cfinvokeargument name="LCid" value="#form.LCID_3#">
					<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
					<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form.Ptelefono1)#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form.Ptelefono2)#">
					<cfinvokeargument name="Pfax" value="#trim(form.Pfax)#">
					<cfinvokeargument name="Pemail" value="#trim(form.Pemail)#">
					<cfinvokeargument name="ts_rversion" value="#trim(form.ts_rversionl)#">
				</cfinvoke>	
			
			<cfelse>	
				
				<!--- Agrega los datos de la ISBlocalizacion --->	
				<cfinvoke component="saci.comp.ISBlocalizacion" method="Alta"  returnvariable="idReturn">
					
					<cfinvokeargument name="RefId" value="#form.CTid#">
					<cfinvokeargument name="Ltipo" value="C">					
					
					<cfif isdefined("Form.CPid") and Len(Trim(Form.CPid))>
						<cfinvokeargument name="CPid" value="#form.CPid#">
					</cfif>
					<cfinvokeargument name="Papdo" value="#form.Papdo#">
					<cfinvokeargument name="LCid" value="#form.LCID_3#">
					<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#">
					<cfinvokeargument name="Pbarrio" value="#form.Pbarrio#">
					<cfinvokeargument name="Ptelefono1" value="#trim(form.Ptelefono1)#">
					<cfinvokeargument name="Ptelefono2" value="#trim(form.Ptelefono2)#">
					<cfinvokeargument name="Pfax" value="#trim(form.Pfax)#">
					<cfinvokeargument name="Pemail" value="#trim(form.Pemail)#">
				</cfinvoke>
				<cfif idReturn eq -1>
					<cfthrow message="Error: No se pudo agregar la persona, verifique los datos.">
				<cfelse>
					<cfset form.Lid = idReturn>  
				</cfif>
				
			</cfif>
			
		</cfif>
		

		<!--- Registro de Atributos Extendidos de la cuenta --->
		<cfif isdefined("form.CTid")>
			<cfinvoke component="saci.comp.atrExtendidosPersona" method="Alta_Cambio">
				<cfinvokeargument 	name="id" 				value="#form.CTid#">
				<cfinvokeargument 	name="identificacion" 	value="">
				<cfinvokeargument 	name="tipo" 			value="4">
				<cfinvokeargument 	name="Usuario" 			value="#session.Usucodigo#">
				<cfinvokeargument 	name="Ecodigo" 			value="#session.Ecodigo#">
				<cfinvokeargument	name="Conexion" 		value="#session.DSN#">
				<cfinvokeargument 	name="form" 			value="#form#">
			</cfinvoke>
		</cfif>
		
		<!------ CAMBIO O ALTA DE PRODUCTOS Y LOGINES SEGUN CANTIDAD DE PAQUETES CONFIGURADOS EN LA CUENTA ------>
		<cfloop from="1" to="#form.cantPaquetes#" index="i">
			<!-------------------------- Obtener la cuenta de facturación del agente ------------------------->
			<cfif Len(Trim(Form['PQcodigo' & i])) and isdefined("form.AgPaquete") and Len(Trim(form.AgPaquete))>
				<cfquery name="dataAgente" datasource="#Session.DSN#">
					select a.CTidAcceso, a.CTidFactura
					from ISBagente a
						inner join ISBagenteOferta b
							on b.AGid = a.AGid
							and b.Habilitado = 1
							and b.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form['PQcodigo' & i]#">
					where a.AGid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.vendedor.agentes#" list="yes" separator=",">)
				</cfquery>
				<cfif dataAgente.recordCount GT 0>
					<cfset LvarCTidFactura = dataAgente.CTidFactura>
				<cfelse>
					<cfset LvarCTidFactura = Form.CTid>
				</cfif>
			<cfelse>
				<cfset LvarCTidFactura = Form.CTid>
			</cfif>
			
			<!----- Obtencion de Datos de Suscriptor de Cable Modem en caso de que el paquete sea de tipo CABM ----->
			<cfif not (isdefined("form.CNnumero#i#") and Len(Trim(Form['CNnumero' & i])))>
				<cfset Form['CNnumero' & i] = "0">
			</cfif>

			<!------------------------------------ CAMBIO DE PRODUCTO ------------------------------------------>
			<cfif isdefined("Form.Contratoid#i#") and Len(Trim(Form['Contratoid' & i]))>
				<cfset contrato = Form['Contratoid' & i]>
				<cfset quota = Form['PQmailQuota' & i]>

				<cfif Len(Trim(Form['PQcodigo' & i]))>

					<!------------------------------------------ CAMBIO DE PAQUETE ----------------------------------->
					<cfinvoke component="saci.comp.ISBproducto" method="Cambio">
						<cfinvokeargument name="Contratoid" value="#contrato#">
						<cfinvokeargument name="CTid" value="#form.CTid#">
						<cfinvokeargument name="CTidFactura" value="#LvarCTidFactura#">
						<cfinvokeargument name="PQcodigo" value="#Form['PQcodigo' & i]#">
						<cfif isdefined("session.saci.vendedor.id") and Len(Trim(session.saci.vendedor.id))>
							<cfinvokeargument name="Vid" value="#session.saci.vendedor.id#">
						</cfif>
						<cfinvokeargument name="CTcondicion" value="#Form['CTcondicion' & i]#">
						<cfif isdefined("form.CNsuscriptor#i#") and Len(Trim(Form['CNsuscriptor' & i]))>
							<cfinvokeargument name="CNsuscriptor" value="#Form['CNsuscriptor' & i]#">
						</cfif>
						<cfinvokeargument name="CNnumero" value="#Form['CNnumero' & i]#">
						<cfinvokeargument name="CNapertura" value="#Now()#">
					</cfinvoke>

					<!------------------------------------------ CAMBIO DE LOGINES ----------------------------------->
					<cfloop from="1" to="#maxServicios.cantidad#" index="k">
						<cfset loginid = Form['LGnumero_' & k & '_' & contrato]>
						<cfset telefono = "">
						<cfif Form['vPQtelefono' & i] EQ 1>
							<cfset telefono = Trim(Form['LGtelefono_' & k & '_' & contrato])>
						</cfif>

						<cfif isdefined("Form.Login_#k#_#contrato#") and Len(Trim(Form['Login_' & k & '_' & contrato]))>
							<cfset login = Form['Login_' & k & '_' & contrato]>
							
							<!--- Verificar existencia de Login antes de guardar y cancelar el guardado de los logines enviando un mensaje de error --->
							<cfinvoke component="saci.comp.ISBlogin" method="Existe" returnvariable="ExisteLogin">
								<cfinvokeargument name="LGlogin" value="#login#">
								<cfif Len(Trim(loginid))>
									<cfinvokeargument name="LGnumero" value="#loginid#">
								</cfif>
							</cfinvoke>
							
							<cfif Len(Trim(loginid))>
								<cfif not ExisteLogin>
									<!--- Desasignar sobres asignados anteriormente --->
									
									<cfquery name="rsSobre" datasource="#session.dsn#">
										select Snumero
										from ISBlogin
										where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#loginid#">
									</cfquery>
								
									<cfif Len(Trim(rsSobre.Snumero))>
										<cfinvoke component="saci.comp.ISBsobres" method="Desasignar_Login">
											<cfinvokeargument name="Snumero" value="#rsSobre.Snumero#">
										</cfinvoke>
									</cfif>
									
									<!--- Lista de Servicios asociados al Login --->
									<cfset serv = "">
									<cfloop query="rsServiciosDisponibles">
										<cfif isdefined("Form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#k#_#contrato#")>
											<cfset serv = serv & Iif(Len(Trim(serv)), DE(","), DE("")) & Form['chk_#Trim(rsServiciosDisponibles.TScodigo)#_#k#_#contrato#']>
										</cfif>
									</cfloop>
									
									<!--- Indica si algun servicio del login es de tipo correo --->
									<cfif listLen(serv)>
										<cfquery name="rsCorreo" datasource="#session.dsn#">
											select count(1)as cant
											from ISBservicioTipo
											where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#serv#">)
												and TStipo='C'
										</cfquery>
									</cfif>
									
									<!--- Modificar Login --->
									<cfinvoke component="saci.comp.ISBlogin" method="Cambio">
										<cfinvokeargument name="LGnumero" value="#loginid#">
										<cfif isdefined("Form.Snumero_#k#_#contrato#") and Len(Trim(Form['Snumero_' & k & '_' & contrato]))>
											<cfinvokeargument name="Snumero" value="#Form['Snumero_' & k & '_' & contrato]#">
										</cfif>
										<cfinvokeargument name="Contratoid" value="#contrato#">
										<cfinvokeargument name="LGlogin" value="#login#">
										<cfinvokeargument name="LGrealName" value="#realname#">
										<cfif isdefined("rsCorreo") and rsCorreo.cant GT 0 >
											<cfinvokeargument name="LGmailQuota" value="#quota#">
										</cfif>
										
										
										<cfinvokeargument name="LGroaming" value="false">
										<cfinvokeargument name="LGprincipal" value="#k eq 1#">
										<cfinvokeargument name="Habilitado" value="false">
										<cfinvokeargument name="LGbloqueado" value="false">
										<cfinvokeargument name="LGmostrarGuia" value="false">
										<cfinvokeargument name="LGtelefono" value="#telefono#">
										<cfinvokeargument name="registrar_en_bitacora" value="false">
									</cfinvoke>
									
									<!--- Modificar los servicios del Login --->
									<cfinvoke component="saci.comp.ISBlogin" method="Cambio_Servicios">
										<cfinvokeargument name="LGnumero" value="#loginid#">
										<cfinvokeargument name="Servicios" value="#serv#">
										<cfinvokeargument name="registrar_en_bitacora" value="false">
									</cfinvoke>
									
									<!--- Selecciona los servicios que fueron deseleccinados--->
									<cfquery name="rsDelTScodigo" datasource="#session.dsn#">
										select TScodigo
										from ISBserviciosLogin
										where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#loginid#">
										<cfif Len(serv)>
											and TScodigo not in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#serv#">)
										</cfif>
									</cfquery>
									<!--- Se eliminan los servicios que fueron deselecionados--->	
									<cfif rsDelTScodigo.recordCount GT 0>
										<cfset noServ = valueList(rsDelTScodigo.TScodigo)>
										<cfinvoke component="saci.comp.ISBserviciosLogin" method="Elimina_ListaServicio">
											<cfinvokeargument name="LGnumero" value="#loginid#">
											<cfinvokeargument name="listTScodigo" value="#noServ#">
										</cfinvoke>
									</cfif>
								</cfif>
								
							<cfelse>
								<cfif not ExisteLogin>
									<!--- Insertar Login --->
									<cfset serv = "">
									<cfloop query="rsServiciosDisponibles">
										<cfif isdefined("Form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#k#_#contrato#")>
											<cfset serv = serv & Iif(Len(Trim(serv)), DE(","), DE("")) & Form['chk_#Trim(rsServiciosDisponibles.TScodigo)#_#k#_#contrato#']>
										</cfif>
									</cfloop>
									
									<!--- Indica si algun servicio del login es de tipo correo --->
									<cfif listLen(serv)>
										<cfquery name="rsCorreo" datasource="#session.dsn#">
											select count(1)as cant
											from ISBservicioTipo
											where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#serv#">)
												and TStipo='C'
										</cfquery>
									</cfif>
									
									<cfinvoke component="saci.comp.ISBlogin" method="Alta" returnvariable="loginid">
										<cfif isdefined("Form.Snumero_#k#_#contrato#") and Len(Trim(Form['Snumero_' & k & '_' & contrato]))>
											<cfinvokeargument name="Snumero" value="#Form['Snumero_' & k & '_' & contrato]#">
										</cfif>
										<cfinvokeargument name="Contratoid" value="#contrato#">
										<cfinvokeargument name="LGlogin" value="#login#">
										<cfinvokeargument name="LGrealName" value="#realname#">
										<cfif isdefined("rsCorreo") and rsCorreo.cant GT 0 >
										<cfinvokeargument name="LGmailQuota" value="#quota#">
										</cfif>
										
										<cfinvokeargument name="LGroaming" value="false">
										<cfinvokeargument name="LGprincipal" value="#k eq 1#">
										<cfinvokeargument name="Habilitado" value="false">
										<cfinvokeargument name="LGbloqueado" value="false">
										<cfinvokeargument name="LGmostrarGuia" value="false">
										<cfinvokeargument name="LGtelefono" value="#telefono#">
										<cfinvokeargument name="Servicios" value="#serv#">
										<cfinvokeargument name="registrar_en_bitacora" value="false">
									</cfinvoke>
								</cfif>
								
							</cfif>
							
							<!--- Asignar el nuevo sobre si viene asignado --->
							<cfif isdefined("Form.Snumero_#k#_#contrato#") and Len(Trim(Form['Snumero_' & k & '_' & contrato]))>
								<cfif len(trim(serv))>
									<cfquery name="rsServExistentes" datasource="#session.dsn#">
										select count(1) as cant
										from ISBservicioTipo
										where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#serv#">)
											and TStipo in ('C','A')
									</cfquery>
		
									<cfif isdefined('rsServExistentes') and rsServExistentes.cant GT 0>
											
											
											<cfquery name="rsvalidaSobre" datasource="#session.dsn#">
												select *
												from ISBsobres
												where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form['Snumero_' & k & '_' & contrato]#">
												and Sestado  = <cfqueryparam cfsqltype="cf_sql_varchar" value="0">
												and Sdonde in ('1','2') <!---Asignado a la Empresa o al  Agente Autorizado--->
												
												<cfif session.saci.vendedor.agentes neq 0 and session.saci.vendedor.interno eq 0>
													and AGid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.vendedor.agentes#" list="yes" separator=",">)
											 	<cfelse>
													<cfif rsAgenteGenerico.RecordCount eq 0>
													<cfthrow message="No se ha seleccionado el vendedor genérico en parámetros globales.">
													</cfif>
													and AGid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAgenteGenerico.AGid#" list="yes" separator=",">)
												</cfif>
											</cfquery>		
											
											<cfif rsvalidaSobre.RecordCount eq 0>
										
												<cfif session.saci.vendedor.agentes eq 0 or session.saci.vendedor.interno eq 1>
													<cfset AGidAgente = rsAgenteGenerico.AGid>
												<cfelse>
													<cfset AGidAgente = session.saci.vendedor.agentes>
												</cfif>
												<cfthrow message="El número de sobre #Form['Snumero_' & k & '_' & contrato]# no está asignado al agente #AGidAgente# o ya está en uso">
											</cfif>
											
											<cfset Sgenero = "undefined">
											<cfif ListFind(serv,'ACCS') and ListFind(serv,'MAIL')> <!--- seleccionaron ambos--->
												<cfset Sgenero = 'M'>
											<cfelseif ListFind(serv,'ACCS')>
												<cfset Sgenero = 'A'>
											<cfelseif ListFind(serv,'MAIL')>	
												<cfset Sgenero = 'C'>
											</cfif>
												
											<cfquery name="rsServSobres" datasource="#session.dsn#">
												select *
												from ISBsobres
												where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form['Snumero_' & k & '_' & contrato]#">
												<cfif Sgenero eq 'A'>
													and Sgenero in ('A','M')
												<cfelseif Sgenero eq 'C'>
													and Sgenero in ('C','M')
												<cfelseif Sgenero eq 'M'>
													and Sgenero  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Sgenero#">
												</cfif>
											</cfquery>							
												
											<cfif rsServSobres.RecordCount eq 0>
												<cfthrow message="El sobre número #Form['Snumero_' & k & '_' & contrato]# no tiene los servicios #serv# definidos en su género.">	
											</cfif>
										
										
										<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
											<cfinvokeargument name="Snumero" value="#Form['Snumero_' & k & '_' & contrato]#">
											<cfinvokeargument name="LGnumero" value="#loginid#">
										</cfinvoke>
									<cfelse>
										<cfthrow message="Error, debe seleccionar al menos un servicio de correo o de acceso para el login: #login#.">
									</cfif>								
								<cfelse>
									<cfthrow message="Error, debe seleccionar al menos un servicio de correo o de acceso para el login: #login#.">
								</cfif>
							</cfif>
							
						<!-------------------------------- BAJA DE LOGINES ---------------------------------------->
						<!--- Si no viene el nombre del login y ya tenía un id de login asignado, entonces debe darlos de baja --->
						<cfelseif Len(Trim(loginid))>
							<!--- Desasignar sobres asignados anteriormente --->
							<cfquery name="rsSobre" datasource="#session.dsn#">
								select Snumero
								from ISBlogin
								where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#loginid#">
							</cfquery>
							<cfif Len(Trim(rsSobre.Snumero))>
								<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
									<cfinvokeargument name="Snumero" value="#rsSobre.Snumero#">
								</cfinvoke>
							</cfif>
							
							<!--- Eliminar Login --->
							<cfinvoke component="saci.comp.ISBlogin" method="Baja">
								<cfinvokeargument name="LGnumero" value="#loginid#">
								<cfinvokeargument name="registrar_en_bitacora" value="false">
							</cfinvoke>
						
						</cfif>
					</cfloop>
					<!-------------------------------------- FIN CAMBIO DE LOGINES ---------------------------------->

					<!--- *************************************************************************************** --->
					<!--- *************************************************************************************** --->
					<!--- 						ACTUALIZACION DE GARANTIAS EN CASO DE QUE AMERITE 				  --->
					<!--- *************************************************************************************** --->
					<!--- *************************************************************************************** --->

				<!----------------------------------------  BAJA DE PRODUCTO ------------------------------------>
				<cfelse>
					
					<cfinvoke component="saci.comp.ISBsobres" method="Desasignar">
						<cfinvokeargument name="Contratoid" value="#contrato#">
					</cfinvoke>

					<cfinvoke component="saci.comp.ISBlogin" method="BajaContrato">
						<cfinvokeargument name="Contratoid" value="#contrato#">
						<cfinvokeargument name="registrar_en_bitacora" value="false">
					</cfinvoke>

					<cfinvoke component="saci.comp.ISBgarantia" method="BajaContrato">
						<cfinvokeargument name="Contratoid" value="#contrato#">
					</cfinvoke>

					<cfinvoke component="saci.comp.ISBproducto" method="Baja">
						<cfinvokeargument name="Contratoid" value="#contrato#">
					</cfinvoke>

				</cfif>
			
			<!------------------------------------- ALTA DE PRODUCTO ------------------------------------------->
			<cfelse>

				<cfif Len(Trim(Form['PQcodigo' & i]))>
					<cfset quota = Form['PQmailQuota' & i]>

					<!------------------------------------------ ALTA DE PAQUETE ----------------------------------->
					<cfinvoke component="saci.comp.ISBproducto" method="Alta" returnvariable="contrato">
						<cfinvokeargument name="CTid" value="#form.CTid#">
						<cfinvokeargument name="CTidFactura" value="#LvarCTidFactura#">
						<cfinvokeargument name="PQcodigo" value="#Form['PQcodigo' & i]#">
						<cfif isdefined("session.saci.vendedor.id") and Len(Trim(session.saci.vendedor.id))>
							<cfinvokeargument name="Vid" value="#session.saci.vendedor.id#">
						</cfif>
						<cfinvokeargument name="CTcondicion" value="#Form['CTcondicion' & i]#">
						<cfif isdefined("form.CNsuscriptor#i#") and Len(Trim(Form['CNsuscriptor' & i]))>
							<cfinvokeargument name="CNsuscriptor" value="#Form['CNsuscriptor' & i]#">
						</cfif>
						<cfinvokeargument name="CNnumero" value="#Form['CNnumero' & i]#">
						<cfinvokeargument name="CNapertura" value="#Now()#">
					</cfinvoke>
					<cfset Form.Contratoid = contrato>
				
		
				
					<!------------------------------------------ ALTA DE LOGINES ----------------------------------->
					<cfloop from="1" to="#maxServicios.cantidad#" index="k">
						<cfif isdefined("Form.Login_#k#") and Len(Trim(Form['Login_' & k]))>
							<cfset login = Form['Login_' & k]>
							<cfset telefono = "">
							<cfif Form['vPQtelefono' & i] EQ 1>
								<cfset telefono = Form['LGtelefono_' & k]>
							</cfif>
							
							<!--- Verificar existencia de Login antes de guardar y cancelar el guardado de los logines enviando un mensaje de error --->
							<cfinvoke component="saci.comp.ISBlogin" method="Existe" returnvariable="ExisteLogin" LGlogin="#login#" />
							
							<cfif not ExisteLogin>
								<!--- Insertar Login --->
								<cfset serv = "">
								<cfloop query="rsServiciosDisponibles">
									<cfif isdefined("Form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#k#")>
										<cfset serv = serv & Iif(Len(Trim(serv)), DE(","), DE("")) & Form['chk_#Trim(rsServiciosDisponibles.TScodigo)#_#k#']>
									</cfif>
								</cfloop>
								
								<!--- Indica si algun servicio del login es de tipo correo --->
								<cfif listLen(serv)>
									<cfquery name="rsCorreo" datasource="#session.dsn#">
										select count(1)as cant
										from ISBservicioTipo
										where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#serv#">)
											and TStipo='C'
									</cfquery>
								</cfif>
									<cfquery name="rsexistesobre" datasource="#session.dsn#">
										select count(1) as cant
										from ISBsobres
										where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form['Snumero_' & k]#">
									</cfquery>		

									<cfif rsexistesobre.cant eq 0>
										<cfthrow message="El número de sobre #Form['Snumero_' & k]#  no existe.">
									</cfif>

								<cfinvoke component="saci.comp.ISBlogin" method="Alta" returnvariable="loginid">
									<cfif isdefined("Form.Snumero_#k#") and Len(Trim(Form['Snumero_' & k]))>
										<cfinvokeargument name="Snumero" value="#Form['Snumero_' & k]#">
									</cfif>
									<cfinvokeargument name="Contratoid" value="#Form.Contratoid#">
									<cfinvokeargument name="LGlogin" value="#login#">
									<cfinvokeargument name="LGrealName" value="#realname#">
									<cfif isdefined("rsCorreo") and rsCorreo.cant GT 0 >
									<cfinvokeargument name="LGmailQuota" value="#quota#">
									</cfif>
									<cfinvokeargument name="LGroaming" value="false">
									<cfinvokeargument name="LGprincipal" value="#k eq 1#">
									<cfinvokeargument name="Habilitado" value="false">
									<cfinvokeargument name="LGbloqueado" value="false">
									<cfinvokeargument name="LGmostrarGuia" value="false">
									<cfinvokeargument name="LGtelefono" value="#telefono#">
									<cfinvokeargument name="Servicios" value="#serv#">
									<cfinvokeargument name="registrar_en_bitacora" value="false">
								</cfinvoke>

								<!--- Asignar el sobre si viene asignado --->
								<cfif isdefined("Form.Snumero_#k#") and Len(Trim(Form['Snumero_' & k]))>
									<cfif len(trim(serv))>
										<cfquery name="rsServExistentes" datasource="#session.dsn#">
											select count(1) as cant
											from ISBservicioTipo
											where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#serv#">)
												and TStipo in ('C','A')
										</cfquery>							
										<cfif isdefined('rsServExistentes') and rsServExistentes.cant GT 0>								
											
											<cfquery name="rsvalidaSobre" datasource="#session.dsn#">
												select *
												from ISBsobres
												where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form['Snumero_' & k]#">
												and Sestado  = <cfqueryparam cfsqltype="cf_sql_varchar" value="0"> <!--- En la Empresa --->
												and Sdonde = <cfqueryparam cfsqltype="cf_sql_varchar" value="1"> <!---Asignado el Agente--->
												<cfif session.saci.vendedor.agentes neq 0 and session.saci.vendedor.interno eq 0>
													and AGid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.vendedor.agentes#" list="yes" separator=",">)
												<cfelse>
													<cfif rsAgenteGenerico.RecordCount eq 0>
													<cfthrow message="No se ha seleccionado el vendedor genérico en parámetros globales.">
													</cfif>
													and AGid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAgenteGenerico.AGid#" list="yes" separator=",">)
												</cfif>
											</cfquery>		
											
											<cfif rsvalidaSobre.RecordCount eq 0>
												
												<cfif session.saci.vendedor.agentes eq 0 or session.saci.vendedor.interno eq 1>
													<cfset AGidAgente = rsAgenteGenerico.AGid>
												<cfelse>
													<cfset AGidAgente = session.saci.vendedor.agentes>
												</cfif>
												<cfthrow message="El número de sobre #Form['Snumero_' & k]#  no está asignado al agente #AGidAgente# o ya está en uso.">
											</cfif>
											
										
											<cfset Sgenero = "undefined">
											<cfif ListFind(serv,'ACCS') and ListFind(serv,'MAIL')>
												<cfset Sgenero = 'M'>
											<cfelseif ListFind(serv,'ACCS')>
												<cfset Sgenero = 'A'>
											<cfelseif ListFind(serv,'MAIL')>	
												<cfset Sgenero = 'C'>
											</cfif>
												
											<cfquery name="rsServSobres" datasource="#session.dsn#">
												select *
												from ISBsobres
												where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form['Snumero_' & k]#">
												<cfif Sgenero eq 'A'>
													and Sgenero in ('A','M')
												<cfelseif Sgenero eq 'C'>
													and Sgenero in ('C','M')
												<cfelseif Sgenero eq 'M'>
													and Sgenero  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Sgenero#">
												</cfif>
											</cfquery>							
												
											<cfif rsServSobres.RecordCount eq 0 >
												<cfthrow message="El sobre número #Form['Snumero_' & k]# no tiene los servicios #serv# definidos en su género.">	
											</cfif>
											
											<cfinvoke component="saci.comp.ISBsobres" method="Asigna_Login">
												<cfinvokeargument name="Snumero" value="#Form['Snumero_' & k]#">
												<cfinvokeargument name="LGnumero" value="#loginid#">
											</cfinvoke>
										<cfelse>
											<cfthrow message="Error, debe seleccionar al menos un servicio de correo o de acceso para el login: #login#.">
										</cfif>										
									<cfelse>
										<cfthrow message="Error, debe seleccionar al menos un servicio de correo o de acceso para el login: #login#.">
									</cfif>																				
								</cfif>
							</cfif>
							
						</cfif>
					</cfloop>
					<!-------------------------------------- FIN ALTA DE LOGINES ---------------------------------->

					<!-------------------------------- ALTA DE GARANTIA ------------------------------------------>	
					<cfquery name="rsLogPrincipal" datasource="#session.DSN#">
						select  b.LGnumero,b.LGlogin
						from ISBproducto a
							inner join ISBlogin b
								on b.Contratoid=a.Contratoid
									and b.LGprincipal=1
						where
							a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
							and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
							and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form['PQcodigo' & i]#">					
					</cfquery>	
					<cfif isdefined('rsLogPrincipal') and rsLogPrincipal.recordCount GT 0>
						<cfset loginid = rsLogPrincipal.LGnumero>
					<cfelse>
						<cfquery datasource="#session.DSN#" maxrows="1">
							Update ISBlogin set LGprincipal = 1								
							from ISBproducto a
								inner join ISBlogin b
									on b.Contratoid=a.Contratoid						
							where 
								a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
								and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
								and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form['PQcodigo' & i]#">							
						</cfquery>
						
						<!--- Se consulta de nuevo para seleccionar el login principal recientemente actualizado --->
						<cfquery name="rsLogPrincipal" datasource="#session.DSN#">
							select  b.LGnumero,b.LGlogin
							from ISBproducto a
								inner join ISBlogin b
									on b.Contratoid=a.Contratoid
										and b.LGprincipal=1
							where
								a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
								and a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
								and a.PQcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form['PQcodigo' & i]#">					
						</cfquery>	
						<cfif isdefined('rsLogPrincipal') and rsLogPrincipal.recordCount GT 0>
							<cfset loginid = rsLogPrincipal.LGnumero>
						<cfelse>						
							<cfthrow message="No existe el login principal para el contrato (#form.Contratoid#) seleccionado.">
						</cfif>
					</cfif>
										
					<cfset form.Gtipo = "3">
					<cfset form.Gmonto = 0>					
							
					<!--- Insercion de los datos del deposito de garantia --->
					<cfinclude template="../../utiles/depoGaran-apply.cfm">										
				</cfif>
			</cfif>
		</cfloop>

	</cftransaction>

<!-------------------------------- BAJA DE CUENTA Y TODAS LAS ESTRUCTURAS ASOCIADAS ------------------------------->
<cfelseif isdefined("Form.Eliminar")>

	<cftransaction>
		<cfinvoke component="saci.comp.ISBsobres" method="DesasignarDeCuenta">
			<cfinvokeargument name="CTid" value="#form.CTid#">
		</cfinvoke>
		
		<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Desasignar">
			<cfinvokeargument name="CTid" value="#form.CTid#">
		</cfinvoke>
		
		<cfinvoke component="saci.comp.ISBlogin" method="BajaCuenta">
			<cfinvokeargument name="CTid" value="#form.CTid#">
			<cfinvokeargument name="soloEnCaptura" value="1">
			<cfinvokeargument name="registrar_en_bitacora" value="false">
		</cfinvoke>

		<cfinvoke component="saci.comp.ISBgarantia" method="BajaCuenta">
			<cfinvokeargument name="CTid" value="#form.CTid#">
			<cfinvokeargument name="soloEnCaptura" value="1">	
		</cfinvoke>
		
		<cfinvoke component="saci.comp.ISBproducto" method="BajaCuenta">
			<cfinvokeargument name="CTid" value="#form.CTid#">
			<cfinvokeargument name="soloEnCaptura" value="1">
		</cfinvoke>
	</cftransaction>

	<cfquery name="hayProductos" datasource="#Session.DSN#">
		Select count(1) as cantProd
		from ISBproducto
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
	</cfquery>

	<!--- Solo se borrara la cuenta si no existen productos asociados a esta --->
	<cfif isdefined('hayProductos') and hayProductos.cantProd EQ 0>
		<cftransaction>
			<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Baja">
				<cfinvokeargument name="CTid" value="#form.CTid#">
			</cfinvoke>
	
			<cfinvoke component="saci.comp.ISBcuentaCobro" method="Baja">
				<cfinvokeargument name="CTid" value="#form.CTid#">
			</cfinvoke>

				<!--- Borra los atributos extendidos de la Cuenta --->
			<cfquery name="eliminaAtributo" datasource="#Session.DSN#">
				Delete ISBcuentaAtributo
				where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
			</cfquery>

			<cfinvoke component="saci.comp.ISBcuenta" method="Baja">
				<cfinvokeargument name="CTid" value="#form.CTid#">
			</cfinvoke>
	
			<cfset Form.CTid = "">
			<cfset Form.cue = "">		
		</cftransaction>
	</cfif>
</cfif>
