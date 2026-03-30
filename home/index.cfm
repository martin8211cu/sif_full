<!---
<cfdump var="#FileExists(ExpandPath(session.sitio.home))#"><cfabort>
http://icfm.dev.soin.net/cfmx/home/index.cfm --->

<cfif IsDefined("session.Usucodigo") and Len(session.Usucodigo) and session.usucodigo neq 0>
	<cfset securemode = 'no'>
<cfelse>
	<cfset securemode = 'home'>
</cfif>
<cfif Len(session.sitio.home) GT 0 and not isdefined("url.newprivatesessionid") and FileExists(ExpandPath(session.sitio.home))>
	<cf_ssl secure='#securemode#' url='/cfmx#session.sitio.home#?newprivatesessionid=#Rand()#'>
	<!---
	<cflocation url='/cfmx#session.sitio.home#?newprivatesessionid=#Rand()#' addtoken="no">
	--->
<cfelse>
	<cf_ssl secure='#securemode#' url='/cfmx/home/menu/index.cfm?newprivatesessionid=#Rand()#'>
	<!---
	<cflocation url='/cfmx/home/menu/index.cfm?newprivatesessionid=#Rand()#' addtoken="no">
	--->
</cfif>
