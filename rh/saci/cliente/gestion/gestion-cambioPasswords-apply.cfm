<cfset usucodigo = session.Usucodigo>
<cfset usuario = session.Usuario>

<cfinclude template="/home/menu/micuenta/usuario-apply5-inter.cfm">

<cfif error is 0>
	<cfset ExtraParams ='ok=1'>
<cfelse>
	<cfset ExtraParams ='ok=0&error=#URLEncodedFormat(error)#'>
</cfif>

<cfinclude template="gestion-redirect.cfm">