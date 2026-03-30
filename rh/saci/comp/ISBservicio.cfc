<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBservicio">
<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="PQinterfaz" type="string" required="No" default="" displayname="Paquete para interafaz siic">
  <cfargument name="SVcantidad" type="numeric" required="Yes"  displayname="Cantidad">
  <cfargument name="SVminimo" type="numeric" required="Yes"  displayname="Cantidad minima">  
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBservicio"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="TScodigo"
				type1="char"
				value1="#Arguments.TScodigo#"
				field2="PQcodigo"
				type2="char"
				value2="#Arguments.PQcodigo#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBservicio
		set PQinterfaz = <cfif isdefined("Arguments.PQinterfaz") and Len(Trim(Arguments.PQinterfaz))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQinterfaz#"><cfelse>null</cfif>
		, SVcantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SVcantidad#" null="#Len(Arguments.SVcantidad) Is 0#">
		, SVminimo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SVminimo#">
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">
		  and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">

	<cfquery datasource="#session.dsn#">
		delete ISBservicio
		where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">  and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="PQinterfaz" type="string" required="No" default="" displayname="Paquete para interafaz siic">
  <cfargument name="SVcantidad" type="numeric" required="Yes"  displayname="Cantidad">
  <cfargument name="SVminimo" type="numeric" required="Yes"  displayname="Cantidad minima">  
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">

	<cfquery datasource="#session.dsn#">
		insert into ISBservicio (
			TScodigo,
			PQcodigo,
			PQinterfaz,
			SVcantidad,
			SVminimo,
			Habilitado,
			BMUsucodigo)
		values (			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">,
			<cfif isdefined("Arguments.PQinterfaz") and Len(Trim(Arguments.PQinterfaz))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQinterfaz#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SVcantidad#" null="#Len(Arguments.SVcantidad) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SVminimo#">,			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

