<cfcomponent hint="Componente para tabla ISBcontactoCta">

<cffunction name="Cambio" output="false" returntype="void" access="public">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Persona">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="CCtipo" type="string" required="No" default="" displayname="Tipo">
  <cfargument name="Habilitado" type="boolean" required="Yes"  displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBcontactoCta"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="Pquien"
				type1="numeric"
				value1="#Arguments.Pquien#"
				field2="CTid"
				type2="numeric"
				value2="#Arguments.CTid#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBcontactoCta
		set CCtipo = <cfif isdefined("Arguments.CCtipo") and Len(Trim(Arguments.CCtipo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CCtipo#"><cfelse>null</cfif>
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
		  and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="public">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Persona">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">

	<cfquery datasource="#session.dsn#">
		delete ISBcontactoCta
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">  and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="public">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Persona">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="CCtipo" type="string" required="No" default="" displayname="Tipo">
  <cfargument name="Habilitado" type="boolean" required="Yes"  displayname="Habilitado">

	<cfquery datasource="#session.dsn#">
		insert into ISBcontactoCta (
			
			Pquien,
			CTid,
			CCtipo,
			Habilitado,
			
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">,
			<cfif isdefined("Arguments.CCtipo") and Len(Trim(Arguments.CCtipo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CCtipo#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

