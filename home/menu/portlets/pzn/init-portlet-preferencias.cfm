<cfparam name="id_pagina" default="4">
<cfquery datasource="asp" name="hay">
	select count(1) as hay
	from SPortletPreferencias
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_pagina#">
</cfquery>
<cfif not hay.hay>

	<cfquery datasource="asp">
		insert into SPortletPreferencias 
		(Usucodigo, id_pagina, id_portlet, columna, fila, parametros, BMUsucodigo, BMfecha)
		select 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			id_pagina, id_portlet, columna, fila, parametros,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		from SPortletPagina
		where id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_pagina#">
	</cfquery>
</cfif>