<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="asp"
				table="SPortletPagina"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_pagina"
				type1="numeric"
				value1="#form.id_pagina#"
			
				field2="id_portlet"
				type2="numeric"
				value2="#form.id_portlet#"
			
		>
	
	<cfquery datasource="asp">
		update SPortletPagina
		set columna = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.columna#" null="#Len(form.columna) Is 0#">
		, fila = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fila#" null="#Len(form.fila) Is 0#">
		
		, parametros = <cfqueryparam cfsqltype="cf_sql_char" value="#form.parametros#" null="#Len(form.parametros) Is 0#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#" null="#Len(form.id_pagina) Is 0#">
		  and id_portlet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_portlet#" null="#Len(form.id_portlet) Is 0#">
	</cfquery>

	<cflocation url="SPagina.cfm?id_pagina=#URLEncodedFormat(form.id_pagina)#&id_portlet=#URLEncodedFormat(form.id_portlet)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="asp">
		delete from SPortletPagina
		where id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#" null="#Len(form.id_pagina) Is 0#">  and id_portlet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_portlet#" null="#Len(form.id_portlet) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="asp">
		insert into SPortletPagina (
			
			id_pagina,
			id_portlet,
			columna,
			fila,
			
			parametros,
			BMfecha,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#" null="#Len(form.id_pagina) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_portlet#" null="#Len(form.id_portlet) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.columna#" null="#Len(form.columna) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fila#" null="#Len(form.fila) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.parametros#" null="#Len(form.parametros) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="SPagina.cfm?id_pagina=#HTMLEditFormat(form.id_pagina)#">
