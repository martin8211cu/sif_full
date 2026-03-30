<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="sa_parentesco"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_parentesco"
				type1="numeric"
				value1="#form.id_parentesco#">
	<cfif Len(form.id_parentesco) and Not Len(form.inverso)>
		<cfquery datasource="#session.dsn#" name="inverso">
			select inverso
			from sa_parentesco
			where id_parentesco = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_parentesco#">
		</cfquery>
		<cfif Len(inverso.inverso)>
			<cfquery datasource="#session.dsn#">
				update sa_parentesco
				set inverso = null
				where id_parentesco = <cfqueryparam cfsqltype="cf_sql_numeric" value="#inverso.inverso#">
			</cfquery>
		</cfif>
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update sa_parentesco
		set nombre_masc = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_masc#" null="#Len(form.nombre_masc) Is 0#">
		, nombre_fem = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_fem#" null="#Len(form.nombre_fem) Is 0#">
		, inverso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.inverso#" null="#Len(form.inverso) Is 0#">
		, CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where id_parentesco = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_parentesco#" null="#Len(form.id_parentesco) Is 0#">
	</cfquery>
	
	<cfif Len(form.inverso) and form.inverso neq form.id_parentesco>
		<cfquery datasource="#session.dsn#">
			update sa_parentesco
			set inverso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_parentesco#" null="#Len(form.id_parentesco) Is 0#">
			where id_parentesco = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.inverso#" null="#Len(form.inverso) Is 0#">
		</cfquery>
	</cfif>

	<cflocation url="sa_parentesco.cfm?id_parentesco=#URLEncodedFormat(form.id_parentesco)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete sa_parentesco
		where id_parentesco = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_parentesco#" null="#Len(form.id_parentesco) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cftransaction>
	<cfquery datasource="#session.dsn#" name="sa_parentesco_inserted">
		insert into sa_parentesco (
			nombre_masc,
			nombre_fem,
			inverso,
			CEcodigo,
			Ecodigo,
			BMfechamod,
			
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_masc#" null="#Len(form.nombre_masc) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_fem#" null="#Len(form.nombre_fem) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.inverso#" null="#Len(form.inverso) Is 0 or form.inverso is -1#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="sa_parentesco_inserted">
	<cfif form.inverso is -1>
		<cfset form.inverso = sa_parentesco_inserted.identity>
	</cfif>
	<cfif Len(form.inverso)>
		<cfquery datasource="#session.dsn#">
			update sa_parentesco
			set inverso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#sa_parentesco_inserted.identity#">
			where id_parentesco = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.inverso#" null="#Len(form.inverso) Is 0#">
		</cfquery>
	</cfif>
	</cftransaction>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="sa_parentesco.cfm">


