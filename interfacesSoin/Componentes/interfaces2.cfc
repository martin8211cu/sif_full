<cffunction name="fnActivarMotor" access="public" returntype="struct">
	<cfargument name="CEcodigo" 	type="numeric" required="yes">
	<cfargument name="urlServidor" 	type="string" default="">
	<cfargument name="Parametros" 	type="boolean" default="no">

	<cfif Arguments.CEcodigo EQ -1><cfreturn></cfif>

	<cfset rsMotor = fnUrlServidorMotor (Arguments.CEcodigo, urlServidor, Parametros)>

	<cfif isdefined("Application.interfazSoin.CE_#Arguments.CEcodigo#")>
		<cfreturn rsMotor>
	</cfif>
	
	<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"] = structNew()>
	
	<!--- FINALIZA LOS PROCESOS CANCELADOS --->
	<cfquery name="rsProc" datasource="sifinterfaces">
		select NumeroInterfaz, IdProceso, SecReproceso
		  from InterfazColaProcesosCancelar
		 where CEcodigo = #Arguments.CEcodigo#
	</cfquery>
	<cfloop query="rsProc">
		<cfset fnProcesoFinalizar(rsProc.NumeroInterfaz,rsProc.IdProceso,-1, "-1", 'Proceso cancelado')>
	</cfloop>

	<!--- FINALIZA LOS PROCESOS QUE QUEDARON ACTIVOS --->
	<cfquery name="rsProc" datasource="sifinterfaces">
		select NumeroInterfaz, IdProceso, SecReproceso, TipoProcesamiento
		  from InterfazColaProcesos p
		 where CEcodigo = #Arguments.CEcodigo#
		   and StatusProceso = 2
	</cfquery>
	<cfset session.CEcodigo = Arguments.CEcodigo>
	<cfloop query="rsProc">
		<cfif rsProc.TipoProcesamiento EQ "S">
			<cfset fnProcesoFinalizarConError(rsProc.NumeroInterfaz,rsProc.IdProceso,rsProc.SecReproceso, 'Proceso cancelado al iniciar el Motor. El proceso estaba dormido o el Servidor de Aplicaciones quedó fuera de servicio antes de terminar su ejecución')>
		<cfelse>
			<cfset fnProcesoPendienteConError(rsProc.NumeroInterfaz,rsProc.IdProceso,rsProc.SecReproceso, 'Proceso cancelado al iniciar el Motor. El proceso estaba dormido o el Servidor de Aplicaciones quedó fuera de servicio antes de terminar su ejecución')>
		</cfif>
	</cfloop>

	<cfset LvarFechaActivacion = now()>
	<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"].FechaActivacion = LvarFechaActivacion>

	<cftransaction>
		<cfquery datasource="sifinterfaces">
			update InterfazMotor
			   set FechaActivacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaActivacion#">
				 , FechaActividad = null
			 where CEcodigo = #Arguments.CEcodigo#
		</cfquery>
		<cfquery datasource="sifinterfaces">
			update Interfaz
			   set FechaActivacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaActivacion#">
				 , FechaActividad 	= null
				 , Ejecutando		= 0
			 <!--- where CEcodigo = #Arguments.CEcodigo# --->
		</cfquery>
		<cfquery datasource="sifinterfaces">
			update InterfazColaProcesos
			   set FechaActivacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaActivacion#">
				 , FechaActividad = null
			 where CEcodigo = #Arguments.CEcodigo#
		</cfquery>
	</cftransaction>
	
	<cfreturn rsMotor>
</cffunction>

<cffunction name="fnUrlServidorMotor" access="public" returntype="struct">
	<cfargument name="CEcodigo" 	type="string" required="yes">
	<cfargument name="urlSrv" 		type="string" default="">
	<cfargument name="Parametros" 	type="boolean" default="no">

	<cfset var LvarMSG = "">

	<cftry>
		<cfquery name="rsMotor" datasource="sifinterfaces">
			select FechaActivacion, urlServidorMotor, Activo
			  from InterfazMotor
			 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		</cfquery>
		<cfif rsMotor.RecordCount EQ 0>
			<cfquery datasource="sifinterfaces">
				insert into InterfazMotor (CEcodigo) values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">)
			</cfquery>
			<cfquery name="rsMotor" datasource="sifinterfaces">
				select FechaActivacion, urlServidorMotor, Activo
				  from InterfazMotor
				 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			</cfquery>
		</cfif>
	
		<cfif not Arguments.Parametros AND Arguments.urlSrv EQ "">
			<cfif Not Arguments.Parametros and rsMotor.Activo EQ "0">
				<cfthrow type="INACTIVO" message="El Motor de Interfaces SOIN esta Inactivo">
			</cfif>
			<cfset LvarUrlServidor = rsMotor.urlServidorMotor>
		<cfelse>
			<cfset LvarUrlServidor = Arguments.urlSrv>
		</cfif>
	
		<cfif len(trim(LvarUrlServidor)) EQ 0>
			<cfthrow message="El Url del Servidor del Motor de Interfaces SOIN no puede quedar en blanco">
		</cfif>
		<cfif mid(LvarUrlServidor,len(LvarUrlServidor),1) NEQ "/">
			<cfset LvarUrlServidor = LvarUrlServidor & "/">
		</cfif>
		<cfset LvarPto = find("/cfmx/", LvarUrlServidor)>
		<cfif LvarPto EQ 0>
			<cfset LvarUrlServidor = LvarUrlServidor & "cfmx/">
		<cfelse>
			<cfset LvarUrlServidor = mid(LvarUrlServidor,1,LvarPto+5)>
		</cfif>
	
		<cfset LvarTareaAsincrona = LvarUrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm">
	
		<cfif Arguments.Parametros>
			<cftry>
				<cfhttp 	method		= "head"
							url			= "#LvarTareaAsincrona#"
							throwonerror="yes"
							timeout		="60"
				>
				</cfhttp>
			<cfcatch type="any">
				<cfthrow type="URLSOIN" message="#cfcatch.Message#" detail="#cfcatch.Detail#">
			</cfcatch>
			</cftry>
		
			<cfset LvarTareaAsincrona = LvarUrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#Arguments.CEcodigo#">
			<cfschedule action		= "update"
						task		= "Tarea Asincrona Motor Interfaces CE=#Arguments.CEcodigo#" 
						operation	= "httprequest"
						startdate	= "1/1/2000"
						starttime	="0:0:0"
						interval	= "61"
						requesttimeout="1"
						url			= "#LvarTareaAsincrona#"
			>
		</cfif>
	<cfcatch type="any">
		<cfset LvarMSG = "">
		<cfif not Arguments.Parametros>
			<cfset LvarMSG = "Error al Verificar el Motor de Interfaces SOIN: ">
		</cfif>
		<cfif cfcatch.Type EQ "URLSOIN">
			<cfset LvarMSG = LvarMSG & "Problemas con el URL del Servidor: ">
		</cfif>
		<cfset LvarMSG = mid(LvarMSG & cfcatch.Message & " " & cfcatch.Detail,1,255)>
		<cfif cfcatch.Type NEQ "INACTIVO">
			<cfquery datasource="sifinterfaces">
				update InterfazMotor
				   set Activo 	= 0
					 , MsgError = '#LvarMSG#'
				 where CEcodigo = #Arguments.CEcodigo#
			</cfquery>
			<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="CE=#Arguments.CEcodigo#, #LvarMSG#">
		</cfif>
		<cfthrow message="Corregir en Parametros de Interfaces SOIN: #cfcatch.Message# #cfcatch.Detail#">
	</cfcatch>
	</cftry>

	<cfset stMotor.urlServidorMotor	= LvarUrlServidor>
	<cfset stMotor.Activo 			= rsMotor.Activo>
	<cfset stMotor.FechaActivacion	= rsMotor.FechaActivacion>
	<cfreturn stMotor>
