<cfif isdefined("form.Aceptar")>
	<cfset v_ruta = form.FDcfm >
	<cfquery name="rs_data" datasource="#session.DSN#">
		select 1
		from FDeduccion
		where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
	</cfquery>
	<cfif rs_data.recordcount >
		<cfquery name="abc" datasource="#session.dsn#">
			update FDeduccion
			set FDformula = <cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#trim(form.FDformula)#" voidnull>,
				FDcfm = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#trim(v_ruta)#" voidnull>
			where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
		</cfquery>
	<cfelse>
		<cfquery name="abc" datasource="#session.dsn#">	
			insert into FDeduccion (TDid, FDformula, FDcfm)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" value="#trim(form.FDformula)#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#trim(v_ruta)#" voidnull>
			 )
		</cfquery>
	</cfif>
<cfelseif isdefined("form.Eliminar")>
	<cfquery name="abc" datasource="#session.dsn#">
		delete FDeduccion
		where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
	</cfquery>
</cfif>

<cfoutput>
<form action="DTipoDeduccion.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="CAMBIO">
	<input name="TDid" type="hidden" value="#Form.TDid#">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>