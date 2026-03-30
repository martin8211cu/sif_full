<cfif IsDefined("form.checkout") OR IsDefined("form.checkout.x")>
	<cfif IsDefined("session.Usucodigo") and Len(session.Usucodigo) neq 0 and session.Usucodigo neq 0>
		<cflocation url="../private/comprar/checkout.cfm" addtoken="no">
	<cfelse>
		<cflocation url="registro/registro.cfm">
	</cfif>
<cfelseif IsDefined("form.update") OR IsDefined("form.update.x")>
	<cfinclude template="carrito_update.cfm">
	<cfinclude template="carrito_recalc.cfm">
	<cflocation url="carrito.cfm" addtoken="no">
<cfelseif IsDefined("form.return") OR IsDefined("form.return.x")>
	<cflocation url="index.cfm" addtoken="no">
<cfelse><!--- Default: update --->
	<cfinclude template="carrito_update.cfm">
	<cfinclude template="carrito_recalc.cfm">
	<cflocation url="carrito.cfm" addtoken="no">
</cfif>