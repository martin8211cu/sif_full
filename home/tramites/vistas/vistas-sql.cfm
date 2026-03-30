<cfparam name="form.id_vista" type="numeric">
<cfparam name="form.id_tipo" type="numeric">
<cfparam name="form.maxitems" type="numeric">
<cfinvoke component="home.tramites.componentes.vistas" method="getVista" id_vista="#form.id_vista#" id_tipo="#form.id_tipo#" returnvariable="rsVista">
<cfquery name="rsVistaEnc" dbtype="query">
	select * from rsVista where es_encabezado = 1
</cfquery>
<cfquery name="rsVistaDet" dbtype="query">
	select * from rsVista where es_encabezado = 0
</cfquery>
<cftransaction>
<cftry>
<cfloop from="1" to="#Form.MaxItems#" index="i">
	<cfif isdefined("Form.id_persona#i#") and len(trim(Evaluate('Form.id_persona#i#')))>
		<!--- insertar en DDRegistro con Form.id_persona#i# --->
		<cfquery datasource="#session.tramites.dsn#" name="rsInsert">
			insert DDRegistro (
				id_persona, id_tipo, BMfechamod, BMUsucodigo
			) values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.id_persona#i#')#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.id_tipo')#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsInsert">
		<!--- insertar en DDCampo con ... --->
		<cfloop query="rsVistaEnc">
			<!--- ... Form.c_#id_tipo#_#id_campo# --->
			<cfquery datasource="#session.tramites.dsn#">
				insert DDCampo (
					id_campo, id_registro, valor, BMfechamod, BMUsucodigo
				) values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVistaEnc.id_campo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('Form.c_#id_tipo#_#id_campo#')#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
			</cfquery>
		</cfloop>
		<cfloop query="rsVistaDet">
			<!--- ... Form.c_#id_tipo#_#id_campo#_#i# --->
			<cfquery datasource="#session.tramites.dsn#">
				insert DDCampo (
					id_campo, id_registro, valor, BMfechamod, BMUsucodigo
				) values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVistaDet.id_campo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('Form.c_#id_tipo#_#id_campo#_#i#')#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
			</cfquery>
		</cfloop>
	</cfif>
</cfloop>
<cfcatch>
	<cfquery name="rsCFCATCH" datasource="#session.tramites.dsn#">
		select * from DDRegistro 
	</cfquery>
	<cfdump var="#rsCFCATCH#" label="DDRegistro">
	<cfquery name="rsCFCATCH" datasource="#session.tramites.dsn#">
		select * from DDCampo
	</cfquery>
	<cfdump var="#rsCFCATCH#" label="DDCampo">
	<cfdump var="#CFCATCH#">
	<cfdump var="#FORM#">
	<cfdump var="#SESSION#">
	<cfabort>
</cfcatch>
</cftry>
</cftransaction>
<cflocation url="/cfmx/home/tramites/vistas/vistas.cfm?id_vista=#form.id_vista#">