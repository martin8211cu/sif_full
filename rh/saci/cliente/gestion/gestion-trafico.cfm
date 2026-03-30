<cfif ExisteTrafico>
	<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr><td align="center">	
				<cf_gestion-traficoList
					idCliente="#form.cliente#"
					tipoFiltro="2"
					incluyeTemplate="../cliente/gestion/gestion-trafico-hiddens.cfm">
			</td></tr>
	</table>
</cfif>