

<cfif IsDefined("form.Cambio")>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
		
	
		<cf_dbtimestamp datasource="asp"
				table="SRelacionado"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_item"
				type1="numeric"
				value1="#form.id_item#"
			
				field2="id_relacionado"
				type2="numeric"
				value2="#form.id_relacionado#"
			
		>
	
	<cfquery datasource="asp">
		update SRelacionado
		set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.posicion#" null="#Len(form.posicion) Is 0#">
		, es_submenu = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_submenu')#">
		
		, es_link = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_link')#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_item#" null="#Len(form.id_item) Is 0#">
		  and id_relacionado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_relacionado#" null="#Len(form.id_relacionado) Is 0#">
	</cfquery>

	<cflocation url="SRelacionado.cfm?id_item=#URLEncodedFormat(form.id_item)#&id_relacionado=#URLEncodedFormat(form.id_relacionado)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="asp">
		delete SRelacionado
		where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_item#" null="#Len(form.id_item) Is 0#">  and id_relacionado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_relacionado#" null="#Len(form.id_relacionado) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="asp">
		insert into SRelacionado (
			
			id_item,
			id_relacionado,
			posicion,
			es_submenu,
			
			es_link,
			BMfecha,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_item#" null="#Len(form.id_item) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_relacionado#" null="#Len(form.id_relacionado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.posicion#" null="#Len(form.posicion) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_submenu')#">,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.es_link')#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="SRelacionado.cfm">


