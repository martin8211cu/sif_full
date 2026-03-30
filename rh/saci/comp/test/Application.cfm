<cfsetting enablecfoutputonly="yes">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">

<cfinclude template="/home/check/aspmonitor.cfm">
<cfinclude template="/home/check/dominio.cfm">
<cfinclude template="/home/check/autentica.cfm">
<!--- <cfinclude template="/home/check/acceso.cfm"> --->
<cfinclude template="/home/check/bienvenido.cfm">

<cfparam name="Session.Preferences.Skin" default="portlet">
<cfparam name="Session.Preferences.SkinMenu" default="portlet">
<!--- 
<cfset Session.Preferences.Skin = "Gray">
<cfset Session.Preferences.SkinMenu = "Gray">
--->
<cfif NOT IsDefined("Session.Debug") OR Session.Debug neq true>
<cferror type="exception" template="/home/public/error/handler.cfm">
<cferror type="validation" template="/home/public/error/handler.cfm">
<cferror type="request" template="/home/public/error/handler.cfm">
</cfif>

<!---
	No debe haber ningun enter despues de esto
	Especialmente por sif/tr/catalogos/flash_newactivity.cfm que se invocan desde flash
	y cualquier enter o espacio adicional hace que no funcionen
--->
<cfsetting enablecfoutputonly="no">