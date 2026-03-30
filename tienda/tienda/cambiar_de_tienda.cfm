<cfif IsDefined("url.ctid") >
	<cfquery datasource="asp" name="info_tienda">
		select distinct 
			e.Ecodigo as EcodigoSDC,
			convert(varchar, e.Ereferencia) as Ecodigo, 
			e.Enombre as nombre, c.Ccache as nombre_cache
		from Empresa e, Caches c
		where e.Cid = c.Cid
		  and e.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ctid#">
		order by nombre, Ecodigo
	</cfquery>
	<cfif info_tienda.RecordCount EQ 1>
		<cfset session.comprar_Ecodigo = info_tienda.Ecodigo>
		<cfset session.DSN = info_tienda.nombre_cache>
		<cfif session.Ecodigo is 0>
			<!--- para que no vaya a olvidar el session.dsn --->
			<cfset session.Ecodigo=info_tienda.Ecodigo>
			<cfset session.Enombre=info_tienda.nombre>
			<cfset session.EcodigoSDC=info_tienda.EcodigoSDC>
		</cfif>

		<cfquery datasource="#session.dsn#" name="moneda" maxrows="1">
		select Miso4217 as moneda
		from Empresas e, Monedas m
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
		  and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
		  and m.Mcodigo = e.Mcodigo
		</cfquery>
		<cfset session.comprar_moneda = moneda.moneda>
		
		<cfset StructDelete(session, "id_carrito")>
		<cfset StructDelete(session, "total_carrito")>
		<cfinclude template="public/carrito_buscar.cfm">
		<cflocation url="#cgi.SCRIPT_NAME#">
	</cfif>

</cfif>
