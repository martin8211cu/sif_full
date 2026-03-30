<cfinvoke component="home.tramites.componentes.vistas" method="getVista" id_vista="#form.id_vista#" id_tipo="#form.id_tipo#" returnvariable="rsVista">

<cfif isdefined("Form.Alta")>
	<cftransaction>
		<!--- Insertar en DDRegistro --->
		<cfquery datasource="#session.tramites.dsn#" name="rsInsert">
			insert into DDRegistro (id_tipo, BMfechamod, BMUsucodigo) 
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
			<cf_dbidentity1 datasource="#session.tramites.dsn#">
		</cfquery>
		<cf_dbidentity2 name="rsInsert" datasource="#session.tramites.dsn#">
		
		<!--- Insertar en DDCampo --->
		<cfloop query="rsVista">
			<cfquery datasource="#session.tramites.dsn#" name="rsInsertDDCampo">
				insert into DDCampo (id_registro, id_campo, valor, BMfechamod, BMUsucodigo) 
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVista.id_campo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.c_#id_campo#')#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				)
			</cfquery>
		
		</cfloop>		
	</cftransaction>

<cfelseif isdefined("Form.Cambio") and isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>

	<!--- Actualizar valores en DDCampo --->
	<cfloop query="rsVista">
		<cfquery datasource="#session.tramites.dsn#" name="rsInsertDDCampo">
			update DDCampo set 
				valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('Form.c_#id_campo#')#">, 
				BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_registro#">
			and id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVista.id_campo#">
		</cfquery>
	</cfloop>		

<cfelseif isdefined("Form.Baja") and isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
	
	<cfquery name="rsDel" datasource="#session.tramites.dsn#">
		delete from DDCampo
		where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_registro#">
	</cfquery>

	<cfquery name="rsDel" datasource="#session.tramites.dsn#">
		delete from DDRegistro
		where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_registro#">
	</cfquery>

</cfif>

<cflocation url="catalogo.cfm?id_vista=#form.id_vista#&id_tipo=#Form.id_tipo#">
