<cfif IsDefined("session.total_carrito") or IsDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
<table border="0">
	<cfif IsDefined("session.total_carrito")>
	  <tr><td width="165" align="center" valign="middle">
		<cfoutput>
			<a href="/cfmx/tienda/tienda/public/carrito.cfm" class="top">
			<img src="/cfmx/tienda/tienda/images/btn_micompra.gif" alt="Mi compra" width="140" height="16" border="0">
			<br>
			&cent;#LSCurrencyFormat(session.total_carrito,'none')# ivi</a>
		</cfoutput>
	  </td></tr>
	</cfif>
	<cfif IsDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
	  <tr><td align="center" valign="middle">
		<a href="/cfmx/tienda/tienda/private/comprar/favoritas.cfm" class="top">
		<img src="/cfmx/tienda/tienda/images/btn_anteriores.gif" alt="Compras anteriores" width="140" height="16" border="0">
		</a>
	  </td></tr>
	</cfif>
</table>
</cfif>