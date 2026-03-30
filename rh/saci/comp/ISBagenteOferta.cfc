<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBagenteOferta">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="no"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBagenteOferta"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="AGid"
						type1="numeric"
						value1="#Arguments.AGid#"
						field2="PQcodigo"
						type2="char"
						value2="#Arguments.PQcodigo#">
	</cfif>
						
	<cfquery datasource="#session.dsn#">
		update ISBagenteOferta
		set Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, BMusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		  and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">

	<cfquery datasource="#session.dsn#">
		delete ISBagenteOferta
		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">

	<cfquery datasource="#session.dsn#">
		insert into ISBagenteOferta (
			AGid,
			PQcodigo,
			Habilitado,
			BMusucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
	</cfquery>
</cffunction>

</cfcomponent>

