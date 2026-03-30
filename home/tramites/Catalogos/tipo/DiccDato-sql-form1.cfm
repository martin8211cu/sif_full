<!--- MODO ALTA --->
<cfif isdefined("Form.Alta")>
	<cftransaction>
		<cfquery name="insDDTipo" datasource="#session.tramites.dsn#">
			insert into DDTipo (nombre_tipo, descripcion_tipo, clase_tipo, tipo_dato, valor_minimo, valor_maximo, longitud, escala, nombre_tabla, BMfechamod, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tipo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion_tipo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.clase_tipo#">, 
				<cfif Form.clase_tipo EQ 'S'>
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.tipo_dato#">, 
				<cfelse>
					null,
				</cfif>
				<cfif Form.clase_tipo EQ 'S' and Form.tipo_dato EQ 'N' and isdefined("Form.valor_minimo") and Len(Trim(Form.valor_minimo))>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.valor_minimo#">,
				<cfelse>
					null,
				</cfif>
				<cfif Form.clase_tipo EQ 'S' and Form.tipo_dato EQ 'N' and isdefined("Form.valor_maximo") and Len(Trim(Form.valor_maximo))>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.valor_maximo#">,
				<cfelse>
					null,
				</cfif>
				<cfif Form.clase_tipo EQ 'S' and (Form.tipo_dato EQ 'N' or Form.tipo_dato EQ 'S') and isdefined("Form.longitud") and Len(Trim(Form.longitud))>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.longitud#">,
				<cfelse>
					null,
				</cfif>
				<cfif Form.clase_tipo EQ 'S' and Form.tipo_dato EQ 'N' and isdefined("Form.escala") and Len(Trim(Form.escala))>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.escala#">,
				<cfelse>
					null,
				</cfif>
				<cfif Form.clase_tipo EQ 'T' and isdefined("Form.nombre_tabla") and Len(Trim(Form.nombre_tabla))>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tabla#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
			<cf_dbidentity1 name="insDDTipo">
		</cfquery>
		<cf_dbidentity2 name="insDDTipo" datasource="#session.tramites.dsn#">
		<cfset Form.id_tipo = insDDTipo.identity>
	</cftransaction>

<!--- MODO CAMBIO --->
<cfelseif isdefined("Form.Cambio")>

	<cfquery name="insDDTipo" datasource="#session.tramites.dsn#">
		update DDTipo set
			nombre_tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tipo#">, 
			descripcion_tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion_tipo#">, 
			clase_tipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.clase_tipo#">, 
			<cfif Form.clase_tipo EQ 'S'>
				tipo_dato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.tipo_dato#">, 
			<cfelse>
				tipo_dato = null,
			</cfif>
			<cfif Form.clase_tipo EQ 'S' and Form.tipo_dato EQ 'N' and isdefined("Form.valor_minimo") and Len(Trim(Form.valor_minimo))>
				valor_minimo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.valor_minimo#">,
			<cfelse>
				valor_minimo = null,
			</cfif>
			<cfif Form.clase_tipo EQ 'S' and Form.tipo_dato EQ 'N' and isdefined("Form.valor_maximo") and Len(Trim(Form.valor_maximo))>
				valor_maximo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.valor_maximo#">,
			<cfelse>
				valor_maximo = null,
			</cfif>
			<cfif Form.clase_tipo EQ 'S' and (Form.tipo_dato EQ 'N' or Form.tipo_dato EQ 'S') and isdefined("Form.longitud") and Len(Trim(Form.longitud))>
				longitud = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.longitud#">,
			<cfelse>
				longitud = null,
			</cfif>
			<cfif Form.clase_tipo EQ 'S' and Form.tipo_dato EQ 'N' and isdefined("Form.escala") and Len(Trim(Form.escala))>
				escala = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.escala#">,
			<cfelse>
				escala = null,
			</cfif>
			<cfif Form.clase_tipo EQ 'T' and isdefined("Form.nombre_tabla") and Len(Trim(Form.nombre_tabla))>
				nombre_tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_tabla#">,
			<cfelse>
				nombre_tabla = null,
			</cfif>
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
	</cfquery>

<!--- MODO BAJA --->
<cfelseif isdefined("Form.Baja")>
	
	<cfquery name="delDDTipo1" datasource="#session.tramites.dsn#">
		delete DDVistaCampo
		where exists (
			select 1
			from DDVista a
			where a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
			and DDVistaCampo.id_vista = a.id_vista
		)
	</cfquery>

	<cfquery name="delDDTipo1" datasource="#session.tramites.dsn#">
		delete DDVista
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
	</cfquery>

	<cfquery name="delDDTipo1" datasource="#session.tramites.dsn#">
		delete DDValor
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
	</cfquery>

	<cfquery name="delDDTipo2" datasource="#session.tramites.dsn#">
		delete DDTipoCampo
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
	</cfquery>

	<cfquery name="delDDTipo" datasource="#session.tramites.dsn#">
		delete DDTipo
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
	</cfquery>
	<cfset StructDelete(Form, "id_tipo")>
	<cfset Form.tab = 0>

</cfif>

<cfset params = "?tab=" & Form.tab>
<cfif isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))>
	<cfset params = params & "&id_tipo=" & Form.id_tipo>
</cfif>
<cflocation url="DiccDato.cfm#params#">
