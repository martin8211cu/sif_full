<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBgrupoCobro">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="GCcodigo" type="numeric" required="Yes"  displayname="Código Grupo de cobro">
  <cfargument name="GCnombre" type="string" required="Yes"  displayname="Nombre grupo de cobro">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBgrupoCobro"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="GCcodigo"
				type1="integer"
				value1="#Arguments.GCcodigo#">
	<cfquery datasource="#session.dsn#">
		update ISBgrupoCobro
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, GCnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.GCnombre#" null="#Len(Arguments.GCnombre) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where GCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GCcodigo#" null="#Len(Arguments.GCcodigo) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="GCcodigo" type="numeric" required="Yes"  displayname="Código Grupo de cobro">

	<cfquery datasource="#session.dsn#">
		delete ISBgrupoCobro
		where GCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GCcodigo#" null="#Len(Arguments.GCcodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="GCcodigo" type="numeric" required="Yes"  displayname="Código Grupo de cobro">
  <cfargument name="GCnombre" type="string" required="Yes"  displayname="Nombre grupo de cobro">

	<cfquery datasource="#session.dsn#">
		insert into ISBgrupoCobro (
			
			GCcodigo,
			Ecodigo,
			GCnombre,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GCcodigo#" null="#Len(Arguments.GCcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.GCnombre#" null="#Len(Arguments.GCnombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

