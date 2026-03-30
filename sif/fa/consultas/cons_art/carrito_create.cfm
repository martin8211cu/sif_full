<!---
<cfinclude template="carrito_buscar.cfm">
--->
<!--- Si no existe el carrito (VentaE) entonces hay que crearlo --->
<cfif Not IsDefined("Session.listaFactura.VentaID")>
	<cfset Session.listaFactura = StructNew()>
	<cfset Session.listaFactura.Total = 0.00>
	
	<cfquery datasource="#session.dsn#" name="moneda_default">
		select m.Miso4217
		from Empresas e
			join Monedas m
				on e.Mcodigo = m.Mcodigo
				and e.Ecodigo = m.Ecodigo
		where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	
	<cfquery datasource="#session.dsn#" name="vendedor">
		select v.FVid, v.Ocodigo, o.LPid
		from FVendedores v
			join Oficinas o
				on o.Ecodigo = v.Ecodigo
				and o.Ocodigo = v.Ocodigo
		where v.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and v.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	</cfquery>
	
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="insert_VentaE">
			insert into VentaE (
				Ecodigo, FVid, Ocodigo, LPid, fecha, tipo_compra, moneda, BMfechamod, BMUsucodigo
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vendedor.FVid#" null="#Len(vendedor.FVid) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vendedor.Ocodigo#" null="#Len(vendedor.Ocodigo) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#vendedor.LPid#" null="#Len(vendedor.LPid) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				'FI',
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#moneda_default.Miso4217#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="insert_VentaE">
		<cfset session.listaFactura.VentaID = insert_VentaE.identity>
		<cfset session.listaFactura.FVid = vendedor.FVid>
	</cftransaction>
	
</cfif>
