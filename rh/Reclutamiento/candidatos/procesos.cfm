
<cfif isdefined("url.AccionAEjecutar") and len(trim(url.AccionAEjecutar)) gt 0 and not isdefined("form.AccionAEjecutar")  >
	<cfset form.AccionAEjecutar = url.AccionAEjecutar>
</cfif>
<cfif isdefined("form.AccionAEjecutar") and len(trim(form.AccionAEjecutar)) gt 0>
	
	<!--- ************************************************************************************ --->
	<!--- EN ESTA AREA SE ENVIA UN RESUME DE LOS CURRICULUM SELECIONADOS A LA PERSONA INDICADA --->
	<!--- ************************************************************************************ --->
	<cfif form.AccionAEjecutar eq 'CORREO'>
		<cfinclude template="CurriculumCorto.cfm">
	<cfelseif  form.AccionAEjecutar eq 'CONCURSO'>
	<cfelseif  form.AccionAEjecutar eq 'DIRECTO'>
	<cfelseif  form.AccionAEjecutar eq 'LIMPIAR'>
		<cflocation url="Candidatos.cfm">
	</cfif>
	<cfset form.AccionAEjecuta ="">
</cfif>