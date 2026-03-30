<cfif session.Usucodigo neq 0>
	<cflocation url="../../private/comprar/checkout.cfm">
</cfif>
<cf_template>
<cf_templatearea name="title">
	Registro de clientes</cf_templatearea>
<cf_templatearea name="body">
	<cfinclude template="../estilo.cfm">
	<cfinclude template="registro_form.cfm">
</cf_templatearea>
</cf_template>
