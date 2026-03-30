<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 12-8-2005.
		Motivo: Nuevo mantenimiento de la tabla: TPTipoDocumento.
 --->


<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->
<cfif isdefined("form.Alta")>
	<cftransaction>
		<cfquery name="rsInserta" datasource="#session.tramites.dsn#">
			insert into TPTipoDocumento(codigo_tipodoc, nombre_tipodoc)
			values(	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo_tipodoc#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipodoc#">
					)
			<cf_dbidentity1 datasource="#session.tramites.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.tramites.dsn#" name="rsInserta">
	</cftransaction>
	<cfset LvarId= rsInserta.identity>
	<cflocation addtoken="no" url="TipoDocumento.cfm?id_tipodoc=#LvarId#">

<cfelseif isdefined("form.Cambio")>
	<cftransaction>
		<cf_dbtimestamp datasource="#session.tramites.dsn#"
			table="TPTipoDocumento"
			redirect="TipoDocumento.cfm"
			timestamp="#form.ts_rversion#"				
			field1="id_tipodoc" 
			type1="numeric"
			value1="#form.id_tipodoc#">

		<cfquery name="rsUpdate" datasource="#session.tramites.dsn#">
			update TPTipoDocumento
			set codigo_tipodoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo_tipodoc#">,
				nombre_tipodoc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_tipodoc#">
			where id_tipodoc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipodoc#">
		</cfquery>
	</cftransaction>
	<cflocation addtoken="no" url="/cfmx/home/tramites/Catalogos/tipodocumento/TipoDocumento.cfm?id_tipodoc=#id_tipodoc#">	
	
<cfelseif isdefined("form.Baja")>
	<cfquery datasource="#session.tramites.dsn#">
		delete TPTipoDocumento
		where id_tipodoc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipodoc#">
	</cfquery>
<cfelseif isdefined("form.Nuevo")>	
	<cflocation addtoken="no" url="/cfmx/home/tramites/Catalogos/tipodocumento/TipoDocumento.cfm">	
</cfif>

<cflocation addtoken="no" url="/cfmx/home/tramites/Catalogos/tipodocumento/TipoDocumento.cfm">