<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBdominioVPN">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="VPNid" type="numeric" required="Yes"  displayname="Consecutivo">
  <cfargument name="VPNdominio" type="string" required="Yes"  displayname="Nombre dominio">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="VPNdescripcion" type="string" required="Yes"  displayname="Descripción del dominio">
  <cfargument name="VPNexterno" type="boolean" required="Yes"  displayname="Dominio externo">
  <cfargument name="VPNtunelId" type="string" required="No" default="" displayname="Identif. túnel">
  <cfargument name="VPNtunelIp" type="string" required="No" default="" displayname="IP túnel">
  <cfargument name="VPNtunelTipo" type="string" required="No" default="" displayname="Tipo de túnel">
  <cfargument name="VPNtunelPass" type="string" required="No" default="" displayname="Password del túnel (hash)">
  <cfargument name="VPNtunelCant" type="numeric" required="No"  displayname="Cantidad de túneles">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBdominioVPN"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="VPNid"
				type1="numeric"
				value1="#Arguments.VPNid#">
	<cfquery datasource="#session.dsn#">
		update ISBdominioVPN
		set VPNdominio = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNdominio#" null="#Len(Arguments.VPNdominio) Is 0#">
		, CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
		, VPNdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNdescripcion#" null="#Len(Arguments.VPNdescripcion) Is 0#">
		
		, VPNexterno = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.VPNexterno#" null="#Len(Arguments.VPNexterno) Is 0#">
		, VPNtunelId = <cfif isdefined("Arguments.VPNtunelId") and Len(Trim(Arguments.VPNtunelId))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNtunelId#"><cfelse>null</cfif>
		, VPNtunelIp = <cfif isdefined("Arguments.VPNtunelIp") and Len(Trim(Arguments.VPNtunelIp))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNtunelIp#"><cfelse>null</cfif>
		, VPNtunelTipo = <cfif isdefined("Arguments.VPNtunelTipo") and Len(Trim(Arguments.VPNtunelTipo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNtunelTipo#"><cfelse>null</cfif>
		
		, VPNtunelPass = <cfif isdefined("Arguments.VPNtunelPass") and Len(Trim(Arguments.VPNtunelPass))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNtunelPass#"><cfelse>null</cfif>
		, VPNtunelCant = <cfif isdefined("Arguments.VPNtunelCant") and Len(Trim(Arguments.VPNtunelCant))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.VPNtunelCant#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where VPNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.VPNid#" null="#Len(Arguments.VPNid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="VPNid" type="numeric" required="Yes"  displayname="Consecutivo">
	<cfquery datasource="#session.dsn#">
		update ISBdominioVPN
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where VPNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.VPNid#" null="#Len(Arguments.VPNid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBdominioVPN
		
		where VPNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.VPNid#" null="#Len(Arguments.VPNid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="VPNdominio" type="string" required="Yes"  displayname="Nombre dominio">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="VPNdescripcion" type="string" required="Yes"  displayname="Descripción del dominio">
  <cfargument name="VPNexterno" type="boolean" required="Yes"  displayname="Dominio externo">
  <cfargument name="VPNtunelId" type="string" required="No" default="" displayname="Identif. túnel">
  <cfargument name="VPNtunelIp" type="string" required="No" default="" displayname="IP túnel">
  <cfargument name="VPNtunelTipo" type="string" required="No" default="" displayname="Tipo de túnel">
  <cfargument name="VPNtunelPass" type="string" required="No" default="" displayname="Password del túnel (hash)">
  <cfargument name="VPNtunelCant" type="numeric" required="No"  displayname="Cantidad de túneles">

	<cfquery datasource="#session.dsn#" name="rsAlta">
		insert into ISBdominioVPN (
			VPNdominio,
			CTid,
			VPNdescripcion,
			
			VPNexterno,
			VPNtunelId,
			VPNtunelIp,
			VPNtunelTipo,
			
			VPNtunelPass,
			VPNtunelCant,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNdominio#" null="#Len(Arguments.VPNdominio) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNdescripcion#" null="#Len(Arguments.VPNdescripcion) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.VPNexterno#" null="#Len(Arguments.VPNexterno) Is 0#">,
			<cfif isdefined("Arguments.VPNtunelId") and Len(Trim(Arguments.VPNtunelId))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNtunelId#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.VPNtunelIp") and Len(Trim(Arguments.VPNtunelIp))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNtunelIp#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.VPNtunelTipo") and Len(Trim(Arguments.VPNtunelTipo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNtunelTipo#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.VPNtunelPass") and Len(Trim(Arguments.VPNtunelPass))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.VPNtunelPass#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.VPNtunelCant") and Len(Trim(Arguments.VPNtunelCant))><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.VPNtunelCant#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#" name="rsAlta">
	</cfquery>
	<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="rsAlta">
	<cfreturn rsAlta.identity>
</cffunction>

</cfcomponent>

