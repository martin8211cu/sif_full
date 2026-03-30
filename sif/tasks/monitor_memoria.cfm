<cfapplication name="SIF_ASP" 
	sessionmanagement="yes"
	clientmanagement="no"
	setclientcookies="no">

<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo"
	datasource="aspmonitor">
</cfinvoke>

<cfif not IsDefined("Application.srvprocid")>
	<cfinvoke component="home.Componentes.aspmonitor" method="InsertMonServerProcess">
	</cfinvoke>
</cfif>


<cfset runtime = CreateObject("java", "java.lang.Runtime")>
<cfset runtime = runtime.getRuntime()>

<cfquery datasource="aspmonitor">
	insert into MonServerStats (fecha, srvprocid, freeMemory, totalMemory, maxMemory)
	values (
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric"   value="#Application.srvprocid#">,
		<cfqueryparam cfsqltype="cf_sql_numeric"   value="#runtime.freeMemory()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric"   value="#runtime.totalMemory()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric"   value="#runtime.maxMemory()#"> )
</cfquery>
<cfoutput>
<table width="300"><tr><td colspan="2">Registro insertado.</td></tr>
<tr><td>totalMemory:</td><td> # NumberFormat( runtime.totalMemory())#</td></tr>
<tr><td>freeMemory: </td><td># NumberFormat(runtime.freeMemory())#</td></tr>
<tr><td>asignada objetos: </td><td># NumberFormat(runtime.totalMemory() - runtime.freeMemory())#</td></tr>
<tr><td>Hora: </td><td>#Now()#
</td></tr>
</cfoutput>
