<cfapplication name="SIF_ASP" 	sessionmanagement="Yes"	clientmanagement="Yes"	setclientcookies="Yes"	sessiontimeout=#CreateTimeSpan(0,10,0,0)#><cfset res = setLocale("English (Canadian)")><cfheader name = "Expires" value = "0"><cfparam name="Session.Idioma" default="ES_CR"><cfinclude template="/home/check/dominio.cfm"><cfinclude template="/home/check/autentica.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>Prueba de funciones (danim)</title></head><body>

<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
<cfinvokeargument name="refresh" value="yes">
</cfinvoke>

<cfparam name="url.ds" default="aspmonitor">
<cftransaction>
	<cfquery datasource="#url.ds#" name="idquery">
		insert into LoginIncorrecto 
		(LIcuando, LIip, CEcodigo, LIalias, LIlogin, LIrazon)
		values (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, '11', 1, '1', '1', '1')
		<cf_dbidentity1 datasource="#url.ds#">
	</cfquery>
	<cf_dbidentity2 datasource="#url.ds#" name="idquery">
</cftransaction>
<cfdump var="#idquery#" label="#url.ds#">

<cfset arr = StructKeyArray(Application.dsinfo)>
<cfset ArraySort(arr,'text')>

<table border="1" cellspacing="0">
<tr><td><strong>datasource</strong></td><td><strong>type</strong></td><td><strong>driver</strong></td></tr>
<cfloop from="1" to="#ArrayLen(arr)#" index="i">
	<cfset nn = arr[i]>
	<cfoutput>
	<tr><td>
<a href="?ds=#Application.dsinfo[nn].name#">#Application.dsinfo[nn].name#</a>
	</td><td>
	#Application.dsinfo[nn].type#
	</td><td>
	#Application.dsinfo[nn].driverClass#
	</td></tr></cfoutput>
</cfloop>
</table>
</body>
</html>
