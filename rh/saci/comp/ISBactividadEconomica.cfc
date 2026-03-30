<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBactividadEconomica">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="AEactividad" type="numeric" required="Yes"  displayname="Código actividad">
  <cfargument name="AEnombre" type="string" required="Yes"  displayname="Nombre actividad">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBactividadEconomica"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="AEactividad"
				type1="integer"
				value1="#Arguments.AEactividad#">
	<cfquery datasource="#session.dsn#">
		update ISBactividadEconomica
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, AEnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AEnombre#" null="#Len(Arguments.AEnombre) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where AEactividad = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AEactividad#" null="#Len(Arguments.AEactividad) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="AEactividad" type="numeric" required="Yes"  displayname="Código actividad">

	<cfquery datasource="#session.dsn#">
		delete ISBactividadEconomica
		where AEactividad = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AEactividad#" null="#Len(Arguments.AEactividad) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="AEactividad" type="numeric" required="Yes"  displayname="Código actividad">
  <cfargument name="AEnombre" type="string" required="Yes"  displayname="Nombre actividad">

	<cfquery datasource="#session.dsn#">
		insert into ISBactividadEconomica (
			
			AEactividad,
			Ecodigo,
			AEnombre,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AEactividad#" null="#Len(Arguments.AEactividad) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AEnombre#" null="#Len(Arguments.AEnombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

