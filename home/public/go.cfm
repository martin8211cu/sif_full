<cfparam name="url.host" default="">
<cfif len(url.host)>
	<cfset CreateObject("component","home.check.functions").seleccionar_dominio(url.host)>
</cfif>
<cfif session.sitio.defaultsite>
	<cfset CreateObject("component","home.check.functions").seleccionar_dominio(url.host&'.com')>
</cfif>
<cfif session.sitio.defaultsite>
	<cfset CreateObject("component","home.check.functions").seleccionar_dominio(url.host&'.net')>
</cfif>
<cfif session.sitio.defaultsite>
	<cfset CreateObject("component","home.check.functions").seleccionar_dominio(url.host&'.soin.net')>
</cfif>
<cfif session.sitio.defaultsite>
	<cfset CreateObject("component","home.check.functions").seleccionar_dominio(url.host&'.dev.soin.net')>
</cfif>
<cfif session.sitio.defaultsite>
	Incorrect host requested syntax.
<cfelse>
	<cfinclude template="../index.cfm">
</cfif>