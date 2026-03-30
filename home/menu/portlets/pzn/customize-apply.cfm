<cfparam name="form.id_pagina" type="numeric">
<cfparam name="form.portlet" default="">

<cftransaction>
<cfquery datasource="asp" name="portlets">
	select pr.id_portlet
	from SPortletPreferencias pr
	where pr.id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#">
	  and pr.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>

<cfset borrar = ''>
<cfloop query="portlets">
	<cfif Not ListFind(form.portlet,portlets.id_portlet)>
		<cfset borrar = ListAppend(borrar, portlets.id_portlet)>
	</cfif>
</cfloop>
<cfif Len(borrar)>
	<cfquery datasource="asp">
		delete SPortletPreferencias
		where id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and id_portlet in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#borrar#" list="yes">)
	</cfquery>
</cfif>

<cfset insertar = ''>
<cfset los_que_ya_hay = ValueList(portlets.id_portlet)>
<cfloop list="#form.portlet#" index="un_portlet">
	<cfif Not ListFind(los_que_ya_hay, un_portlet)>
		<cfset insertar = ListAppend(insertar, un_portlet)>
	</cfif>
</cfloop>
<cfif Len(insertar)>
	<cfquery datasource="asp">
		insert into SPortletPreferencias 
		(Usucodigo, id_pagina, id_portlet, columna, fila, parametros, BMUsucodigo, BMfecha)
		select 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			id_pagina, id_portlet, columna, fila, parametros,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		from SPortletPagina
		where id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_pagina#">
		  and id_portlet in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertar#" list="yes">)
	</cfquery>
</cfif>
</cftransaction>

<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfset LvarLocation = '/cfmx/sif/cc/consultas/analisisSocioHM.cfm?SNcodigo=#form.SNcodigo#'>
<cfelse>
	<cfset LvarLocation = '../../portal.cfm'>
</cfif>
	<cflocation url="#LvarLocation#">
