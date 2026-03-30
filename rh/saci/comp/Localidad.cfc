<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla Localidad">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="LCid" type="numeric" required="Yes"  displayname="Localidad">
  <cfargument name="Ppais" type="string" required="No" default="CR" displayname="Ppais">
  <cfargument name="DPnivel" type="numeric" required="Yes"  displayname="Nivel">
  <cfargument name="LCcod" type="string" required="Yes"  displayname="Código político">
  <cfargument name="LCnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="LCidPadre" type="numeric" required="No"  displayname="Padre">
  <cfargument name="Habilitado" type="numeric" required="No" default="1"  displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

	<cf_dbtimestamp datasource="#session.dsn#"
					table="Localidad"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="LCid"
					type1="numeric"
					value1="#Arguments.LCid#">
					
	<cfquery datasource="#session.dsn#">
		update Localidad
		set Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppais#" null="#Len(Arguments.Ppais) Is 0#">
		, DPnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DPnivel#" null="#Len(Arguments.DPnivel) Is 0#">
		, LCcod = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LCcod#" null="#Len(Arguments.LCcod) Is 0#">
		, LCnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LCnombre#" null="#Len(Arguments.LCnombre) Is 0#">
		, LCidPadre = <cfif isdefined("Arguments.LCidPadre") and Len(Trim(Arguments.LCidPadre))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCidPadre#"><cfelse>null</cfif>
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  	<cfargument name="LCid" type="numeric" required="Yes"  displayname="Localidad">
  
	<cfquery datasource="#session.dsn#">
		delete LocalidadCubo
		where LCidHijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete LocalidadCubo
		where LCidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete Localidad
		where LCidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete Localidad
		where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Ppais" type="string" required="No" default="CR" displayname="Ppais">
  <cfargument name="DPnivel" type="numeric" required="Yes"  displayname="Nivel">
  <cfargument name="LCcod" type="string" required="Yes"  displayname="Código político">
  <cfargument name="LCnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="LCidPadre" type="numeric" required="No"  displayname="Padre">
  <cfargument name="Habilitado" type="numeric"  required="No" default="1"  displayname="Habilitado">
  
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="insert">
			insert into Localidad (
				Ppais,
				DPnivel,
				LCcod,			
				LCnombre,
				LCidPadre,
				Habilitado,
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppais#" null="#Len(Arguments.Ppais) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DPnivel#" null="#Len(Arguments.DPnivel) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LCcod#" null="#Len(Arguments.LCcod) Is 0#">,			
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LCnombre#" null="#Len(Arguments.LCnombre) Is 0#">,
				<cfif isdefined("Arguments.LCidPadre") and Len(Trim(Arguments.LCidPadre))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCidPadre#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
				<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert"> 
	</cftransaction>

	<!--- Variables para el LocalidadCubo --->
	<cfset Padre = "">
	<cfset Hijo = -1>
	<cfset Nivel = Arguments.DPnivel - 1>	
	
	<cfif isdefined("Arguments.LCidPadre") and Len(Trim(Arguments.LCidPadre))>
		<cfset Padre = Arguments.LCidPadre>
		<cfset Hijo = insert.identity>
	<cfelse>
		<cfset Padre = insert.identity>
		<cfset Hijo = insert.identity>		
	</cfif>

	<cfquery datasource="#session.dsn#">
		insert LocalidadCubo (
			LCidPadre
			, LCidHijo
			, LCnivel)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Padre#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Hijo#">
			, <cfqueryparam cfsqltype="cf_sql_integer" value="#Nivel#">)
	</cfquery>
	
	<cfreturn Hijo>
</cffunction>

</cfcomponent>

