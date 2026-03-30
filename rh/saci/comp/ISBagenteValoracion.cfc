<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBagenteValoracion">

<cffunction name="Alta2" output="false" returntype="numeric" access="remote">

</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
	<cfargument name="ANid" type="numeric" required="Yes"  displayname="Valoracion">
  	<cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  	<cfargument name="ANvaloracion" type="numeric" required="Yes"  displayname="Tipo de Valoracion">
  	<cfargument name="ANautomatica" type="boolean" required="Yes" displayname="Automatica o manual">
	<cfargument name="ANpuntaje" type="numeric" required="Yes" displayname="Puntaje de Valoración">
  	<cfargument name="ANobservacion" type="string" required="Yes"  displayname="Observación">
  	<cfargument name="ANfecha" type="date" required="No"  default="#now()#" displayname="Fecha de inclusión">
  	<cfargument name="ts_rversion" type="string" required="no" default=""  displayname="ts_rversion">
	
	<cfif isdefined("Arguments.ts_rversion")and len(trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
					table="ISBagenteValoracion"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="ANid"
					type1="numeric"
					value1="#Arguments.ANid#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBagenteValoracion set
			AGid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
			, ANvaloracion	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ANvaloracion#" null="#Len(Arguments.ANvaloracion) Is 0#">
			, ANautomatica	= <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ANautomatica#" null="#Len(Arguments.ANautomatica) Is 0#">
			, ANobservacion	= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.ANobservacion#" null="#Len(Arguments.ANobservacion) Is 0#">
			, ANfecha		= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.ANfecha#" null="#Len(Arguments.ANfecha) Is 0#">
			, ANpuntaje 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ANpuntaje#" null="#Len(Arguments.ANpuntaje) Is 0#">
			, BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where ANid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ANid#" null="#Len(Arguments.ANid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="ANid" type="numeric" required="Yes"  displayname="Valoracion">

	<cfquery datasource="#session.dsn#">
		delete ISBagenteValoracion
		where ANid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ANid#" null="#Len(Arguments.ANid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  	<cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  	<cfargument name="ANvaloracion" type="numeric" required="Yes"  displayname="Tipo de Valoracion">
  	<cfargument name="ANautomatica" type="boolean" required="no" default="0" displayname="Automatica o manual">
	<cfargument name="ANpuntaje" type="numeric" required="Yes" displayname="Puntaje de Valoración">
  	<cfargument name="ANobservacion" type="string" required="Yes"  displayname="Observación">
  	<cfargument name="ANfecha" type="date" required="No"  default="#now()#" displayname="Fecha de inclusión">  

	<cfquery datasource="#session.dsn#" name="rsAlta">
		insert ISBagenteValoracion (
			AGid
			, ANvaloracion
			, ANautomatica
			, ANobservacion
			, ANfecha
			, ANpuntaje
			, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ANvaloracion#" null="#Len(Arguments.ANvaloracion) Is 0#">
			, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.ANautomatica#" null="#Len(Arguments.ANautomatica) Is 0#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.ANobservacion#" null="#Len(Arguments.ANobservacion) Is 0#">
			, <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.ANfecha#" null="#Len(Arguments.ANfecha) Is 0#">
			, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ANpuntaje#" null="#Len(Arguments.ANpuntaje) Is 0#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="rsAlta" verificar_transaccion="false">

	<cfreturn rsAlta.identity>
</cffunction>

</cfcomponent>

