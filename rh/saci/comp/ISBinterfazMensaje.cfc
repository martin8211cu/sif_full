<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBinterfazMensaje">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="codMensaje" type="string" required="Yes"  displayname="Número msg XXX-9999">
  <cfargument name="mensaje" type="string" required="Yes"  displayname="Descripcion mensaje">
  <cfargument name="severidad" type="numeric" required="Yes"  displayname="Severidad">
  <cfargument name="codmensajeinterfaz" type="numeric" required="Yes"  displayname="codmensajeinterfaz">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBinterfazMensaje"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="codMensaje"
				type1="char"
				value1="#Arguments.codMensaje#">
	<cfquery datasource="#session.dsn#">
		update ISBinterfazMensaje
		set mensaje = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.mensaje#" null="#Len(Arguments.mensaje) Is 0#">
		, severidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.severidad#" null="#Len(Arguments.severidad) Is 0#">
		, codmensajeinterfaz = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.codmensajeinterfaz#" null="#Len(Arguments.codmensajeinterfaz) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where codMensaje = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.codMensaje#" null="#Len(Arguments.codMensaje) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="codMensaje" type="string" required="Yes"  displayname="Número msg XXX-9999">
	<cfquery datasource="#session.dsn#">
		update ISBinterfazMensaje
		
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where codMensaje = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.codMensaje#" null="#Len(Arguments.codMensaje) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBinterfazMensaje
		
		where codMensaje = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.codMensaje#" null="#Len(Arguments.codMensaje) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="codMensaje" type="string" required="Yes"  displayname="Número msg XXX-9999">
  <cfargument name="mensaje" type="string" required="Yes"  displayname="Descripcion mensaje">
  <cfargument name="severidad" type="numeric" required="Yes"  displayname="Severidad">
	<cfargument name="codmensajeinterfaz" type="numeric" required="Yes"  displayname="codmensajeinterfaz">
	
	<cfquery datasource="#session.dsn#">
		insert into ISBinterfazMensaje (
			
			codMensaje,
			mensaje,
			severidad,
			codmensajeinterfaz,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.codMensaje#" null="#Len(Arguments.codMensaje) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.mensaje#" null="#Len(Arguments.mensaje) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.severidad#" null="#Len(Arguments.severidad) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.codmensajeinterfaz#" null="#Len(Arguments.codmensajeinterfaz) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

