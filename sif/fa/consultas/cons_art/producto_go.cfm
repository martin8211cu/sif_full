<cfif IsDefined("form.add") OR IsDefined("form.add.x")>
	<cfinclude template="carrito_add.cfm">
	<cflocation url="carrito.cfm" addtoken="no">
<cfelseif IsDefined("form.return") OR IsDefined("form.return.x")>
	<cflocation url="index.cfm" addtoken="no">
<cfelse>
	<!--- default: add --->
	<cfinclude template="carrito_add.cfm">
	<cflocation url="carrito.cfm" addtoken="no">
</cfif>