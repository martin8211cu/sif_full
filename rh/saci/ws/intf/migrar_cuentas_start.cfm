<cftry>
<cfflush interval="128">
<!---
	el mecanismo de cuantosPorTiro es por si se cae, no para trabajar en bloques,
	para no depender del browser y poder reintentar desde donde iba
--->
<cfset cuantosPorTiro = 999999>
<html><head><title>Migración de clientes</title>
<link href="migrar_cuentas.css" rel="stylesheet" type="text/css" />
</head><body>
<cfsetting requesttimeout="#5*24*3600#" enablecfoutputonly="yes">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes" sessiontimeout="#CreateTimeSpan(200,0,0,0)#">
<cfif Server.migracion.startTime is 0>

	<!--- para que lo haga solamente la primera vez--->
	<cfset Server.migracion.startTime = GetTickCount()>
	<cfset Server.migracion.errorcount = 0>
	<cfset Server.migracion.procesados = 0>
</cfif>
<cflog file="migracion_saci" text="Inicia migración">

<cferror type="exception" template="/home/public/error/handler.cfm">
<cfset comp = CreateObject("component", "saci.ws.intf.migrar_cuentas")>

<cfset Server.migracion.rc = 'Inicio - Seleccionando lote de cedulas'>
<cfoutput>Inicio #Now()#. El proceso se seguirá ejecutando aunque cierre esta ventana.<br /></cfoutput>

<cflock scope="server" timeout="1">
<cfquery datasource="#session.dsn#" maxrows="#cuantosPorTiro#" name="rsLoginLista">
	select top #cuantosPorTiro# cedula from migra_cedula order by cedula
</cfquery>
<cfset Server.migracion.stop = false>
<cfloop query="rsLoginLista">
	<cfif Server.migracion.stop>
		<cfoutput>Abortando misión...#Now()#<br />
		<cfset Server.migracion.elap = '#comp.MillisFormat(GetTickCount() - Server.migracion.startTime)# - Misión abortada'>
		</cfoutput><cfbreak>
	</cfif>
	<cfset errmsg = ''>
	<cftry>
		<cfoutput>#Chr(13)# | #cedula#</cfoutput>
		<cfset Server.migracion.procesados = Server.migracion.procesados + 1>
		<cfquery datasource="#session.dsn#">
			delete from migra_cedula
			where cedula=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLoginLista.cedula#">
		</cfquery>
		<cfinvoke component="#comp#" returnvariable="procesoOK"
			method="migrar_cedula"
			cedula="#rsLoginLista.cedula#" />
		<cfif procesoOK>
			<cfoutput> ok </cfoutput>
		<cfelse>
			<cfset Server.migracion.errorcount = Server.migracion.errorcount + 1>
			<cfoutput> err </cfoutput>
		</cfif>
	<cfcatch type="any">
		<cfset errmsg = 'CFCATCH: ' & cfcatch.Message & ' ' & cfcatch.Detail>
		<cfoutput> #errmsg# </cfoutput>
		<cfset Server.migracion.errorcount = Server.migracion.errorcount + 1>
		<cfset comp.log_error(rsLoginLista.cedula, errmsg, cfcatch.TagContext)>
	</cfcatch>
	</cftry>
	
	<cfset promedio = (GetTickCount() - Server.migracion.startTime) / Server.migracion.procesados>
	<cfset avance = Server.migracion.procesados / Server.migracion.TotalRows>
	<cfset restante = promedio * (Server.migracion.TotalRows - Server.migracion.procesados)>

	<cfset Server.migracion.pct = avance>
	<cfset Server.migracion.rc ='#Server.migracion.procesados# / #Server.migracion.TotalRows# (#NumberFormat( Server.migracion.pct * 100, '0.0')#%)'>
	<cfset Server.migracion.tasaerr = '#NumberFormat(Server.migracion.errorcount * 100 / Server.migracion.procesados, "0.0")# %'>
	<cfset Server.migracion.ced = '#JSStringFormat( rsLoginLista.cedula ) #'>
	<cfset Server.migracion.elap = '#comp.MillisFormat(GetTickCount() - Server.migracion.startTime)#'>
	<cfif Server.migracion.procesados GT 20>
		<cfset Server.migracion.resta = '#comp.MillisFormat(restante)#'>
		<cfset Server.migracion.prom = '#NumberFormat(promedio,"0.0")# ms'>
	</cfif>
	
</cfloop>
</cflock>
<cfoutput>
#rsLoginLista.RecordCount# obtenidos.
<cfif rsLoginLista.RecordCount LT cuantosPorTiro and not Server.migracion.stop>
<a href="migrar_cuentas_start.cfm">Continuar</a>
<cfelse>
Terminado todo #Now()#<br />
</cfif>
<br />
====Promedio Final: #(GetTickCount() - Server.migracion.startTime) / Server.migracion.TotalRows#ms / registro<br />


<cfif Server.migracion.errorcount>
	Hubo <cfif Server.migracion.errorcount is 1> un error<cfelse>#Server.migracion.errorcount# errores</cfif>, por favor revise # HTMLEditFormat( ExpandPath( '/WEB-INF/cfusion/logs/migracion_saci.log' ))#<br />
<cfelse>
	No hubo errores.  Yupi!
</cfif>
</cfoutput>	
	
<cflog file="migracion_saci" text="Termina migracion">
<cfapplication sessiontimeout="#CreateTimeSpan(0,0,1,0)#">
<cfsetting enablecfoutputonly="no">
</body></html>
<cfcatch>
	<cflog file="migracion_saci" text="Error fatal, abortando.  #cfcatch.Message# #cfcatch.Detail#">
	<cfrethrow>
</cfcatch>
</cftry>