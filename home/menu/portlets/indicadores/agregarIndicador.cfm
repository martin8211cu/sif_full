<cf_template>
<cf_templatearea name="title">Agregar Indicadores</cf_templatearea>
<cf_templatearea name="body">

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="1%" valign="top" align="right">
				<!--- Agenda --->
				<cf_web_portlet titulo="Agenda" skin="portlet" width="164">
					<form action="../agenda/agenda.cfm" name="calform">
						<cf_calendario form="calform" includeForm="no" name="fecha" fontSize="10" onChange="document.getElementById('pendientes').src='/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha='+escape(dmy)">
					</form>
				</cf_web_portlet>
				<br>
			
				<!--- Pendientes --->
				<cf_web_portlet titulo="Pendientes para hoy" skin="portlet" width="164">
					<cfinclude template="../agenda/lista-hoy.cfm">
				</cf_web_portlet>	
			</td>
			
			<!--- Contenido --->
			<td valign="top" align="center">
				<cf_web_portlet titulo="Indicadores" skin="portlet" width="525">
					<cfinclude template="agregarIndicador-form.cfm">
				</cf_web_portlet>	
			</td>

			<!--- AYUDA --->
			<td width="1%" valign="top" align="right">
				<!--- Agenda --->
				<cf_web_portlet titulo="Ayuda" skin="portlet" width="164">
					<table width="100%" cellpadding="2" cellspacing="0" bgcolor="#f5f5f5">
						<tr><td><strong>Los indicadores</strong> nos permiten determinar el comportamiento de ciertas variables que desee monitorear en una empresa.
									<br><br><strong>El prop&oacute;sito</strong> de los indicadores es evaluar el desempeño financiero, operacional y de producci&oacute;n de la empresa, para poder 
									medir asi, la eficacia de la estrategia aplicada.
									<br><br>Esta pantalla permite agregar nuevos indicadores para ser mostrados en la pantalla de an&aacute;lisis de los mismos.
									<br><br>A su vez, esta pantalla permite modificar los valores asignados al Centro Funcional, Oficina y Departamento relacionados al indicador.<br>&nbsp;
						</td></tr>
					</table>
				</cf_web_portlet>
				<br>
			</td>

		</tr>
	</table>
</cf_templatearea>
</cf_template>