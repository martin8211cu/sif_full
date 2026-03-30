<cf_template>
	<cf_templatearea name="title">
		Consulta de Actividades por Usuario
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Analisis de Horas por Proyecto">
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfinclude template="formChartHorasXPry.cfm">
		</cf_web_portlet>
	</cf_templatearea>	
</cf_template>