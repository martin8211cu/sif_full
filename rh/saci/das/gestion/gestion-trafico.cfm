<cfif ExisteTrafico>
	<table  width="100%"cellpadding="2" cellspacing="0" border="0">
			<tr><td>
			<cf_gestion-traficoList
				tipoFiltro="2"
				idCliente="#form.cli#"
				incluyeTemplate = "/saci/das/gestion/gestion-hiddens.cfm">			
			</td></tr>
	</table>
</cfif>