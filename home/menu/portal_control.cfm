<cfif Not IsDefined('Request._PORTAL_CONTROL_')>
<cfset _PORTAL_CONTROL_=1>
<cfparam name="session.menues.Ecodigo" default="">
<cfparam name="session.menues.SScodigo" default="">
<cfparam name="session.menues.SMcodigo" default="">
<cfparam name="session.menues.SPcodigo" default="">
<cfparam name="session.menues.SMNcodigo" default="">
<cfparam name="session.menues.id_item" default="">

<cfquery name="dataMenu" datasource="asp" maxrows="1">
	select a.id_menu, a.id_root
	from SMenu a
	
	inner join SMenuItem b
	on a.id_root = b.id_item
	
	where a.ocultar_menu = 0
	order by a.orden_menu
</cfquery>

<cfif len(trim(dataMenu.id_menu)) and len(trim(dataMenu.id_root))>
	<cfparam name="session.menues.id_menu" default="#dataMenu.id_menu#">
	<cfparam name="session.menues.id_root" default="#dataMenu.id_root#">
<cfelse>
	<cfparam name="session.menues.id_menu" default="500000000000006"><!--- Administrador --->
	<cfparam name="session.menues.id_root" default="50"><!--- Administrador --->
</cfif>

<cfif IsDefined('url._nav')>
	<cfif IsDefined('url.seleccionar_EcodigoSDC')>
		<cfset session.menues.Ecodigo = session.Ecodigo>
	</cfif>
	<cfif IsDefined('url.id_menu') and IsDefined('url.id_root') and Len(url.id_menu) and Len(url.id_root)>
		<cfset session.menues.id_menu = url.id_menu>
		<cfset session.menues.id_root = url.id_root>
	</cfif>
	<cfif IsDefined('url.i')>
		<cfquery datasource="asp" name="menu_item">
			select i.SScodigo, i.SMcodigo, i.SPcodigo, i.id_pagina, i.url_item, i.id_item, p.SPhomeuri
			from SMenuItem i
				left join SProcesos p
					on  p.SScodigo = i.SScodigo
					and p.SMcodigo = i.SMcodigo
					and p.SPcodigo = i.SPcodigo
			where i.id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.i#">
		</cfquery>
		<cfif Len(menu_item.SPhomeuri)>
			<cfset session.menues.SScodigo = menu_item.SScodigo>
			<cfset session.menues.SMcodigo = menu_item.SMcodigo>
			<cfset session.menues.SPcodigo = menu_item.SPcodigo>
			<cfset session.menues.id_item  = menu_item.id_item>
			<cflocation url="/cfmx#menu_item.SPhomeuri#">
		<cfelseif Len(menu_item.url_item)>
			<cflocation url="/cfmx#menu_item.url_item#">
		<cfelseif Len(menu_item.id_pagina)>
			<cflocation url="/cfmx/home/menu/portal_pagina.cfm?p=#menu_item.id_pagina#">
		</cfif>
	</cfif>
	<cfif IsDefined('url.root')>
		<cfset session.menues.SScodigo = "">
		<cfset session.menues.SMcodigo = "">
		<cfset session.menues.SPcodigo = "">
		<cfset session.menues.id_item  = "">
	</cfif>
	<cfif IsDefined('url.s')>
		<cfset session.menues.SScodigo = url.s>
		<cfset session.menues.SMcodigo = "">
		<cfset session.menues.SPcodigo = "">
		<cfset session.menues.id_item  = "">
	</cfif>
	<cfif IsDefined('url.m')>
		<cfset session.menues.SMcodigo = url.m>
		<cfset session.menues.SPcodigo = "">
		<cfset session.menues.id_item  = "">
	</cfif>
	<cfif IsDefined('url.p')>
		<cfset session.menues.SPcodigo = url.p>
		<cfset session.menues.id_item  = "">
		<cfquery datasource="asp" name="get_home_page">
			select SPhomeuri
			from SProcesos p
			where p.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
			  and p.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#">
			  and p.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">
		</cfquery>
		<cfif Len(Trim(get_home_page.SPhomeuri)) GT 1>
			<cflocation url="/cfmx#Trim(get_home_page.SPhomeuri)#" addtoken="no">
		</cfif>
		
	</cfif>
	<cfif IsDefined('url.mn')>
		<cfset session.menues.SMNcodigo = url.mn>
	</cfif>
</cfif>

<!--- fin ifdef --->
</cfif>
