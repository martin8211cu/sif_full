<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cfparam name="url.x" default="">

<cfoutput>#Now()#</cfoutput><br>

<cflock scope="application" timeout="5" throwontimeout="no">
	<cfif Len(url.x)>
		<cfquery datasource="asp">waitfor delay '0:0:20' </cfquery>
	</cfif>
</cflock>

<cfoutput>#Now()#</cfoutput><br>


bueno ya