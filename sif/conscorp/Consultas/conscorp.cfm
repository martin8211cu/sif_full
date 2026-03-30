<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Consulta Corporativa
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Consulta Corporativa">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			
			<cfinclude template="conscorp-filtro.cfm">
			
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