</cffunction>

<cffunction name="sbActivarCola" access="public">
	<cfargument name="CEcodigo" type="numeric" required="yes">

	<cfset var rsInterfaces = "">
	<cfset var LvarNow = Now()>

	<cftry>
		<cflock name="ColaCE#Arguments.CEcodigo#" timeout="10" throwontimeout="yes" type="exclusive">
			<cfif datediff("s",LvarNow,now()) GT 1>
				<cfthrow message="Hay mas de una tarea ejecutandose a la vez">
			</cfif>
			
			<cfobject type = "Java"	action = "Create" class = "java.lang.Thread" name = "LobjThread">
			<cfset LobjThread.sleep(3000)>

			<cfif not isdefined("Application.interfazSoin.CE_#Arguments.CEcodigo#")>
				<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"] = structNew()>
			</cfif>
			<cfset Application.interfazSoin["CE_#Arguments.CEcodigo#"].FechaActividad = now()>
		
			<cfif Arguments.CEcodigo EQ -1><cfreturn></cfif>
		
			<cfset rsMotor = fnActivarMotor (Arguments.CEcodigo)>
		
			<cfset LvarNow = Now()>	
			<cfquery datasource="sifinterfaces">
				update InterfazMotor
				   set FechaActividad = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarNow#">
				 where CEcodigo = #Arguments.CEcodigo#
			</cfquery>
		
			<cfset LvarSegs = "floor (#dateDiff("s",rsMotor.FechaActivacion,LvarNow)#/(i.MinutosRetardo*60))*i.MinutosRetardo*60">
			<cfset LvarFechaActivacion = "'#DateFormat(rsMotor.FechaActivacion,'dd-mm-yyyy')# #TimeFormat(rsMotor.FechaActivacion,'HH:mm:ss')#'">
			<cf_dbfunction name="timeadd" args="#LvarSegs#,#LvarFechaActivacion#" returnvariable="LvarFechaActividad" datasource="sifinterfaces">
	
			<cftransaction isolation="read_uncommitted">
				<cfquery name="rsInterfaces" datasource="sifinterfaces">
					select i.NumeroInterfaz
					  from Interfaz i
					 where i.Activa	= 1
					   and i.TipoProcesamiento = 'A'
					   and coalesce(
								(
									select count(1) from InterfazColaProcesos p
									 where p.CEcodigo 		= #Arguments.CEcodigo#
									   and p.NumeroInterfaz = i.NumeroInterfaz
									   and p.StatusProceso 	= 1
									   <!--- FechaInclusion <= FechaActivacion + int((FechaActivacion-Now())/MinutosRetardo)*MinutosRetardo --->
									   and p.FechaInclusion <= 
											case coalesce(i.MinutosRetardo,0)
												when 0 then p.FechaInclusion
												else #PreserveSingleQuotes(LvarFechaActividad)#
											end
								)
							, 0) > 0
					order by NumeroInterfaz
				</cfquery>
			</cftransaction>
		
			<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="Activando Interfaces CE=#Arguments.CEcodigo#:">
			<cfloop query="rsInterfaces">
				<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="Activando Interfaz #rsInterfaces.NumeroInterfaz#">
		
				<cfset LvarTareaAsincrona = LvarUrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#Arguments.CEcodigo#&NI=#rsInterfaces.NumeroInterfaz#">
				<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="Envia a Ejecutar #LvarTareaAsincrona#">
				<cfhttp 	method		= "get"
							url			= "#LvarTareaAsincrona#"
							timeout		= "1"
							throwonerror="no"
				>
				</cfhttp>
			</cfloop>
		</cflock>
	<cfcatch type="any">
		<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="Error Activando Interfaces CE=#Arguments.CEcodigo#: #cfcatch.Message#">
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="sbInvocarInterfaz" access="public">
	<cfargument name="UrlServidor" 		type="string" required="yes">
	<cfargument name="CEcodigo" 		type="numeric" required="yes">
	<cfargument name="NumeroInterfaz"	type="numeric" required="yes">

	<cfset LvarTareaAsincrona = Arguments.UrlServidor & "interfacesSoin/tareaAsincrona/activarCola.cfm?CE=#Arguments.CEcodigo#&NI=#Arguments.NumeroInterfaz#">
	<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="Envia a Ejecutar #LvarTareaAsincrona#">
	<cfhttp 	method		= "get"
				url			= "#LvarTareaAsincrona#"
				timeout		= "1"
				throwonerror="no"
	>
	</cfhttp>
</cffunction>

<cffunction name="sbActivarInterfaz" access="public">
	<cfargument name="CEcodigo" 		type="numeric" required="yes">
	<cfargument name="NumeroInterfaz"	type="numeric" required="yes">
	
	<cfif Arguments.CEcodigo EQ -1><cfreturn></cfif>
	<cfif Arguments.NumeroInterfaz EQ -1><cfreturn></cfif>
	<cfset rsMotor = fnActivarMotor (Arguments.CEcodigo)>

	<cfset LvarMinutos = dateDiff("n",rsMotor.FechaActivacion,now())>
	<cftry>
		<cfquery name="rsInterfaz42" datasource="sifinterfaces">
			select i.Componente
			  from Interfaz i
			 <!--- where i.CEcodigo 	= Arguments.CEcodigo --->
			 where i.NumeroInterfaz = #Arguments.NumeroInterfaz#
			   and i.Activa = 1
			   and i.Ejecutando = 0
		</cfquery>
		<cfif rsInterfaz42.recordCount GT 0>
			<cfquery datasource="sifinterfaces">
				update Interfaz
				   set FechaActividad = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					 , Ejecutando = 1
				 <!--- where i.CEcodigo 	= Arguments.CEcodigo --->
				 where NumeroInterfaz = #Arguments.NumeroInterfaz#
			</cfquery>
			<cfloop condition="true">
				<cfquery name="rsProc" datasource="sifinterfaces">
					select 	p.IdProceso, p.SecReproceso, p.EcodigoSDC, p.UsucodigoInclusion, p.FechaInclusion,
							p.ParametrosSOIN, p.TipoMovimientoSOIN
					  from InterfazColaProcesos p
					 where p.CEcodigo = #Arguments.CEcodigo#
					   and p.NumeroInterfaz = #Arguments.NumeroInterfaz#
					   and p.StatusProceso = 1
					order by FechaInclusion
				</cfquery>
				<cfif rsProc.recordCount EQ 0><cfbreak></cfif>
				<cfloop query="rsProc">
					<cfif rsProc.EcodigoSDC EQ "">
						<cfthrow message="No se registró el EcodigoSDC para el proceso en la Cola de Procesos">
					</cfif>
					<cfif rsProc.UsucodigoInclusion EQ "">
						<cfthrow message="No se registró el UsucodigoInclusion para el proceso en la Cola de Procesos">
					</cfif>
					<cfset sbIniciarSession (Arguments.CEcodigo, rsProc.EcodigoSDC, rsProc.UsucodigoInclusion)>
					<cfset LvarMSG = fnActivarProceso	(Arguments.CEcodigo, Arguments.NumeroInterfaz, rsProc.IdProceso, rsProc.SecReproceso, rsInterfaz42.Componente, 'A', rsProc.ParametrosSOIN, rsProc.TipoMovimientoSOIN)> 
				</cfloop>
			</cfloop>
			<cfquery name="rsInterfaz" datasource="sifinterfaces">
				update Interfaz
				   set Ejecutando = 0
				 <!--- where i.CEcodigo 	= Arguments.CEcodigo --->
				 where NumeroInterfaz = #Arguments.NumeroInterfaz#
			</cfquery>
		</cfif>
	<cfcatch>
		<cfquery name="rsInterfaz" datasource="sifinterfaces">
			update Interfaz
			   set Ejecutando = 0
			 <!--- where i.CEcodigo 	= Arguments.CEcodigo --->
			 where NumeroInterfaz = #Arguments.NumeroInterfaz#
		</cfquery>
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="sbIniciarSession" access="public" returntype="string">
	<cfargument name="CEcodigo" 	type="numeric" required="yes">
	<cfargument name="EcodigoSDC"	type="numeric" required="yes">
	<cfargument name="Usucodigo"	type="numeric" required="yes">

	<cfset session.autoafiliado = Arguments.Usucodigo>

	<cfset session.login_no_interactivo = true>
	<cfset form.j_empresa 	= "">
	<cfset LvarEcodigoSDC 	= Arguments.EcodigoSDC>
	<cfset form.j_username 	= "">
	<cfset form.j_password 	= "">
	<cfinclude template="/home/check/dominio.cfm">
	<cfinclude template="/home/check/autentica.cfm">
	<!--- <cfinclude template="/home/check/acceso.cfm"> --->
	<cfif not isdefined("session.usucodigo") or session.usucodigo eq 0>
		<cfset fnErrorHdr("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Usuario no Autorizado")>
	</cfif>
	<cfquery name="rsEmpresas" datasource="asp">
		select distinct p.Ecodigo as EcodigoSDC, Enombre, 
			'#trim(session.datos_personales.Nombre) & " " & trim(session.datos_personales.Apellido1) & " " & trim(session.datos_personales.Apellido2)#' as Nombre
		  from vUsuarioProcesos p
			   inner join Empresa e 
				  on CEcodigo = #Session.CEcodigo#
				 and p.Ecodigo = e.Ecodigo
		 where Usucodigo=#Session.Usucodigo#
		   and p.Ecodigo = #LvarEcodigoSDC#
	</cfquery>
	<cfif rsEmpresas.recordCount NEQ 1>
		<cfset fnErrorHdr("ERROR DE SEGURIDAD ANTES DE INICIAR LA INTERFAZ: Empresa no Autorizada")>
	</cfif>
	<cfset CreateObject("Component","/home/check/functions").seleccionar_empresa(rsEmpresas.EcodigoSDC)>
