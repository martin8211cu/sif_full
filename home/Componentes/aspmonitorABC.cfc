<cfcomponent output="no">
<cfset This.PoliticasCFC = CreateObject("component", "home.Componentes.Politicas")><!---Inicializa el componente---->
<cfset This.activo = This.PoliticasCFC.trae_parametro_global("monitor.habilitar", 1) is 1>

<cffunction name="Monitoreo" output="no">
	<cfargument name="SScodigo" type="string" required="yes">
	<cfargument name="SMcodigo" type="string" required="yes">
	<cfargument name="SPcodigo" type="string" required="yes">
	
	<cfparam name="session.monitoreo.sessionid" default="0" type="numeric">
	<cfparam name="session.sitio.ip" default="">
	<cfparam name="session.sitio.host" default="">
	<cfparam name="session.Usucodigo" default="0">
	<cfparam name="session.Usuario" default="">

	<cfif not IsDefined("Application.srvprocid") or len(trim(Application.srvprocid)) eq 0>
		<!--- Ver si apenas estamos levantando el servidor --->
		<!--- esto no lo ponemos en cola, se supone que solamente una vez se va a hacer cuando el servidor reinicie --->
		<cfset This.InsertMonServerProcess()>
	</cfif>
	<cfif This.activo or (session.monitoreo.sessionid is 0)>
		<cfset thread = CreateObject("java", "java.lang.Thread")>
		<cfset MonPacket = StructNew()>
		<cfset MonPacket.threadName     = thread.currentThread().getName()>
		<cfset MonPacket.sessionid      = session.monitoreo.sessionid>
		<cfset MonPacket.requestid      = "">
		<cfset MonPacket.SScodigo       = Arguments.SScodigo>
		<cfset MonPacket.SMcodigo       = Arguments.SMcodigo>
		<cfset MonPacket.SPcodigo       = Arguments.SPcodigo>
		<cfset MonPacket.QueryString    = This.GetQueryString()>
		<cfset MonPacket.Usucodigo      = session.Usucodigo>
		<cfset MonPacket.login          = session.Usuario>
		<cfset MonPacket.ipaddr         = session.sitio.ip>
		<cfset MonPacket.ScriptName     = CGI.SCRIPT_NAME>
		<cfset MonPacket.RequestMethod  = CGI.REQUEST_METHOD>
		<cfset MonPacket.StartTime      = Now()>
		<cfset MonPacket.FinishTime     = "">
		<cfset MonPacket.HttpHost       = "">
		<cfif IsDefined('session.EcodigoSDC')>
			<cfset MonPacket.EcodigoSDC = session.EcodigoSDC>
		<cfelse>
			<cfset MonPacket.EcodigoSDC = ''>
		</cfif>
		<cfif IsDefined('session.CEcodigo')>
			<cfset MonPacket.CEcodigo = session.CEcodigo>
		<cfelse>
			<cfset MonPacket.CEcodigo = ''>
		</cfif>
		<cfset MonPacket.usedMemory = This.GetUsedMemory()>
		<cfset MonPacket.IsNewSession  = IsDefined('Request.SesionNuevaFavorNoExpirar')>
		<!--- Crear WeakReference con el Request (ver QuitarThreadsInactivos) --->
		<cfset Request.WeakReferent = CreateObject("java","java.lang.String").init("WeakReferent")>
		<cfset MonPacket.WeakRef = CreateObject("java","java.lang.ref.WeakReference").init( Request.WeakReferent )>
		<cfif Right(CGI.SCRIPT_NAME,3) neq 'CFC'>
		<cftry>
		<cfset httpRequestData = GetHTTPRequestData()>
		<cfcatch type="any"><!--- Da error si se invoca desde un web service ---></cfcatch></cftry>
		</cfif>
		<cfif IsDefined('httpRequestData')>
			<cfset myReq = httpRequestData.headers>
			<cfif StructKeyExists(myReq,"X-Forwarded-Host")>
				<cfset MonPacket.HttpHost = ListAppend(MonPacket.HttpHost, Trim(myReq["X-Forwarded-Host"]))>
			</cfif>
			<cfif StructKeyExists(myReq,"Host")>
				<cfset MonPacket.HttpHost = ListAppend(MonPacket.HttpHost, Trim(myReq["Host"]))>
			</cfif>
		</cfif>
	</cfif>
	<!--- esto se hace aunque el monitoreo esté inactivo:
		Crear la sesión, y expirarla --->
	<cfif (session.monitoreo.sessionid is 0)>
		<!--- esto no se puede poner en cola, porque el sessionid es requisito para que lo de la cola sirva --->
		<cfset This.InsertMonProcesos(MonPacket)>
		<cfset This.InsertMonHistoria(MonPacket)>
		<cfset This.InsertMonRequest(MonPacket)>
	<cfelse>
		<cfif This.activo>
			<cfset This.enqueue(MonPacket)>
		</cfif>
		<cfset This.VerSiLaSesionYaExpiro()>
	</cfif>
	<cfif This.activo>
		<!--- liberar cualquier request anterior que hubiera en este mismo thread --->
		<cfif IsDefined('server.monitor_thread') and StructKeyExists(server.monitor_thread, MonPacket.threadName)>
			<cfif Len(server.monitor_thread[MonPacket.threadName].FinishTime) EQ 0>
				<cfset server.monitor_thread[MonPacket.threadName].FinishTime = Now()>
			</cfif>
		</cfif>
		<!--- /liberar cualquier request anterior que hubiera en este mismo thread --->
	
		<!--- insertar este request server.monitor_thread --->
		<cflock name="server_monitor_thread" timeout="1" throwontimeout="yes" type="exclusive" >
			<cfif Not IsDefined('server.monitor_thread')>
				<cfset server.monitor_thread = StructNew()>
			</cfif>
			<cfset StructInsert(server.monitor_thread, MonPacket.threadName, MonPacket, true)>
		</cflock>
		<!--- /insertar este request server.monitor_thread --->
		
		<!--- guardar para el MonitoreoEnd --->
		<cfset Request.MonPacket = MonPacket>
	</cfif>
