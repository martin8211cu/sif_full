<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBrsServidor">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="nombreRS" type="string" required="Yes"  displayname="Nombre servidor RS">
  <cfargument name="nombreASE" type="string" required="Yes"  displayname="Nombre servidor RSSD">
  <cfargument name="nombreRSSD" type="string" required="Yes"  displayname="Nombre basedatos RSSD">
  <cfargument name="datasource" type="string" required="Yes"  displayname="Datasource de coldfusion por usar">
  <cfargument name="activo" type="boolean" required="Yes"  displayname="Monitoreo activado">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBrsServidor"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="nombreRS"
				type1="char"
				value1="#Arguments.nombreRS#">
	<cfquery datasource="#session.dsn#">
		update ISBrsServidor
		set nombreASE = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreASE#" null="#Len(Arguments.nombreASE) Is 0#">
		, nombreRSSD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreRSSD#" null="#Len(Arguments.nombreRSSD) Is 0#">
		, datasource = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.datasource#" null="#Len(Arguments.datasource) Is 0#">
		
		, activo = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.activo#" null="#Len(Arguments.activo) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where nombreRS = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreRS#" null="#Len(Arguments.nombreRS) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="nombreRS" type="string" required="Yes"  displayname="Nombre servidor RS">

	<cfquery datasource="#session.dsn#">
		delete ISBrsServidor
		where nombreRS = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreRS#" null="#Len(Arguments.nombreRS) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="nombreRS" type="string" required="Yes"  displayname="Nombre servidor RS">
  <cfargument name="nombreASE" type="string" required="Yes"  displayname="Nombre servidor RSSD">
  <cfargument name="nombreRSSD" type="string" required="Yes"  displayname="Nombre basedatos RSSD">
  <cfargument name="datasource" type="string" required="Yes"  displayname="Datasource de coldfusion por usar">
  <cfargument name="activo" type="boolean" required="Yes"  displayname="Monitoreo activado">

	<cfquery datasource="#session.dsn#">
		insert into ISBrsServidor (
			
			nombreRS,
			nombreASE,
			nombreRSSD,
			datasource,
			
			activo,
			EVfecha,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreRS#" null="#Len(Arguments.nombreRS) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreASE#" null="#Len(Arguments.nombreASE) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.nombreRSSD#" null="#Len(Arguments.nombreRSSD) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.datasource#" null="#Len(Arguments.datasource) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.activo#" null="#Len(Arguments.activo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="# CreateDate(2006,1,1)#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

