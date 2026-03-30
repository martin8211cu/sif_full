<cf_template>
<cf_templatearea name="title">
	Registro de personas
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navegacion=ListToArray('index.cfm,Registro de Personas;javascript:void(0),Datos Personales',';')>
	<cfinclude template="../../pNavegacion.cfm">

	<cfinclude template="sa_personas-form.cfm">
</cf_templatearea>
</cf_template>