</cffunction>

<cffunction name="fnActivarProceso" access="public" returntype="string">
	<cfargument name="CEcodigo" 			type="numeric"	required="yes">
	<cfargument name="NumeroInterfaz"		type="numeric" 	required="yes">
	<cfargument name="IdProceso"			type="numeric" 	required="yes">
	<cfargument name="SecReproceso"			type="numeric" 	required="yes">
	<cfargument name="Componente"			type="string" 	required="yes">
	<cfargument name="TipoProcesamiento"	type="string" 	required="yes">
	<cfargument name="ParametrosSOIN"		type="string" 	required="yes">
	<cfargument name="TipoMovimientoSOIN"	type="string" 	required="yes">

	<cfset var LvarMSG = "OK">

	<cftry>
		<cfif Arguments.TipoProcesamiento EQ "A">
			<cfquery datasource="sifinterfaces">
				update InterfazColaProcesos
				   set StatusProceso = 2
					 , FechaInicioProceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 where CEcodigo 		= #session.CEcodigo#
				   and NumeroInterfaz	= #Arguments.NumeroInterfaz#
				   and IdProceso		= #Arguments.IdProceso#
				   and SecReproceso		= #Arguments.SecReproceso#
				   and StatusProceso	= 1
			</cfquery>
		</cfif>

		<cfset GvarNI = Arguments.NumeroInterfaz>
		<cfset GvarID = Arguments.IdProceso>
		<cfset GvarSR = Arguments.SecReproceso>

		<cfset sbEjecutarComponente(Arguments.Componente, Arguments.ParametrosSOIN, Arguments.TipoMovimientoSOIN)>

		<cfif Arguments.TipoProcesamiento EQ "A">
			<cfset sbProcesoSpFinal (Arguments.CEcodigo, GvarNI,GvarID,GvarSR)>
		</cfif>
		<cfset fnProcesoFinalizarConExito (GvarNI,GvarID,GvarSR)>
	<cfcatch type="any">
		<cfif fnIsBug(cfcatch)>
			<cfset LvarMSGstackTrace = fnGetStackTrace(cfcatch)>
			<cfset LvarMSG = "ERROR DE EJECUCION">
		<cfelse>
			<cfset LvarMSGstackTrace = "">
			<cfset LvarMSG = "#cfcatch.Message# #cfcatch.Detail#">
		</cfif>

		<cfif Arguments.TipoProcesamiento EQ "S">
			<cfset fnProcesoFinalizarConError (GvarNI,GvarID,GvarSR,LvarMSG,LvarMSGstackTrace)>
		<cfelseif cfcatch.Type NEQ "spFinal">
			<cfset fnProcesoPendienteConError (GvarNI,GvarID,GvarSR,LvarMSG,LvarMSGstackTrace)>
		</cfif>
	</cfcatch>
	</cftry>

	<cfreturn LvarMSG>
</cffunction>
 
<cffunction name="sbEjecutarComponente" access="private" returntype="string">
	<cfargument name="Componente"			type="string" 	required="yes">
	<cfargument name="ParametrosSOIN"		type="string" 	required="yes">
	<cfargument name="TipoMovimientoSOIN"	type="string" 	required="yes">
	
	<cfset StructClear(url)>
	<cfloop index="LvarParms" list="#Arguments.ParametrosSOIN#" delimiters="&">
		<cfset LvarParm = listToArray(LvarParms,"=")>
		<cfif arrayLen(LvarParm) EQ 2>
			<cfset url[LvarParm[1]] = URLDecode(LvarParm[2])>
		</cfif>
	</cfloop>
	<cfparam name="url.ID" default="#GvarID#">
	<cfparam name="url.MODO" default="#Arguments.TipoMovimientoSOIN#">

	<cfinclude template="#Arguments.Componente#">
</cffunction>

<cffunction name="sbProcesoSpFinal" access="public">
	<cfargument name="CEcodigo" 			type="numeric"	required="yes">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">

	<cftry>
		<cfquery name="rsMotor" datasource="sifinterfaces">
			select spFinal, spFinalTipo
			  from InterfazMotor
			 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		</cfquery>
		<cfif rsMotor.spFinal NEQ "">
			<cfif rsMotor.spFinalTipo EQ "S">
				<cfquery name="rsInterfaz" datasource="sifinterfaces">
					select ejecutarSpFinal
					  from Interfaz
					 where <!--- CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#"> and ---> 
							NumeroInterfaz = #Arguments.NumeroInterfaz#
				</cfquery>
				<cfif rsInterfaz.ejecutarSpFinal EQ "S">
					<cfif application.dsinfo.sifinterfaces.type EQ 'sybase'>
						<cfquery datasource="sifinterfaces" >
							set nocount on
							exec #rsMotor.spFinal# #Arguments.NumeroInterfaz#, #Arguments.IdProceso#
						</cfquery>
					<cfelseif application.dsinfo.sifinterfaces.type EQ 'oracle'>
						<cfstoredproc datasource="sifinterfaces" procedure="#rsMotor.spFinal#" >
							<cfprocparam cfsqltype="cf_sql_numeric" value="#Arguments.NumeroInterfaz#">
							<cfprocparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
						</cfstoredproc>
					<cfelse>
						<cfthrow message="Tipo de Base de Datos no soportado en datasource='sifinterfaces'">
					</cfif>
				</cfif>
			<cfelseif NOT fileExists(expandPath(rsMotor.spFinal))>
				<cfthrow message="No existe el fuente '#rsMotor.spFinal#' del spFinal del Motor de Interfaces">
			<cfelse>
				<cfinclude template="#rsMotor.spFinal#">
			</cfif>
		</cfif>
	<cfcatch type="any">
		<cfset LvarMSG = "#cfcatch.Message# #cfcatch.Detail#">
		<cfset fnProcesoSpFinalConError (Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.SecReproceso,LvarMSG,"")>
		<cfthrow type="spFinal" message="#LvarMSG#">
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="sbReportarActividad" access="public">
	<cfargument name="NumeroInterfaz" 		type="string" required="yes">
	<cfargument name="IdProceso" 			type="string" required="yes">

	<cfset session.InterfazSoin.NI = Arguments.NumeroInterfaz>
	<cfset session.InterfazSoin.ID = Arguments.IdProceso>
	<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
		<cfset Application.interfazSoin["CE_#session.CEcodigo#"]["ID_#Arguments.IdProceso#"] = now()>
		<cfif isdefined("Application.InterfazSoin.CE_#session.CEcodigo#.ID_CAN_#Arguments.IdProceso#")>
			<cfset LvarMSG = Application.InterfazSoin["CE_#session.CEcodigo#"]["ID_CAN_#Arguments.IdProceso#"]>
			<cfthrow message="#LvarMSG#">
		</cfif>
	</cflock>