</cffunction>

<cffunction name="ProcesaPacket" output="no">
	<cfargument name="MonPacket" type="struct" >
	
	<cfset var mp = LeerMonProcesos(MonPacket.sessionid)>
	
	<cfif Len(MonPacket.requestid) is 0>
		<!--- paquete sin insertar, vamos a insertarlo ya --->
		<cfif (mp.RecordCount Is 0)>
			<cflog file="monitoreo" text="Sesion perdida: #MonPacket.sessionid#">
			<cfthrow message="Sesion perdida: #MonPacket.sessionid#">
		</cfif>
		<cfset MonPacket.historiaid = mp.historiaid>
		<cfset This.UpdateMonHistoria(mp.historiaid)>
		<cfif  ( Len(mp.historiaid) Is 0 )
			Or ( Trim(mp.SScodigo) NEQ Trim(MonPacket.SScodigo) )
			Or ( Trim(mp.SMcodigo) NEQ Trim(MonPacket.SMcodigo) )
			Or ( Trim(mp.SPcodigo) NEQ Trim(MonPacket.SPcodigo) )>
			<cfset This.InsertMonHistoria(MonPacket)>
		</cfif>
		<cfset This.UpdateMonProcesos(MonPacket)>
		<cfset This.InsertMonRequest(MonPacket)>
	</cfif>
	<cfif Len(MonPacket.requestid)>
		<cfif  Len(MonPacket.finishTime)>
			<cfset millis = MonPacket.FinishTime.getTime() - MonPacket.StartTime.getTime()>
			<!--- 
				Quitar de monitor_thread
			--->
			<cfif StructKeyExists(server.monitor_thread, MonPacket.threadName)>
				<cfset StructDelete( server.monitor_thread , MonPacket.threadName )>
			</cfif>
		<cfelse>
			<!--- se deja en la cola de nuevo, esperando el tiempo final --->
			<cfset This.enqueue(MonPacket)>
			<cfset Ahora = Now()>
			<cfset millis = Ahora.getTime() - MonPacket.StartTime.getTime()>
		</cfif>
		<cfquery datasource="aspmonitor">
			update MonRequest
			set millis = <cfqueryparam cfsqltype="cf_sql_numeric" value="#millis#">
			where requestid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MonPacket.requestid#">
		</cfquery>
	</cfif>
</cffunction>


