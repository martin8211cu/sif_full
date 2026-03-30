<cfif session.Usucodigo neq 0>
	<cflocation url="../../private/comprar/checkout.cfm">
<cfelse>
	<cflocation url="registro.cfm">
</cfif>