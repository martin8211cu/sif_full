<table width="100%"cellpadding="2" cellspacing="0" border="0">
	<tr>
		<td valign="top" width="75%">
				<cfif isdefined("form.ppaso") and form.ppaso EQ 1>
					<cf_web_portlet_start titulo="Datos Generales">
					<cfif Len(url.recargaok)>
						<cfif url.recargaok is 1>
							<cf_message text="El pago ha sido aceptado" type="information">
						<cfelse>
							<cf_message text="La transacción ha sido rechazada" type="error">
						</cfif>
					</cfif>
					<cfinclude template="gestion-paquetes-datos.cfm">
					<cf_web_portlet_end> 
					
				<cfelseif isdefined("form.ppaso") and form.ppaso EQ 2>
					<cf_web_portlet_start titulo="Cambio de Paquete">
						<cfinclude template="gestion-paquetes-cambio.cfm">
					<cf_web_portlet_end> 
				
				<cfelseif isdefined("form.ppaso") and form.ppaso EQ 3>
					<cf_web_portlet_start titulo="Retiro de Servicio">
					<cfinclude template="gestion-retiro-servicios.cfm">
					<cf_web_portlet_end> 
				</cfif>
		</td>
		<td valign="top"  width="25%">
			<cfinclude template="gestion-paquete-menu.cfm">
		</td>
	</tr>
</table>