<cffunction name="InsertMonProcesos" output="no">
	<cfargument name="MonPacket" type="struct" >

	<cftransaction>
	<cfquery datasource="aspmonitor" name="insert1">
	  insert into MonProcesos (
		Usucodigo, ip, login, srvprocid,
		SScodigo, SMcodigo, SPcodigo,
		historiaid, desde, acceso, user_agent, http_host,
		Ecodigo, CEcodigo)
	  values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,
		<cfif Len(Arguments.MonPacket.login)>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.login#">,
		<cfelse>' ',
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Application.srvprocid#">,
		
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SScodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SMcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SPcodigo#">,
		0, 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.HttpHost#">,
		
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.EcodigoSDC#" null="#Len(Arguments.MonPacket.EcodigoSDC) is 0#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.CEcodigo#" null="#Len(Arguments.MonPacket.CEcodigo) is 0#">)
	  <cf_dbidentity1 datasource="aspMonitor">
	</cfquery>
	<cf_dbidentity2 datasource="aspMonitor" name="insert1">
	</cftransaction>
	<cfset session.monitoreo.sessionid = insert1.identity>
</cffunction>

<cffunction name="InsertMonHistoria">
	<cfargument name="MonPacket">
	
	<cftransaction>
		<cfquery datasource="aspmonitor" name="ret">
		  insert into MonHistoria (
				sessionid, Usucodigo, srvprocid,
				SScodigo, SMcodigo, SPcodigo,
				desde, hasta)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.sessionid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Application.srvprocid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SScodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SMcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SPcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MonPacket.StartTime#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MonPacket.StartTime#">)
			<cf_dbidentity1 datasource="aspMonitor">
		</cfquery>
		<cf_dbidentity2 datasource="aspMonitor" name="ret">
	</cftransaction>
	<cfset Arguments.MonPacket.historiaid = ret.identity>
</cffunction>

<cffunction name="InsertMonRequest">
	<cfargument name="MonPacket" type="struct" >
	
	<cftransaction>
	<cfquery datasource="aspmonitor" name="inserted">
	  insert into MonRequest (
			historiaid, sessionid, srvprocid,
			method, uri, args, requested, millis)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.historiaid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.sessionid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Application.srvprocid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.RequestMethod#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.ScriptName#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.QueryString#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#MonPacket.StartTime#">, -1)
		<cf_dbidentity1 datasource="aspMonitor">
	</cfquery>
	<cf_dbidentity2 datasource="aspMonitor" name="inserted">
	</cftransaction>
	<cfset MonPacket.requestid = inserted.identity>
</cffunction>

<cffunction name="LeerMonProcesos">
	<cfargument name="sessionid" type="numeric" required="yes">
	<cfquery datasource="aspmonitor" name="ret">
		select SScodigo,SMcodigo,SPcodigo,
			historiaid, cerrada, desde, acceso, motivo_cierre
		from MonProcesos mp
		where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.sessionid#">
	</cfquery>
	<cfreturn ret>
</cffunction>

<cffunction name="UpdateMonProcesos">
	<cfargument name="MonPacket" type="struct" >

	<cfquery datasource="aspmonitor">
		update MonProcesos<!---acceso--->
		set Usucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.Usucodigo#">
			, ip          = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.ipaddr#">
			, login       = <cfif Len(Arguments.MonPacket.login)>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.login#">
							<cfelse>' '
							</cfif>
			, SScodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SScodigo#">
			, SMcodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SMcodigo#">
			, SPcodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MonPacket.SPcodigo#">
		<cfif Len(Arguments.MonPacket.FinishTime)>
			, acceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MonPacket.FinishTime#">
		<cfelseif Len(Arguments.MonPacket.StartTime)>
			, acceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MonPacket.StartTime#">
		</cfif>
		<cfif Len(Arguments.MonPacket.historiaid)>
		   ,historiaid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.historiaid#">
		</cfif>
		<cfif Arguments.MonPacket.IsNewSession And Len(Arguments.MonPacket.StartTime)>
		   ,desde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MonPacket.StartTime#">
		</cfif>
			, Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.EcodigoSDC#" null="#Len(Arguments.MonPacket.EcodigoSDC) is 0#">
			, CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.CEcodigo#" null="#Len(Arguments.MonPacket.CEcodigo) is 0#">
		where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MonPacket.sessionid#">
	</cfquery>
