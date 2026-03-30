<cfcomponent output="no" hint="Tarea de Cambio de Paquete">
	
	<cffunction name="ejecutar" access="public" returntype="void" output="false">
		<cfargument name="datasource" 	type="string" required="yes">
		<cfargument name="TPid" 		type="numeric" required="yes">
		<cfargument name="CTid" 		type="numeric" required="yes">
		<cfargument name="Contratoid" 	type="numeric" required="yes">
		<cfargument name="LGnumero" 	type="numeric" required="no">
		<cfargument name="TPxml" 		type="xml" required="yes">
		<cfargument name="TPorigen" 	type="string" 	required="no" 	default="SACI" 	displayname="Indica el origen del último evento">
		
		<!---Crea la estructura que va a contener los datos para el cambio de paquete. Toma los valores del XML y los pone en variables para despues ponerlas en memoria--->
		<cfset telConservar = "">
		<cfset logConservar = "">
		<cfset servConservar = "">
		<cfif isdefined('Arguments.TPxml.cambioPaquete.loginPorConservar')>
			<cfloop index="i" from="1" to="#ArrayLen(Arguments.TPxml.cambioPaquete.loginPorConservar)#">
				<cfset j=1>
				<cfloop index="j" from="1" to="#ArrayLen(Arguments.TPxml.cambioPaquete.loginPorConservar[i].servicio)#">
					<cfset logConservar =logConservar & IIf( len(trim(logConservar)), DE(','), DE('')) & Arguments.TPxml.cambioPaquete.loginPorConservar[i].XmlAttributes.login>
					<cfif isdefined('Arguments.TPxml.cambioPaquete.loginPorConservar.telefono')>
					<cfset telConservar= telConservar & IIf( len(trim(telConservar)), DE(','), DE('')) & Arguments.TPxml.cambioPaquete.loginPorConservar[i].telefono[1].XmlText>
					</cfif>
					<cfset servConservar= servConservar & IIf( len(trim(servConservar)), DE(','), DE('')) & Arguments.TPxml.cambioPaquete.loginPorConservar[i].servicio[j].XmlText>
				</cfloop>
			</cfloop>
		</cfif>
		
		<cfset logBorrar = "">
		<cfset servBorrar = "">
		<cfif isdefined('Arguments.TPxml.cambioPaquete.loginPorBorrar')>
			<cfloop index="i" from="1" to="#ArrayLen(Arguments.TPxml.cambioPaquete.loginPorBorrar)#">
				<cfset j=1>
				<cfloop index="j" from="1" to="#ArrayLen(Arguments.TPxml.cambioPaquete.loginPorBorrar[i].servicio)#">
					<cfset logBorrar =logBorrar & IIf( len(trim(logBorrar)), DE(','), DE('')) & Arguments.TPxml.cambioPaquete.loginPorBorrar[i].XmlAttributes.login>
					<cfset servBorrar= servBorrar & IIf( len(trim(servBorrar)), DE(','), DE('')) & Arguments.TPxml.cambioPaquete.loginPorBorrar[i].servicio[j].XmlText>
				</cfloop>
			</cfloop>
		</cfif>
		
		<cfset PQAdd = "">
		<cfset logPQAdd = "">
		<cfset servPQAdd = "">
		<cfif isdefined('Arguments.TPxml.cambioPaquete.paqueteAdicional')>
			<cfloop index="i" from="1" to="#ArrayLen(Arguments.TPxml.cambioPaquete.paqueteAdicional)#">	
				<cfloop index="j" from="1" to="#ArrayLen(Arguments.TPxml.cambioPaquete.paqueteAdicional[i].login)#">
					<cfloop index="k" from="1" to="#ArrayLen(Arguments.TPxml.cambioPaquete.paqueteAdicional[i].login[j].servicio)#">
						<cfset PQAdd =PQAdd & IIf( len(trim(PQAdd)), DE(','), DE('')) & Arguments.TPxml.cambioPaquete.paqueteAdicional[i].codigoPaquete.XmlText>
						<cfset logPQAdd =logPQAdd & IIf( len(trim(logPQAdd)), DE(','), DE('')) & Arguments.TPxml.cambioPaquete.paqueteAdicional[i].login[j].XmlAttributes.login>
						<cfset servPQAdd= servPQAdd & IIf( len(trim(servPQAdd)), DE(','), DE('')) & Arguments.TPxml.cambioPaquete.paqueteAdicional[i].login[j].servicio[k].XmlText>
					</cfloop>
				</cfloop>
			</cfloop>
		</cfif>
		
		<!---Pone en memoria los datos de XML--->
		<cfset session.saciTemp.cambioPQ = StructNew()>											
		<cfset session.saciTemp.cambioPQ.contrato = Arguments.Contratoid>
		<cfset session.saciTemp.cambioPQ.PQanterior = TPxml.cambioPaquete.PaqueteAnterior.codigoPaquete.XmlText>
		<cfset session.saciTemp.cambioPQ.PQnuevo = TPxml.cambioPaquete.PaqueteNuevo.codigoPaquete.XmlText>
		
		<cfif isdefined("TPxml.cambioPaquete.PaqueteNuevo.CNsuscriptor.XmlText") and len(trim(TPxml.cambioPaquete.PaqueteNuevo.CNsuscriptor.XmlText))>
			<cfset session.saciTemp.cambioPQ.CNsuscriptor = TPxml.cambioPaquete.PaqueteNuevo.CNsuscriptor.XmlText>
			<cfset session.saciTemp.cambioPQ.CNnumero = TPxml.cambioPaquete.PaqueteNuevo.CNnumero.XmlText>
		</cfif>

		<cfset session.saciTemp.cambioPQ.logConservar = StructNew()>
		<cfset session.saciTemp.cambioPQ.logConservar.login =logConservar>
		<cfset session.saciTemp.cambioPQ.logConservar.servicios = servConservar>
		<cfif isdefined("telConservar")and ListLen(telConservar)>
		<cfset session.saciTemp.cambioPQ.logConservar.telefono = telConservar>
		</cfif>
		
		<cfset session.saciTemp.cambioPQ.logBorrar = StructNew()>
		<cfset session.saciTemp.cambioPQ.logBorrar.login = logBorrar>
		<cfset session.saciTemp.cambioPQ.logBorrar.servicios = servBorrar>
		
		<cfset session.saciTemp.cambioPQ.pqAdicional = StructNew()>
		<cfset session.saciTemp.cambioPQ.pqAdicional.cod = PQAdd>
		<cfset session.saciTemp.cambioPQ.pqAdicional.logMover = StructNew()>
		<cfset session.saciTemp.cambioPQ.pqAdicional.logMover.login = logPQAdd>
		<cfset session.saciTemp.cambioPQ.pqAdicional.logMover.servicios = servPQAdd>
		<!--- Actualizacion del paquete en el producto --->
		<cfinvoke component="saci.comp.ISBtareaProgramadaCP" method="cambioPaquete">				
			<cfinvokeargument name="CTid"		value="#Arguments.CTid#">
			<cfinvokeargument name="Contratoid"	value="#Arguments.Contratoid#">
			<cfinvokeargument name="str"		value="#session.saciTemp#">
			<cfinvokeargument name="datasource"	value="#Arguments.datasource#">		
			<cfinvokeargument name="LGevento"	value="#Arguments.TPorigen#">		
		</cfinvoke>
		
	</cffunction>
	
	
	
	<cffunction name="cambioPaquete" access="public" returntype="void" output="false">
		<cfargument name="CTid" 		type="numeric" 	required="yes"	displayname="Id de la cuenta">
		<cfargument name="Contratoid" 	type="numeric" 	required="yes"	displayname="Id del contrato">
		<cfargument name="str"			type="struct" 	required="yes"	displayname="Estructura que contiene los valores para el cambio de paquete">
		<cfargument name="datasource" 	type="string" 	required="No"	default="#session.DSN#"	displayname="Datasourse">
		
		<cfargument name="LGnumero" 	type="string" 	required="No"	default=""displayname="Id del login">				<!---se usa en caso de que sea llamado desde las interfases--->
		<cfargument name="LGtelefono" 	type="string" 	required="No"	default=""	displayname="Numero de telefono">				
		<cfargument name="CNsuscriptor" type="string" 	required="No"	default=""	displayname="Suspcriptor (intpad)">
		
		<cfargument name="BLautomatica" type="string" 	required="no" 	default="0" displayname="BLautomatica">				<!---parámetros para la bitacora de login--->
	    <cfargument name="BLobs" 		type="string" 	required="no" 	default="" displayname="Observaciones">
		
		<cfargument name="AGid" 		type="string" 	required="no" 	default=""  	displayname="Agente">				<!---Parametros para el mensaje al cliente--->
	    <cfargument name="MSoperacion" 	type="string" 	required="no" 	default="B" 	displayname="Tipo de operacion">
	    <cfargument name="MSfechaEnvio" type="string" 	required="no" 	default="#now()#"displayname="Fecha de envio del mensaje">
	    <cfargument name="MSsaldo" 		type="numeric" 	required="no" 	default="0" 	displayname="Saldo_Mensajes_Cliente">
	    <cfargument name="MSmotivo" 	type="string" 	required="no" 	default="Q" 	displayname="Motivo_Mensajes_Cliente">
	    <cfargument name="MStexto" 		type="string" 	required="no" 	default=""  	displayname="Texto_Mensajes_Cliente">
	 	<cfargument name="LGevento" 	type="string" 	required="no" 	default="SACI" 	displayname="Indica el origen del último evento">
	 
		<cftransaction>
		<!---Generacion de las listas y arreglos que va a contener los logines- servicios por conservar, por borrar y por arregar en un paquete adicional--->
		
		<cfif isdefined("str.cambioPQ.logConservar.login") and ListLen(str.cambioPQ.logConservar.login)> 
			<cfset arrLogCons = str.cambioPQ.logConservar.login>							<!---logines por conservar--->
			<cfset arrServCons = str.cambioPQ.logConservar.servicios>
			<cfif isdefined("str.cambioPQ.logConservar.telefono") and ListLen(str.cambioPQ.logConservar.telefono)>
				<cfset arrTelCons = str.cambioPQ.logConservar.telefono>
			</cfif>
		</cfif>
		
		<cfset arrLogBorr = "">
		<cfif isdefined("str.cambioPQ.logBorrar.login") and ListLen(str.cambioPQ.logBorrar.login)> 
			<cfset arrLogBorr = str.cambioPQ.logBorrar.login>								<!---logines por borrar--->
			<cfset arrServBorr = str.cambioPQ.logBorrar.servicios>
		</cfif>
		
		<cfif isdefined("str.cambioPQ.pqAdicional.cod") and ListLen(str.cambioPQ.pqAdicional.cod)> 
			<cfset arrPqPA = ListToArray(str.cambioPQ.pqAdicional.cod,",")>					<!---paquetes y logines adicionales--->
			<cfset arrLogPA = ListToArray(str.cambioPQ.pqAdicional.logMover.login,",")>
			<cfset arrSerPA = ListToArray(str.cambioPQ.pqAdicional.logMover.servicios,",")>
		</cfif>
		
		<!--- Actualizacion del producto con el nuevo paquete (es ejecutado por SACI e interfases SIIC)--->
		<cfinvoke component="saci.comp.ISBproducto" method="cambioPaquete">								
			<cfinvokeargument name="Contratoid"	value="#Arguments.Contratoid#">
			<cfinvokeargument name="pqNuevo"	value="#str.cambioPQ.PQnuevo#">
			<cfinvokeargument name="datasource"	value="#Arguments.datasource#">
			<cfinvokeargument name="LGevento"	value="#Arguments.LGevento#">
		</cfinvoke>
		
		<!---Actualizacion del campo de CNsuscriptor (es ejecutado por interfases SIIC)--->
		<cfif len(trim(Arguments.CNsuscriptor))>											
			<cfinvoke component="saci.comp.ISBproducto" method="CambioSuscriptor">						
				<cfinvokeargument name="Contratoid"		value="#Arguments.Contratoid#">
				<cfinvokeargument name="CNsuscriptor"	value="#Arguments.CNsuscriptor#">
				<cfinvokeargument name="datasource"		value="#Arguments.datasource#">
			</cfinvoke>
		</cfif>
		
		<!--- Actualizacion del Suscriptor y numero de suscriptor si viene definido en la estructura (es ejecutado por SACI)--->
		<cfif isdefined("str.cambioPQ.CNsuscriptor") and len(trim(str.cambioPQ.CNsuscriptor))>
			<cfinvoke component="saci.comp.ISBproducto" method="CambioSuscriptor">								
				<cfinvokeargument name="Contratoid"	value="#Arguments.Contratoid#">
				<cfinvokeargument name="CNsuscriptor"	value="#str.cambioPQ.CNsuscriptor#">
				<cfinvokeargument name="datasource"	value="#Arguments.datasource#">
			</cfinvoke>
		</cfif>
	
		<!--- Borrado de logines y servicios que fueron descartados en el cambio del paquete --->
		<cfset borrarServicios(
				Arguments.datasource
				, arrLogBorr
				, str.cambioPQ.PQnuevo
				, Arguments.BLobs
				, Arguments.AGid
				, Arguments.MSoperacion
				, Arguments.MSfechaEnvio
				, Arguments.MSsaldo
				, Arguments.MSmotivo
				, Arguments.MStexto)>
		
		<!--- Si no hay servicios por conservar significa que se esta ejecutando desde las interfases SIIC, si los hay entonces los estamos ejecutando desde SACI--->		
		<cfif not isdefined("arrLogCons") or not ListLen(arrLogCons)>	
						
			<cfquery datasource="#Arguments.datasource#" name="servicioNuevoPaq">							
				Select TScodigo
					From ISBservicio
				Where PQcodigo = <cfqueryparam  cfsqltype="cf_sql_char" value="#str.cambioPQ.PQnuevo#"> 
				and SVminimo > 0
			</cfquery>
			<cfset ServNuevoPaq = ValueList(servicioNuevoPaq.TScodigo,',')>
			
			<cfquery datasource="#Arguments.datasource#" name="mayorista">
				Select coalesce(MRidMayorista,0) as MRidMayorista
				 from ISBpaquete
				Where PQcodigo =  <cfqueryparam  cfsqltype="cf_sql_char" value="#str.cambioPQ.PQnuevo#"> 
			</cfquery>
			
			<!---actualiza la tabla ISBserviciosLogin con el nuevo paquete para cada login(interfases SIIC)--->
			<cfquery datasource="#Arguments.datasource#" name="rsLogines">							
				select LGnumero,LGprincipal from ISBlogin 
				where	Contratoid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#">
			</cfquery>
			<cfif rsLogines.recordCount gt 0>
				<!--- Primero tiene que borrar los servicios que no existen en el paquete destino, de
					lo contrario se produciría un error de integridad --->
				<cfquery datasource="#Arguments.datasource#">
					delete ISBserviciosLogin
					where LGnumero in (
						select LGnumero from ISBlogin 
						where	Contratoid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#">
						)
					and TScodigo not in (
						select TScodigo from ISBservicio
						where PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#str.cambioPQ.PQnuevo#">
						)
				</cfquery>
	
													
				<cfloop query="rsLogines">					
					<cfinvoke component="saci.comp.ISBserviciosLogin" method="UpdatePaqueteServicio">	
						<cfinvokeargument name="LGnumero" value="#rsLogines.LGnumero#">
						<cfinvokeargument name="PQcodigo" value="#str.cambioPQ.PQnuevo#">
						<cfinvokeargument name="datasource" value="#Arguments.datasource#">
					</cfinvoke>
					
					 <cfloop from="1" to="#ListLen(ServNuevoPaq)#" index="i">					
						<cfquery datasource="#Arguments.datasource#" name="serviciosLogin">							
							Select count(*) as cant
								From ISBserviciosLogin
							Where	LGnumero = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsLogines.LGnumero#">
							and TScodigo = <cfqueryparam  cfsqltype="cf_sql_char" value="#ListGetAt(ServNuevoPaq, i, ',')#">
						</cfquery>
						
						<!--- Los servicios mínimos para el paquete destino se agregan al principal, en caso que no existan --->
						<cfif serviciosLogin.cant eq 0 and rsLogines.LGprincipal>						
							<cfinvoke component="saci.comp.ISBserviciosLogin" method="Alta">
							<cfinvokeargument name="LGnumero" value="#rsLogines.LGnumero#">
							<cfinvokeargument name="TScodigo" value="#ListGetAt(ServNuevoPaq, i, ',')#">
							<cfinvokeargument name="PQcodigo" value="#str.cambioPQ.PQnuevo#">
							<cfinvokeargument name="SLpassword" value="*">
							<cfinvokeargument name="Habilitado" value="1">
							</cfinvoke>
					  	</cfif> 						
					 </cfloop>
				</cfloop>
			</cfif>
					
			<cfif len(Arguments.LGnumero)>
				<cfif len(Arguments.LGtelefono)>
					<!---actualiza el telefono si viene definido en los argumentos y registra en bitacora (interfases SIIC)--->
					<cfinvoke component="saci.comp.ISBlogin" method="CambioTelefono">						
						<cfinvokeargument name="LGnumero"		value="#Arguments.LGnumero#">
						<cfinvokeargument name="LGtelefono"	value="#Arguments.LGtelefono#">
						<cfinvokeargument name="datasource"	value="#Arguments.datasource#">
						<cfinvokeargument name="BLautomatica"	value="#Arguments.BLautomatica#">
						<cfif len(Arguments.BLobs)><cfinvokeargument name="BLobs"	value="#Arguments.BLobs#">
						<cfelse><cfinvokeargument name="BLobs"	value="Cambio de telefono en el login #Arguments.LGnumero# por Cambio de Paquete."> </cfif>
					</cfinvoke>
				</cfif>
				<!--- Bitacora de Cambios de Paquete  --->
					<cfinvoke component="saci.comp.ISBbitacoraCambioPaquete" method="Alta">
						<cfinvokeargument name="LGnumero"	value="#Arguments.LGnumero#">
						<cfinvokeargument name="Contratoid"	value="#Arguments.Contratoid#">
						<cfinvokeargument name="Paqdestino"value="#str.cambioPQ.PQnuevo#">
					</cfinvoke>	
				<cfif Arguments.MSsaldo NEQ 0>
					<!---Registro de Mensaje al cliente (interfases SIIC)--->
					<cfinvoke component="saci.comp.ISBlogin" method="EnviarMensajeCliente">
						<cfinvokeargument name="Contratoid"	value="#Arguments.Contratoid#">
						<cfinvokeargument name="LGnumero"	value="#Arguments.LGnumero#">
						<cfinvokeargument name="BLautomatica"value="#Arguments.BLautomatica#">
						<cfif len(Arguments.AGid)><cfinvokeargument name="AGid"	value="#Arguments.AGid#"></cfif>
						<cfinvokeargument name="MSoperacion"	value="#Arguments.MSoperacion#">
						<cfinvokeargument name="MSfechaEnvio"	value="#Arguments.MSfechaEnvio#">
						<cfinvokeargument name="MSsaldo"		value="#Arguments.MSsaldo#">
						<cfinvokeargument name="MSmotivo"		value="#Arguments.MSmotivo#">
						<cfif len(Arguments.MStexto)><cfinvokeargument name="MStexto"	value="#Arguments.MStexto#">
						<cfelse><cfinvokeargument name="MStexto"value="Modificación del saldo."> </cfif>
						<cfinvokeargument name="datasource"value="#Arguments.datasource#">
					</cfinvoke>
				</cfif>
			</cfif>
			
		<cfelse>
		<!--------------------------------------------Logines por Conservar(ejecutado por SACI)------------------------------------------------------------>	
			
			<!---Consulta el plazo de vencimiento en dias para los logines que estan retirados--->
			<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="plazoLogines">	
				<cfinvokeargument name="Pcodigo" value="40">
			</cfinvoke>
			
			<cfquery datasource="#Arguments.datasource#" name="rscablemodem">							
				Select count(1) as cantidad
					From ISBservicio
				Where PQcodigo = <cfqueryparam  cfsqltype="cf_sql_char" value="#str.cambioPQ.PQnuevo#"> 
				and TScodigo = 'CABM'				
			</cfquery>

			
			<!--- Selecciona los LGnumeros correspondientes a cada login por conservar activo--->
			<cfquery datasource="#Arguments.datasource#" name="rsLogines">							
				select LGnumero,LGlogin,Habilitado,LGprincipal from ISBlogin 										
				where	Contratoid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"> 
					and rtrim(ltrim(LGlogin))in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#trim(arrLogCons)#">)
			</cfquery>
			
			<cfif rsLogines.recordCount gt 0>		
				<cfloop query="rsLogines">
					<cfset LGnum = rsLogines.LGnumero>
					<cfset LGlog = rsLogines.LGlogin>
					
					<!---Actualiza la tabla ISBserviciosLogin con el nuevo paquete para el LGnumero que viene como argumento--->
					<cfinvoke component="saci.comp.ISBserviciosLogin" method="UpdatePaqueteServicio">	
						<cfinvokeargument name="PQcodigo" value="#str.cambioPQ.PQnuevo#">
						<cfinvokeargument name="LGnumero" value="#LGnum#">
						<cfinvokeargument name="datasource" value="#Arguments.datasource#">
					</cfinvoke>

					
					<cfif rscablemodem.cantidad neq 0 and rsLogines.LGprincipal and Not ListFind(arrServCons,'CABM')>						
						<cfinvoke component="saci.comp.ISBserviciosLogin" method="Alta">
						<cfinvokeargument name="LGnumero" value="#rsLogines.LGnumero#">
						<cfinvokeargument name="TScodigo" value="CABM">
						<cfinvokeargument name="PQcodigo" value="#str.cambioPQ.PQnuevo#">
						<cfinvokeargument name="SLpassword" value="*">
						<cfinvokeargument name="Habilitado" value="1">
						</cfinvoke>
					</cfif>
					
					<!---Actualiza los telefonos para los logines se vienen definidos en la estructura--->
					<cfif isdefined("arrTelCons")and len(trim(arrTelCons))>
						<cfset pos = ListFindNoCase(arrLogCons, LGlog,",")>
						<cfset tel = ListGetAt(arrTelCons, pos,",")>
						<cfinvoke component="saci.comp.ISBlogin" method="CambioTelefono">	
							<cfinvokeargument name="LGnumero" value="#LGnum#">
							<cfinvokeargument name="LGtelefono" value="#tel#">
							<cfinvokeargument name="datasource" value="#Arguments.datasource#">
							<cfinvokeargument name="BLautomatica" value="#Arguments.BLautomatica#">
							<cfif len(Arguments.BLobs)><cfinvokeargument name="BLobs"	value="#Arguments.BLobs#">
							<cfelse><cfinvokeargument name="BLobs"	value="Cambio de telefono en el login #Arguments.LGnumero# por Cambio de Paquete."> </cfif>
						</cfinvoke>
					</cfif>
				</cfloop>
			</cfif>
			
			<!--- Selecciona los LGnumeros que estan retirados y vencidos--->
			<cfquery datasource="#Arguments.datasource#" name="rsLogVencidos">							
				select LGnumero,LGlogin,Habilitado from ISBlogin 										<!---Logines que retirados vencidos(estos logines no se usan mas)--->
				where	Contratoid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"> 
					and Habilitado=4
					<!---and datediff( day, LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) > <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">--->
			</cfquery>
			<cfif rsLogVencidos.recordCount gt 0>		
				<cfloop query="rsLogVencidos">
					<!---Actualiza la tabla ISBserviciosLogin con el nuevo paquete para el LGnumero vencido--->
					<cfinvoke component="saci.comp.ISBserviciosLogin" method="UpdatePaqueteServicio">	
						<cfinvokeargument name="LGnumero" value="#rsLogVencidos.LGnumero#">
						<cfinvokeargument name="PQcodigo" value="#str.cambioPQ.PQnuevo#">
						<cfinvokeargument name="datasource" value="#Arguments.datasource#">
					</cfinvoke>	
				</cfloop>
			</cfif>
			
			
			<!--- Selecciona los LGnumeros de los logines que estan retirados No vencidos--->
			<cfquery datasource="#Arguments.datasource#" name="rsLogRetirados">							
				select LGnumero,LGlogin,MRid,LGfechaRetiro
				from ISBlogin 
				where Contratoid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"> 
				and Habilitado=2
				and LGlogin not in (<cfqueryparam  cfsqltype="cf_sql_char" list="yes" separator="," value="#arrLogBorr#">) 
				<!---and datediff( day, LGfechaRetiro, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#plazoLogines#">--->
			</cfquery>
			
			<cfloop query="rsLogRetirados">
				<cfset idLogin = rsLogRetirados.LGnumero>
				<cfset Login = rsLogRetirados.LGlogin>
				
				<!---Actualiza la tabla ISBserviciosLogin con el nuevo paquete para el LGnumero de los logines por reprogramar--->
				<cfinvoke component="saci.comp.ISBserviciosLogin" method="UpdatePaqueteServicio">	
					<cfinvokeargument name="LGnumero" value="#idLogin#">
					<cfinvokeargument name="PQcodigo" value="#str.cambioPQ.PQnuevo#">
					<cfinvokeargument name="datasource" value="#Arguments.datasource#">
				</cfinvoke>
				
				
				<!--- Devuelve una estructura con los servicios actuales de los logines activos y los logines retirados, y los servicios maximos y minimos--->
				<cfinvoke component="saci.comp.ISBservicioTipo" method="ComparaServicios"  returnvariable="query">
					<cfinvokeargument name="cuentaid" value="#Arguments.CTid#">
					<cfinvokeargument name="contratoid" value="#Arguments.Contratoid#">
					<cfinvokeargument name="idLoginesR" value="#rsLogRetirados.LGnumero#">
					<cfinvokeargument name="conexion" value="#Arguments.datasource#">
				</cfinvoke>
				
				<!--- Revisa que se cumpla con los servicios minimos y maximos, si no cumple entonces pone el login retirado en un nuevo paquete por defecto--->
				<cfset muchosServ = ""> <cfset pocosServ = "">
				<cfloop query="query">
					<cfset actu = query.ServActivos + query.ServReprogramar>
					<cfset permit= query.ServPermitidos>
					<cfset mini = query.ServMinimos >
					
					<cfif actu GT permit>	<cfset muchosServ = muchosServ &' '& IIF(muchosServ neq "", DE(","), DE(""))&' '&query.TScodigo>	</cfif>
					<cfif  mini GT actu>	<cfset pocosServ = pocosServ &' '& IIF(pocosServ neq "", DE(","), DE(""))&' '&query.TScodigo>	</cfif>
				</cfloop>
				<cfif len(trim(pocosServ)) or len(trim(muchosServ))>
					
					<cfinvoke component="saci.comp.ISBpaquete" method="PQpordefecto"  returnvariable="PQcodigo"/>			<!---Trae un paquete el paquete por defecto--->
					
					<cfif len(trim(PQcodigo))>
						<cfinvoke component="saci.comp.ISBserviciosLogin" method="RetornaServicios"  returnvariable="Lista">	<!---Trae la lista de servicios--->
							<cfinvokeargument name="LGnumero" value="#idLogin#">
						</cfinvoke>
						<!---Se agrega a la lista de paquetes adicionales el paquete por defecto con el login y servicios que causan conflicto con el nuevo paquete--->
						<cfloop index="idservicio" list="#Lista#" delimiters=",">
							
							<cfif not isdefined("arrPqPA")>	<cfset arrPqPA =""><cfset arrLogPA =""><cfset arrSerPA ="">
							<cfelse>	<cfset arrPqPA=ArraytoList(arrPqPA)>	<cfset arrLogPA=ArraytoList(arrLogPA)>	<cfset arrSerPA=ArraytoList(arrSerPA)> </cfif>
							<cfset arrPqPA = arrPqPA & IIF(listLen(arrPqPA),DE(','),DE('')) & PQcodigo>	
							<cfset arrLogPA = arrLogPA & IIF(listLen(arrLogPA),DE(','),DE('')) & Login>
							<cfset arrSerPA = arrSerPA & IIF(listLen(arrSerPA),DE(','),DE('')) & idservicio>
							
							<cfset arrPqPA=listToArray(arrPqPA)>	<cfset arrLogPA=listToArray(arrLogPA)>	<cfset arrSerPA=listToArray(arrSerPA)>
						</cfloop>
					</cfif>
				</cfif>
				
			</cfloop>
			
		</cfif>
		
		<!--------------------------------------------Paquetes Adicionales(ejecutado por SACI)------------------------------------------------------------>	

		<cfif isdefined("arrPqPA")and ArrayLen(arrPqPA)> 
			
			<!---consulta los datos actuales del nuevo paquete para que los paquetes adicionales posean las mismas caracteriscas del paquete actual--->
			<cfinvoke component="saci.comp.ISBproducto" method="consultarProducto"returnvariable="rsPQdatos">
				<cfinvokeargument name="Contratoid"	value="#Arguments.Contratoid#">
				<cfinvokeargument name="datasource"	value="#Arguments.datasource#">
			</cfinvoke>
		
			<cfset act="">
			<cfset act2="">
			<cfloop index="cont" from = "1" to = "#ArrayLen(arrPqPA)#">
	
				<cfif act NEQ arrPqPA[cont]>
					<cfset act = arrPqPA[cont]>
					<!---agregar producto con las mismas caracteristicas que posee el paquete nuevo--->	
					<cfinvoke component="saci.comp.ISBproducto" method="Alta" returnvariable="contrato">	
						<cfinvokeargument name="CTid" value="#Arguments.CTid#">
						<cfinvokeargument name="CTidFactura" value="#rsPQdatos.CTidFactura#">
						<cfinvokeargument name="PQcodigo" value="#act#">
						<cfif Len(Trim(rsPQdatos.Vid))><cfinvokeargument name="Vid" value="#rsPQdatos.Vid#"></cfif>
						<cfinvokeargument name="CTcondicion" value="#rsPQdatos.CTcondicion#">
						<cfif Len(Trim(rsPQdatos.CNsuscriptor))><cfinvokeargument name="CNsuscriptor" value="#rsPQdatos.CNsuscriptor#"></cfif>
						<cfinvokeargument name="CNnumero" value="#rsPQdatos.CNnumero#">
						<cfinvokeargument name="CNapertura" value="#Now()#">
						<cfif isdefined("rsLogRetirados")and len(trim(arrLogPA[cont])) and ListFindNoCase(rsLogRetirados.LGlogin,arrLogPA[cont],',')NEQ 0>
							<cfinvokeargument name="MRid" value="#ListGetAt(rsLogRetirados.MRid, ListFindNoCase(rsLogRetirados.LGlogin,arrLogPA[cont],','), ',')#">>
							<cfinvokeargument name="CNfechaRetiro" value="#now()#">
						</cfif>
					</cfinvoke>
<!---
					<cfif isdefined('contrato') and len(trim(contrato))>
						<!--- Actualizacion del producto con el nuevo paquete, esto se hace para que se dispare la interfaz cada vez que se realice un Alta en ISBproducto
							 (es ejecutado por SACI e interfases SIIC)--->
						<cfinvoke component="saci.comp.ISBproducto" method="cambioPaquete">								
							<cfinvokeargument name="Contratoid"	value="#contrato#">
							<cfinvokeargument name="pqNuevo"	value="#act#">
							<cfinvokeargument name="datasource"	value="#Arguments.datasource#">
						</cfinvoke>					
					</cfif>
--->					
				</cfif>				
				<cfset act2="">
				
				<cfif act2 NEQ arrLogPA[cont]>
					<cfset act2 = arrLogPA[cont]>
					
					<!---Consulta el id del login--->
					<cfquery datasource="#Arguments.datasource#" name="rsIdlogin">							
						select LGnumero,LGfechaRetiro,Habilitado from ISBlogin 
						where Contratoid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"> 
						and upper(ltrim(rtrim(LGlogin))) = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#ucase(trim(act2))#"> 
					</cfquery>
					
					<!---Pueden haber logines iguales pero solo un login activo o retirado activo--->
					<cfloop query="rsIdlogin">
						<cfset activ =rsIdlogin.Habilitado>
						<cfset id =rsIdlogin.LGnumero>
						<cfset fech =rsIdlogin.LGfechaRetiro>
						
						<cfif activ EQ 2>
							<cfif isdefined("fech")and len(trim(fech)) and  datediff('d',fech,now())>
								<!---Actualiza en los logines el nuevo contrato al que van a pertenecer, actualiza en los servicios el nuevo paquete y registra en bitacora de logines--->	
								<cfinvoke component="saci.comp.ISBlogin" method="cambioContratoLogin">				
								<cfinvokeargument name="Contratoid"		value="#contrato#">
								<cfinvokeargument name="LGnumero"		value="#id#">
								<cfinvokeargument name="LGlogin"		value="#act2#">
								<cfinvokeargument name="PQcodigo"		value="#act#">
								</cfinvoke>
							</cfif>
						<cfelse>
							<!---Actualiza en los logines el nuevo contrato al que van a pertenecer, actualiza en los servicios el nuevo paquete y registra en bitacora de logines--->	
							<cfinvoke component="saci.comp.ISBlogin" method="cambioContratoLogin">				
							<cfinvokeargument name="Contratoid"		value="#contrato#">
							<cfinvokeargument name="LGnumero"		value="#id#">
							<cfinvokeargument name="LGlogin"		value="#act2#">
							<cfinvokeargument name="PQcodigo"		value="#act#">
							</cfinvoke>
						</cfif>
					</cfloop>
				</cfif>				
			</cfloop>			
		</cfif>	
		</cftransaction>
		
	</cffunction>
	
	<!--------------------------------------------Logines por Borrar(ejecutado por SACI)------------------------------------------------------------>	
	<!--- Si en la estructura de logines por borrar hay logines que tambien existen en los logines por conservar se realiza el borrado fisico de cada
	 servicio que presente en la lista de servicios por borrar para ese login, si en la lista de logines por borrar y en la lista de servicios por borrar
	 incluyen el login y todos sus servicios entonces solo ejecuta un borrado logico de todo el login sin realizar el borrado fisico de los servicios --->
	<cffunction name="borrarServicios" access="public" returntype="void" output="false">
		<cfargument name="datasource" 	type="string" 	required="No"	default="#session.DSN#"	displayname="Datasourse">
		<cfargument name="arrLogBorr" 	type="string" 	required="yes"	displayname="Logines a Borrar">
		<cfargument name="PQnuevo"	 	type="string" 	required="yes"	displayname="PQcodigo nuevo">		
		<cfargument name="BLobs"	 	type="string" 	required="No"	displayname="Observaciones">				
		<cfargument name="AGid"	 		type="string" 	required="No"	displayname="ID Agente">
		<cfargument name="MSoperacion" 	type="string" 	required="Yes" 	default="I" 		displayname="Tipo de operacion">
		<cfargument name="MSfechaEnvio" type="string" 	required="no" 	default="#now()#" 	displayname="Fecha de envio del mensaje">
		<cfargument name="MSsaldo" 		type="numeric" 	required="no" 	default="0" 		displayname="Saldo_Mensajes_Cliente">
		<cfargument name="MSmotivo" 	type="string" 	required="no" 	default="I" 		displayname="Motivo_Mensajes_Cliente">
		<cfargument name="MStexto" 		type="string" 	required="no" 	default="" 			displayname="Texto_Mensajes_Cliente">
		<cfargument name="BLautomatica" type="string" 	required="no" 	default="0"	 		displayname="BLautomatica">		

		<cfif isdefined("Arguments.arrLogBorr") and ListLen(Arguments.arrLogBorr)>
			<cfquery datasource="#Arguments.datasource#" name="rsBorrar">
				select distinct LGnumero, LGlogin from ISBlogin
				where rtrim(ltrim(LGlogin)) in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#trim(Arguments.arrLogBorr)#">)
				and Habilitado=1
			</cfquery>
			
			<cfloop query="rsBorrar">
				<cfset idlogin= rsBorrar.LGnumero>
				<cfset login= rsBorrar.LGlogin>				
				
				<!---si la cantidad de servicios que borro es igual a la cantidad de servicios que posee el login en base de datos, hace el borrado logico de los logines, si no hace el borrado del servicio--->
				<cfquery datasource="#Arguments.datasource#" name="rsNumero">
					select count(1) as cant from ISBserviciosLogin
					where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idlogin#">
				</cfquery>
				
				<cfset servBorrar = ListValueCountNoCase(arrLogBorr, trim(login),',')>
				
				<!---Borrado Fisico de servicios--->
				<cfif servBorrar NEQ rsNumero.cant>
					<cfset listTScodigo="">
					<cfset ind = ListFindNoCase(arrLogBorr, trim(login), ',')>
					<cfloop  index="i" from = "#ind#" to = "#ind + servBorrar - 1#">
						<cfset listTScodigo = listTScodigo & IIF(len(trim(listTScodigo)),DE(','),DE(''))& ListGetAt(arrServBorr, i , ',')>
						<cfset i = i+1>
					</cfloop>
					<cfinvoke component="saci.comp.ISBserviciosLogin" method="Elimina_ListaServicio">
						<cfinvokeargument name="LGnumero"		value="#idlogin#">
						<cfinvokeargument name="listTScodigo"	value="#listTScodigo#">
					</cfinvoke>
				</cfif>
				
				<!---Borrado Logico de logines--->
				<cfif servBorrar EQ rsNumero.cant>
					
					
					<cfquery datasource="#Arguments.datasource#" name="rsISBServicios">
						select b.TScodigo from ISBserviciosLogin a
							inner join ISBservicio b
							on a.TScodigo = b.TScodigo
						where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idlogin#">
							and b.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQnuevo#">
					</cfquery>
							
					<cfloop query="rsISBServicios">	
					<cfinvoke component="saci.comp.ISBserviciosLogin" method="UpdatePaqueteServicio"><!---Actualiza la tabla ISBserviciosLogin con el nuevo paquete para el LGnumero que viene como argumento--->	
						<cfinvokeargument name="PQcodigo" value="#Arguments.PQnuevo#">
						<cfinvokeargument name="LGnumero" value="#idlogin#">
						<cfinvokeargument name="datasource" value="#Arguments.datasource#">
					</cfinvoke>
					</cfloop>

					<cfinvoke component="saci.comp.ISBlogin" method="RetirarLogin">	<!---Realiza borrado lógico, registra en la bitacora y registra en MensajesCliente(si el paquete es cablera, es decir si posee un mayorista)--->
						<cfinvokeargument name="LGnumero"	value="#idlogin#">
						<cfinvokeargument name="fecha"		value="#now()#">
						<cfinvokeargument name="borradoLogico"value="true">
						<cfinvokeargument name="datasource"value="#Arguments.datasource#">
						
						<cfinvokeargument name="BLautomatica"value="#Arguments.BLautomatica#">
						<cfif len(Arguments.BLobs)><cfinvokeargument name="BLobs"	value="#Arguments.BLobs#">
						<cfelse><cfinvokeargument name="BLobs"	value="Retiro del login #idlogin# por Cambio de Paquete."> </cfif>
						
						<cfif len(Arguments.AGid)><cfinvokeargument name="AGid"	value="#Arguments.AGid#"></cfif>
						<cfinvokeargument name="MSoperacion"	value="#Arguments.MSoperacion#">
						<cfinvokeargument name="MSfechaEnvio"	value="#Arguments.MSfechaEnvio#">
						<cfinvokeargument name="MSsaldo"		value="#Arguments.MSsaldo#">
						<cfinvokeargument name="MSmotivo"		value="#Arguments.MSmotivo#">
						<cfif len(Arguments.MStexto)><cfinvokeargument name="MStexto"	value="#Arguments.MStexto#">
						<cfelse><cfinvokeargument name="MStexto"value="Retiro por Cambio de Paquete."> </cfif>
					</cfinvoke>
				</cfif>
			</cfloop>
		</cfif>	
	</cffunction>
</cfcomponent>