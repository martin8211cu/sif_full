<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 16-8-2005.
		Motivo: Mantenimiento de la tabla DDVista.
 --->

<!---<cfdump var="#form#">
<cf_dump var="#url#">
  --->

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.ALTA")>
		<cftransaction>
			<cfquery name="insertDDVista" datasource="#session.tramites.dsn#">     
				insert into DDVista(id_tipo, nombre_vista, titulo_vista,
					 BMUsucodigo, BMfechamod, vigente_desde, vigente_hasta, 
					 es_masivo, es_individual)
				values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_vista#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.titulo_vista#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#form.vigente_desde#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#form.vigente_hasta#">,
						<cfif isdefined("form.es_masivo") and form.es_masivo eq 1>
							<cfqueryparam cfsqltype="cf_sql_bit" value="#form.es_masivo#">,
						<cfelse>
							0,
						</cfif>
						<cfif isdefined("form.es_individual") and form.es_individual eq 1>
							<cfqueryparam cfsqltype="cf_sql_bit" value="#form.es_individual#">
						<cfelse>
							0
						</cfif>
					)
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
			</cfquery>			
			<cf_dbidentity2 datasource="#session.tramites.dsn#" name="insertDDVista">
			<cfquery name="insertDDVistaGrupo" datasource="#session.tramites.dsn#">
				insert into DDVistaGrupo 
					(id_vista, etiqueta, columna, orden, borde, BMfechamod, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertDDVista.identity#" >,
					'General', 1, 1, 0, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#" >
					)
			</cfquery>
		</cftransaction>
		<cfset modo = 'CAMBIO'>
		<cflocation url="Vista_Principal.cfm?id_tipo=#form.id_tipo#&id_vista=#insertDDVista.identity#&modo=#modo#">
		
	<cfelseif isdefined("Form.Baja")>
		<!--- BORRAR DEMAS TABLAS --->
		<cftransaction>
			<cfquery datasource="#session.tramites.dsn#">
				delete DDVistaCampo
				where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_vista#">
			</cfquery>
			<cfquery datasource="#session.tramites.dsn#">
				delete DDVistaGrupo
				where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_vista#">
			</cfquery>
			<cfquery datasource="#session.tramites.dsn#">
				delete DDVista
				where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_vista#">
			</cfquery>
			<cfset modo="ALTA">
		</cftransaction>
		<cflocation url="listaVista.cfm?modo=#modo#">

	<cfelseif isdefined("Form.Cambio")>
		<cftransaction>
		<!---
			<cf_dbtimestamp datasource="#session.tramites.dsn#"
				table="DDVista"
				redirect="Vista_Principal.cfm"
				timestamp="#form.ts_rversion#"				
				field1="id_tipo" 
				type1="numeric"
				value1="#form.id_tipo#"
				field2="id_vista" 
				type2="numeric"
				value2="#form.id_vista#"
				>
				--->

			<cfquery name="update" datasource="#session.tramites.dsn#">
				update DDVista
					set id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo#">,
						nombre_vista = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre_vista#">,
						titulo_vista = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.titulo_vista#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.usucodigo#">, 
						BMfechamod = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
						vigente_desde = <cfqueryparam cfsqltype="cf_sql_date" value="#form.vigente_desde#">, 
						vigente_hasta = <cfqueryparam cfsqltype="cf_sql_date" value="#form.vigente_hasta#">,
						es_masivo = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_masivo')#">,
						es_individual = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_individual')#">
					where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo#">
						and id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
			</cfquery>
		</cftransaction>
		<cfset modo="CAMBIO">
		<cflocation url="Vista_Principal.cfm?id_tipo=#form.id_tipo#&id_vista=#form.id_vista#&modo=#modo#">
	</cfif><!--- isdefined("Form.ALTA") isdefined("Form.Baja") isdefined("Form.Cambio") --->

	<cfelseif isdefined("Form.Nuevo")>
		<cflocation url="Vista_Principal.cfm">

</cfif><!--- not isdefined("Nuevo") --->


<!--- <cflocation url="Vista_Principal.cfm?id_tipo=#form.id_tipo#"> --->
