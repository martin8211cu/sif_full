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

Este proceso se encarga de pasar las llamadas inconsistentes que son ignoradas por el proceso de tasación hacia la tabla (tasacion..ISBCrudoInconsistente) 
<br /> <br />


<!--- Averiguar el usuario para invocación de Tareas Programadas --->
<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="usuario">
	<cfinvokeargument name="Pcodigo" value="220">
</cfinvoke>

<!--- Selecionar el número de días mediante los cuáles se cálcula la fecha histórica (Fecha histórica = (fecha actual - días)) --->



<!---<cfoutput query="rsEmpresas">--->
Ejecutando @ #Now()# Empresa: #rsEmpresas.Ecodigo# Cache: #rsEmpresas.DSN#<br />

<cfset Session.Ecodigo = rsEmpresas.Ecodigo>
<cfset Session.DSN = rsEmpresas.DSN>

<cfif Len(Trim(usuario))>
	<cfset Session.Usucodigo = usuario>
<cfelse>
	<cfset Session.Usucodigo = 0>
</cfif>

<cfoutput>
<cftry>
 
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="dias">
		<cfinvokeargument name="Pcodigo" value="226">
	</cfinvoke>
	
	<cfdump var="(Número de días #dias#)">
	
	 <cfquery datasource="#session.DSN#">
		exec tasacion..isb_pasaCrudo
			@dias = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dias#">
	  </cfquery>

		<cfcatch type="any">
			<cflog file="isb_pasaCrudo" text="isb_pasaCrudo::task #cfcatch.Message# #cfcatch.Detail#">
			<cfrethrow>
		</cfcatch>
</cftry>
Terminado @ #Now()# Empresa: #rsEmpresas.Ecodigo# Cache: #rsEmpresas.DSN#<br />

</cfoutput>

</body>
</html>
