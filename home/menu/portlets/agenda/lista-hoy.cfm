	<cfoutput>
	<cfparam name="url.fecha" default="">
	<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', url.fecha) is 0>
		<cfset url.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
	</cfif>

	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<iframe name="pendientes" id="pendientes" height="180" width="162" marginheight="0" marginwidth="0" frameborder="0" src="/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha=#url.fecha#" style="margin:0; border:0;"></iframe>
			</td>
		</tr>
	</table>
	</cfoutput>
