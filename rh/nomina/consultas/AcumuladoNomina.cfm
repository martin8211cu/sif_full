<!--- OPARRALES 2019-02-06
	- Reporte de acumulados de Nomina
 --->
<cf_navegacion name="RCNid" navegacion="">
<cf_navegacion name="CFidconta" navegacion="">
<cf_navegacion name="tipo" navegacion="">

<cfif isdefined("url.dependencias")>
<cf_navegacion name="dependencias" navegacion="">
</cfif>

<cfset paramsuri = ArrayNew (1)>
<cfset ArrayAppend(paramsuri, 'RCNid='         & URLEncodedFormat(url.RCNid))>
<cfset ArrayAppend(paramsuri, 'CFidconta='             & URLEncodedFormat(url.CFidconta))>
<cfset ArrayAppend(paramsuri, 'tipo='             & URLEncodedFormat(url.tipo))>
<cfif isdefined('url.agrupar')>
<cfset ArrayAppend(paramsuri, 'agrupar='             & URLEncodedFormat(url.agrupar))>
</cfif>
<cfif isdefined("url.dependencias")>
	<cfset ArrayAppend(paramsuri, 'dependencias='        & URLEncodedFormat(url.dependencias))>
</cfif>

<cfinclude template="AcumuladoNomina-form.cfm">