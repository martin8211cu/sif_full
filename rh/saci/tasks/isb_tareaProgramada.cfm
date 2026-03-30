<cfsetting enablecfoutputonly="no" showdebugoutput="no" requesttimeout="36000">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="No"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cferror type="exception" template="/home/public/error/handler.cfm">

<cffunction name="show_date">
	<cfoutput>@ #Now()# #RepeatString(' ', 2000)#<br></cfoutput>
	<cfflush>
</cffunction>
<html><head><title>Tarea de ejecución de ISBtareaProgramada</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>

<cfoutput>
Comienza tarea... #show_date()#

<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" />
dsinfo ok ... #show_date()#
<cfquery datasource="asp" name="empresas">
	select distinct c.Ccache, e.Ereferencia as Ecodigo
	from Empresa e, ModulosCuentaE m, Caches c
	where e.CEcodigo = m.CEcodigo
	  and c.Cid = e.Cid
	  and m.SScodigo = 'SACI'
	and Ereferencia is not null
    and c.Ccache = 'isb'
</cfquery>
Caches leídos ... #show_date()#
<cfdump var="#empresas#">
<cfloop query="empresas">
	<cftry>
		Datasource: #empresas.Ccache# @ #show_date()#
		<cfif Not StructKeyExists(Application.dsinfo, empresas.Ccache)>
			Datasource #empresas.Ccache# no existe.
		<cfelse>
			<cfset session.dsn = empresas.Ccache>
			<cfset session.Ecodigo = empresas.Ecodigo>
			<cfset session.Usucodigo = 0>
			<cfset session.Usuario = 0>
			Ejecutando ... #show_date()#
			<cfinvoke component="saci.comp.ISBtareaProgramada" method="ejecutarPendientes"
					datasource="#cCache#" />
			Terminado OK. #show_date()#<br>
			
		</cfif>
		
		<cfcatch type="any">
			<cflog file="ISBtareaProgramada" text="ISBtareaProgramada::task #cfcatch.Message# #cfcatch.Detail#">
			<cfrethrow>
		</cfcatch>
		
	</cftry>

</cfloop>
Tarea terminada #show_date()#
</cfoutput>
</body></html>