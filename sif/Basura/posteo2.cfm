<cfsetting enablecfoutputonly="yes" requesttimeout="99999">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name = "Expires" value = "0">
<cfparam name="Session.Idioma" default="ES_CR">

<cfinclude template="/home/check/dominio.cfm">
<cfinclude template="/home/check/autentica.cfm">
<!--- <cfinclude template="/home/check/acceso.cfm">
<cfinclude template="/home/check/aspmonitor.cfm"> --->

<cfparam name="Session.Preferences.Skin" default="ocean">
<cfparam name="Session.Preferences.SkinMenu" default="ocean">
<!---
<cfif NOT IsDefined("Session.Debug") OR Session.Debug neq true>
<cferror type="exception" template="/home/public/error/handler.cfm">
<cferror type="validation" template="/home/public/error/handler.cfm">
<cferror type="request" template="/home/public/error/handler.cfm">
</cfif>  --->


<cfset session.dsn = 'minisif'>
<cfset session.Ecodigo = 1>

<cfoutput>inicio: #Now()#<br></cfoutput>


<cfquery datasource="#session.dsn#" name="xx">
select min (IDcontable) as IDcontable
from EContables
where Edescripcion like 'Asiento de prueba volumen %'
</cfquery>
<cfif Len(xx.IDcontable) is 0>
	<cfthrow message="No hay asiento de prueba">
</cfif>

<cfoutput>Asiento de prueba: #xx.IDcontable#<br></cfoutput>

<cfquery datasource="#session.dsn#" name="enc">
select *
from EContables
where IDContable = #xx.IDcontable#
</cfquery>
<cfdump var="#enc#">
<cfinvoke component="sif.Componentes.Contabilidad" method="Balance_Moneda">
	<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
	<cfinvokeargument name="IDcontable" value="#enc.IDcontable#">
	<cfinvokeargument name="Cconcepto" value="#enc.Cconcepto#">
	<cfinvokeargument name="Eperiodo" value="#enc.Eperiodo#">
	<cfinvokeargument name="Emes" value="#enc.Emes#">
	<cfinvokeargument name="Edocumento" value="#enc.Edocumento#">
</cfinvoke>


<cfoutput>fin: #Now()#<br>

<a href="?rnd=#Rand()#">Otra vez !</a>

</cfoutput>