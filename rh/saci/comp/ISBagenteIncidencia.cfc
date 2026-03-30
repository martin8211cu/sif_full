<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBagenteIncidencia">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="INid" type="numeric" required="Yes"  displayname="Identif Incidencia">
  <cfargument name="Iid" type="numeric" required="Yes"  displayname="Inconsistencia">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="Contratoid" type="numeric" required="Yes"  displayname="Identificador producto">
  <cfargument name="IEstado" type="string" required="Yes"  displayname="Estado">
  <cfargument name="INobsCrea" type="string" required="Yes"  displayname="Observación">
  <cfargument name="INfechaCrea" type="date" required="no" default="#now()#" displayname="Fecha de modificación">
  <cfargument name="ts_rversion" type="string" required="no" default=""  displayname="ts_rversion">
	
	<cfif isdefined("Arguments.ts_rversion")and len(trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
					table="ISBagenteIncidencia"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="INid"
					type1="numeric"
					value1="#Arguments.INid#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBagenteIncidencia
		set Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" null="#Len(Arguments.Iid) Is 0#">
			, AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
			, CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
			, Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
			, IEstado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.IEstado#" null="#Len(Arguments.IEstado) Is 0#">
			, INobsCrea = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.INobsCrea#" null="#Len(Arguments.INobsCrea) Is 0#">
			, INfechaCrea = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.INfechaCrea#" null="#Len(Arguments.INfechaCrea) Is 0#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where INid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.INid#" null="#Len(Arguments.INid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="CambioCorrige" output="false" returntype="void" access="remote">
  <cfargument name="INid" type="numeric" required="Yes"  displayname="Identif Incidencia">
  <cfargument name="Iid" type="numeric" required="Yes"  displayname="Inconsistencia">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="Contratoid" type="numeric" required="Yes"  displayname="Identificador producto">
  <cfargument name="IEstado" type="string" required="Yes"  displayname="Estado">
  <cfargument name="INobsCorrige" type="string" required="Yes"  displayname="Observación">
  <cfargument name="INfechaCorrige" type="date" required="no" default="#now()#" displayname="Fecha de modificación">
  <cfargument name="ts_rversion" type="string" required="no" default=""  displayname="ts_rversion">
	
	<cfif isdefined("Arguments.ts_rversion")and len(trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
					table="ISBagenteIncidencia"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="INid"
					type1="numeric"
					value1="#Arguments.INid#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBagenteIncidencia
		set Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" null="#Len(Arguments.Iid) Is 0#">
		, AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		, CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
		, Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
		, IEstado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.IEstado#" null="#Len(Arguments.IEstado) Is 0#">
		, INobsCorrige = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.INobsCorrige#" null="#Len(Arguments.INobsCorrige) Is 0#">
		, INfechaCorrige = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.INfechaCorrige#" null="#Len(Arguments.INfechaCorrige) Is 0#">
		, INusuarioCorrige = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where INid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.INid#" null="#Len(Arguments.INid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="INid" type="numeric" required="Yes"  displayname="Identif Incidencia">

	<cfquery datasource="#session.dsn#">
		delete ISBagenteIncidencia
		where INid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.INid#" null="#Len(Arguments.INid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Iid" type="numeric" required="Yes"  displayname="Inconsistencia">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="Contratoid" type="numeric" required="Yes"  displayname="Identificador producto">
  <cfargument name="IEstado" type="string" required="Yes"  displayname="Estado">
  <cfargument name="INobsCrea" type="string" required="Yes"  displayname="Observación">
  <cfargument name="INfechaCrea" type="date" required="No"  default="#now()#" displayname="Fecha de modificación">
	
	<cfquery datasource="#session.dsn#" name="rsAlta">
		insert ISBagenteIncidencia (
			Iid
			, AGid
			, CTid
			, Contratoid
			, IEstado
			, INfechaCrea
			, INusuarioCrea
			, INobsCrea
			, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" null="#Len(Arguments.Iid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.IEstado#" null="#Len(Arguments.IEstado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.INfechaCrea#" null="#Len(Arguments.INfechaCrea) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.INobsCrea#" null="#Len(Arguments.INobsCrea) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="rsAlta" verificar_transaccion="false">

	<cfreturn rsAlta.identity>
</cffunction>

</cfcomponent>