</cffunction>

<cffunction name="UpdateMonHistoria">
	<cfargument name="historiaid" type="numeric">
	<cfquery datasource="aspmonitor">
		update MonHistoria
		set hasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where MonHistoria.historiaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.historiaid#">
	</cfquery>
</cffunction>

<cffunction name="MonitoreoEnd">
	<cfif IsDefined('Request.MonPacket')>
		<cfset Request.MonPacket.finishTime = Now()>
		<cflock name="server_monitor_thread" timeout="1" throwontimeout="yes" type="exclusive" >
			<cfset StructDelete(server.monitor_thread, Request.MonPacket.ThreadName, false)>
		</cflock>
		<cfset StructDelete(Request.MonPacket, 'WeakRef')>
	</cfif>
</cffunction>

<cffunction name="MonitoreoLogout" output="no">
	<cfargument name="reason" default="L">
	<cfargument name="sessionid" type="numeric">
	<cfargument name="srvprocid" default="0" type="numeric">

	<cfif Arguments.srvprocid EQ 0>
		<cfif not IsDefined("Application.srvprocid") or len(trim(Application.srvprocid)) eq 0>
			<!--- Ver si apenas estamos levantando el servidor --->
			<!--- esto no lo ponemos en cola, se supone que solamente una vez se va a hacer cuando el servidor reinicie --->
			<cfset This.InsertMonServerProcess()>
		</cfif>
		<cfset Arguments.srvprocid = Application.srvprocid>
	</cfif>
	<!---
		reason table
		L       Logout
		T       Timeout
		K       Admin kill
		R       Se abrió otra sesión con el mismo usuario
	--->
    <cfif not isdefined("Arguments.sessionid") or len(trim(Arguments.sessionid)) EQ 0>
		<cfif isdefined("session.monitoreo.sessionid") and session.monitoreo.sessionid GT 0>
			<cfset Arguments.sessionid=session.monitoreo.sessionid>
		<cfelse>
			<cfreturn>
		</cfif>
	</cfif>

	<cftransaction>
		<cfquery datasource="aspmonitor">
			update MonProcesos           <!---logout--->
			set cerrada = 1, motivo_cierre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.reason#">
			where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.sessionid#">
			  and cerrada = 0
		</cfquery>
		<cfif Arguments.reason NEQ 'L'>
			<cfquery datasource="aspmonitor" name="KillSession">
				select motivo_cierre
				from KillSession
				where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.sessionid#">
				  and srvprocid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.srvprocid#">
			</cfquery>
			<cfif KillSession.RecordCount Is 0>
				<cfquery datasource="aspmonitor">
					insert into KillSession (sessionid, srvprocid, fecha, motivo_cierre)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.sessionid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.srvprocid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_char"      value="#Arguments.reason#">)
				</cfquery>
			</cfif>
		</cfif>
	</cftransaction>
</cffunction>

<cffunction name="verifica_usuarioDemo" access="public" returntype="boolean" output="false" hint="Verifica si el usuario logueado es de demos">
	<cfargument name="Usucodigo"	type="numeric" required="yes">
	<cfset return_demo = false>
	<!----Obtener la cuenta empresarial de demos---->
	<cfset EmpDemo =  This.PoliticasCFC.trae_parametro_global("demo.CuentaEmpresarial")><!---Obtiene la cuenta empresarial de los parametros globales---->
	<cfif EmpDemo EQ 1>
		<!--- asegurarme de que pso no expire por una mala parametrización --->
		<cfreturn false>
	</cfif>
	<cfif len(trim(EmpDemo))>
		<cfquery name="rsCuentaEmpresarial" datasource="asp">
			select CEcodigo
			from CuentaEmpresarial 
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EmpDemo#">
		</cfquery>
		<cfif isdefined("rsCuentaEmpresarial") and rsCuentaEmpresarial.RecordCount NEQ 0>
			<cfquery name="rsDemo" datasource="asp">
				select 1
				from Usuario
				where  Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaEmpresarial.CEcodigo#">
			</cfquery>
			<cfif rsDemo.RecordCount NEQ 0>
				<cfset return_demo = true>
			<cfelse>
				<cfset return_demo = false>				
			</cfif>
		<cfelse>
			<cfset return_demo = false>				
		</cfif>
	<cfelse>
		<cfset return_demo = false>				
	</cfif>
	<cfreturn return_demo>
