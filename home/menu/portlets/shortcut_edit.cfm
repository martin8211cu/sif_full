<cf_template>
<cf_templatearea name="title">
	Organizar Favoritos
</cf_templatearea>

<cf_templatearea name="body">
	
	<cfinclude template="../portal_control.cfm">

	<table width="955"  border="0" cellspacing="2" cellpadding="0">
		<tr>
			<td width="162">&nbsp;</td>
			<td width="793">&nbsp;</td>
		</tr>

		<tr>
			<!--- PORTLETS IZQUIERDA --->
			<td valign="top">
				<cf_web_portlet titulo="Horario de la Agenda" skin="portlet" width="164">
					<form action="portlets/agenda/agenda.cfm" name="calform">
						<cf_calendario form="calform" includeForm="no" name="fecha" fontSize="10" onChange="document.getElementById('pendientes').src='/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha='+escape(dmy)">
					</form>
				</cf_web_portlet>
				<br>
	
				<cf_web_portlet titulo="Pendientes para hoy" skin="portlet" width="164">
					<cfinclude template="agenda/lista-hoy.cfm">
				</cf_web_portlet>
			</td>
	
			<!--- CONTENIDO DE LA PAGINA --->
			<td valign="top"><cfinclude template="shortcut_edit-form.cfm"></td>
		</tr>
	
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>

</cf_templatearea>

</cf_template>