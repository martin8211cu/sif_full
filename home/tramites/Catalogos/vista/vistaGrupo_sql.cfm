<cfif isdefined("form.Agregar")>
	<cftransaction>
	<cfquery datasource="#session.tramites.dsn#" name="dato" >
		insert INTO DDVistaGrupo(id_vista, etiqueta, columna, orden, borde, BMfechamod, BMUsucodigo)
		values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.etiqueta#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.columna#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden#">,
				 <cfif isdefined("form.borde")>1<cfelse>0</cfif>,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
			<cf_dbidentity1 datasource="#session.tramites.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.tramites.dsn#" name="dato">
		<cfset form.id_vistagrupo = dato.identity >
	</cftransaction>

<cfelseif isdefined("form.Modificar")>
	<cfquery datasource="#session.tramites.dsn#" >
		update DDVistaGrupo
		set etiqueta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.etiqueta#">, 
			columna=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.columna#">, 
			orden=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.orden#">, 
			borde=<cfif isdefined("form.borde")>1<cfelse>0</cfif>
		where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
		  and id_vistagrupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vistagrupo#">
	</cfquery>
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="#session.tramites.dsn#" >
		delete DDVistaGrupo
		where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
		  and id_vistagrupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vistagrupo#">
	</cfquery>
</cfif>

<cflocation url="Vista_Principal.cfm?tab=3&id_vista=#form.id_vista#&id_tipo=#form.id_tipo#&id_vistagrupo=#form.id_vistagrupo#">