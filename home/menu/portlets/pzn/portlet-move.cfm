<cfif IsDefined('id_pagina') and isDefined('id_portlet') and IsDefined('direction') and (direction EQ 'close')>
	<cfquery datasource="asp">
		delete SPortletPreferencias
		where id_pagina  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_pagina#">
		  and id_portlet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_portlet#">
		  and Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
<cfelse>
	<cfloop from="1" to="100" index="i">
		<cfif Not StructKeyExists(url, 'n' & i)>
			<cfbreak>
		</cfif>
		<cfset tr = url['n' & i]>
		<cfset columna = ListGetAt(tr,1)>
		<cfset fila    = ListGetAt(tr,2)>
		<cfset portlet = ListGetAt(tr,3)>
		<cfoutput>tr #i# : #tr#<br></cfoutput>
		<cfquery datasource="asp">
			update SPortletPreferencias
			set fila    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fila#">,
				columna = <cfqueryparam cfsqltype="cf_sql_numeric" value="#columna#">
			where id_pagina  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_pagina#">
			  and id_portlet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#portlet#">
			  and Usucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		</cfquery>
	</cfloop>
</cfif>

