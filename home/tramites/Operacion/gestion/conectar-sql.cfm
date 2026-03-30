<cfset parametros = '?id_persona=#url.id_persona#&id_tramite=#url.id_tramite#&identificacion_persona=#url.identificacion_persona#&id_tipoident=#url.id_tipoident#' >

<!--- trae la instancia de tramite--->
<cfinvoke component="home.tramites.componentes.tramites"
	method="obtener_instancia"
	id_persona="#url.id_persona#"
	id_tramite="#url.id_tramite#"
	returnvariable="instancia" />

<!--- tipo asociado al documento --->	
<cfquery name="tipo" datasource="#session.tramites.dsn#">
	select id_tipo
	from TPDocumento
	where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_documento#">
</cfquery>

<!--- busca datos en expediente de la persona --->
<cfquery name="registro" datasource="#session.tramites.dsn#" maxrows="1">
	select id_registro
	from DDRegistro
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
	  and id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tipo.id_tipo#">
  	order by BMfechamod desc, id_registro desc 
</cfquery>

<cfif len(trim(registro.id_registro))>
	<cfquery datasource="#session.tramites.dsn#">
		update TPInstanciaRequisito
		set id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#registro.id_registro#">
		where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia#">
		and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
	</cfquery>
<cfelse>
	<cfset parametros = parametros & '&noexiste=1'>
</cfif>

<cflocation url="gestion-form.cfm#parametros#">