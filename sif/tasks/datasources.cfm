<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
<cfinvokeargument name="refresh" value="yes">
</cfinvoke>

<!--- <cfdump var="#Application#"> --->

<!--- ok --->
