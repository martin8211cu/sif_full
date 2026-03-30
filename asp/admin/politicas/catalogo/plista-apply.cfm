<cfdump var="#form#">
<cfif isdefined ("form.guardar")>
	<cfparam name="form.es_global" default="">
	<cfparam name="form.es_cuenta" default="">
	<cfparam name="form.es_usuario" default="">

	<cfif Len(form.parametro0)>
		<cfquery datasource="asp">
			update PLista
			set pnombre    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pnombre#">,
			    es_global  = <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="#form.es_global is 1#">,
			    es_cuenta  = <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="#form.es_cuenta is 1#">,
			    es_usuario = <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="#form.es_usuario is 1#">,
				predeterminado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.predeterminado#">,
				BMfecha     = <cf_dbfunction name="now">,
			    BMUsucodigo = #session.Usucodigo#
			where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parametro#">
		</cfquery>
		<cflocation url="index.cfm?parametro=#HTMLEditFormat(form.parametro)#">
	<cfelse>
		<cfquery datasource="asp">
			insert into PLista (parametro, pnombre, predeterminado, es_global, es_cuenta, es_usuario, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parametro#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pnombre#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.predeterminado#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_bit" value="#form.es_global is 1#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_bit" value="#form.es_cuenta is 1#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_bit" value="#form.es_usuario is 1#">,
				<cf_dbfunction name="now">,
				#session.Usucodigo#)
		</cfquery>
	</cfif>

<cfelseif isdefined ("form.eliminar")>

	<cfquery datasource="asp">
		delete from PLista
		where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.parametro#">
	</cfquery>

</cfif>

<cflocation url="index.cfm">