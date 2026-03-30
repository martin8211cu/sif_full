<cfsetting enablecfoutputonly="yes">
<cfapplication name="SIF_ASP" 
sessionmanagement="Yes"
clientmanagement="Yes"
setclientcookies="Yes"
sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfparam name="Session.Idioma" default="ES_CR">
<!--- <cfcontent type="text/html; charset=ISO-8859-1"> ---->
<cfinclude template="/sif/Connections/Conexion.cfm">
<cfinclude template="/sif/Utiles/SIFfunciones.cfm">
<cfheader name = "Expires" value = "0">
<!--- 
<cfscript>
	SetEncoding("url", "ISO-8859-1");
	SetEncoding("Form", "ISO-8859-1");
</cfscript>
--->
<!--- 
<cfcontent type="text/html; charset=ISO-8859-1">
--->
<!---

 --->
<!--- <cferror template="/sif/errorPages/sitewide.cfm" exception="expression" type="request"> --->
<!--- <cfset res = setLocale("Spanish (Modern)")> --->

<cfinclude template="/sif/logout/login-check.cfm">
<!--- <cfinclude template="/sif/seguridad/seguridad.cfm"> --->



<!--- 	<cflogin>
		<cfset Session.Usuario = "marcel">
		<cfset Session.Usucodigo="11000000000002568">
		<cfset Session.Ulocalizacion="00">
		<cfloginuser name="marcel" password="" roles="admin">
	</cflogin> --->



<cfparam name="Session.Preferences.Skin" default="ocean">
<cfparam name="Session.Preferences.SkinMenu" default="ocean">
<!---
<cfset Session.Preferences.Skin = "ocean">
<cfset Session.Preferences.SkinMenu = "ocean">
--->
<!--- 
<cfif isdefined("Form.Fieldnames") and len(trim(Form.Fieldnames)) gt 0>
	<cfloop list="#Form.FieldNames#" index="i">
		<cfparam name="Form.#i#" default="">
		<cfset "Form.#i#" = Replace(Evaluate('Form.#i#'),"'",' ',"all")>
	</cfloop>
</cfif>
--->
<cfsetting enablecfoutputonly="no">