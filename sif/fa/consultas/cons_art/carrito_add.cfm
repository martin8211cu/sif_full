<cfparam name="form.cantidad" default="1">
<cfparam name="form.observaciones" default="">
<cfinclude template="carrito_create.cfm">
<cfif isDefined("Session.listaFactura")>
	<cfif isdefined('url.prod')><cfset form.prod = url.prod ></cfif>
	<cfif form.cantidad EQ 0>
		<cfquery datasource="#session.dsn#">
			delete VentaD
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.prod#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="buscar_VentaD">
			select numero_linea
			from VentaD
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
			  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.prod#">
		</cfquery>
		<cfif Len(buscar_VentaD.numero_linea)>
			<cfquery datasource="#session.dsn#">
				update VentaD
				set cantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cantidad#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">
				  and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.prod#">
				  and numero_linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#buscar_VentaD.numero_linea#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				insert VentaD (Ecodigo, VentaID, Aid, fecha,
					cantidad, BMfechamod, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.listaFactura.VentaID#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.prod#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.cantidad#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		</cfif>
	</cfif>
	<cfinclude template="carrito_recalc.cfm">
</cfif>
