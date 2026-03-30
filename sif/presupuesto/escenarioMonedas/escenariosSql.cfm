<cfif isdefined("form.Alta")>
	<cftransaction>
	<cfquery name="alta_cvt" datasource="#session.dsn#">
		insert into CVTipoCambioEscenario
		(Ecodigo, CVTdescripcion, CVTtipo, CVTaplicado)
		values(#Session.Ecodigo#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CVTdescripcion#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CVTtipo#">,
			0)
			<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="alta_cvt">
	</cftransaction>
	<cfif GDebug><h1>Alta Exitosa! CVTid = <cfoutput>#alta_cvt.identity#</cfoutput></h1><br><cfquery name="rsdebug" datasource="#session.dsn#">select * from CVTipoCambioEscenario where Ecodigo = #Session.Ecodigo#	and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#alta_cvt.identity#"></cfquery><cfdump var="#rsdebug#"></cfif>
<cfelseif isdefined("form.Cambio")>
	<cfquery name="cambio_cvt" datasource="#session.dsn#">
		update CVTipoCambioEscenario
		set CVTdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CVTdescripcion#">,
			CVTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CVTtipo#">
		where Ecodigo = #Session.Ecodigo#
			and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CVTid#">
	</cfquery>
	<cfif GDebug><h1>Cambio Exitoso! CVTid = <cfoutput>#form.cvtid#</cfoutput></h1><br><cfquery name="rsdebug" datasource="#session.dsn#">select * from CVTipoCambioEscenario where Ecodigo = #Session.Ecodigo#	and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#"></cfquery><cfdump var="#rsdebug#"></cfif>
<cfelseif isdefined("form.Baja")>
	<cfquery name="baja_mes" datasource="#session.dsn#">
		delete from CVTipoCambioEscenarioMes 
		where Ecodigo = #session.ecodigo#
			and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvtid#">
	</cfquery>
	<cfquery name="baja_cvt" datasource="#session.dsn#">
		delete from CVTipoCambioEscenario
		where Ecodigo = #Session.Ecodigo#
			and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CVTid#">
	</cfquery>
	<cfset Form.CVTid = "">
	<cfif GDebug><h1>Baja Exitosa!</cfif>
</cfif>