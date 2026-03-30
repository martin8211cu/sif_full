<cfparam name="session.comprar_cat" default="0">
<cfparam name="url.cat" type="numeric" default="#session.comprar_cat#">
<cfif session.comprar_cat NEQ url.cat>
	<cfset session.comprar_cat = url.cat>
</cfif>

<cfquery datasource="#session.dsn#" name="categoria" >
	select c.id_categoria, c.nombre_categoria, c.formato, c.txt_descripcion
	from Categoria c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.comprar_Ecodigo#">
	  and c.id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.cat#">
	order by c.orden_relativo, c.nombre_categoria
</cfquery>

<cf_template>
	<cf_templatearea name="title">Ver categor&iacute;a</cf_templatearea>
	<cf_templatearea name="body">
		<cfinclude template="estilo.cfm">
		<cfinclude template="catview2.cfm">
	</cf_templatearea>
</cf_template>
