<cfcomponent hint="Componente para tabla ISBinconsistencias">

<cffunction name="Cambio" output="false" returntype="void" access="public">
  <cfargument name="rangoid" type="numeric" required="Yes"  displayname="Rango ID">
  <cfargument name="rangodes" type="string" required="Yes"  displayname="Descripción del Rango">
  <cfargument name="rangotope" type="numeric" required="Yes"  displayname="Porcentaje Mínimo de Calificación">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBrangoValoracion"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="rangoid"
				type1="numeric"
				value1="#Arguments.rangoid#">
	<cfquery datasource="#session.dsn#">
		update ISBrangoValoracion
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, rangodes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.rangodes#" null="#Len(Arguments.rangodes) Is 0#">
		, rangotope = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.rangotope#" null="#Len(Arguments.rangotope) Is 0#">
		
		where rangoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.rangoid#" null="#Len(Arguments.rangoid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="public">
  <cfargument name="rangoid" type="numeric" required="Yes"  displayname="Inconsistencia">

	<cfquery datasource="#session.dsn#">
		delete ISBrangoValoracion
		where rangoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.rangoid#" null="#Len(Arguments.rangoid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="true" returntype="numeric" access="remote">
  <cfargument name="rangodes" type="string" required="Yes"  displayname="Descripción del Rango">
  <cfargument name="rangotope" type="numeric" required="Yes"  displayname="Porcentaje mínimo de calificación">
  
	<cftransaction>
			<cfquery name="rsAlta" datasource="#session.dsn#">
				insert into ISBrangoValoracion (
					Ecodigo,
					rangodes,
					rangotope,
					
					BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.rangodes#" null="#Len(Arguments.rangodes) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.rangotope#" null="#Len(Arguments.rangotope) Is 0#">,
					
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

