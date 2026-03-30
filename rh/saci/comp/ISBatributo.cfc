<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document">

<cffunction name="Cambio" output="true" returntype="numeric" access="remote">
  <cfargument name="Aid" type="numeric" required="Yes" default="">
  <cfargument name="Ecodigo" type="numeric" required="No" default="#session.Ecodigo#">
  <cfargument name="Aetiq" type="string" required="Yes"default="" >
  <cfargument name="Adesc" type="string" required="Yes" default="">
  <cfargument name="AtipoDato" type="string" required="Yes" default="">
  <cfargument name="Aorden" type="numeric" required="Yes"default="0">
  <cfargument name="AapFisica" type="boolean" required="Yes" default="">
  <cfargument name="AapJuridica" type="boolean" required="Yes" default="">
  <cfargument name="AapCuenta" type="boolean" required="Yes" default="">
  <cfargument name="AapAgente" type="boolean" required="Yes" default="">
  <cfargument name="Habilitado" type="boolean" required="Yes" default="">
	  
	<cfquery datasource="#session.dsn#">
		update ISBatributo
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, Aetiq = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Aetiq#" null="#Len(Arguments.Aetiq) Is 0#">
		, Adesc = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Adesc#" null="#Len(Arguments.Adesc) Is 0#">
		
		, AtipoDato = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AtipoDato#" null="#Len(Arguments.AtipoDato) Is 0#">
		, Aorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aorden#" null="#Len(Arguments.Aorden) Is 0#">
		, AapFisica = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AapFisica#" null="#Len(Arguments.AapFisica) Is 0#">
		, AapJuridica = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AapJuridica#" null="#Len(Arguments.AapJuridica) Is 0#">
		
		, AapCuenta = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AapCuenta#" null="#Len(Arguments.AapCuenta) Is 0#">
		, AapAgente = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AapAgente#" null="#Len(Arguments.AapAgente) Is 0#">
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#" null="#Len(Arguments.Aid) Is 0#">
	</cfquery>
	<cfreturn  Arguments.Aid>
</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Aid" type="numeric" required="Yes"  displayname="Atributo">

	<!--- Borrado de los campos para la lista de valores --->
	<cfquery datasource="#session.dsn#">
		delete ISBatributoValor
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#" null="#Len(Arguments.Aid) Is 0#">
	</cfquery>

	<cfquery datasource="#session.dsn#">
		delete ISBatributo
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aid#" null="#Len(Arguments.Aid) Is 0#">
	</cfquery>
	
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Ecodigo" type="numeric" required="No" default="" displayname="Cdigo Empresa">
  <cfargument name="Aetiq" type="string" required="Yes"  displayname="Etiqueta">
  <cfargument name="Adesc" type="string" required="Yes"  displayname="Descripcin">
  <cfargument name="AtipoDato" type="string" required="Yes"  displayname="Tipo de dato">
  <cfargument name="Aorden" type="numeric" required="Yes"  displayname="Ordenamiento">
  <cfargument name="AapFisica" type="boolean" required="Yes"  displayname="Aplica a persona fsica">
  <cfargument name="AapJuridica" type="boolean" required="Yes"  displayname="Aplica a persona jurdica">
  <cfargument name="AapCuenta" type="boolean" required="Yes"  displayname="Aplica a Cuentas">
  <cfargument name="AapAgente" type="boolean" required="Yes"  displayname="Aplica a Agentes">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">

    <cftransaction>
	<cfquery datasource="#session.dsn#" name="rsAlta">
		insert into ISBatributo (
			Ecodigo,
			Aetiq,
			Adesc,
			
			AtipoDato,
			Aorden,
			AapFisica,
			AapJuridica,
			
			AapCuenta,
			AapAgente,
			Habilitado,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Aetiq#" null="#Len(Arguments.Aetiq) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Adesc#" null="#Len(Arguments.Adesc) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.AtipoDato#" null="#Len(Arguments.AtipoDato) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Aorden#" null="#Len(Arguments.Aorden) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AapFisica#" null="#Len(Arguments.AapFisica) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AapJuridica#" null="#Len(Arguments.AapJuridica) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AapCuenta#" null="#Len(Arguments.AapCuenta) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.AapAgente#" null="#Len(Arguments.AapAgente) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			<cf_dbidentity1 conexion="#Session.DSN#">
	</cfquery>
		<cf_dbidentity2 conexion="#Session.DSN#" name="rsAlta">
	
	</cftransaction>
	
	<cfif isdefined("rsAlta.identity") and len(trim(rsAlta.identity))>
		<cfreturn  rsAlta.identity>
	<cfelse>
		<cfreturn>
	</cfif>
	
</cffunction>

</cfcomponent>

