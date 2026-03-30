<cfif IsDefined("session.id_carrito") and IsDefined("form.fieldnames")>
	<cfset n_updates = 0>
	<cfloop from="1" to="#ListLen(form.fieldnames)#" index="i">
		<cfset elem = ListGetAt(form.fieldnames,i)>
		<cfif ListLen(elem,"_") EQ 3 AND ListGetAt(elem,1,"_") EQ "cant" and IsNumeric(form[elem])>
			<cfset prod = ListGetAt(elem,2,"_")>
			<cfset pres = ListGetAt(elem,3,"_")>
			<cfif form[elem] EQ 0>
				<cfquery datasource="#session.dsn#" >
					delete Item
					where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
					  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#prod#">
					  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pres#">
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.dsn#" >
					update Item
					set cantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form[elem]#">
					where id_carrito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.id_carrito#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
					  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#prod#">
					  and id_presentacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pres#">
				</cfquery>
			</cfif>
			<cfset n_updates = n_updates + 1>
		</cfif>
	</cfloop>
	<cfif n_updates GT 0>
		<cfinclude template="carrito_recalc.cfm">
	</cfif>
</cfif>
