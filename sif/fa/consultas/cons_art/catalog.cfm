<!---<cfquery datasource="#session.dsn#" name="categorias" >
	select c.Ccodigo, c.Cdescripcion
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by c.Cpath, c.Cdescripcion
</cfquery>--->

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">Tienda en línea</cf_templatearea>
	<cf_templatearea name="body">
		<cfinclude template="estilo.cfm">
		<cfinclude template="catalog_result.cfm">
	</cf_templatearea>
</cf_template>