<cfsetting enablecfoutputonly="yes">
<cfset GvarMSG = "OK">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name = "Expires" value = "0">
<cfparam name="Session.Idioma" default="ES_CR">

<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" />
