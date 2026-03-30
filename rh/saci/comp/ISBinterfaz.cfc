<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBinterfaz">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="interfaz" type="string" required="Yes"  displayname="Codigo">
  <cfargument name="nombreInterfaz" type="string" required="Yes"  displayname="Nombre de interfaz">
  <cfargument name="S02ACC" type="string" required="No" default="" displayname="Letra S02ACC">
  <cfargument name="componente" type="string" required="Yes"  displayname="Componente CFC">
  <cfargument name="metodo" type="string" required="Yes"  displayname="Metodo">
  <cfargument name="severidad_reenvio" type="numeric" required="Yes"  displayname="Severidad de reenvío">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBinterfaz"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="interfaz"
				type1="char"
				value1="#Arguments.interfaz#">
	<cfquery datasource="#session.dsn#">
		update ISBinterfaz
		set nombreInterfaz = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreInterfaz#" null="#Len(Arguments.nombreInterfaz) Is 0#">
		, S02ACC = <cfif isdefined("Arguments.S02ACC") and Len(Trim(Arguments.S02ACC))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.S02ACC#"><cfelse>null</cfif>
		, componente = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.componente#" null="#Len(Arguments.componente) Is 0#">
		
		, metodo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.metodo#" null="#Len(Arguments.metodo) Is 0#">
		, severidad_reenvio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.severidad_reenvio#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where interfaz = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.interfaz#" null="#Len(Arguments.interfaz) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="interfaz" type="string" required="Yes"  displayname="Codigo">
	<cfquery datasource="#session.dsn#">
		update ISBinterfaz
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where interfaz = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.interfaz#" null="#Len(Arguments.interfaz) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBinterfaz
		
		where interfaz = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.interfaz#" null="#Len(Arguments.interfaz) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="interfaz" type="string" required="Yes"  displayname="Codigo">
  <cfargument name="nombreInterfaz" type="string" required="Yes"  displayname="Nombre de interfaz">
  <cfargument name="S02ACC" type="string" required="No" default="" displayname="Letra S02ACC">
  <cfargument name="componente" type="string" required="Yes"  displayname="Componente CFC">
  <cfargument name="metodo" type="string" required="Yes"  displayname="Metodo">
  <cfargument name="severidad_reenvio" type="numeric" required="Yes"  displayname="Severidad de reenvío">

	<cfquery datasource="#session.dsn#">
		insert into ISBinterfaz (
			
			interfaz,
			nombreInterfaz,
			S02ACC,
			componente,
			
			metodo,
			severidad_reenvio,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.interfaz#" null="#Len(Arguments.interfaz) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreInterfaz#" null="#Len(Arguments.nombreInterfaz) Is 0#">,
			<cfif isdefined("Arguments.S02ACC") and Len(Trim(Arguments.S02ACC))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.S02ACC#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.componente#" null="#Len(Arguments.componente) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.metodo#" null="#Len(Arguments.metodo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.severidad_reenvio#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

