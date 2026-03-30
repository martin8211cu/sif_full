<cfsetting enablecfoutputonly="yes">

<cfparam name="url.u">
<cfparam name="url.s" default="0">

<cfif url.s or IsDefined('session.sitio.ssl_todo') and session.sitio.ssl_todo>
	<cfset RequiredProtocol = 'https:'>
	<cfset RequiredHostname = session.sitio.ssl_dominio>
<cfelse>
	<cfset RequiredProtocol = 'http:'>
	<cfset RequiredHostname = session.sitio.host>
</cfif>

<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><head>
<script type="text/javascript">
<!--
	var destination = '#JSStringFormat(RequiredProtocol)#//#RequiredHostname##JSStringFormat(url.u)#';
	if (location.href != destination) {
		location.href = destination;
	}
-->
</script>
</head>
</html>
</cfoutput>