</cffunction>

<cffunction name="fnProcesoNuevoExterno" access="public" returntype="string">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="IdProceso" 			type="numeric" required="yes">
	<cfargument name="UsuarioDbInclusion"	type="string" required="yes">
	
	<cfset rsInterfaz = fnVerificaInterfaz(Arguments.NumeroInterfaz, "E")>
	<cfif rsInterfaz.TipoProcesamiento EQ "D">
		<cfthrow message="ERROR DE ANTES DE INICIAR LA INTERFAZ: Se intenta ejecutar una Interfaz Directa sin utilizar el WebService XML">
	</cfif>
	<cfreturn fnProcesoNuevo (Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.UsuarioDbInclusion,rsInterfaz,"","")>
</cffunction>

<cffunction name="fnProcesoNuevoExternoXML" access="public" returntype="struct">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="UsuarioDbInclusion"	type="string" required="yes">
	
	<cfset rsInterfaz = fnVerificaInterfaz(Arguments.NumeroInterfaz, "E")>
	<cfif rsInterfaz.TipoProcesamiento EQ "D">
		<cftry>
			<cfif form.XML_OUT EQ "0">
				<cfthrow message="ERROR DE ANTES DE INICIAR LA INTERFAZ: Se intenta ejecutar una Interfaz Directa indicando que no devuelva datos por XML">
			</cfif>

			<cfset GvarNI = Arguments.NumeroInterfaz>
			<cfset GvarID = 0>
			<cfset GvarSR = 0>
			<cfset GvarXML_IE = url.XML_IE>
			<cfset GvarXML_ID = url.XML_ID>
			<cfset GvarXML_IS = url.XML_IS>
		
			<cfset LvarRet = structNew()>
			<cfset sbEjecutarComponente(rsInterfaz.Componente, "", "")>
			<cfset LvarRet.MSG = "OK">
			<cfset LvarRet.DIRECTA = true>
			<cfset LvarRet.XML_OE = GvarXML_OE>
			<cfset LvarRet.XML_OD = GvarXML_OD>
			<cfset LvarRet.XML_OS = GvarXML_OS>
		<cfcatch type="any">
			<cfif fnIsBug(cfcatch)>
				<cfset LvarMSGstackTrace = fnGetStackTrace(cfcatch)>
				<cfset LvarRet.MSG = "ERROR DE EJECUCION: #LvarMSGstackTrace#">
			<cfelse>
				<cfset LvarMSGstackTrace = "">
				<cfset LvarRet.MSG = "#cfcatch.Message# #cfcatch.Detail#">
			</cfif>
		</cfcatch>
		</cftry>
		<cfset LvarRet.ID  = '0'>
		<cfreturn LvarRet>
	</cfif>

	<cfset GvarID  = fnSiguienteIdProceso()>
	<cfset sbGeneraXMLtoTabla(Arguments.NumeroInterfaz, GvarID, "E", url.XML_IE)>
	<cfset sbGeneraXMLtoTabla(Arguments.NumeroInterfaz, GvarID, "D", url.XML_ID)>
	<cfset sbGeneraXMLtoTabla(Arguments.NumeroInterfaz, GvarID, "S", url.XML_IS)>
	<cfset LvarRet = structNew()>
	<cfset LvarRet.MSG = fnProcesoNuevo (Arguments.NumeroInterfaz, GvarID, Arguments.UsuarioDbInclusion,rsInterfaz,"","")>
	<cfset LvarRet.ID  = GvarID>
	<cfreturn LvarRet>
</cffunction>

<cffunction name="fnProcesoNuevoSoin" access="public" returntype="string">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="ParametrosSOIN"		type="string" required="yes">
	<cfargument name="TipoMovimientoSOIN"	type="string" required="yes">
	
	<cfif not isdefined("Application.dsinfo.sifinterfaces")>
		<cfreturn "OK">
	</cfif>
	<cfset rsInterfaz = fnVerificaInterfaz(Arguments.NumeroInterfaz, "S")>
	<cfif rsInterfaz.TipoProcesamiento EQ "D">
		<cfthrow message="ERROR DE ANTES DE INICIAR LA INTERFAZ: Se intenta ejecutar una Interfaz Directa originada desde SOIN (sólo se permiten en Interfaces Externas)">
	</cfif>
	<cfreturn fnProcesoNuevo (Arguments.NumeroInterfaz,fnSiguienteIdProceso(),session.Usulogin,rsInterfaz,Arguments.ParametrosSOIN,Arguments.TipoMovimientoSOIN)>
</cffunction>

<cffunction name="fnSiguienteIdProceso" access="private" returntype="numeric">
	<cfset LvarIdProceso = 0>
	<cfif Application.dsinfo.sifinterfaces.type EQ "sybase">
		<cfquery name="rsSQL" datasource="sifinterfaces">
			exec S_IdProceso_Nextval
		</cfquery>
		<cfset LvarIdProceso = rsSQL.ID>
	<cfelseif Application.dsinfo.sifinterfaces.type EQ "oracle">
		<cfquery name="rsSQL" datasource="sifinterfaces">
			SELECT S_IDPROCESO.NEXTVAL as ID FROM DUAL
		</cfquery>
		<cfset LvarIdProceso = rsSQL.ID>
	</cfif>
	<cfreturn LvarIdProceso>
</cffunction>

<cffunction name="sbGeneraTablaToXML" access="public" output="true">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="IdProceso" 			type="numeric" required="yes">
	<cfargument name="TipoTabla"			type="string"  required="yes">

	<cftry>
		<cfquery name="rsSQL" datasource="sifinterfaces">
			select * from #Arguments.TipoTabla##Arguments.NumeroInterfaz#
			 where ID = #Arguments.IdProceso#
		</cfquery>
		<cf_dbstruct name="#Arguments.TipoTabla##Arguments.NumeroInterfaz#" datasource="sifinterfaces">
		<cfset LvarCampos 	= valueList(rsStruct.name)>
		<cfset LvarCFtypes 	= valueList(rsStruct.cf_type)>
		
<cfoutput>
<!--
</cfoutput>
<cfoutput><response name="XML_#Arguments.TipoTabla#">
</cfoutput>
			<cfif form.XML_DBS EQ "1">
<cfoutput>  <dbstruct>
</cfoutput>
			<cfloop query="rsStruct">
<cfoutput>    <column name="#rsStruct.name#" type="#rsStruct.cf_type#" len="#rsStruct.len#" ent="#rsStruct.ent#" dec="#rsStruct.dec#" mandatory="#rsStruct.mandatory#"/>
</cfoutput>
			</cfloop>
