<cfparam name="url.cat" default="0">
<cfset ruta = ArrayNew(1)>
<cfset desc = ArrayNew(1)>

<cfquery datasource="#session.dsn#" name="catpath_query">
	select distinct c.id_categoria, c.nombre_categoria
	from CategoriaRelacion r, Categoria c
	where r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and r.hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	  and r.ancestro = c.id_categoria
	  and c.id_categoria != 0
	order by distancia desc
</cfquery>

<div style="border-top:1px solid blue; border-bottom:1px solid blue; padding:4px">
<a href="catview.cfm?cat=0" class="catview_link">Categor&iacute;as</a>

<cfset min_cat = 1>
<cfif Find('/catview.cfm', CGI.SCRIPT_NAME)>
	<cfset min_cat = 2>
</cfif>

<cfoutput query="catpath_query">
	&gt;
	<a href="catview.cfm?cat=#id_categoria#" class="catview_link">#nombre_categoria#</a>
</cfoutput>
</div>