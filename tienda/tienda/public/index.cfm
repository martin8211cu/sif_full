<cfif Not IsDefined("session.comprar_Ecodigo")>
	<cflocation url="seleccione_tienda.cfm">
</cfif>

<cfquery datasource="#session.dsn#" name="arte_tienda" >
	select a.tipo_vista
	from ArteTienda a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
</cfquery>

<cfif arte_tienda.tipo_vista EQ 'M'>
	<cfinclude template="menu.cfm">
<cfelseif arte_tienda.tipo_vista EQ 'C'>
<!---	<cfinclude template="catalog.cfm"> --->
	<cfinclude template="catview.cfm">
<cfelse>
	<cfinclude template="catview.cfm">
</cfif>