<cfoutput>  </dbstruct>
</cfoutput>
			</cfif>
<cfoutput>  <recordset>
</cfoutput>
		<cfloop query="rsSQL">
<cfoutput>    <row>
</cfoutput>
			<cfset LvarPto = 0>
			<cfloop index="LvarCampo" list="#LvarCampos#">
				<cfset LvarPto = LvarPto + 1>
				<cfset LvarCFType = listGetAt(LvarCFtypes,LvarPto)>
				<cfset LvarValor  = evaluate("rsSQL.#LvarCampo#")>
				<cfif LvarCFType EQ "B">
					<cfset LvarValor = ToBase64(LvarValor)>
				<cfelseif LvarCFType EQ "D">
					<cfset LvarValor = "#DateFormat(LvarValor,"YYYY-MM-DD")# #TimeFormat(LvarValor,"HH:mm:ss")#">
				<cfelseif LvarCFType EQ "N">
				<cfelseif LvarCFType EQ "S">
					<cfset LvarValor = XMLformat(LvarValor)>
				</cfif>
<cfoutput>      <#LvarCampo#>#LvarValor#</#LvarCampo#>
</cfoutput>
			</cfloop>
<cfoutput>    </row>
</cfoutput>
		</cfloop>
<cfoutput>  </recordset>
</cfoutput>
<cfoutput></response>
</cfoutput>
<cfoutput>-->
</cfoutput>
	<cfcatch type="any"></cfcatch>
	</cftry>
</cffunction>

<cffunction name="sbGeneraXMLtoTabla" access="private">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="IdProceso" 			type="numeric" required="yes">
	<cfargument name="Nivel"	 			type="string" required="yes">
	<cfargument name="XML" 					type="string" required="yes">
	
	<cfif trim(Arguments.XML) EQ "">
		<cfreturn>
	</cfif>

	<cftry>
		<cf_dbstruct name="I#Nivel##NumeroInterfaz#" datasource="sifinterfaces">
		<cfif rsStruct.recordCount EQ 0>
			<cfthrow message="Tabla I#Nivel##NumeroInterfaz# no esta definida en Base Datos de Interfaz">
		</cfif>
		<cfset LvarNames = "">
		<cfloop query="rsStruct">
			<cfset LvarName = rsStruct.name>
			<cfif LvarName NEQ "ts_rversion">
				<cfset LvarNames = "#LvarNames#, #LvarName#">
			</cfif>
		</cfloop>
		<cfset LvarNames = mid(LvarNames,2,1000)>

		<cfset LvarXML = XmlParse(Arguments.XML)>
		<cfloop index="i" from="1" to="#arrayLen(LvarXML.resultset.XmlChildren)#"> 
			<cfset LvarValues = "">
			<cfquery datasource="sifinterfaces">
				insert into I#Nivel##NumeroInterfaz# (#LvarNames#)
				values (
				<cfloop query="rsStruct">
					<cfset LvarName = rsStruct.name>
					<cfif LvarName NEQ "ts_rversion">
						<cfif LvarName EQ "ID">
							<cfset LvarValue = GvarID>
						<cfelse>
							<cfset LvarPos = XmlChildPos(LvarXML.resultset.row[i],LvarName, 1)>
							<cfif LvarPos EQ -1>
								<cfthrow message="No se existe valor en el XML para el Campo '#LvarName#' en la linea #i#">
							<cfelse>
								<cfset LvarValue = LvarXML.resultset.row[i].XmlChildren[LvarPos].XmlText>

								<cfset LvarCFType = rsStruct.cf_type>
								<cfif LvarCFType EQ "B">
									<cfset LvarValue = ToBinary(LvarValue)>
								<cfelseif LvarCFType EQ "D">
								<cfelseif LvarCFType EQ "N">
									<cfset LvarValue = replace(LvarValue,",","","ALL")>
								<cfelseif LvarCFType EQ "S">
								</cfif>
							</cfif>
						</cfif>
						<cfif LvarValues NEQ "">
							,
						</cfif>
						<cfqueryparam cfsqltype="#rsStruct.cf_sql_type#" value="#LvarValue#" null="#trim(LvarValue) eq ''#">
						<cfset LvarValues = "#LvarValues#, #LvarValue#">
					</cfif>
				</cfloop>
				)
			</cfquery>
			<cfset LvarSQL = "insert into I#Nivel##NumeroInterfaz# (#LvarNames#) values (#mid(LvarValues,2,1000)#)">
		</cfloop>
	<cfcatch type="any">
			<cfthrow object="#cfcatch#">
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="fnProcesoNuevo" access="private" returntype="string">
	<cfargument name="NumeroInterfaz" 		type="numeric" 	required="yes">
	<cfargument name="IdProceso" 			type="numeric" 	required="yes">
	<cfargument name="UsuarioDbInclusion"	type="string" 	required="yes">
	<cfargument name="rsInterfaz"			type="query" 	required="yes">
	<cfargument name="ParametrosSOIN"		type="string" 	required="yes">
	<cfargument name="TipoMovimientoSOIN"	type="string" 	required="yes">

	<cfset var LvarMSG = "OK">
	<cftry>
		<cfset rsMotor = fnActivarMotor (session.CEcodigo)>
	
		<cfquery name="rsProceso" datasource="sifinterfaces">
			select count(1) as cantidad
			  from InterfazColaProcesos
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
			   and IdProceso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
		</cfquery>
		<cfif rsProceso.cantidad GT 0>
			<cfthrow message="Proceso '#Arguments.IdProceso#' de la Interfaz '#Arguments.NumeroInterfaz#' ya fue incluido en la Cola de Procesos">
		</cfif>
	
		<cfquery name="rsProceso" datasource="sifinterfaces">
			select count(1) as cantidad
			  from InterfazBitacoraProcesos
			 where CEcodigo 		= #Session.CEcodigo#
			   and NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
			   and IdProceso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
			   and StatusProceso <> 12
		</cfquery>
		<cfif rsProceso.cantidad GT 0>
			<cfthrow message="Proceso '#Arguments.IdProceso#' de la Interfaz '#Arguments.NumeroInterfaz#' ya fue incluido y finalizado en la Cola de Procesos">
		</cfif>

		<cfquery datasource="sifinterfaces">
			insert into InterfazColaProcesos
				(
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					StatusProceso, 
					UsucodigoInclusion, 
					UsuarioBdInclusion, 
					FechaInclusion,
					FechaInicioProceso
					<cfif Arguments.OrigenInterfaz EQ "S">
					, ParametrosSOIN, TipoMovimientoSOIN
					</cfif>
				)
			values (
				 #session.CEcodigo#
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#NumeroInterfaz#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#IdProceso#">
				,#session.EcodigoSDC#
				,'#Arguments.rsInterfaz.OrigenInterfaz#'
				,'#Arguments.rsInterfaz.TipoProcesamiento#'
				,<cfif Arguments.rsInterfaz.TipoProcesamiento EQ "A">1<cfelse>2</cfif>
				,#session.Usucodigo#
				,<cfqueryparam cfsqltype="cf_sql_char" value="#UsuarioDbInclusion#">
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				,<cfif Arguments.rsInterfaz.TipoProcesamiento EQ "A">
					null
				 <cfelse>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 </cfif>
				<cfif Arguments.OrigenInterfaz EQ "S">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#ParametrosSOIN#">
					, <cfqueryparam cfsqltype="cf_sql_char" value="#TipoMovimientoSOIN#">
				</cfif>
				)
		</cfquery>
	<cfcatch type="any">
		<cfif fnIsBug(cfcatch)>
			<cfset LvarMSGstackTrace = fnGetStackTrace(cfcatch)>
			<cfset LvarMSG = "ERROR DE EJECUCION">
			<cfset fnProcesoNuevoConError (Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.UsuarioDbInclusion,"E",LvarMSG,LvarMSGstackTrace)>
		<cfelse>
			<cfset LvarMSG = "ERROR ANTES DE INICIAR LA INTERFAZ: #cfcatch.Message# #cfcatch.Detail#">
			<cfset fnProcesoNuevoConError (Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.UsuarioDbInclusion,"E",LvarMSG)>
		</cfif>
	</cfcatch>
	</cftry>
	
	<cfif LvarMSG EQ "OK">
		<cfif Arguments.rsInterfaz.TipoProcesamiento EQ "S">
			<cfif Arguments.rsInterfaz.OrigenInterfaz EQ "S">
				<cfthrow message="ERROR DE ANTES DE INICIAR LA INTERFAZ: Una Interfaz originada por SOIN no puede ser Sincrónica">
			</cfif>
			<cfset LvarMSG = fnActivarProceso	(session.CEcodigo, Arguments.NumeroInterfaz, Arguments.IdProceso, '0', Arguments.rsInterfaz.Componente, 'S', '', '')> 
		<cfelse>
			<!------------------------------------ PROCESAMIENTO ASINCRONICO --------------------------------------->
			<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=1 (Solicitud de procesamiento)">
			<cfif Arguments.rsInterfaz.MinutosRetardo EQ 0>
				<cfset sbInvocarInterfaz (rsMotor.urlServidorMotor, session.CEcodigo, Arguments.NumeroInterfaz)>
			</cfif>
		</cfif>
	</cfif>
	
	<cfreturn LvarMSG>
