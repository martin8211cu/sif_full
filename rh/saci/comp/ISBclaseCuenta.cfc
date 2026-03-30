<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBclaseCuenta">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="CCclaseCuenta" type="numeric" required="Yes"  displayname="Código clase de cuenta">
  <cfargument name="CCnombre" type="string" required="Yes"  displayname="Nombre clase de cuenta">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBclaseCuenta"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="CCclaseCuenta"
				type1="integer"
				value1="#Arguments.CCclaseCuenta#">
	<cfquery datasource="#session.dsn#">
		update ISBclaseCuenta
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, CCnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CCnombre#" null="#Len(Arguments.CCnombre) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where CCclaseCuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CCclaseCuenta#" null="#Len(Arguments.CCclaseCuenta) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="CCclaseCuenta" type="numeric" required="Yes"  displayname="Código clase de cuenta">

	<cfquery datasource="#session.dsn#">
		delete ISBclaseCuenta
		where CCclaseCuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CCclaseCuenta#" null="#Len(Arguments.CCclaseCuenta) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="CCclaseCuenta" type="numeric" required="Yes"  displayname="Código clase de cuenta">
  <cfargument name="CCnombre" type="string" required="Yes"  displayname="Nombre clase de cuenta">

	<cfquery datasource="#session.dsn#">
		insert into ISBclaseCuenta (
			
			CCclaseCuenta,
			Ecodigo,
			CCnombre,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CCclaseCuenta#" null="#Len(Arguments.CCclaseCuenta) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CCnombre#" null="#Len(Arguments.CCnombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