</cffunction>

<cffunction name="ValidarSiSePuedeIniciarSesion">
	<cfargument name="Usucodigo" type="numeric">
	
	<cfif Arguments.Usucodigo is 0>
		<cfthrow message="Usuario invalido: #Arguments.Usucodigo#">
	</cfif>
	
	<cfquery datasource="asp" name="Eactiva_Q">
		select 1
		from Usuario u
			join CuentaEmpresarial ce
				on ce.CEcodigo = u.CEcodigo
			join Empresa e
				on e.CEcodigo = ce.CEcodigo
		where ce.CEactiva = 1
		  and e.Eactiva = 1
		  and u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
	</cfquery>
	
	<cfif Eactiva_Q.RecordCount is 0>
		<cfset This.MonitoreoLogout('I')>
		<cfset url.uri = "/cfmx/home/public/logged_out.cfm?motivo_cierre=I">
		<cfinclude template="/home/public/logout.cfm">
	</cfif>
	
	<cfset sesion_bloqueo_cant     = This.PoliticasCFC.trae_parametro_usuario("sesion.bloqueo.cant",     Arguments.Usucodigo)>
	<cfset sesion_bloqueo_duracion = This.PoliticasCFC.trae_parametro_usuario("sesion.bloqueo.duracion", Arguments.Usucodigo)>
	<cfset sesion_bloqueo_periodo  = This.PoliticasCFC.trae_parametro_usuario("sesion.bloqueo.periodo",  Arguments.Usucodigo)>
	
	<cfset sesion_multiple = This.PoliticasCFC.trae_parametro_usuario("sesion.multiple", Arguments.Usucodigo)>
	<cfif sesion_multiple is 2 or sesion_multiple is 3>
		<!---
			'1': se permiten varias sesiones por usuario, ok
			'2','3':	validar sesion unica por usuario.  Primero hay que
			        vaciar el contenido de la cola, para que el query sobre
					MonProcesos sea exacto, independientemente de que
					varias sesiones se hayan iniciado simultáneamente
		--->
		<cfset VaciarCola(false)>
		<cfset duracion_default = This.PoliticasCFC.trae_parametro_usuario('sesion.duracion.default', Arguments.Usucodigo)>
		<cfset duracion_modo    = This.PoliticasCFC.trae_parametro_usuario('sesion.duracion.modo', Arguments.Usucodigo)>
		<cfquery datasource="aspmonitor" name="otras_sesiones">
			select sessionid, desde, acceso
			from MonProcesos
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and cerrada = 0
			  <!--- filtra los candidatos sin tomar en cuenta duracion_modo --->
			  and desde  >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n', -duracion_default-1, Now())#">
			  and acceso >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n', -duracion_default-1, Now())#">
		</cfquery>
		<cfif sesion_multiple is 2>
			<!--- '2': si hay otras sesiones, cerrarlas con status 'R' --->
			<cfloop query="otras_sesiones">
				<cfset This.MonitoreoLogout('R', otras_sesiones.sessionid)>
			</cfloop>
		<cfelseif sesion_multiple is 3>
			<!--- '3': no permitir si hay otras sesiones activas --->
			<cfloop query="otras_sesiones">
				<cfif duracion_modo is '1'>
					<!--- '1': duracion total --->
					<cfset expiracion = DateAdd('n', duracion_default, otras_sesiones.desde)>
				<cfelse>
					<!--- '2' : periodo de inactividad --->
					<cfset expiracion = DateAdd('n', duracion_default, otras_sesiones.acceso)>
				</cfif>
				<cfif expiracion gt Now()>
					<cfset This.MonitoreoLogout('T')>
					<cfset url.uri = "/cfmx/home/public/logged_out.cfm?motivo_cierre=Y&duracion_default=#duracion_default#">
					<cfinclude template="/home/public/logout.cfm">
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
	
	<cfset 	usuario_demo = false>
	<cfset usuario_demo = this.verifica_usuarioDemo(Arguments.Usucodigo)><!---Verificar si el usuario es de demos---->
	<cfif usuario_demo EQ 'true'><!---Si es usuario de demo verifica si no ha expirado---->
		<cfquery name="rsExpira" datasource="asp">
			select 1
			from Usuario 
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				and Ufhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		</cfquery>
		<cfif rsExpira.RecordCount NEQ 0><!----Si ya expiro envia a pantalla con mensaje---->
			<cfset url.uri = "/cfmx/home/public/DMExpiroUsuario.cfm">			
			<cfinclude template="/home/public/logout.cfm">			
		</cfif>
	</cfif>