</cffunction>

<cffunction name="fnVerificaInterfaz" access="public" returntype="query">
	<cfargument name="NumeroInterfaz" 		type="numeric" required="yes">
	<cfargument name="OrigenInterfaz"		type="string" required="yes">

	<cfquery name="rsInterfaz" datasource="sifinterfaces">
		select Descripcion,
			   OrigenInterfaz,
			   TipoProcesamiento,
			   Componente,
			   Activa,
			   coalesce(MinutosRetardo,0) as MinutosRetardo
		  from Interfaz
		 where NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
	</cfquery>
	<cfif rsInterfaz.recordCount EQ 0>
		<cfif Arguments.OrigenInterfaz EQ "E">
			<cfthrow message="Interfaz '#Arguments.NumeroInterfaz#' no esta definida en los parámetros del Sistema">
		<cfelse>
			<cfreturn "OK">
		</cfif>
	<cfelseif rsInterfaz.Activa NEQ 1>
		<cfif Arguments.OrigenInterfaz EQ "E">
			<cfthrow message="Interfaz '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#' no esta Activa en los parámetros del Sistema">
		<cfelse>
			<cfreturn "OK">
		</cfif>
	<cfelseif rsInterfaz.OrigenInterfaz NEQ Arguments.OrigenInterfaz>
		<cfif rsInterfaz.OrigenInterfaz NEQ "E">
			<cfthrow message="Interfaz '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#' no esta definida como Interfaz Externa hacia SOIN en los parámetros del Sistema">
		<cfelse>
			<cfthrow message="Interfaz '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#' no esta definida como Interfaz desde SOIN hacia sistemas Externos en los parámetros del Sistema">
		</cfif>
	<cfelseif NOT fileExists(expandPath(rsInterfaz.Componente))>
		<cfthrow message="No existe el fuente '#rsInterfaz.Componente#' del Componente de la Interfaz '#Arguments.NumeroInterfaz#=#rsInterfaz.Descripcion#'">
	</cfif>
	
	<cfreturn rsInterfaz>
</cffunction>

<cffunction name="fnProcesoNuevoConError" access="public">
	<cfargument name="NumeroInterfaz" 	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="UidDataBase" 		type="string" required="yes">
	<cfargument name="OrigenInterfaz" 	type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">

	<cfset var LvarMSG = "">
	<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, BEGIN">
	<cfif Arguments.MSGstackTrace NEQ ""><cfset LvarMSG=Arguments.MSGstackTrace><cfelse><cfset LvarMSG=Arguments.MSG></cfif>
	<cfset LvarStatus="12 (Error antes de iniciar la interfaz)">
	<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=#LvarStatus#, MSG=#LvarMSG#">
	<cfset fnLogDatos ("I", Arguments.IdProceso, Arguments.NumeroInterfaz)>
	<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, END">

 	<cfquery datasource="sifinterfaces">
		insert into InterfazBitacoraProcesos
		    (
				CEcodigo,
				NumeroInterfaz,
				IdProceso,
				SecReproceso,
				EcodigoSDC,
				OrigenInterfaz,
				TipoProcesamiento,
				StatusProceso,
				FechaInclusion,
				UsucodigoInclusion,
				UsuarioBdInclusion,
				MsgError,
				MsgErrorStack
			)
		values (
			 #session.CEcodigo#
			,<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
			,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
			,999999
			,#session.EcodigoSDC#
			,'#Arguments.OrigenInterfaz#'
			,'0'
			,12
			,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			,#session.Usucodigo#
			,<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.UidDataBase#">
			,<cfqueryparam cfsqltype="cf_sql_char" value="#mid(Arguments.MSG,1,255)#">
			,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#" null="#Arguments.MSGstackTrace EQ ''#">
			)
	</cfquery>
</cffunction>

<cffunction name="fnProcesoFinalizarConExito" access="public">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfset fnProcesoFinalizar(Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.SecReproceso, "10", "OK")>
</cffunction>

<cffunction name="fnProcesoFinalizarConError" access="public">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">
	<cfset fnProcesoFinalizar(Arguments.NumeroInterfaz,Arguments.IdProceso,Arguments.SecReproceso, "11", Arguments.MSG, Arguments.MSGstackTrace)>
</cffunction>

<cffunction name="fnProcesoCancelar" access="public">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">

	<cfquery name="rsSQL" datasource="sifinterfaces">
		select count(1) as Cantidad
		  from InterfazColaProcesosCancelar
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
		   and IdProceso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IdProceso#">
		   and SecReproceso		= #Arguments.SecReproceso#
	</cfquery>
	<cfif rsSQL.Cantidad EQ 0>
		<cfquery datasource="sifinterfaces">
			insert into InterfazColaProcesosCancelar 
				(
					CEcodigo,
					NumeroInterfaz,
					IdProceso,
					SecReproceso,
					UsucodigoCancela,
					FechaCancelacion,
					MsgCancelacion
				)
			values (
					#session.CEcodigo#,
					#Arguments.NumeroInterfaz#,
					#Arguments.IdProceso#,
					#Arguments.SecReproceso#,
					#session.Usucodigo#,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#mid(Arguments.MSG,1,255)#">
				)
		</cfquery>
	</cfif>

	<cfquery name="rsProceso" datasource="sifinterfaces">
		select StatusProceso
		  from InterfazColaProcesos
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
		   and IdProceso 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#IdProceso#">
		   and SecReproceso		= #Arguments.SecReproceso#
	</cfquery>

	<cfif rsProceso.StatusProceso EQ "2">
		<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
			<cfset Application.InterfazSoin["CE_#session.CEcodigo#"]["ID_CAN_#Arguments.IdProceso#"] = "CANCELADO POR #session.usuLogin#: " & mid(Arguments.MSG,1,255)>
		</cflock>
	<cfelse>
		<cfset fnProcesoFinalizar(Arguments.NumeroInterfaz,Arguments.IdProceso,-1, "-1", Arguments.MSG)>
	</cfif>
</cffunction>

