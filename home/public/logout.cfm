<!--- Expirar la sesión --->
<!---
Modificado por: Yu Hui Wen
Fecha: 10 de Marzo del 2003
Por favor NO CAMBIAR
Modificado por danim, 16 Enero 2006
	Se establece el cfapplication.sessiontimeout a 10 minutos para que dé tiempo
	suficiente para ejecutar el resto de la pantalla.  En coldfusion 7.0+ al poner el
	sessiontimeout en 0 se elimina la sesión, y ya no es posible accederla para 
	realizar el logout, dejando sesiones de monitoreo abiertas.
--->
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,0,10,0)#>
<cftry>
	<cfinvoke component="home.Componentes.aspmonitor" method="MonitoreoLogout">
	</cfinvoke>

	<cflogout>
	<cfset LastUsucodigoLogged=duplicate(Session.Usucodigo)>
	<cfset StructDelete(Session,"Usucodigo")>
	<cfset StructClear(Session)>
	<cfset Session.LastUsucodigoLogged=LastUsucodigoLogged>
	<cfcatch type="anyx"></cfcatch></cftry>
<cfapplication name="EDU"
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,0,0,10)#>
<cftry>
	<cflogout>
	<cfset LastUsucodigoLogged=duplicate(Session.Usucodigo)>
	<cfset StructDelete(Session,"Usucodigo")>
	<cfset StructClear(Session)>
	<cfset Session.LastUsucodigoLogged=LastUsucodigoLogged>
	<cfcatch type="any"></cfcatch></cftry>
<cfparam name="url.uri" default="/cfmx/home/index.cfm">
<cflocation url="#url.uri#" addtoken="no">
