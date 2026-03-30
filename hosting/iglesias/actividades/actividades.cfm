<cf_template>
	<cf_templatearea name="title">
		Registro de Actividades y Eventos
	</cf_templatearea>
	<cf_templatearea name="left">
		<cfinclude template="../pMenu.cfm">
	</cf_templatearea>
	<cf_templatearea name="body">
		<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
		
		<cfinclude template="actividades-form.cfm">
		<cfinclude template="actividades-lista.cfm">
	
	</cf_templatearea>
</cf_template>
