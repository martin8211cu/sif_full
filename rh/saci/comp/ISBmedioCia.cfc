<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBmedioCia">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="EMid" type="numeric" required="Yes"  displayname="Empresa Medio">
  <cfargument name="EMnombre" type="string" required="Yes"  displayname="Nombre Empresa">
  <cfargument name="TAtarifa" type="string" required="no" default="-1" displayname="Tarifa">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">
  <cfargument name="EMlogo" type="binary" required="No" default="" displayname="Logotipo Empresa">
  <cfargument name="EMcorreoEnvioFacturas" type="string" required="yes" default="" displayname="Correo para enviar facturación de medios">
  <cfargument name="EMcorreoReciboFacturas" type="string" required="yes" default="" displayname="Correo para recibir facturación de medios">

	<cf_dbtimestamp datasource="#session.dsn#"
					table="ISBmedioCia"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="EMid"
					type1="numeric"
					value1="#Arguments.EMid#">
	<cfquery datasource="#session.dsn#">
		update ISBmedioCia
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, EMnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.EMnombre#" null="#Len(Arguments.EMnombre) Is 0#">
		, EMlogo = <cfqueryparam cfsqltype="cf_sql_blob" value="#Arguments.EMlogo#" null="#Len(Arguments.EMlogo) Is 0#">
		, TAtarifa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Arguments.TAtarifa EQ -1#">
		, EMcorreoEnvioFacturas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EMcorreoEnvioFacturas#" null="#Len(Arguments.EMcorreoEnvioFacturas) Is 0#">
		, EMcorreoReciboFacturas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EMcorreoReciboFacturas#" null="#Len(Arguments.EMcorreoReciboFacturas) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#" null="#Len(Arguments.EMid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="EMid" type="numeric" required="Yes"  displayname="Empresa Medio">

	<cfquery datasource="#session.dsn#">
		delete ISBmedioCia
		where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#" null="#Len(Arguments.EMid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="true" returntype="numeric" access="remote">
  <cfargument name="EMnombre" type="string" required="Yes"  displayname="Nombre Empresa">
  <cfargument name="EMlogo" type="binary" required="No" default="" displayname="Logotipo Empresa">
  <cfargument name="TAtarifa" type="numeric" required="No" default="-1" displayname="Tarifa">
  <cfargument name="EMcorreoEnvioFacturas" type="string" required="yes" default="" displayname="Correo para enviar facturación de medios">
  <cfargument name="EMcorreoReciboFacturas" type="string" required="yes" default="" displayname="Correo para recibir facturación de medios">

	<cftransaction>
		<cfquery name="rsAlta" datasource="#session.dsn#">
			insert into ISBmedioCia (
				Ecodigo,
				EMnombre,
				EMlogo,
				TAtarifa,
				
				EMcorreoEnvioFacturas,
				EMcorreoReciboFacturas,
				
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.EMnombre#" null="#Len(Arguments.EMnombre) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_blob" value="#Arguments.EMlogo#" null="#Len(Arguments.EMlogo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TAtarifa#" null="#Arguments.TAtarifa EQ -1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EMcorreoEnvioFacturas#" null="#Len(Arguments.EMcorreoEnvioFacturas) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EMcorreoReciboFacturas#" null="#Len(Arguments.EMcorreoReciboFacturas) Is 0#">,
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

