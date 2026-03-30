<!--- modificado en notepad para incluir el boom --->
<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla RHPagosExternos">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="PEXid" type="numeric" required="Yes"  displayname="PEXid">
  <cfargument name="PEXTid" type="numeric" required="No"  displayname="PEXTid">
  <cfargument name="DEid" type="numeric" required="No"  displayname="ID de Empleado">
  <cfargument name="PEXmonto" type="numeric" required="Yes"  displayname="PEXmonto">
  <cfargument name="PEXfechaPago" type="date" required="Yes"  displayname="PEXfechaPago">
  <cfargument name="ts_rversion" type="string" required="No" default="" displayname="Timestamp version de registro">

  <cf_dbtimestamp datasource="#session.dsn#"
				table="RHPagosExternos"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="PEXid"
				type1="numeric"
				value1="#Arguments.PEXid#">
	<cfquery datasource="#session.dsn#">
		update RHPagosExternos
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, PEXTid = <cfif isdefined("Arguments.PEXTid") and Len(Trim(Arguments.PEXTid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXTid#"><cfelse>null</cfif>
		, DEid = <cfif isdefined("Arguments.DEid") and Len(Trim(Arguments.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#"><cfelse>null</cfif>
		
		, PEXmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.PEXmonto#" null="#Len(Arguments.PEXmonto) Is 0#">
		, PEXperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Year(lsParseDateTime(Arguments.PEXfechaPago))#">
		, PEXmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Month(lsParseDateTime(Arguments.PEXfechaPago))#">
		, PEXfechaPago = <cfqueryparam cfsqltype="cf_sql_date" value="#lsParseDateTime(Arguments.PEXfechaPago)#">
		, Ifechasis = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where PEXid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXid#" null="#Len(Arguments.PEXid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="PEXid" type="numeric" required="Yes"  displayname="PEXid">
	<cfquery datasource="#session.dsn#">
		update RHPagosExternos
		
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where PEXid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXid#" null="#Len(Arguments.PEXid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete RHPagosExternos
		
		where PEXid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXid#" null="#Len(Arguments.PEXid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="PEXTid" type="numeric" required="No"  displayname="PEXTid">
  <cfargument name="DEid" type="numeric" required="No"  displayname="ID de Empleado">
  <cfargument name="PEXmonto" type="numeric" required="Yes"  displayname="PEXmonto">
  <cfargument name="PEXfechaPago" type="date" required="Yes"  displayname="PEXfechaPago">

	<cftransaction>
	<cfquery name="alta" datasource="#session.dsn#">
		insert into RHPagosExternos (
			Ecodigo,
			PEXTid,
			DEid,
			
			PEXmonto,
			PEXperiodo,
			PEXmes,
			PEXfechaPago,
			Ifechasis,
			
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfif isdefined("Arguments.PEXTid") and Len(Trim(Arguments.PEXTid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXTid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.DEid") and Len(Trim(Arguments.DEid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.PEXmonto#" null="#Len(Arguments.PEXmonto) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Year(lsParseDateTime(Arguments.PEXfechaPago))#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Month(lsParseDateTime(Arguments.PEXfechaPago))#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#lsParseDateTime(Arguments.PEXfechaPago)#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="alta">
	</cftransaction>
	<cfreturn alta.identity>
</cffunction>

</cfcomponent>