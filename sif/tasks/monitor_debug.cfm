<cfsetting requesttimeout="3600">
<cfapplication name="SIF_ASP" 
	sessionmanagement="yes"
	clientmanagement="no"
	setclientcookies="no">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Transferencia del debug</title>
</head>

<body>
<cflock name="monitor_debug_cfm" timeout="5">
<cffunction name="getminmax">
	<cfquery datasource="aspmonitor" name="minid">
		select min(debugid) as debugid
		from MonDebugIRequest
	</cfquery>
	<cfquery datasource="aspmonitor" name="maxid">
		select max(debugid) as debugid
		from MonDebugIRequest
	</cfquery>
</cffunction>

<cfset cantidad = 100>
<cfset getminmax()>
<cfset start_time = GetTickCount()>
<cfset start_min = 0>
<cfset start_max = 0>
<cfset cantidad_total = 0>
<cfif Len(minid.debugid) And Len(maxid.debugid)>
	<cfset start_min = minid.debugid>
	<cfset start_max = maxid.debugid>
	<cfset cant = (maxid.debugid - minid.debugid) / cantidad>
	<cfif cant LT 1 ><cfset cant = 1></cfif>
	<cfloop from="1" to="#cant#" index="numero">
		<cfoutput>
			Iteración número: #numero# #Now()# <br />
			#RepeatString(' ',512)#
			<cfflush>
		</cfoutput>
		<cfinvoke component="home.Componentes.DebugLogger" method="transferQ2I" cantidad="#cantidad#"/>
	</cfloop>
</cfif>
<cfset elapsed = GetTickCount() - start_time>

<cfset getminmax()>

<cfif start_min And start_max>
	<cfif Len(minid.debugid)><!--- quedaron registros --->
		<cfset cantidad_total = minid.debugid - start_min>
	<cfelse><!--- se hizo todo --->
		<cfset cantidad_total = start_max - start_min>
	</cfif>
</cfif>
</cflock>
<cfoutput>
<table width="300"><tr><td colspan="2">#NumberFormat(cantidad_total)# Registros transferidos.</td></tr>
<tr><td>Duración:</td><td>#NumberFormat(elapsed)# ms<cfif cantidad_total>, avg: #NumberFormat(elapsed/cantidad_total)# ms</cfif></td></tr>
<cfif Len(minid.debugid) And Len(maxid.debugid)>
<tr><td>Mínimo ID:</td><td> # NumberFormat( minid.debugid )#</td></tr>
<tr><td>Máximo ID:</td><td> # NumberFormat( maxid.debugid )#</td></tr>
<tr><td>Diferencia:</td><td> # NumberFormat( maxid.debugid - minid.debugid)#</td></tr>
<cfelse>
<tr><td colspan="2">No hay registros pendientes</td></tr>
</cfif>
<tr><td>Hora: </td><td>#Now()#</td></tr>
</cfoutput>
</body>
</html>
