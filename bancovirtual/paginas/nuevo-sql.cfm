
<cfset existe = false >
<cfset ir = 'tramites-autorizados.cfm?id_persona=#form.id_persona#' >



<cfif isdefined("form.id_persona") and isdefined("form.id_tramite") and len(trim(form.id_tramite))>
entro
	<cfquery name="persona" datasource="tramites_cr">
		select id_persona
		from TPPersona
		where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	</cfquery>
	<cfif len(trim(persona.id_persona)) >
		<!--- trae la instancia de tramite--->
		<cfinvoke component="home.tramites.componentes.tramites"
				  method="obtener_instancia"
				  id_persona="#persona.id_persona#"
				  id_tramite="#form.id_tramite#"
				  returnvariable="instancia" />
	
		<cfset ir = ir & '&id_instancia=#instancia#' >
	</cfif>
</cfif>

<cflocation url="/cfmx/bancovirtual/paginas/#ir#">