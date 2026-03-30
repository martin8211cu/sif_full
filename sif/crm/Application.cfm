<cfapplication name="SIF_CRM" 
sessionmanagement="Yes"
clientmanagement="Yes"
setclientcookies="Yes"
sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfparam name="Session.Idioma" default="ES_CR">
<cfcontent type="text/html; charset=UTF-8">
<cfinclude template="/sif/Connections/Conexion.cfm">
<cfinclude template="/sif/Utiles/SIFfunciones.cfm">

<!--- <cferror template="/sif/errorPages/sitewide.cfm" exception="expression" type="request"> --->
<!--- 
<cflogin>
	<cfparam name="GetSessionRet" default="">
	<cfparam name="url.sess_pk" default="">
	<cfinvoke 
	 component="sif.Componentes.sEP"
	 method="GetSession"
	 returnvariable="GetSessionRet">
		<cfinvokeargument name="sid" value="#url.sess_pk#"/>
		<cfinvokeargument name="uid" value="#url.uid#"/>
		<cfinvokeargument name="debug" value="true"/>
	</cfinvoke>
	<cfif len (GetSessionRet.Usucodigo) GT 0 >
		<cfloginuser name="#GetSessionRet.Usulogin#" password="#GetSessionRet.Usucodigo#" roles="" >
		<cfset SESSION.logoninfo = GetSessionRet >
		<cfset SESSION.sess_pk = url.sess_pk >
	</cfif>
</cflogin>
--->

<cfparam name="Session.Preferences.Skin" default="CRM2">
<cfset Session.Preferences.Skin = "cfmx">
<cfparam name="Session.Preferences.SkinMenu" default="CRM2">
<cfset Session.Preferences.SkinMenu = "cfmx">

<cfset Session.Modulo = "CRM">

<cfif isdefined('GetSessionRet.Usulogin')>
	<cfparam name="Session.Usuario" default="#GetSessionRet.Usulogin#">
	<cfparam name="Session.Usucodigo" default="#GetSessionRet.Usucodigo#">
	<cfparam name="Session.Ulocalizacion" default="#GetSessionRet.Ulocalizacion#">
<cfelse>
	<cfset Session.Usuario = "rh_user">
</cfif>
<cfparam name="Session.Usuario" default="marcel">
<cfparam name="Session.Usucodigo" default="11000000000002568"><!--- 11000000000002568--->
<cfparam name="Session.Ulocalizacion" default="00">