</cffunction>

<cffunction name="VerSiLaSesionYaExpiro" output="false">

	<cfif session.Usucodigo is 0><cfreturn></cfif>

	<!--- esta línea evita que si me estoy logueando en una sesión ya expirada dé error, ver autentica.cfm --->
	<cfif IsDefined('Request.SesionNuevaFavorNoExpirar')><cfreturn></cfif>

	<cfset mp = LeerMonProcesos(session.monitoreo.sessionid)>

	<!--- KILL/TIMEOUT/LOGOUT ejecutados --->
	<cfif mp.cerrada is 1>
		<cfset url.uri = "/cfmx/home/public/logged_out.cfm?motivo_cierre=#mp.motivo_cierre#">
		<cfinclude template="/home/public/logout.cfm">
	</cfif>
	
	<!--- KILL/TIMEOUT/LOGOUT ejecutados --->
	<cfif mp.RecordCount is 0>
		<cfset url.uri = "/cfmx/home/public/logged_out.cfm?motivo_cierre=T">
		<cfinclude template="/home/public/logout.cfm">
	</cfif>
	
	<!--- VER SI YA EXPIRO: ojo que no leemos la cola pendiente --->
	<cfif Not IsDefined('session.duracion_modo')>
		<!--- esto solo ocurre con sesiones abiertas mientras se instalaba esta funcionalidad --->
		<cfset expiracion = CreateDate(2006, 1, 1)>
	<cfelseif session.duracion_modo is '1'>
		<!--- '1': duracion total --->
		<cfset expiracion = DateAdd('n', session.duracion_minutos, mp.desde)>
	<cfelse>
		<!--- '2' : periodo de inactividad --->
		<cfparam name="session.monitoreo.ultimo_acceso" default="#Now()#">
		<cfset expiracion = DateAdd('n', session.duracion_minutos, session.monitoreo.ultimo_acceso)>
		<cfset session.monitoreo.ultimo_acceso = Now()>
	</cfif>

	<cfif Now() GT expiracion>
		<cfset This.MonitoreoLogout('T')>
		<cfset url.uri = "/cfmx/home/public/logged_out.cfm?motivo_cierre=T&now=# DateFormat(Now(),'yyyymmdd')#-# TimeFormat(Now(),'HHmmss')#&expiracion=# DateFormat(expiracion,'yyyymmdd')#-# TimeFormat(expiracion,'HHmmss')#&minutos=#session.duracion_minutos#&modo=#session.duracion_modo#&aspsession=#session.monitoreo.sessionid#">
		<cfinclude template="/home/public/logout.cfm">
	</cfif>

	<cfif Not This.activo>
		<cfset sesion_multiple = This.PoliticasCFC.trae_parametro_usuario("sesion.multiple", session.Usucodigo)>
		<cfif (sesion_multiple is 2 or sesion_multiple is 3)>
			<!---
				aun cuando no esté activo el monitoreo,
				se debe actualizar la fecha de acceso
				para el control de sesiones múltiples.
				Se establece la hora de acceso y el código de usuario, ya
				que no habiendo monitoreo quedaría de otra manera en cero
				
				Cuando esté activo este update es innecesario
			--->
			<cfquery datasource="aspmonitor">
				update MonProcesos
				set acceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
			</cfquery>
		</cfif>
	</cfif>

</cffunction>

