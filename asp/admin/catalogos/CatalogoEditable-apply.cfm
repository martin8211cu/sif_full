<cfif IsDefined("form.Cambio")>
	
		<cf_dbtimestamp datasource="asp"
				table="CatalogoEditable"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="tabla"
				type1="char"
				value1="#form.tabla#"	>
	
	<cfquery datasource="asp">
		update CatalogoEditable
		set descripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.descripcion#" null="#Len(form.descripcion) Is 0#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tabla#" null="#Len(form.tabla) Is 0#">
	</cfquery>

	<cflocation url="CatalogoEditable.cfm?tabla=#URLEncodedFormat(form.tabla)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="asp">
		delete from CatalogoEditable
		where tabla = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tabla#" null="#Len(form.tabla) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="asp">
		insert into CatalogoEditable (
			
			tabla,
			descripcion,
			BMfecha,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.tabla#" null="#Len(form.tabla) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.descripcion#" null="#Len(form.descripcion) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="CatalogoEditable.cfm">