<cffunction name="fnProcesoFinalizar" access="private">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="StatusProceso"	type="string" required="yes">
	<!--- StatusProceso EQ "-1" equivale a Cancelar un Proceso --->
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">

	<cftransaction>
		<cfif Arguments.StatusProceso EQ "-1">
			<cfquery name="rsCancelado" datasource="sifinterfaces">
				select 	UsucodigoCancela, 
						FechaCancelacion, 
						MsgCancelacion
			  	  from InterfazColaProcesosCancelar c
				 where CEcodigo 		= #session.CEcodigo#
				   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
				   and IdProceso		= #Arguments.IdProceso#
			</cfquery>
			<cfif rsCancelado.RecordCount EQ 0>
				<cfset Cancelar.Usucodigo = session.Usucodigo>
			</cfif>
		<cfelse> 
			<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, BEGIN">
			<cfif Arguments.MSGstackTrace NEQ ""><cfset LvarMSG=Arguments.MSGstackTrace><cfelse><cfset LvarMSG=Arguments.MSG></cfif>
			<cfif Arguments.StatusProceso EQ "10"><cfset LvarStatus="10 (Finalizado con exito)"><cfelse><cfset LvarStatus="11 (Finalizado con error)"></cfif>
			<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, Status=#LvarStatus#, MSG=#LvarMSG#">
			<cfset fnLogDatos ("I", Arguments.IdProceso, Arguments.NumeroInterfaz)>
			<cfif Arguments.StatusProceso EQ "10">
				<cfset fnLogDatos ("O", Arguments.IdProceso, Arguments.NumeroInterfaz)>
			</cfif>
			<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, END">

			<cfquery datasource="sifinterfaces">
				update InterfazColaProcesos
				   set StatusProceso 	= #Arguments.StatusProceso#
					 , MsgError			= <cfqueryparam cfsqltype="cf_sql_char" value="#mid(Arguments.MSG,1,255)#">
					 <cfif Arguments.MSGstackTrace NEQ "">
					 , MsgErrorStack	= <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#">
					 </cfif>
				 where CEcodigo = #session.CEcodigo#
				   and NumeroInterfaz	= #Arguments.NumeroInterfaz#
				   and IdProceso		= #Arguments.IdProceso#
				   and SecReproceso		= #Arguments.SecReproceso#
			</cfquery>
		</cfif>

		<cfquery datasource="sifinterfaces">
			insert into InterfazBitacoraProcesos
				(
					CEcodigo,
					NumeroInterfaz,
					IdProceso,
					SecReproceso,
					EcodigoSDC,
					OrigenInterfaz,
					TipoProcesamiento,
					StatusProceso,
					FechaInclusion,
					UsucodigoInclusion,
					UsuarioBdInclusion,
					FechaInicioProceso,
					FechaFinalProceso,
					MsgError,
					MsgErrorStack,
					ParametrosSOIN,
					TipoMovimientoSOIN
					<cfif Arguments.StatusProceso EQ "-1">
						,UsucodigoCancela, 
						FechaCancelacion, 
						MsgCancelacion
					</cfif>
				)
			select 
					p.CEcodigo,
					p.NumeroInterfaz,
					p.IdProceso,
					p.SecReproceso,
					p.EcodigoSDC,
					p.OrigenInterfaz,
					p.TipoProcesamiento,
					p.StatusProceso,
					p.FechaInclusion,
					p.UsucodigoInclusion,
					p.UsuarioBdInclusion,
					p.FechaInicioProceso,
					case 
						when p.FechaFinalProceso is not null
							then p.FechaFinalProceso 
						when p.FechaInicioProceso is not null
							then <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					end,
					p.MsgError,
					p.MsgErrorStack,
					p.ParametrosSOIN,
					p.TipoMovimientoSOIN
					<cfif Arguments.StatusProceso EQ "-1">
						,#rsCancelado.UsucodigoCancela#, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCancelado.FechaCancelacion#">,
						'#rsCancelado.MsgCancelacion#'
					</cfif>
			  from InterfazColaProcesos p
			 where p.CEcodigo 			= #session.CEcodigo#
			   and p.NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and p.IdProceso			= #Arguments.IdProceso#
		</cfquery>
		<cfquery datasource="sifinterfaces">
			delete from InterfazColaProcesosCancelar
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
		</cfquery>
		<cfquery datasource="sifinterfaces">
			delete from InterfazColaProcesos
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
		</cfquery>
	</cftransaction>
	<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_#Arguments.IdProceso#")>
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_CAN_#Arguments.IdProceso#")>
	</cflock>
</cffunction>

<cffunction name="fnProcesoReprocesar" access="public">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">

	<cftransaction>
		<cfquery datasource="sifinterfaces">
			update InterfazColaProcesos
			   set StatusProceso 	= 4
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
			   and SecReproceso		= #Arguments.SecReproceso#
		</cfquery>
	
	 	<cfquery datasource="sifinterfaces">
			insert into InterfazColaProcesos
				(
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					SecReproceso,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					StatusProceso, 
					FechaInclusion,
					FechaInicioProceso,
					UsucodigoInclusion, 
					UsuarioBdInclusion,
					ParametrosSOIN,
					TipoMovimientoSOIN
				)
			select 
					CEcodigo, 
					NumeroInterfaz, 
					IdProceso, 
					SecReproceso+1,
					EcodigoSDC, 
					OrigenInterfaz, 
					TipoProcesamiento, 
					1, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					null,
					#session.Usucodigo#, 
					UsuarioBdInclusion,
					ParametrosSOIN,
					TipoMovimientoSOIN
			  from InterfazColaProcesos
				 where CEcodigo 		= #session.CEcodigo#
				   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
				   and IdProceso		= #Arguments.IdProceso#
				   and SecReproceso		= #Arguments.SecReproceso#
		</cfquery>
	</cftransaction>
	<cfquery name="rsInterfaz" datasource="sifinterfaces">
		select coalesce(MinutosRetardo,0) as MinutosRetardo
		  from Interfaz
		 where NumeroInterfaz 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">
	</cfquery>
	<cfif rsInterfaz.MinutosRetardo EQ 0>
		<cfquery name="rsMotor" datasource="sifinterfaces">
			select urlServidorMotor
			  from InterfazMotor
			 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		</cfquery>
		<cfset sbInvocarInterfaz (rsMotor.urlServidorMotor, session.CEcodigo, Arguments.NumeroInterfaz)>
	</cfif>
</cffunction>