<cffunction name="GetQueryString" returntype="string" output="false">
	<cfset var QueryString = "">
	<cfif UCase(CGI.REQUEST_METHOD) is 'POST' And IsDefined('form')>
		<!--- "form" no está definido cuando la invocación es hacia un Web Service --->
		<cfset keys = StructKeyArray(form)>
		<cfif ArrayLen(keys)>
			<cfset ArraySort(keys,'text')>
			<cfloop from="1" to="#ArrayLen(keys)#" index="ikey">
				<cfif IsSimpleValue(form[keys[ikey]]) And (ucase(keys[ikey]) neq 'FIELDNAMES')>
					<cfset QueryString = ListAppend(QueryString,
							keys[ikey] & "=" & URLEncodedFormat(form[keys[ikey]]), '&')>
				</cfif>
			</cfloop>
			<cfif Len(QueryString)>
				<cfreturn Mid(QueryString,1,255)>
			</cfif>
		</cfif>
	<cfelseif Len(CGI.QUERY_STRING)>
		<cfreturn CGI.QUERY_STRING>
	</cfif>
	<cfreturn ' '>
</cffunction>

<cffunction name="enqueue" output="false">
	<cfargument name="MonPacket">
	
	<cfif Not IsDefined('Server.monitor_accesos')>
		<cfset Collections = CreateObject("java", "java.util.Collections")>
		<cfset new_queue = CreateObject("java", "java.util.LinkedList")>
		<cfset new_queue.init()>
		<cfset syn_queue = Collections.synchronizedList(new_queue)>
		<cflock name="server_monitor_accesos" timeout="1" type="exclusive">
			<cfif Not IsDefined('Server.monitor_accesos')>
				<cfset Server.monitor_accesos = syn_queue>
			</cfif>
		</cflock>
	</cfif>
	<cflock name="server_monitor_accesos" timeout="1" type="exclusive">
		<cfset Server.monitor_accesos.add(Arguments.MonPacket)>
	</cflock>
	
</cffunction>

<cffunction name="GetHostName" output="false">
	<cfset var javaInetAddress = CreateObject("java", "java.net.InetAddress")>
	<cfset var hostname     = javaInetAddress.getLocalHost().getHostName()>
	<cfreturn hostname>
</cffunction>

