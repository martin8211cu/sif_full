<cfset params = 'sel=#form.sel#&RHRSid=#form.RHRSid#'>

<cfif isdefined("form.ALTA") or isdefined("form.publicar") >
	<!--- pone estado publicado a la relacion --->
	<cfif isdefined("form.publicar")>
		<cfquery datasource="#session.DSN#">
			update RHRelacionSeguimiento
			set RHRSestado = 20
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRSid#">
		</cfquery>
	</cfif>
	<!--- crea la primer instancia --->
	<cfinvoke component="rh.admintalento.Componentes.RH_PublicarRelacion" method="init" returnvariable="publicar" />
	<cfset publicar.crearRelacion(form.RHRSid) >
</cfif>

<cflocation url="registro_evaluacion.cfm?#params#">