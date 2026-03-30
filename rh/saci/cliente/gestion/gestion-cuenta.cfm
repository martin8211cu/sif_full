<table width="100%"cellpadding="2" cellspacing="0" border="0">
	<tr>
		<td valign="top" width="75%">
				<cfif isdefined("form.cpaso") and form.cpaso EQ 1>
					<cf_web_portlet_start titulo="Datos Generales">
					<cfinclude template="gestion-cuenta-datos.cfm">
					<cf_web_portlet_end> 
					
				<cfelseif isdefined("form.cpaso") and form.cpaso EQ 2>
					<cf_web_portlet_start titulo="Tareas Programadas">
						<cfinclude template="gestion-cuenta-tarea-list.cfm">
					<cf_web_portlet_end> 
				<cfelseif isdefined("form.cpaso") and form.cpaso EQ 3>
					<cf_web_portlet_start titulo="Cambio de Forma de Cobro">
					<cfinclude template="gestion-cobro.cfm">
					<cf_web_portlet_end> 
					
				<cfelseif isdefined("form.cpaso") and form.cpaso EQ 4>
					<cf_web_portlet_start titulo="Contactos">
					<cfinclude template="gestion-contacto.cfm">
					<cf_web_portlet_end> 
				</cfif>
		</td>
		<td valign="top"  width="25%">
			<cfinclude template="gestion-cuenta-menu.cfm">
			
			<br />
			
			<cfif isdefined("form.cpaso") and form.cpaso EQ 4>
				<cfinclude template="gestion-contacto-menu.cfm">
			</cfif>
		</td>
	</tr>
</table>