<cffunction name="InsertMonServerProcess" output="no">
	<cfset var hostname    = "*">
	<cfset var java_version = "*">
	<cfset var java_vendor  = "*">
	
	<cfif Not IsDefined("Application.srvprocid") or len(trim(Application.srvprocid)) eq 0>
		<cfset javaSystem   = CreateObject("java", "java.lang.System")>	
		<cfset hostname     = GetHostName()>
		<cfset java_version = javaSystem.getProperty("java.version")>
		<cfset java_vendor  = javaSystem.getProperty("java.vendor" )>


		<cflock name="application_srvprocid" timeout="10" type="exclusive" throwontimeout="yes">
			<cfset LvarFecha = now()>
			<cfquery datasource="aspMonitor">
				insert into MonServerProcess (
					start_time, app_server, cf_version, 
					os_arch, os_name, os_version,
					java_version, java_vendor, hostname)
				values (
					<cfqueryparam cfsqltype="cf_sql_date" value="#lsdateformat(LvarFecha)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Server.ColdFusion.AppServer#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Server.ColdFusion.ProductVersion#">,

					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Server.Os.Arch#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Server.Os.Name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Server.Os.Version#">,
					
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#java_version#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#java_vendor#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#hostname#">)
			</cfquery>
			<cfquery name="newproc" datasource="aspMonitor">
				select max(srvprocid) as SrvProcId
				from MonServerProcess
				where start_time = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
				  and app_server = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Server.ColdFusion.AppServer#">
				  and hostname   = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#hostname#">
			</cfquery>
			<cfset Application.srvprocid = newproc.SrvProcId>
		</cflock>
	</cfif>		
</cffunction>


<cffunction name="QuitarThreadsInactivos" hint="Elimina de server.monitor_thread los threads que están inactivos" output="false">
	<cfif IsDefined('server.monitor_thread') and IsDefined('server.monitor_accesos')>
		<cfloop list="#StructKeyList(server.monitor_thread)#" index="threadName">
			<cfset monpkt = server.monitor_thread[threadName]>
			<cfif StructKeyExists(monpkt, 'WeakRef')>
				<cfset testobj = monpkt.WeakRef.get()>
				<cfif NOT IsDefined('testobj')>
					<!---
						significa que WeakRef.get() == null, por lo tanto el request ya no
						existe, o sea que ya se terminó de ejecutar.
						N.B.: Puede haber terminado de ejecutarse, pero no haberse pasado por
						el gc.  Preferiría usar countStackFrames() GT 16, pero provoca que se
						caiga el servidor usando el IBM JDK a partir del WAS 5.1.1.7.
						Con el J2SE 5.0 se podrá usar Thread.getStackTrace().length
					--->
					<cfset StructDelete( server.monitor_thread , threadName )>
				</cfif>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#ArrayLen(server.monitor_accesos)#" index="n">
			<cfif NOT StructKeyExists (server.monitor_thread, server.monitor_accesos [n].threadName) >
				<cfif Len(server.monitor_accesos [n].FinishTime) EQ 0>
					<cfset server.monitor_accesos [n].FinishTime = Now() >
				</cfif>
			</cfif>
		</cfloop>
	</cfif>

	<!---
		Se comenta el contenido anterior de la funcion QuitarThreadsInactivos, que
		se basa en java.lang.Thread.countStackFrames.  Esta funcion java hace
		que se caiga el servidor en al menos WAS 5.1.1
		
	<cfset var thread = CreateObject("java", "java.lang.Thread")>
	<cfset var array = CreateObject("java", "java.lang.reflect.Array")>
	<cfset var tarray = array.newInstance(thread.getClass(), thread.activeCount())>
	<cfset var enumerateThreadCount = thread.currentThread().enumerate(tarray) >
	<cfif IsDefined('server.monitor_thread') and IsDefined('server.monitor_accesos')>
		<cfloop list="#StructKeyList(server.monitor_thread)#" index="threadName">
			<cfset existe = false>
			<cfloop from="1" to="#enumerateThreadCount#" index="i">
				<cfif (tarray[i].getName() EQ threadName) and (tarray[i].countStackFrames() GT 16)>
					<!---
						el valor de 16 se basa en las observaciones de countStackFrames en distintos application servers:
						JRun 4.0 = 25-29 ocupado, 5-8 libre
						Tomcat 5.5 = 38 ocupado, 8 libre
						EAS 5.2 = 32 ocupado
						WAS 60 = 41 ocupado
					--->
					<cfset existe = true >
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif NOT existe>
				<cfset StructDelete( server.monitor_thread , threadName )>
			</cfif>
		</cfloop>
		<cfloop from="1" to="#ArrayLen(server.monitor_accesos)#" index="n">
			<cfif NOT StructKeyExists (server.monitor_thread, server.monitor_accesos [n].threadName) >
				<cfif Len(server.monitor_accesos [n].FinishTime) EQ 0>
					<cfset server.monitor_accesos [n].FinishTime = Now() >
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	--->
</cffunction>


<cffunction name="VaciarCola" hint="Baja los datos que haya en la cola a la base de datos. Para llamarse periodicamente">
	<cfargument name="mostrar_proceso" required="yes" type="boolean" default="no">

	<cfset This.QuitarThreadsInactivos()>
	
	<cfif IsDefined('Server.monitor_accesos')>
		<cfif Not Server.monitor_accesos.isEmpty()>
	
			<cfset aspmonitor = CreateObject("Component", "home.Componentes.aspmonitor")>
			<cflock name="server_monitor_accesos" timeout="1" type="exclusive">
				<cfset monitor_accesos_list = Server.monitor_accesos >
				<cfset StructDelete(Server, "monitor_accesos")>
			</cflock>
			
			<cfset monitor_accesos_task_size = monitor_accesos_list.size() >
			<cfloop from="0" to="#monitor_accesos_task_size-1#" index="i"><cfsilent>
				<cfset MonPacket = monitor_accesos_list.get ( JavaCast ("int", i ) ) >
				<cfset aspmonitor.ProcesaPacket(MonPacket) >
				<cfif Arguments.mostrar_proceso>
					<cfset WriteOutput("#i#:#MonPacket.requestid# <br />")>
				</cfif>
			</cfsilent></cfloop>
		<cfelse>
			Lista vac&iacute;a.
		</cfif>
	<cfelse>
		Sin datos.  Lista no existe.
	</cfif>

</cffunction>

<cffunction name="GetUsedMemory" returntype="numeric" output="false">
	<cfset var runtime = CreateObject("java", "java.lang.Runtime").getRuntime()>
	<cfset usedMemory = runtime.totalMemory() - runtime.freeMemory()>
	<cfreturn usedMemory>
</cffunction>

</cfcomponent>
