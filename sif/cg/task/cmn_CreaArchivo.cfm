<cfsetting requesttimeout="1800">

<cfparam name="url.LLAVE" default="-1">
<cfparam name="url.USER" default="">
<cfparam name="url.dsn" default="iceweb6">
<cfparam name="url.forzar" default="false">

<cfflush interval="32">

<cfset LLAVE = trim(url.LLAVE)>
<cfset USER = trim(url.USER)>
<cfset dsn = trim(url.dsn)>
<cfif not isdefined("session.dsn")>
	<cfset session.dsn = dsn>
</cfif>
<cfif not isdefined("session.usuario")>
	<cfset session.usuario = USER>
</cfif>
<cfif StructKeyExists(Application.dsinfo, dsn)>
	<cfset session.DSinfo = Application.DSinfo['#dsn#']>
</cfif>
<cfif not isdefined("session.dsinfo.type")>
	<cfset session.dsinfo.type="sybase">
</cfif>
<cfif not isdefined("session.Usulogin")>
	<cfset session.Usulogin ="automatico">
</cfif>
<cfoutput> #Now()#<br></cfoutput>
<cfif len(dsn) eq 0>
	<cfabort>
</cfif>
<cfinvoke 
	component="cmn_CreaArchivoSalida" 
	method="fnGeneraSalidaArchivo" 
	returnvariable="Procesado">
	<cfinvokeargument name="LLAVE" value="#LLAVE#">
	<cfinvokeargument name="USER"  value="#USER#">
	<cfinvokeargument name="MostrarSalida" value="true">
	<cfinvokeargument name="conexion" value="#dsn#">
	<cfinvokeargument name="ProcesarForzado" value="#forzar#">
</cfinvoke>
<cfoutput> #Now()#<br></cfoutput>
