<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#
>
<cfset LvarOK = false>
<cfparam name="url.Sid" default="0">
<cfif isdefined("application.Sid.SID#url.Sid#")>
	<cfset structdelete(application.Sid, "SID#url.Sid#")>
<cfelse>
	<cfinclude template="../../Application.cfm">
</cfif>