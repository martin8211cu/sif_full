<cfapplication 
	name				= "SIF_ASP"
    sessionmanagement	= "yes"
    clientmanagement	= "no"
    applicationtimeout	= "#CreateTimeSpan( 0, 10, 0, 0 )#"
    setclientcookies	= "yes"
>
<cfsetting requesttimeout="120" showdebugoutput="false" enablecfoutputonly="false"/>
