<cfset params="">
<cfif isdefined("form.ALTA")>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into TESRPTconceptoCompras (CEcodigo, TESRPTCCcodigo, TESRPTCCdescripcion, TESRPTCCincluir, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.TESRPTCCcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESRPTCCdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#form.TESRPTCCincluir#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" returnvariable="TESRPTCCid">
	</cftransaction>		
	<cfset params = params & "TESRPTCCid=#rsInsert.identity#">
<cfelseif isdefined("form.CAMBIO")>
		<cfquery datasource="#session.DSN#">
			update TESRPTconceptoCompras
			set 
				TESRPTCCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESRPTCCcodigo#">,
				TESRPTCCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESRPTCCdescripcion#">,
				TESRPTCCincluir	= <cfqueryparam cfsqltype="cf_sql_bit" value="#form.TESRPTCCincluir#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where TESRPTCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCCid#">
		</cfquery>
	<cfset params = params & "TESRPTCCid=#form.TESRPTCCid#">
<cfelseif isdefined("form.BAJA")>
		<cfquery datasource="#session.DSN#">
			delete from TESRPTconceptoCompras
			where TESRPTCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRPTCCid#">
		</cfquery>
	<cflocation url="ConceptoComprasTerceros.cfm">
<cfelseif isdefined("form.NUEVO")>
	<cflocation url="ConceptoComprasTerceros_Form.cfm?#params#">
</cfif>	
<cflocation url="ConceptoComprasTerceros_Form.cfm?#params#">