<cfif ExisteTrafico>
	<table  width="100%"cellpadding="2" cellspacing="0" border="0">
			<tr><td>
				<cfinclude template="/saci/das/gestion/gestion-trafico-filtro.cfm">
			</td></tr>
			<tr><td align="center">	
				<cfinclude template="/saci/das/gestion/gestion-trafico-lista.cfm">
			</td></tr>
	</table>
</cfif>