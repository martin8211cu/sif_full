<cfif IsDefined("form.Cambio")>
	
	<cf_dbtimestamp datasource="asp"
				table="APEsquema"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="esquema"
				type1="char"
				value1="#form.esquema#"
			
		>
	<cfquery datasource="asp">
		update APEsquema set nombre = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre#" null="#Len(form.nombre) Is 0#"> , datasource = <cfqueryparam cfsqltype="cf_sql_char" value="#form.datasource#" null="#Len(form.datasource) Is 0#"> where esquema = <cfqueryparam cfsqltype="cf_sql_char" value="#form.esquema#" null="#Len(form.esquema) Is 0#"> </cfquery>

	<cflocation url="APEsquema.cfm?esquema=#URLEncodedFormat(form.esquema)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="asp">
		delete from APEsquema where esquema = <cfqueryparam cfsqltype="cf_sql_char" value="#form.esquema#" null="#Len(form.esquema) Is 0#"> </cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="asp">
		insert into APEsquema ( esquema,
			nombre,
			datasource)
		values ( <cfqueryparam cfsqltype="cf_sql_char" value="#form.esquema#" null="#Len(form.esquema) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre#" null="#Len(form.nombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.datasource#" null="#Len(form.datasource) Is 0#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="APEsquema.cfm">


