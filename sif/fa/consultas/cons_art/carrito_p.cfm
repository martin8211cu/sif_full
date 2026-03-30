<cfif IsDefined("session.listaFactura.Total")>
<table border="0" width="100%"  align="left">
  <tr><td align="center" valign="middle">
	<cfoutput>
		<a href="/cfmx/sif/fa/consultas/cons_art/carrito.cfm" class="top">
		<img src="/cfmx/sif/fa/consultas/cons_art/images/btn_micompra.gif" alt="Mi compra" width="140" height="16" border="0">
		<br>
		&cent;#LSCurrencyFormat(session.listaFactura.Total,'none')# ivi</a>
	</cfoutput>
  </td></tr>
</table>
</cfif>
