<cfcomponent hint="Ver SACI-03-H014.doc" extends="base">
	<!---cambioPaquete--->
	<cffunction name="cambioPaquete" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="CINCAT" type="string" required="yes">
		<cfargument name="telefono" type="string" required="yes">
		<cfargument name="saldo" type="string" required="yes" default="0" hint="String por si viene vacío o inválido.">
		<cfargument name="INTPAD" type="string" required="yes" default="">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		<cfargument name="notificarSIIC" type="boolean" default="no" hint="Indica si el cambio debe notificarse al SIIC">
		<cfargument name="isbevento" type="string" required="no" default="SIIC" hint="Indica quién origino el evento en la tabla ISBproducto">
						
		<cfset control_inicio( Arguments, 'H014a', Arguments.login & ' isbevento= ' & Arguments.isbevento )>
				
		<cftry>
			<cfset control_servicio( 'siic' )>
			<cfset ProgramarAFuturo = false>
			<cfif Arguments.S02CON>
				<cfinvoke component="SSXS02" method="getTarea"
					S02CON="#Arguments.S02CON#" returnvariable="Tarea"/>
				<cfif Tarea.S02COF LT 0>
					<cfset control_mensaje( 'ISB-0012', 'Cambio paquete con S02COF=#Tarea.S02COF#' )>
					<cfset ProgramarAFuturo = true>
				</cfif>
			</cfif>
			<cfset control_servicio( 'saci' )>
			<cfquery datasource="#session.dsn#" name="ISBpaquete">
				<!--- Paquete destino --->
				select PQcodigo, PQroaming, PQmailQuota,
					PQinterfaz, PQnombre, PQtelefono
				from ISBpaquete
				where CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CINCAT#">
				and Habilitado = 1				
			</cfquery>
			<cfif ISBpaquete.RecordCount is 0>
				<cfthrow message="No hay un paquete habilitado con CINCAT = #Arguments.CINCAT#" errorcode="ISB-0013">
			</cfif>
	
			<cfif Arguments.telefono is '0000000'>
				<cfset Arguments.telefono = ''>
			</cfif>
			
			<cfif ISBpaquete.PQtelefono neq 1 And Len(Arguments.telefono)>
				<cfset Arguments.telefono = ''>
				<cfset control_mensaje( 'ISB-0014', 'Teléfono #Arguments.telefono# ignorado, paquete #ISBpaquete.PQcodigo#' )>
			</cfif>
			<cfset LGnumero = getLGnumero(Arguments.login)>
			<cfset ISBlogin = getISBlogin(LGnumero)>
					
			
			<cfset control_mensaje ('QRY-0004', 'LGnumero=#ISBlogin.LGnumero#, login=#Arguments.login#')>
			<!--- servicios disponibles en paquete destino --->
			<cfquery datasource="#session.dsn#" name="servicios_destino">
				select TScodigo
				from ISBservicio
				where PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBpaquete.PQcodigo#">
			</cfquery>
			<cfif Arguments.origen neq 'saci'>
		
				<cfquery datasource="#session.dsn#" name="ISBloginexiste">
					<!--- El login no puede estár borrado --->
					select count(1) cant
					from ISBlogin
					where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
					and Habilitado = 1				
				</cfquery>
				<cfif ISBloginexiste.cant is 0>
					<cfthrow message="El login #Arguments.login# se encuentra inactivo">
				</cfif>
					
				<cfquery datasource="#session.dsn#" name="ISBpaqueteactual">
					<!--- Paquete actual --->
					select paq.PQcodigo
					from ISBpaquete paq
						inner join ISBproducto pro
						on paq.PQcodigo = pro.PQcodigo
					where pro.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
					and paq.Habilitado = 1				
				</cfquery>
				<cfif ISBpaqueteactual.RecordCount is 0>
					<cfthrow message="No hay un paquete habilitado para el Contrato #ISBlogin.Contratoid#">
				</cfif>
							
				<cfquery datasource="#session.dsn#" name="ISBpaqueteCambio">
					<!--- Se verifica las reglas entre cambios de paquete --->
					select count(1) cant
					from ISBpaqueteCambio
					where PQcodDesde = <cfqueryparam cfsqltype="cf_sql_char" value="#ISBpaqueteactual.PQcodigo#">
					and PQcodHacia =  <cfqueryparam cfsqltype="cf_sql_char" value="#ISBpaquete.PQcodigo#">
				</cfquery>
				<!--- <cfif ISBpaqueteCambio.cant is 0>
					<cfthrow message="No se permite realizar el cambio del paquete #ISBpaqueteactual.PQcodigo# al paquete #ISBpaquete.PQcodigo# ">
				</cfif> --->
	
				<cfset control_servicio( 'saci' )>
				<cfset structureSaci.cambioPQ = StructNew()>
				<cfset structureSaci.cambioPQ.contrato = ISBlogin.Contratoid>
				<cfset structureSaci.cambioPQ.PQanterior = ISBlogin.PQcodigo>
				<cfset structureSaci.cambioPQ.PQnuevo = ISBpaquete.PQcodigo>
				<cfif Len(Arguments.INTPAD)>
					<cfset structureSaci.cambioPQ.CNsuscriptor = Arguments.INTPAD>
					<cfset structureSaci.cambioPQ.CNnumero = Arguments.INTPAD>
				</cfif>
				
				<cfset structureSaci.cambioPQ.logConservar = StructNew()>
				<cfset structureSaci.cambioPQ.logConservar.login = ''>
				<cfset structureSaci.cambioPQ.logConservar.servicios = ValueList(servicios_destino.TScodigo)>
				<cfset structureSaci.cambioPQ.logConservar.telefono = Arguments.telefono>
				
				<cfset structureSaci.cambioPQ.logBorrar = StructNew()>
				<cfset structureSaci.cambioPQ.logBorrar.login = ''>
				<cfset structureSaci.cambioPQ.logBorrar.servicios = ''>
				
				<cfset structureSaci.cambioPQ.pqAdicional = StructNew()>
				<cfset structureSaci.cambioPQ.pqAdicional.cod = ''>
				<cfset structureSaci.cambioPQ.pqAdicional.logMover = StructNew()>
				<cfset structureSaci.cambioPQ.pqAdicional.logMover.login = ''>
				<cfset structureSaci.cambioPQ.pqAdicional.logMover.servicios = ''>
				
				<cfif ProgramarAFuturo>
					<!--- Solamente realizar la programación de la tarea --->
					<cfinvoke component="saci.comp.generadorXML" method="CambioPaquete"
						returnvariable="PaqueteXML"
						cambioPQ="#structureSaci.cambioPQ#"
						cuentaid="#ISBlogin.CTid#"/>
					<cfset FinDeMes = CreateDate(Year(Now()), Month(Now()), 1)>
					<cfset FinDeMes = DateAdd('m', 1, FinDeMes)>
					<cfset FinDeMes = DateAdd('d', -1, FinDeMes)>
					<cfquery datasource="#session.dsn#" name="buscar_tarea">
						select TPid from ISBtareaProgramada
						where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.CTid#">
						  and Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
						  and TPtipo = 'CP'
						  and TPestado = 'P'
					</cfquery>
					<cfset control_mensaje ('ISB-0015', '#IIf(buscar_tarea.RecordCount, DE('Actualizar tarea programada'), DE('Nueva tarea programada'))#')>
					<cfinvoke component="saci.comp.ISBtareaProgramada" method="#IIf(buscar_tarea.RecordCount, DE('Cambio'), DE('Alta'))#"
						TPid="#buscar_tarea.TPid#"
						CTid="#ISBlogin.CTid#"
						Contratoid="#ISBlogin.Contratoid#"
						TPinsercion="#now()#"
						TPfecha="#FinDeMes#"
						TPdescripcion="Cambio del paquete #ISBlogin.PQcodigo#-#ISBlogin.PQnombre# por el paquete #ISBpaquete.PQcodigo#-#ISBpaquete.PQnombre# (#Arguments.origen#)"
						TPxml="#PaqueteXML#"
						TPestado="P"
						TPtipo="CP"
						TPorigen="ACUM"/>
				<cfelse>
					<!---Llamar a componente que realiza el cambio de paquete--->
					<cfset control_mensaje ('ISB-0016', 'Ejecutando cambio de paquete')>
					<cfinvoke component="saci.comp.ISBtareaProgramadaCP" method="cambioPaquete">
						<cfinvokeargument name="CTid"		value="#ISBlogin.CTid#">
						<cfif isdefined('LGnumero')>					
							<cfinvokeargument name="LGnumero"	value="#LGnumero#">
						</cfif>
						<cfinvokeargument name="Contratoid"	value="#ISBlogin.Contratoid#">
						<cfinvokeargument name="str"		value="#structureSaci#">
						<cfinvokeargument name="LGevento"	value="SIIC">
					</cfinvoke>
					<cfquery datasource="#session.dsn#" name="buscar_tarea">
						<!--- por si habían otros cambios de paquete pendientes --->
						delete from ISBtareaProgramada
						where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.CTid#">
						  and Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
						  and TPtipo = 'CP'
						  and TPestado = 'P'
					</cfquery>
				</cfif>
			</cfif>
			
			<cfif not ProgramarAFuturo>
				<cfset accesos = getTStipos(ISBlogin.LGnumero)>
			
				<!--- modificar solamente parentGroup y telefono
						maxSession no se actualiza porque no se puede cambiar de paquete VPN a no-VPN
						timeout no se actualiza porque los prepagos no cambian de paquete
				--->
				<cfset ISBlogin = getISBlogin(LGnumero)>
								<!--- Actualizar en SACISIIC --->
				<cfset control_mensaje ('SIC-0006', 'SERCLA=#ISBlogin.LGlogin#, CINCAT=#ISBlogin.CINCAT#')>
				<cfquery datasource="SACISIIC">
					update SSXINT
					set CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBlogin.CINCAT#">
					<cfif Len(Arguments.INTPAD)>
					, INTPAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.INTPAD#">
					</cfif>
					where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">
				</cfquery>
				<cfset control_mensaje ('SIC-0007', 'SERCLA=#ISBlogin.LGlogin#, CUECUE=#ISBlogin.CUECUE#, CINCAT=#ISBlogin.CINCAT#')>
				<cfquery datasource="SACISIIC">
					update SSXSSC
					set CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBlogin.CINCAT#">
					where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">
					and CUECUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBlogin.CUECUE#">
				</cfquery>
				
				
				
				<cfif ListFind(accesos, 'A')>
					<cfset control_servicio( 'acceso' )>
					<cfinvoke component="CiscoService" method="changeUserParent" 
						usuario="#ISBlogin.LGlogin#"
						newParent="#ISBlogin.PQnombre#" />
					
					<cfif (origen eq 'SIIC' and isbevento eq 'SIIC') 
					          or (origen eq 'SACI' and isbevento eq 'SACI' or isbevento eq 'ACUM')>
					<cfinvoke component="CiscoService" method="updateTelefono" 
						usuario="#ISBlogin.LGlogin#"
						telefono="#Arguments.telefono#" />
					</cfif>
				
				</cfif>
				<!--- Se actualiza el casillero de correos, la cuota pudo haber cambiado --->
				<cfif ListFind(accesos, 'C')>
					<cfinvoke component="IPlanetService" method="update"
						usuario="#ISBlogin.LGlogin#"
						mailQuotaKB="#ISBlogin.LGmailQuota#"
						RealName="#ISBlogin.LGrealName#"
						nombre="#ISBlogin.Pnombre#"
						apellido="#ISBlogin.Papellido# #ISBlogin.Papellido2#" />
				</cfif>

			</cfif>
			<!--- Cumplimiento --->
			<cfif Arguments.origen is 'siic'>
				<cfset control_servicio( 'siic' )>
				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#" />
			<cfelseif Arguments.origen is 'saci' and Arguments.notificarSIIC and isbevento eq 'SACI'>
				<!--- Notificar al siic --->
				<cfset S01VA1 = ArrayNew(1)>
				<cfset ArrayAppend(S01VA1, ISBlogin.CUECUE)>
				<cfset ArrayAppend(S01VA1, ISBlogin.LGlogin)>
				<cfset ArrayAppend(S01VA1, ISBlogin.CINCAT)>
				<cfif Len(Trim(ISBlogin.LGtelefono))>
					<cfset ArrayAppend(S01VA1, ISBlogin.LGtelefono)>
				<cfelse>
					<cfset ArrayAppend(S01VA1, '00000000')>
				</cfif>
				<cfset ArrayAppend(S01VA1, '0')>
				<cfset ArrayAppend(S01VA1, ISBlogin.Usulogin)>
				
				<cfif Len(ISBlogin.MRidMayorista)>
				<!---es cable modem se agrega el suscriptor--->
					<cfset ArrayAppend(S01VA1, ISBlogin.LGserids)>
				<cfelseif ListFind('8,9', ISBlogin.CINCAT)> 
					<!--- es paquete de correo --->
					<cfquery datasource="#session.dsn#" name="LGserids_padre">
					select LGserids
						from ISBlogin 
						where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
							and LGserids is not null
							and LGserids != ''
							and LGprincipal = 1
						order by LGnumero
					</cfquery>
					<cfset LGserids_padre = LGserids_padre.LGserids>
					<cfif Len(LGserids_padre) is 0>
						<cfset ArrayAppend(S01VA1, '0')>
					<cfelse>
						<cfset ArrayAppend(S01VA1, LGserids_padre)>
					</cfif>
				<cfelse>
				<!--- dejar el S01VA1 hasta donde iba --->
				</cfif>
				<cfquery datasource="SACISIIC">
					exec sp_Alta_SSXS01
						@S01ACC = 'Q',
						@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(S01VA1, '*')#">
				</cfquery>
			</cfif>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
				S02CON="#Arguments.S02CON#" 
				Error="#Request._saci_intf.Error#"/>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---cambioServiciosLogin. Se llama cuando se insert/update/delete en ISBserviciosLogin. El cambio de paquete se aplica en cambioPaquete, no aquí --->
	<cffunction name="cambioServiciosLogin" access="public" returntype="void">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="PQcodigo" type="string" required="yes">
		<cfargument name="TScodigo" type="string" required="yes">
		<cfargument name="Habilitado" type="boolean" required="yes">
		<cfargument name="TipoEvento" type="string" required="yes">
		<cfargument name="origen" type="string" default="siic">

		<cfset control_inicio( Arguments, 'H014b', '#Arguments.TipoEvento# #Arguments.LGnumero# #Arguments.PQcodigo# #Arguments.TScodigo#' )>
		<cftry>
		
			<!--- ver qué TStipo se está siendo insertado o borrado --->
			<cfquery datasource="#session.dsn#" name="ISBservicioTipo_Q">
				select c.TStipo
				from ISBservicioTipo c
				where c.TScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TScodigo#">
			</cfquery>
			<cfquery datasource="#session.dsn#" name="actual">
				select case when b.Habilitado = 1 and lg.Habilitado = 1
					then 1 else 0 end as Habilitado, b.SLpassword
				from ISBserviciosLogin b
					join ISBlogin lg
						on lg.LGnumero = b.LGnumero
				where b.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
				  and b.TScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TScodigo#">
			</cfquery>
			<!--- ver si es el único con el mismo TStipo que está habilitado --->
			<cfquery datasource="#session.dsn#" name="otros">
				select b.TScodigo
				from ISBlogin a
					join ISBserviciosLogin b
						on a.LGnumero = b.LGnumero
					join ISBservicioTipo c
						on c.TScodigo = b.TScodigo
				where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
				  and c.TStipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBservicioTipo_Q.TStipo#">
				  and c.TScodigo != <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TScodigo#">
				  and b.Habilitado = 1
				  and a.Habilitado = 1
			</cfquery>
			<!---
				Las condiciones para modificar el ambiente son:
				insert: El registro entra habilitado, y no hay otros habilitados para el mismo TStipo
				update: Cambia Habilitado, y no hay otros habilitados para el mismo TStipo
				delete: El registro sale habilitado, y no hay otros habilitados para el mismo TStipo
			--->
			<cflog file="isb_interfaz" text="analizar acción: #Arguments.TipoEvento#. Habilitado:#Arguments.Habilitado#->#actual.Habilitado#, otros: #otros.RecordCount#, Len(SLpassword): #Len(actual.SLpassword)#">
			<cfset control_mensaje( 'ISB-0017', 'analizar acción: #Arguments.TipoEvento#. Habilitado:#Arguments.Habilitado#->#actual.Habilitado#, otros: #otros.RecordCount#, Len(SLpassword): #Len(actual.SLpassword)#' )>
			<cfif otros.RecordCount>
				<cflog file="isb_interfaz" text="Había otros registros habilitados para TStipo=#ISBservicioTipo_Q.TStipo#: TScodigo=#ValueList(otros.TScodigo)#">
			<cfelse>
				<!--- obtener los datos de la cuenta --->
				<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
				<cfset control_asunto ( '#Arguments.TipoEvento# #ISBlogin.LGlogin# #Arguments.PQcodigo# #Arguments.TScodigo#' )>
				<cfif Arguments.TipoEvento is 'insert' and actual.Habilitado is 1
					Or Arguments.TipoEvento is 'update' and Arguments.Habilitado neq 1 and actual.Habilitado is 1>
					<!--- habilitar acceso --->
					<cflog file="isb_interfaz" text="habilitar acceso #ISBservicioTipo_Q.TStipo#">
					<!--- cisco: acceso A => Acceso --->
					<cfif ISBservicioTipo_Q.TStipo is 'A'>
						<cfset control_servicio( 'acceso' )>
						<cfinvoke component="CiscoService" method="createUser"
							usuario="#ISBlogin.LGlogin#"
							clave="#ISBlogin.SpwdAcceso#"
							parentGroup="#ISBlogin.PQnombre#"
							listaTelefonos="#ISBlogin.LGtelefono#"
							maxSession="#ISBlogin.PQmaxSession#" />
					</cfif>
					<!--- iplanet: acceso C => Correo --->
					<cfif ISBservicioTipo_Q.TStipo is 'C'>
						<cfset control_servicio( 'correo' )>
						<!--- Qué contraseña uso: estoy poniendo la del sobre --->
						<cfinvoke component="IPlanetService" method="add"
							usuario="#ISBlogin.LGlogin#"
							mailQuotaKB="#ISBlogin.LGmailQuota#"
							RealName="#ISBlogin.LGrealName#"
							nombre="#ISBlogin.Pnombre#"
							apellido="#ISBlogin.Papellido# #ISBlogin.Papellido2#"
							userpassword="#ISBlogin.SpwdAcceso#"/>
					</cfif>
				<cfelseif Arguments.TipoEvento is 'delete' and Arguments.Habilitado is 1
					Or Arguments.TipoEvento is 'update' and Arguments.Habilitado is 1 and actual.Habilitado neq 1>
					<!--- quitar acceso --->
					<cflog file="isb_interfaz" text="quitar acceso #ISBservicioTipo_Q.TStipo#">
					<!--- cisco: acceso A => Acceso --->
					<cfif ISBservicioTipo_Q.TStipo is 'A'>
						<cfset control_servicio( 'acceso' )>
						<cfinvoke component="CiscoService" method="deleteUser" 
							usuario="#ISBlogin.LGlogin#" />
					</cfif>
					<!--- iplanet: acceso C => Correo --->
					<cfif ISBservicioTipo_Q.TStipo is 'C'>
						<cfset control_servicio( 'correo' )>
						<cfinvoke component="IPlanetService" method="delete"
							usuario="#ISBlogin.LGlogin#" />
					</cfif>
				<cfelse>
					<cflog file="isb_interfaz" text="no activar ni inactivar">
					<!--- no realizar modificación --->
				</cfif>
				<!--- ipass: acceso R => Roaming no cambia en ISBserviciosLogin --->
			</cfif>
			
			<!--- cambiar contraseña si está especificada --->
			<cfif Len(actual.SLpassword) and actual.SLpassword neq '*'>
				<cflog file="isb_interfaz" text="cambiando contraseñas, TStipo = #ISBservicioTipo_Q.TStipo#">
				<!--- cisco: acceso A => Acceso --->
				<cfif ISBservicioTipo_Q.TStipo is 'A'>
					<cfset control_servicio( 'acceso' )>
					<cfinvoke component="CiscoService" method="updatePassword" 
						usuario="#ISBlogin.LGlogin#"
						newPassword="#actual.SLpassword#"/>
				</cfif>
				<!--- iplanet: acceso C => Correo --->
				<cfif ISBservicioTipo_Q.TStipo is 'C'>
					<cfset control_servicio( 'correo' )>
					<cfinvoke component="IPlanetService" method="updatePassword"
						usuario="#ISBlogin.LGlogin#"
						UserPassword="#actual.SLpassword#"/>
				</cfif>
				<cfset control_servicio('saci')>
				<cfquery datasource="#session.dsn#">
					update ISBserviciosLogin
					set SLpassword = '*'
					where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
					  and TScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TScodigo#">
				</cfquery>
			</cfif>
			
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>		
	</cffunction>
	<!---cambioPaqueteSACI. Método auxiliar para cambiar logines de un Contratoid--->
	<cffunction name="cambioPaqueteSACI" output="false" hint="Invoca al cambio de paquete">
		<cfargument name="Contratoid" type="numeric" required="yes">
		<cfargument name="isbevento" type="string" required="no" default="SACI" hint="Indica quién origino el evento en la tabla ISBproducto">
		
		<cfquery datasource="#session.dsn#" name="logines">
			select
				l.LGnumero, l.LGlogin, p.PQcodigo, l.LGtelefono,
				p.CNnumero, q.CINCAT
			from ISBlogin l
				join ISBproducto p
					on p.Contratoid = l.Contratoid
				join ISBpaquete q
					on q.PQcodigo = p.PQcodigo
			where p.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#">
		</cfquery>
		
		<cfloop query="logines">
			<cfinvoke component="#This#" method="cambioPaquete"
				origen="saci"
				login="#logines.LGlogin#"
				CINCAT="#logines.CINCAT#"
				telefono="#logines.LGtelefono#"
				INTPAD="#logines.CNnumero#"
				notificarSIIC="#logines.CurrentRow is 1#"
				isbevento="#isbevento#"/>
		</cfloop>
		
	</cffunction>
</cfcomponent>