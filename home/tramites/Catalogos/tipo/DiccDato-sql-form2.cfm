<!--- MODO ALTA --->
<cfif isdefined("Form.Alta")>
	<cfquery name="insDDValor" datasource="#session.tramites.dsn#">
		insert into DDValor (id_tipo, valor, BMfechamod, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.valor#">, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		)
	</cfquery>

<!--- MODO CAMBIO --->
<cfelseif isdefined("Form.Cambio")>

	<cfquery name="insDDValor" datasource="#session.tramites.dsn#">
		update DDValor set
			valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.valor#">, 
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		where id_valor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_valor#">
	</cfquery>

<!--- MODO BAJA --->
<cfelseif isdefined("Form.Baja")>

	<cfquery name="delDDTipoCampo" datasource="#session.tramites.dsn#">
		delete DDValor
		where id_valor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_valor#">
	</cfquery>
	<cfset StructDelete(Form, "id_valor")>

</cfif>

<cfset params = "">
<cfif isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))>
	<cfset params = "?id_tipo=" & Form.id_tipo>
</cfif>
<cflocation url="DiccDato-form2.cfm#params#">
