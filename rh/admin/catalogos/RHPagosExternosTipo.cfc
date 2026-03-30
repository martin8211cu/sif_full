<!--- * modificado en notepad para incluir el boom * --->
<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla RHPagosExternosTipo">

<cfinclude template="RHPagosExternosTipo-dicc.cfm">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="PEXTid" type="numeric" required="Yes"  displayname="PEXTid">
  <cfargument name="PEXTcodigo" type="string" required="Yes"  displayname="PEXTcodigo">
  <cfargument name="PEXTdescripcion" type="string" required="Yes"  displayname="PEXTdescripcion">
  <cfargument name="PEXTsirenta" type="numeric" required="Yes"  displayname="PEXTsirenta">
  <cfargument name="PEXTsicargas" type="numeric" required="Yes"  displayname="PEXTsicargas">
  <cfargument name="DClinea" type="numeric" required="Yes"  displayname="DClinea">
  <cfargument name="ts_rversion" type="string" required="No" default="" displayname="Timestamp version de registro">

<cf_dbtimestamp datasource="#session.dsn#"
				table="RHPagosExternosTipo"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="PEXTid"
				type1="numeric"
				value1="#Arguments.PEXTid#">
	<cfinvoke method="validatePEXTcodigoIsNew" PEXTcodigo="#Arguments.PEXTcodigo#" PEXTid="#ARguments.PEXTid#">
	<cfquery datasource="#session.dsn#">
		update RHPagosExternosTipo
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, PEXTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PEXTcodigo#" null="#Len(Arguments.PEXTcodigo) Is 0#">
		, PEXTdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PEXTdescripcion#" null="#Len(Arguments.PEXTdescripcion) Is 0#">
		
		, PEXTsirenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PEXTsirenta#" null="#Len(Arguments.PEXTsirenta) Is 0#">
		, PEXTsicargas = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PEXTsicargas#" null="#Len(Arguments.PEXTsicargas) Is 0#">
		, DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#" null="#Len(Arguments.PEXTsicargas) Is 0 or Arguments.PEXTsicargas Is 0#">
		, Ifechasis = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where PEXTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXTid#" null="#Len(Arguments.PEXTid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="PEXTid" type="numeric" required="Yes"  displayname="PEXTid">
	<cfquery datasource="#session.dsn#">
		update RHPagosExternosTipo
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where PEXTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXTid#" null="#Len(Arguments.PEXTid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from RHPagosExternosTipo
		
		where PEXTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXTid#" null="#Len(Arguments.PEXTid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="PEXTcodigo" type="string" required="Yes"  displayname="PEXTcodigo">
  <cfargument name="PEXTdescripcion" type="string" required="Yes"  displayname="PEXTdescripcion">
  <cfargument name="PEXTsirenta" type="numeric" required="Yes"  displayname="PEXTsirenta">
  <cfargument name="PEXTsicargas" type="numeric" required="Yes"  displayname="PEXTsicargas">
  <cfargument name="DClinea" type="numeric" required="Yes"  displayname="DClinea">
	<cfinvoke method="validatePEXTcodigoIsNew" PEXTcodigo="#Arguments.PEXTcodigo#">
	<cftransaction>
	<cfquery name="alta" datasource="#session.dsn#">
		insert into RHPagosExternosTipo (
			Ecodigo,
			PEXTcodigo,
			PEXTdescripcion,
			
			PEXTsirenta,
			PEXTsicargas,
			DClinea,
			Ifechasis,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PEXTcodigo#" null="#Len(Arguments.PEXTcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PEXTdescripcion#" null="#Len(Arguments.PEXTdescripcion) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PEXTsirenta#" null="#Len(Arguments.PEXTsirenta) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PEXTsicargas#" null="#Len(Arguments.PEXTsicargas) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DClinea#" null="#Len(Arguments.PEXTsicargas) Is 0 or Arguments.PEXTsicargas Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1>
	</cfquery>
	<cf_dbidentity2 name="alta">
	</cftransaction>
	<cfreturn alta.identity>
</cffunction>

<cffunction name="validatePEXTcodigoIsNew" output="false" returntype="void" access="remote">
  <cfargument name="PEXTcodigo" type="string" required="Yes"  displayname="PEXTcodigo">
  <cfargument name="PEXTid" type="numeric" required="No" default="0" displayname="PEXTid">
	<cfquery name="validate" datasource="#session.dsn#">
		select 1 from RHPagosExternosTipo
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and PEXTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PEXTcodigo#" null="#Len(Arguments.PEXTcodigo) Is 0#">
			and PEXTid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PEXTid#" null="#Len(Arguments.PEXTid) Is 0#">
	</cfquery>
	<cfif validate.recordcount GT 0>
		<cf_throw message="#LB_Error001#" errorcode="2040">
	</cfif>
</cffunction>

</cfcomponent>