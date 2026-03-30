<cfcomponent hint="Componente para tabla ISBinconsistencias">

<cffunction name="Cambio" output="false" returntype="void" access="public">
  <cfargument name="Iid" type="numeric" required="Yes"  displayname="Inconsistencia">
  <cfargument name="Inombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="Idescripcion" type="string" required="Yes"  displayname="Descripción">
  <cfargument name="Iseveridad" type="string" required="Yes"  displayname="Severidad">
  <cfargument name="Ipenalizada" type="boolean" required="Yes"  displayname="Penalizada">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBinconsistencias"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="Iid"
				type1="numeric"
				value1="#Arguments.Iid#">
	<cfquery datasource="#session.dsn#">
		update ISBinconsistencias
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, Inombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Inombre#" null="#Len(Arguments.Inombre) Is 0#">
		, Idescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Idescripcion#" null="#Len(Arguments.Idescripcion) Is 0#">
		
		, Iseveridad = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Iseveridad#" null="#Len(Arguments.Iseveridad) Is 0#">
		, Ipenalizada = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Ipenalizada#" null="#Len(Arguments.Ipenalizada) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" null="#Len(Arguments.Iid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="public">
  <cfargument name="Iid" type="numeric" required="Yes"  displayname="Inconsistencia">

	<cfquery datasource="#session.dsn#">
		delete ISBinconsistencias
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" null="#Len(Arguments.Iid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="true" returntype="numeric" access="remote">
  <cfargument name="Inombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="Idescripcion" type="string" required="Yes"  displayname="Descripción">
  <cfargument name="Iseveridad" type="string" required="Yes"  displayname="Severidad">
  <cfargument name="Ipenalizada" type="boolean" required="Yes"  displayname="Penalizada">
  
	<cftransaction>
			<cfquery name="rsAlta" datasource="#session.dsn#">
				insert into ISBinconsistencias (
					Ecodigo,
					Inombre,
					Idescripcion,
					
					Iseveridad,
					Ipenalizada,
					BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Inombre#" null="#Len(Arguments.Inombre) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Idescripcion#" null="#Len(Arguments.Idescripcion) Is 0#">,
					
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Iseveridad#" null="#Len(Arguments.Iseveridad) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Ipenalizada#" null="#Len(Arguments.Ipenalizada) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
				<cf_dbidentity1 conexion="#Session.DSN#">
		</cfquery>
		<cf_dbidentity2 conexion="#Session.DSN#" name="rsAlta">
	</cftransaction>
	
	<cfif isdefined("rsAlta.identity") and len(trim(rsAlta.identity))>
		<cfreturn  rsAlta.identity>
	<cfelse>
		<cfreturn -1>
	</cfif>
</cffunction>

</cfcomponent>

