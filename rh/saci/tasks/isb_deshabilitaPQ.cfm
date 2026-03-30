<cfsetting enablecfoutputonly="no" showdebugoutput="no">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="No"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cferror type="exception" template="/home/public/error/handler.cfm">

<html><head><title>Deshabilitar Paquete</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>

<cfquery name="rsEmpresas" datasource="asp">
	select distinct e.Ereferencia as Ecodigo, c.Ccache as DSN
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'SACI'
	  and c.Ccache = 'isb'
	and e.Ereferencia is not null
</cfquery>

Este proceso se encarga de deshabilitar los paquetes, basado en la fecha Cese del mismo
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

	<cftry>

		<cfinvoke component="saci.comp.ISBpaquete" method="DeshabilitarPQ" Ecodigo="#rsEmpresas.Ecodigo#" datasource="#rsEmpresas.DSN#" />
			Terminado @ #Now()# Empresa: #rsEmpresas.Ecodigo# Cache: #rsEmpresas.DSN#<br />
		
		<cfcatch type="any">
			<cflog file="isb_deshabilitaPQ" text="isb_deshabilitaPQ::task #cfcatch.Message# #cfcatch.Detail#">
			<cfrethrow>
		</cfcatch>
		
	</cftry>
</cfoutput>

</body>
</html>
