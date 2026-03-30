<cfsetting enablecfoutputonly="no" showdebugoutput="no">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="No"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cferror type="exception" template="/home/public/error/handler.cfm">

<html><head><title>Prospectaci&oacute;n</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>

<cfquery name="rsEmpresas" datasource="asp">
	select distinct e.Ereferencia as Ecodigo, c.Ccache as DSN
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and c.Ccache = 'isb'
	  and m.SScodigo = 'SACI'  
	  and e.Ereferencia is not null
</cfquery>

Este proceso se encarga de revisar si los prospectos han sido atendidos dentro del tiempo establecido. En caso contrario se le reasigna a otro agente.
<br /> <br />

<cfoutput query="rsEmpresas">
Ejecutando @ #Now()# Empresa: #rsEmpresas.Ecodigo# Cache: #rsEmpresas.DSN#<br />

<cfset Session.Ecodigo = rsEmpresas.Ecodigo>
<cfset Session.DSN = rsEmpresas.DSN>

<!--- Averiguar el usuario para invocación de Tareas Programadas --->
<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="usuario">
	<cfinvokeargument name="Pcodigo" value="220">
</cfinvoke>
<cfif Len(Trim(usuario))>
	<cfset Session.Usucodigo = usuario>
<cfelse>
	<cfset Session.Usucodigo = 0>
</cfif>

<cfinvoke component="saci.comp.ISBprospectos" method="proc_prospectacion" Ecodigo="#rsEmpresas.Ecodigo#" datasource="#rsEmpresas.DSN#" />

Terminado @ #Now()# Empresa: #rsEmpresas.Ecodigo# Cache: #rsEmpresas.DSN#<br />

</cfoutput>

</body>
</html>
