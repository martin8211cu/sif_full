<cf_template>
	<cf_templatearea name="title">Ver categor&iacute;a</cf_templatearea>
	<cf_templatearea name="body">
		<cfinclude template="catinit.cfm">
		<cfif isdefined("Session.lista_precios") and Len(Trim(Session.lista_precios))>
			<cfinclude template="estilo.cfm">
			<cfinclude template="catview2.cfm">
		<cfelse>
			<cf_errorCode	code = "50374" msg = "Debe crear la Lista de Precios antes de Continuar">
		</cfif>
	</cf_templatearea>
</cf_template>


