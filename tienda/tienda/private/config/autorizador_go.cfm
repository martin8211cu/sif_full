<cfparam name="form.autorizador" type="numeric">
<cfparam name="form.comercio" type="numeric">
<cfif isDefined("form.btnAdd")>
	<cfparam name="form.prioridad" type="numeric">
	<cfquery datasource="aspsecure">
		update AutorizadorEmpresa
		set prioridad = prioridad + 1
		where Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and prioridad >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.prioridad#">
		  and exists (select * from AutorizadorEmpresa
		  	where Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			  and prioridad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.prioridad#">)
		insert AutorizadorEmpresa (autorizador, comercio, Ecodigosdc, prioridad)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comercio#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigosdc#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.prioridad#">)
	</cfquery>
<cfelseif isDefined("form.btnDelete")>
	<cfquery datasource="aspsecure">
		delete AutorizadorEmpresa
		where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">
		  and comercio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comercio#">
		  and Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		update AutorizadorEmpresa
		set prioridad = prioridad - 1
		where Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and prioridad >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.prioridad#">
		  and not exists (select * from AutorizadorEmpresa
		  	where Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			  and prioridad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.prioridad#">)

	</cfquery>
<cfelseif isDefined("form.btnUpdate")>
	<cfparam name="form.prioridad" type="numeric">
	<cfquery datasource="aspsecure">
		update AutorizadorEmpresa
		set prioridad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.prioridad#">
		where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#">
		  and comercio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comercio#">
		  and Ecodigosdc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	</cfquery>
</cfif>
<cflocation url="autorizador.cfm">