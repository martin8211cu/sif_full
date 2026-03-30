<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#
>
<cfset session.dsn	= "minisif_soin">
<cfset GvarOBJ		= createObject("component","sif.CGV3.CGV3conta")>

<cfparam name="session.Usucodigo"	default="0">
<cfparam name="session.isTask"		default="false">

<cfif isdefined("url.Mstatus") AND url.Mstatus EQ 1>
	<cfset GvarOBJ.sbGenerarCuentas(url.Ecodigo, url.Eperiodo, url.Emes)>
	<cflocation url="/cfmx/sif/tasks/CGV3task.cfm?Mstatus=0">
<cfelseif isdefined("url.Mstatus") AND url.Mstatus EQ 3>
	<cfset GvarOBJ.sbGenerarAsientos(url.Ecodigo, url.Eperiodo, url.Emes)>
	<cflocation url="/cfmx/sif/tasks/CGV3task.cfm?Mstatus=0">
<cfelseif isdefined("url.Mstatus") AND url.Mstatus EQ 0>
<cfelse>
	<cfif session.Usucodigo EQ 0>
		<cfset session.isTask = true>
		<cfinclude template="/home/check/dominio.cfm">
		<cfquery name="rsUsuario" datasource="asp" maxrows="1">
			select 
				a.Usucodigo, 
				a.Usulogin,
				a.datos_personales,
				a.Utemporal,
				a.CEcodigo,
				b.CEnombre, a.LOCIdioma, a.Usurespuesta,
				p.skin, p.enterActionDefault
			from Usuario a
				join CuentaEmpresarial b
				  on a.CEcodigo = b.CEcodigo
				left join Preferencias p
				  on p.Usucodigo = a.Usucodigo
			where a.Usulogin = 'pso'
		</cfquery>
		
		<cfif len(rsUsuario.Usucodigo) GT 0>
			<cfset session.logoninfo = StructNew()>
			<cfset session.logoninfo.Utemporal = rsUsuario.Utemporal>
			<cfif IsDefined('AUTHBACKEND')>
				<cfset Session.AUTHBACKEND = AUTHBACKEND>
			</cfif>
			<cfset Session.Usuario=rsUsuario.Usulogin>
			<cfset Session.Usulogin=rsUsuario.Usulogin>
			<cfset Session.Ulocalizacion="00"><!--- para compatibilidad con tramites --->
			<cfset Session.Usucodigo=rsUsuario.Usucodigo>
			<cfset Session.CEcodigo=rsUsuario.CEcodigo>
			<cfset Session.CEnombre=rsUsuario.CEnombre>
			<cfset Session.idioma = rsUsuario.LOCIdioma>
			
			<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
			<cfset Session.duracion_minutos = Politicas.trae_parametro_usuario('sesion.duracion.default')>
			<cfset Session.duracion_modo   = Politicas.trae_parametro_usuario('sesion.duracion.modo')>
			
			<!--- esta linea evita que si me estoy logueando en una sesión ya expirada dé error, ver aspmonitor.cfc --->
			<cfset Request.SesionNuevaFavorNoExpirar = true>
			
			<cf_datospersonales action="select" key="#rsUsuario.datos_personales#" name="datos_personales">
			<cfset Session.datos_personales = datos_personales>
			<cfloginuser name="#Session.Usuario#" roles="none" password="#rsUsuario.Usucodigo#">
			<cfif Len(rsUsuario.enterActionDefault)>
				<cfset session.sitio.enterActionDefault = rsUsuario.enterActionDefault>
			<cfelse>
				<cfset session.sitio.enterActionDefault = "submit">
			</cfif>
			<cfif Len(rsUsuario.skin)>
				<cfset UserCSS = GetDirectoryFromPath(session.sitio.css) & rsUsuario.skin>
				<cfif FileExists(ExpandPath(UserCSS))>
					<cfset session.sitio.css = UserCSS>
				</cfif>
			</cfif>
		</cfif>
	</cfif>

	<cfif session.isTask>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Mstatus, Ecodigo
			  from CGV3cierres
			 where Mstatus <> 4
			 order by Mstatus
		</cfquery>
		<cfset session.Ecodigo	= rsSQL.Ecodigo>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Mstatus, Ecodigo
			  from CGV3cierres
			 where Mstatus <> 4
			   and Ecodigo = #session.Ecodigo#
		</cfquery>
	</cfif>
	
	<cfif rsSQL.Ecodigo EQ "">
		No hay registros a procesar
		<cfif NOT session.isTask>
			<cflocation url="/cfmx/sif/CGV3/CGV3conta.cfm">
		</cfif>
		<cfabort>
	</cfif>
	Procesando Ecodigo = <cfoutput>#session.Ecodigo#</cfoutput>...<BR>
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Ecodigo
		  from ConceptoContableE
		 where Ecodigo	 = #session.Ecodigo# 
		   and Cconcepto = 300
	</cfquery>
	<cfif rsSQL.recordCount EQ 0>
		<cfthrow message="Falta incluir el Concepto Contable 300 - Contabilidad V.3">
	</cfif>
	
	<cfquery name="rsCierres" datasource="#session.dsn#">
		select 	min(case when Mstatus = 1 			then Eperiodo*100+Emes else 600001 end) as cargado,
				min(case when Mstatus = 3			then Eperiodo*100+Emes else 600001 end) as convertido,
				min(case when Mstatus in (2,4)		then Eperiodo*100+Emes else 600001 end) as ejecucion,
				min(case when Mstatus < 0			then Eperiodo*100+Emes else 600001 end) as error,
				min(case when Mstatus <> 4			then Eperiodo*100+Emes else 600001 end) as todos
		  from CGV3cierres
		 where Ecodigo	= #session.Ecodigo# 
	</cfquery>

	<cfif rsCierres.ejecucion NEQ 600001>
		<!--- PROCESOS EN EJECUCION --->
		<cfthrow type="toUser" message="Existe un proceso en ejecucion, favor esperar">
	<cfelseif rsCierres.convertido LTE rsCierres.todos>
		<!--- PROCESO DE GENERACION Y APLICACION DE ASIENTOS --->
		<!--- Sólo se pueden generar asientos si es el primero en la lista --->
		<cfset LvarPeriodo	= left(rsCierres.convertido,4)>
		<cfset LvarMes		= right(rsCierres.convertido,2)>
		<cfset GvarOBJ.sbGenerarAsientos(session.Ecodigo, LvarPeriodo, LvarMes)>
	<cfelseif rsCierres.cargado NEQ 600001>
		<!--- PROCESO DE GENERACION DE CUENTAS --->
		<!--- Siempre se pueden generar cuentas en el momento en que esté cargado --->
		<cfset LvarPeriodo	= left(rsCierres.cargado,4)>
		<cfset LvarMes		= right(rsCierres.cargado,2)>
		<cfset GvarOBJ.sbGenerarCuentas(session.Ecodigo, LvarPeriodo, LvarMes)>
	<cfelseif rsCierres.error LT rsCierres.convertido>
		<!--- ERRORES PENDIENTES --->
		<cfset LvarPeriodo	= left(rsCierres.cargado,4)>
		<cfset LvarMes		= right(rsCierres.cargado,2)>
		<cfthrow message="Existen Meses anteriores con Error que hay que resolver primero para seguir adelante con #LvarPeriodo#/#LvarMes#">
	<cfelseif rsCierres.convertido NEQ 600001>
		<!--- ERRORES PENDIENTES --->
		<cfset LvarPeriodo	= left(rsCierres.cargado,4)>
		<cfset LvarMes		= right(rsCierres.cargado,2)>
		<cfthrow message="Existen Meses anteriores pendientes que hay que terminar para seguir adelante con #LvarPeriodo#/#LvarMes#">
	</cfif>
</cfif>
<cfif NOT session.isTask>
	<cflocation url="/cfmx/sif/CGV3/CGV3conta.cfm">
</cfif>
FIN DE PROCESO
