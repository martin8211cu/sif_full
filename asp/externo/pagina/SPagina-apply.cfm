

<cfif IsDefined("form.Cambio")>
	
	
	
	
	
	
	
	
	
	
	
	
		
		
	
		<cf_dbtimestamp datasource="asp"
				table="SPagina"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="id_pagina"
				type1="numeric"
				value1="#form.id_pagina#"
			
		>
	
	<cfquery datasource="asp">
		update SPagina
		set nombre_pagina = <cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_pagina#" null="#Len(form.nombre_pagina) Is 0#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#" null="#Len(form.id_pagina) Is 0#">
	</cfquery>

	<cflocation url="SPagina.cfm?id_pagina=#URLEncodedFormat(form.id_pagina)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="asp">
		delete from SPagina
		where id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#" null="#Len(form.id_pagina) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="asp">
		insert into SPagina (
			nombre_pagina,
			BMfecha,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.nombre_pagina#" null="#Len(form.nombre_pagina) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="SPagina.cfm">