<cffunction name="fnLogDatos">
	<cfargument name="T"				type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">

	<cfset LvarLogName = "InterfacesSoin#DateFormat(now(),'YYYYMMDD')#">
	<cfif Arguments.T EQ "I">
		<cfset LvarTablaType = "Input">
	<cfelse>
		<cfset LvarTablaType = "Output">
	</cfif>
	
	<cftry>
		<cfset LvarTabla = "#Arguments.T#E#Arguments.NumeroInterfaz#">
		<cfquery name="rsSQL" datasource="sifinterfaces">
			select * from #LvarTabla# where ID=#Arguments.IdProceso#
		</cfquery>
		<cfset LvarCols = rsSQL.getColumnNames()>
		<cflog file="#LvarLogName#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarCols)#">
		<cfloop query="rsSQL">
			<cfset LvarVals = arrayNew(1)>
			<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
				<cfset LvarVal = evaluate("rsSQL.#LvarCols[i]#")>
				<cfif isBinary(LvarVal)>
					<cfset LvarVals[i] = createobject("component","sif.Componentes.DButils").toTimeStamp(LvarVal)>
				<cfelse>
					<cfset LvarVals[i] = LvarVal>
				</cfif>
			</cfloop>
			<cflog file="#LvarLogName#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarVals)#">
		</cfloop>
	<cfcatch type="any">
		<cflog file="#LvarLogName#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Error=#cfcatch.Message# #cfcatch.Detail#">
	</cfcatch>
	</cftry>
	
	<cftry>
		<cfset LvarTabla = "#Arguments.T#D#Arguments.NumeroInterfaz#">
		<cfquery name="rsSQL" datasource="sifinterfaces">
			select * from #LvarTabla# where ID=#Arguments.IdProceso#
		</cfquery>
		<cfset LvarCols = rsSQL.getColumnNames()>
		<cflog file="#LvarLogName#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarCols)#">
		<cfloop query="rsSQL">
			<cfset LvarVals = arrayNew(1)>
			<cfloop index="i" from="1" to="#arrayLen(LvarCols)#">
				<cfset LvarVal = evaluate("rsSQL.#LvarCols[i]#")>
				<cfif isBinary(LvarVal)>
					<cfset LvarVals[i] = createobject("component","sif.Componentes.DButils").toTimeStamp(LvarVal)>
				<cfelse>
					<cfset LvarVals[i] = LvarVal>
				</cfif>
			</cfloop>
			<cflog file="#LvarLogName#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Columns=#ArrayToList(LvarVals)#">
		</cfloop>
	<cfcatch type="any">
		<cflog file="#LvarLogName#" text="ID=#Arguments.IdProceso#, Interfaz=#Arguments.NumeroInterfaz#, #LvarTablaType#=#LvarTabla#, Error=#cfcatch.Message# #cfcatch.Detail#">
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="fnProcesoPendienteConError" access="public">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">

	<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_#Arguments.IdProceso#")>
		<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_CAN_#Arguments.IdProceso#")>
	</cflock>
	<cfquery datasource="sifinterfaces">
		update InterfazColaProcesos
		   set StatusProceso = 3
			 , FechaFinalProceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			 , MsgError			 = <cfqueryparam cfsqltype="cf_sql_char" value="#mid(Arguments.MSG,1,255)#">
			 <cfif Arguments.MSGstackTrace NEQ "">
			 , MsgErrorStack	 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#">
			 </cfif>
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
		   and IdProceso		= #Arguments.IdProceso#
		   and SecReproceso		= #Arguments.SecReproceso#
		   and StatusProceso 	= 2
	</cfquery>
</cffunction>

<cffunction name="fnProcesoSpFinalConError" access="public">
	<cfargument name="NumeroInterfaz"	type="string" required="yes">
	<cfargument name="IdProceso" 		type="string" required="yes">
	<cfargument name="SecReproceso"		type="string" required="yes">
	<cfargument name="MSG"				type="string" required="yes">
	<cfargument name="MSGstackTrace"	type="string" required="no" default="">

<cflock name="interfazSoin_#session.CEcodigo#" timeout="1" throwontimeout="no" type="exclusive">
	<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_#Arguments.IdProceso#")>
	<cfset StructDelete(Application.interfazSoin["CE_#session.CEcodigo#"],"ID_CAN_#Arguments.IdProceso#")>
</cflock>
<cftry>
	<cfquery datasource="sifinterfaces">
		update InterfazColaProcesos
		   set StatusProceso = 5
			 , FechaFinalProceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			 , MsgError			 = <cfqueryparam cfsqltype="cf_sql_char" value="#mid(Arguments.MSG,1,255)#">
			 <cfif Arguments.MSGstackTrace NEQ "">
			 , MsgErrorStack	 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#">
			 </cfif>
		 where CEcodigo 		= #session.CEcodigo#
		   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
		   and IdProceso		= #Arguments.IdProceso#
		   and SecReproceso		= #Arguments.SecReproceso#
	</cfquery>
<cfcatch type="any">
	<cftry>
		<cfset LvarPersisteError = false>
		<cfquery datasource="sifinterfaces">
			update InterfazColaProcesos
			   set StatusProceso = 5
				 , FechaFinalProceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 , MsgError			 = <cfqueryparam cfsqltype="cf_sql_char" value="#mid(Arguments.MSG,1,255)#">
				 <cfif Arguments.MSGstackTrace NEQ "">
				 , MsgErrorStack	 = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.MSGstackTrace#">
				 </cfif>
			 where CEcodigo 		= #session.CEcodigo#
			   and NumeroInterfaz 	= #Arguments.NumeroInterfaz#
			   and IdProceso		= #Arguments.IdProceso#
			   and SecReproceso		= #Arguments.SecReproceso#
		</cfquery>
	<cfcatch type="any">
		<cfset LvarPersisteError = true>
	</cfcatch>
	</cftry>
	<cfif LvarPersisteError>
		<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="CE=#session.CEcodigo#, ERROR EN SP_FINAL QUE NO SE PUDO ATRAPAR: #Arguments.MSG#">
		<cfif Arguments.MSGstackTrace NEQ "">
			<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="CE=#session.CEcodigo#, ERROR TRACE EN SP_FINAL: #Arguments.MSGstackTrace#">
		</cfif>

		<cfthrow message="ERROR EN SP_FINAL QUE NO SE PUDO ATRAPAR (ver log de interfaces): #Arguments.MSG#. ERROR POR EL QUE NO SE PUDO ATRAPAR: #cfcatch.Message#">
	</cfif>
</cfcatch>
</cftry>
</cffunction>

<cffunction name="fnGetStackTrace" access="private" returntype="string">
	<cfargument name="LprmError">

	<cfset TemplateRoot = Replace(ExpandPath(""), "\", "/",'all')>
	<cfset LvarStackTrace = "<strong>ERROR DE EJECUCION:</strong> (Type: #LprmError.Type#)<BR>#LprmError.Message#<BR>">
	<cfif trim(LprmError.Detail) NEQ "">
		<cfset LvarStackTrace = LvarStackTrace & "#LprmError.Detail#<BR>">
	</cfif>
	<cfif IsDefined("LprmError.TagContext") and IsArray(LprmError.TagContext) and ArrayLen(LprmError.TagContext) NEQ 0>
		<cfset LvarStackTrace = LvarStackTrace & "<strong>Template Stack Trace</strong>:<br>">
		<cfloop from="1" to="#ArrayLen(LprmError.TagContext)#" index="i">
			<cfset TagContextTemplate = LprmError.TagContext[i].Template>
			<cfset TagContextTemplate = Replace(TagContextTemplate, "\", "/", 'all')>
			<cfset TagContextTemplate = ReplaceNoCase(TagContextTemplate, TemplateRoot, "")>
			<cfset LvarStackTrace = LvarStackTrace & " at " & 
				TagContextTemplate & ":" &
				LprmError.TagContext[i].Line>
				<cfset LvarTagContextI = LprmError.TagContext[i]>
				<cfif isdefined('LvarTagContextI.ID')>
					<cfset LvarStackTrace = LvarStackTrace  & " (" & LprmError.TagContext[i].ID & ")">
				</cfif>
			<cfset LvarStackTrace = LvarStackTrace & "<br>" >
		</cfloop>
	</cfif>
	<cfreturn LvarStackTrace>
</cffunction>

<cffunction name="fnIsBug" access="public" returntype="string">
	<cfargument name="LprmError">

	<cfset LvarTagContext1 = LprmError.TagContext[1]>
	<cfif isdefined('LvarTagContext1.ID')>
		<cfreturn NOT (ucase(LprmError.Type) EQ "APPLICATION" AND ucase(LprmError.TagContext[1].ID) EQ "CFTHROW")>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cffunction name="fnErrorHdr" access="private">
	<cfargument name="msg" type="string" required="yes">

	<cfset GvarMSG = Arguments.msg>
	<cflog file="InterfacesSoin#DateFormat(now(),'YYYYMMDD')#" text="ID=#url.ID#, Interfaz=#url.NI#, MSG=#GvarMSG#">
	<cfheader name="SOIN-MSG" value="#URLEncodedFormat(GvarMSG)#">
	<cfinclude template="interfaz-service-form.cfm">
	<cfset session.AU = "">
	<cfabort>
</cffunction>