<cfinclude template="/home/Application.cfm"><cfsetting enablecfoutputonly="yes">
<cfparam name="url.login" default="">
<cfquery datasource="asp" name="result">
	select Pnombre,Papellido1,Papellido2
	from DatosPersonales a, Usuario b
	where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.login#">
	  and a.datos_personales = b.datos_personales
</cfquery>
<cfoutput>nombre=#URLEncodedFormat(result.Pnombre)
	#+#URLEncodedFormat(result.Papellido1)
	#+#URLEncodedFormat(result.Papellido2)#<cfif isdefined('session.usuario')>--#session.usuario#</cfif>&telefono=222-2222</cfoutput>
<cfdump var="#session#">