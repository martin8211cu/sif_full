<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="GradoAcademico"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="GAcodigo"
				type1="numeric"
				value1="#form.GAcodigo#"
		>
	<cfquery datasource="#session.dsn#">
		update GradoAcademico
		set GAnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#form.GAnombre#" null="#Len(form.GAnombre) Is 0#">
		, GAorden = <cfqueryparam cfsqltype="cf_sql_char" value="#form.GAorden#" null="#Len(form.GAorden) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#" null="#Len(form.GAcodigo) Is 0#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset LvarCodigo = 0><cfif len(trim(form.GAcodigo))><cfset LvarCodigo=form.GAcodigo></cfif>
	<cf_translatedata name="set" tabla="GradoAcademico" col="GAnombre" valor="#form.GAnombre#" filtro=" GAcodigo=#LvarCodigo# and Ecodigo=#session.Ecodigo#">

	<cflocation url="RHGradosAcademico.cfm?GAcodigo=#URLEncodedFormat(form.GAcodigo)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from GradoAcademico
		where GAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#" null="#Len(form.GAcodigo) Is 0#">
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into GradoAcademico (
			Ecodigo,
			GAnombre,
			GAorden,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.GAnombre#" null="#Len(form.GAnombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GAorden#" null="#Len(form.GAorden) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
		<cfset LvarCodigo = 0><cfif len(trim(form.GAcodigo))><cfset LvarCodigo=form.GAcodigo></cfif>
	<cf_translatedata name="set" tabla="GradoAcademico" col="GAnombre" valor="#form.GAnombre#" filtro=" GAcodigo=#LvarCodigo# and Ecodigo=#session.Ecodigo#">

<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="RHGradosAcademico.cfm">


