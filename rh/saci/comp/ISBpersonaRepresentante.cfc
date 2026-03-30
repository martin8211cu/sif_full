<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBpersonaRepresentante">

<cffunction name="Cambio" output="false" returntype="numeric" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Organización">
  <cfargument name="Pcontacto" type="numeric" required="Yes"  displayname="Contacto">
  <cfargument name="RJtipo" type="string" required="Yes"  displayname="Tipo de contacto">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion")and len(trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBpersonaRepresentante"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="Pquien"
				type1="numeric"
				value1="#Arguments.Pquien#"
				field2="Pcontacto"
				type2="numeric"
				value2="#Arguments.Pcontacto#">
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update ISBpersonaRepresentante
		set RJtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.RJtipo#" null="#Len(Arguments.RJtipo) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
		  and Pcontacto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcontacto#" null="#Len(Arguments.Pcontacto) Is 0#">
	</cfquery>
	
	<cfquery name="rsCambio" datasource="#session.dsn#">
		select Rid from ISBpersonaRepresentante
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
		  and Pcontacto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcontacto#" null="#Len(Arguments.Pcontacto) Is 0#">
	</cfquery>
	<cfreturn rsCambio.Rid>
</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Organización">
  <cfargument name="Pcontacto" type="numeric" required="Yes"  displayname="Contacto">

	<cfquery datasource="#session.dsn#">
		delete ISBpersonaRepresentante
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
		and Pcontacto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcontacto#" null="#Len(Arguments.Pcontacto) Is 0#">
	</cfquery>
	
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Organización">
  <cfargument name="Pcontacto" type="numeric" required="Yes"  displayname="Contacto">
  <cfargument name="RJtipo" type="string" required="Yes"  displayname="Tipo de contacto">

	<cfquery name="rsAlta" datasource="#session.dsn#">
		insert into ISBpersonaRepresentante (
			
			Pquien,
			Pcontacto,
			RJtipo,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcontacto#" null="#Len(Arguments.Pcontacto) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.RJtipo#" null="#Len(Arguments.RJtipo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
		<cf_dbidentity1 conexion="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 conexion="#Session.DSN#" name="rsAlta" verificar_transaccion="false">
	<cfreturn rsAlta.identity>
</cffunction>

</cfcomponent>

