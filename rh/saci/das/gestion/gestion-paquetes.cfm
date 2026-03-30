<table width="100%"cellpadding="2" cellspacing="0" border="0">
	<tr>
		<td valign="top" width="75%">
				<cfif isdefined("form.ppaso") and form.ppaso EQ 1>
					<cf_web_portlet_start titulo="Datos Generales">
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
					
				<cfelseif isdefined("form.ppaso") and form.ppaso EQ 4>
					<cf_web_portlet_start titulo="Nuevo Servicio">
					<cfinclude template="gestion-agregar-servicios.cfm">
					<cf_web_portlet_end> 
				</cfif>
		</td>
		<td valign="top"  width="25%">
			<cfinclude template="gestion-paquete-menu.cfm">
		</td>
	</tr>
</table>
