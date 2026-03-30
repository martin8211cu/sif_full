
<cfquery name="updateVentaE" datasource="#session.dsn#">
	update VentaE
	set	estado = 0,
		VPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VPid#">,
		obs_venta_perdida = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.obs_venta_perdida #">
	where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
</cfquery>
<cfset StructDelete(session,"listaFactura")>

<cflocation url="index.cfm">
