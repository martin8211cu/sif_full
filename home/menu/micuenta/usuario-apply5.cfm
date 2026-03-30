<cfset usucodigo = session.Usucodigo>
<cfset usuario = session.Usuario>

<cfinclude template="usuario-apply5-inter.cfm">

<cfif error is 0>
	<cflocation url="index.cfm?tab=5&ok=1">
</cfif>
<cflocation url="index.cfm?tab=5&ok=0&error=#URLEncodedFormat(error)#">