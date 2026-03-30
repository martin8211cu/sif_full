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
<cfinclude template="/home/check/acceso.cfm">
<cfinclude template="/home/check/bienvenido.cfm">

<cfparam name="Session.Preferences.Skin" default="portlet">
<cfparam name="Session.Preferences.SkinMenu" default="portlet">
<!--- 
<cfset Session.Preferences.Skin = "Gray">
<cfset Session.Preferences.SkinMenu = "Gray">
--->
<cfif SERVER.ColdFusion.ProductName NEQ "Railo" AND (NOT IsDefined("Session.Debug") OR Session.Debug neq true)>
<cferror type="exception" template="/home/public/error/handler.cfm">
<cferror type="validation" template="/home/public/error/handler.cfm">
<cferror type="request" template="/home/public/error/handler.cfm">
</cfif>

<cfif not isdefined("Request.Translate")>
 
	<cffunction name="Translate" displayname="Translate" output="false" hint="Translate">
		<cfargument name="Etiqueta" default="" type="string" required="true">
		<cfargument name="default" default="" type="string" required="true">
		<cfargument name="File" default="" type="string" required="false">
		<cfargument name="Idioma" default="" type="String" required="false">
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="#Arguments.Etiqueta#"
			Default="#Arguments.default#"
			XmlFile="#Arguments.File#"
			returnvariable="Traduccion"/>
			
			<cfreturn #Traduccion#>
	</cffunction>
	<cfset Request.Translate = Translate>
</cfif>

<!---
	No debe haber ningun enter despues de esto
	Especialmente por sif/tr/catalogos/flash_newactivity.cfm que se invocan desde flash
	y cualquier enter o espacio adicional hace que no funcionen
--->
<cfsetting enablecfoutputonly="no">