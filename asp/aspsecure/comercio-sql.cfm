<cfparam name="form.comisionporc">
<cfparam name="form.comisionfija">
<cfif REFind('^\d*.\d*$', form.comisionporc) is 0><cfset form.comisionporc = 0></cfif>
<cfif REFind('^\d*.\d*$', form.comisionfija) is 0><cfset form.comisionfija = 0></cfif>
<cfif isdefined("form.baja")>
	<cfquery datasource="aspsecure">
		delete from ComercioAfiliado
		where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">
		  and comercio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comercio#">
	</cfquery>
	<cflocation url="comercio.cfm">
<cfelseif len(form.autorizador) neq 0 and len(form.comercio) neq 0>
	<cf_direccion action="readform" name="direccion">
	<cf_direccion action="update" data="#direccion#" name="direccion">
	<cfquery datasource="aspsecure">
		update ComercioAfiliado
		set moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.moneda#">,
		    id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">,
			configuracion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.configuracion#">,
			comisionporc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comisionporc#">,
			comisionfija = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comisionfija#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">
		  and comercio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comercio#">
	</cfquery>
	
	<cflocation url="comercio.cfm?autorizador=#form.autorizador#&comercio=#form.comercio#">
<cfelse>
	<!--- default = alta --->
	<cf_direccion action="readform" name="direccion">
	<cf_direccion action="insert" data="#direccion#" name="direccion">
	
	<cfquery datasource="aspsecure" name="inserted">
		insert INTO ComercioAfiliado (
			autorizador, moneda, configuracion, id_direccion, comisionporc, comisionfija,
			BMUsucodigo, BMfechamod)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.moneda#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.configuracion#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion.id_direccion#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comisionporc#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comisionfija#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)

	  <cf_dbidentity1 datasource="aspsecure">
	</cfquery>
	<cf_dbidentity2 datasource="aspsecure" name="inserted">
		
	<cfset comercio = inserted.identity>
	<cflocation url="comercio.cfm?autorizador=#form.autorizador#&comercio=#form.comercio#">
</cfif>