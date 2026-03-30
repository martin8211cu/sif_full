<cfsilent>
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout="#CreateTimeSpan(0,0,1,0)#">
	
	<cfset session.dsn = 'isb'>
	<cfset session.Ecodigo = 235>
	<cfset session.saci.pais = "CR">

</cfsilent>