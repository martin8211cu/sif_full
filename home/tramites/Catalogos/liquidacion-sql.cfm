<cf_dbtimestamp datasource="#session.tramites.dsn#"
	table="TPInstitucion"
	redirect="instituciones.cfm"
	timestamp="#form.ts_rversion#"
	field1="id_inst" 
	type1="numeric" 
	value1="#form.id_inst#">

<cfquery datasource="#session.tramites.dsn#">			
	update TPInstitucion 
	set liq_dias   = <cfif len(trim(Form.liq_dias))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.liq_dias#"><cfelse>null</cfif>, 
		liq_banco  = <cfif len(trim(Form.liq_banco))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.liq_banco#"><cfelse>null</cfif>, 
		liq_cuenta = <cfif len(trim(Form.liq_cuenta))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.liq_cuenta#"><cfelse>null</cfif> 
	where  id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
</cfquery>

<cflocation url="instituciones.cfm?id_inst=#form.id_inst#&tab=6">