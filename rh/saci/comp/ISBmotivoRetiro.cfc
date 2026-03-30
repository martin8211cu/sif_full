<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBmotivoRetiro">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="MRid" type="numeric" required="Yes"  displayname="Motivo Retiro">
  <cfargument name="MRcodigo" type="string" required="Yes"  displayname="Código motivo">
  <cfargument name="MRnombre" type="string" required="Yes"  displayname="Nombre Motivo">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBmotivoRetiro"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="MRid"
				type1="numeric"
				value1="#Arguments.MRid#">
	<cfquery datasource="#session.dsn#">
		update ISBmotivoRetiro
		set MRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MRcodigo#" null="#Len(Arguments.MRcodigo) Is 0#">
		, MRnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MRnombre#" null="#Len(Arguments.MRnombre) Is 0#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#" null="#Len(Arguments.MRid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="MRid" type="numeric" required="Yes"  displayname="Motivo Retiro">
	<cfquery datasource="#session.dsn#">
		update ISBmotivoRetiro
		
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#" null="#Len(Arguments.MRid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBmotivoRetiro
		
		where MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#" null="#Len(Arguments.MRid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="true" returntype="numeric" access="remote">
  <cfargument name="MRcodigo" type="string" required="Yes"  displayname="Código motivo">
  <cfargument name="MRnombre" type="string" required="Yes"  displayname="Nombre Motivo">

	<cftransaction>
		<cfquery name="rsAlta" datasource="#session.dsn#">
			insert into ISBmotivoRetiro (
				MRcodigo,
				MRnombre,
				Ecodigo,			
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MRcodigo#" null="#Len(Arguments.MRcodigo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MRnombre#" null="#Len(Arguments.MRnombre) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
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

