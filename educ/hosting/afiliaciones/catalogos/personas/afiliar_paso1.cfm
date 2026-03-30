<cf_template>
<cf_templatearea name="title">
	Afiliaci&oacute;n a programas
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navegacion=ListToArray('index.cfm,Registro de Personas;sa_personas.cfm?id_persona=#URLEncodedFormat(url.id_persona)#,Datos Personales;javascript:void(0),Afiliación',';')>
	<cfinclude template="../../pNavegacion.cfm">
	<cfinclude template="afiliar_paso1-form.cfm">	
</cf_templatearea>
</cf_template>

<script language="javascript1.2">
	function validar(obj){
		return true;
	}
</script>

