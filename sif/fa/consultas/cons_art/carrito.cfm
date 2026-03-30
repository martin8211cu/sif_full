<cfinclude template="catinit.cfm"><!---
<cfquery datasource="#session.dsn#" name="categorias" >
	select c.Ccodigo, c.Cdescripcion
	from Clasificaciones c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by c.Cpath, c.Cdescripcion
</cfquery>--->

<cf_template>
<cf_templatearea name="title">
	Shopping basket</cf_templatearea>
<cf_templatearea name="body">
	<cfinclude template="estilo.cfm">
	<cfinclude template="carrito_cont.cfm">
</cf_templatearea>
</cf_template>
