<cfif Not IsDefined("session.comprar_Ecodigo")>
	<cflocation url="seleccione_tienda.cfm">
</cfif>
<cfquery datasource="#session.dsn#" name="categorias" >
	select c.id_categoria, c.nombre_categoria, c.formato
	from Categoria c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	order by c.orden_relativo, c.nombre_categoria
</cfquery>

<cf_template>
<cf_templatearea name="title">
	Shopping basket</cf_templatearea>
<cf_templatearea name="body">
	<cfinclude template="estilo.cfm">
	<cfinclude template="carrito_cont.cfm">
</cf_templatearea>
</cf_template>
