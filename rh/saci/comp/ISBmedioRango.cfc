<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBmedioRango">

<cfset normalizar = CreateObject("component", "saci.comp.normalizar")>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="MRid" type="numeric" required="Yes"  displayname="Rango ID">
  <cfargument name="EMid" type="numeric" required="Yes"  displayname="Empresa Medio">
  <cfargument name="access_server" type="string" required="yes" displayname="Servidor de Acceso">
  <cfargument name="MRdesde" type="string" required="Yes"  displayname="Dirección IP desde">
  <cfargument name="MRhasta" type="string" required="Yes"  displayname="Dirección IP hasta">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">
  
  <cfset Arguments.access_server = LCase( Arguments.access_server )>

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBmedioRango"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="MRid"
				type1="numeric"
				value1="#Arguments.MRid#">
	<cfquery datasource="#session.dsn#">
		update ISBmedioRango
		set EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#" null="#Len(Arguments.EMid) Is 0#">
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, access_server = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.access_server#" null="#Len(Arguments.access_server) EQ 0#">
		, MRdesde = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MRdesde#" null="#Len(Arguments.MRdesde) Is 0#">
		
		, MRhasta = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MRhasta#" null="#Len(Arguments.MRhasta) Is 0#">
		, MRdesdeNormal = <cfqueryparam cfsqltype="cf_sql_char" value="#normalizar.normalizar_ip(Arguments.MRdesde)#" null="#Len(Arguments.MRdesde) Is 0#">
		, MRhastaNormal = <cfqueryparam cfsqltype="cf_sql_char" value="#normalizar.normalizar_ip(Arguments.MRhasta)#" null="#Len(Arguments.MRhasta) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#" null="#Len(Arguments.MRid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="MRid" type="numeric" required="Yes"  displayname="Rango ID">

	<cfquery datasource="#session.dsn#">
		delete ISBmedioRango
		where MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MRid#" null="#Len(Arguments.MRid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="true" returntype="numeric" access="remote">
  <cfargument name="EMid" type="numeric" required="Yes"  displayname="Empresa Medio">
  <cfargument name="access_server" type="string" required="yes" displayname="Servidor de Acceso">
  <cfargument name="MRdesde" type="string" required="Yes"  displayname="Dirección IP desde">
  <cfargument name="MRhasta" type="string" required="Yes"  displayname="Dirección IP hasta">
  <cfset Arguments.access_server = LCase( Arguments.access_server )>
  
	<cftransaction>
		<cfquery name="rsAlta" datasource="#session.dsn#">
				insert into ISBmedioRango (
					EMid,
					Ecodigo,
					access_server,
					MRdesde,
					
					MRhasta,
					MRdesdeNormal,
					MRhastaNormal,
					BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#" null="#Len(Arguments.EMid) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.access_server#" null="#Len(Arguments.access_server) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MRdesde#" null="#Len(Arguments.MRdesde) Is 0#">,
					
					<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MRhasta#" null="#Len(Arguments.MRhasta) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#normalizar.normalizar_ip(Arguments.MRdesde)#" null="#Len(Arguments.MRdesde) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#normalizar.normalizar_ip(Arguments.MRhasta)#" null="#Len(Arguments.MRhasta) Is 0#">,
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

