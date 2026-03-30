<cfparam name="form.padre" default="">
<cfif len(form.padre) is 0>
	<cfset form.padre = form.root>
</cfif>


<cfif IsDefined("form.Cambio")>
	
<!---
		<cf_dbtimestamp datasource="asp"
				table="SMenuItem"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_item"
				type1="numeric"
				value1="#form.id_item#"
			
		>
--->		

	<cfquery datasource="asp">
		update SMenuItem
		set etiqueta_item = <cfqueryparam cfsqltype="cf_sql_char" value="#form.etiqueta_item#" null="#Len(form.etiqueta_item) Is 0#">
		, SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#" null="#Len(form.SScodigo) Is 0#">
		
		, SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#" null="#Len(form.SMcodigo) Is 0#">
		, SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#" null="#Len(form.SPcodigo) Is 0#">
		, id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#" null="#Len(form.id_pagina) Is 0#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_item#" null="#Len(form.id_item) Is 0#">
	</cfquery>

	<!--- posicion --->
	<cfset Lvarpos = '' >
	<cfif isdefined("form.posicion") and len(trim(form.posicion))>
		<cfset Lvarpos = form.posicion >
	<cfelse>
		<cfif len(trim(form.posicion)) is 0 >
			<cfquery datasource="asp" name="buscar_posicion">
				select coalesce (max(posicion), 0) as max_pos
				from SRelacionado
				where profundidad = 1
				  and id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.padre#">
			</cfquery>
			<cfset Lvarpos = buscar_posicion.max_pos + 10>
		</cfif>
	</cfif>
	
	<!---<cfif (form.padre neq form._padre) >--->
		<cftransaction>
			<cfinvoke component="SMenuItem" method="cambiarpadre" inserta="no" id_hijo="#form.id_item#" id_padre="#form.padre#" posicion="#Lvarpos#" >
		</cftransaction>
	<!---</cfif>--->

	<!---<cflocation url="SMenuItem.cfm?id_menu=#form.id_menu#&id_item=#URLEncodedFormat(form.id_item)#&root=#URLEncodedFormat(form.root)#&padre=#URLEncodedFormat(form.padre)#&estereotipo=#URLEncodedFormat(form.estereotipo)#">--->

<cfelseif IsDefined("form.Baja")>
	<cftransaction>
		<cfquery datasource="asp">
			delete SRelacionado
			where id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_item#" null="#Len(form.id_item) Is 0#">
		</cfquery>
		<cfquery datasource="asp">
			delete SRelacionado
			where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_item#" null="#Len(form.id_item) Is 0#">
		</cfquery>
		<cfquery datasource="asp">
			delete SMenuItem
			where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_item#" null="#Len(form.id_item) Is 0#">
		</cfquery>
	</cftransaction>

<cfelseif IsDefined("form.Nuevo")>
	<cfif Len(form.id_item)>
		<cfset form.padre = form.id_item>
	</cfif>

<cfelseif IsDefined("form.Alta")>
	<cftransaction>
		<!--- posicion --->
		<cfset Lvarpos = '' >
		<cfif isdefined("form.posicion") and len(trim(form.posicion)) >
			<cfset Lvarpos = form.posicion >
		</cfif>

		<cfinvoke component="SMenuItem" method="insertar" 
			etiqueta_item="#form.etiqueta_item#"
			SScodigo="#form.SScodigo#"
			SMcodigo="#form.SMcodigo#"
			SPcodigo="#form.SPcodigo#"
			id_pagina="#form.id_pagina#"
			padre="#form.padre#"
			posicion="#Lvarpos#"
			returnvariable="inserted">
	</cftransaction>
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cfif Len(form.id_item)>
		<cfset form.padre = form.id_item>
	</cfif>
</cfif>

<cfset parametros = '' >
<cfif isdefined("form.SScodigo") and len(trim(form.SScodigo))>
	<cfset parametros = "&SScodigo=#form.SScodigo#" >
</cfif>
<cfif isdefined("form.SMcodigo") and len(trim(form.SMcodigo))>
	<cfset parametros = parametros & "&SMcodigo=#form.SMcodigo#" >
</cfif>

<cflocation url="SMenuItem.cfm?id_menu=#form.id_menu#&root=#URLEncodedFormat(form.root)#&padre=#URLEncodedFormat(form.padre)##parametros#">
<!--- &estereotipo=#URLEncodedFormat(form.estereotipo)# --->