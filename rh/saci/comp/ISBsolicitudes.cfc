<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBservicioTipo">

<cffunction name="marcaEnviado" output="false" returntype="void" access="remote">
  	<cfargument name="SOid" type="numeric" required="yes" displayname="ID solicitud">
  	<cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">	

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBsolicitudes"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="SOid"
						type1="numeric"
						value1="#Arguments.SOid#">
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update ISBsolicitudes set 
			SOfechapro = getDate()
			, SOenviada = 1
			, BMusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where SOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SOid#" null="#Len(Arguments.SOid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  	<cfargument name="SOid" type="numeric" required="yes" displayname="ID solicitud">
  	<cfargument name="SOfechasol" type="string" required="yes" displayname="Fecha_de_solicitud">	
  	<cfargument name="SOtipo" type="string" required="yes" displayname="Tipo">
  	<cfargument name="SOestado" type="string" required="yes" default="" displayname="Estado">
  	<cfargument name="SOtiposobre" type="string" required="no" displayname="Tipo de Sobre">
  	<cfargument name="SOcantidad" type="numeric" required="no" displayname="Cantidad">
	<cfargument name="SOgenero" type="string" required="no" displayname="Genero">
	<cfargument name="SOPrefijo" type="string" required="no" displayname="Prefijo">	
	<cfargument name="SOobservaciones" type="string" required="no" displayname="Observaciones">	
  	<cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">	

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBsolicitudes"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="SOid"
						type1="numeric"
						value1="#Arguments.SOid#">
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update ISBsolicitudes set 
			SOfechasol = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.SOfechasol#">
			, SOtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOtipo#">
			, SOestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOestado#">
			, SOfechapro = null
			<cfif isdefined('Arguments.SOtipo') and Arguments.SOtipo EQ 'P'>
				, SOtiposobre = null
				, SOgenero = null
			<cfelse>
				, SOtiposobre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOtiposobre#" null="#Len(Arguments.SOtiposobre) Is 0#">
				, SOgenero = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOgenero#" null="#Len(Arguments.SOgenero) Is 0#">				
			</cfif>			
			, SOcantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SOcantidad#" null="#Len(Arguments.SOcantidad) Is 0#">

			<cfif isdefined('Arguments.SOtipo') and Arguments.SOtipo EQ 'S'>
				, SOPrefijo = null
			<cfelse>
				, SOPrefijo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOPrefijo#" null="#Len(Arguments.SOPrefijo) Is 0#">
			</cfif>			
			, SOobservaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SOobservaciones#" null="#Len(Arguments.SOobservaciones) Is 0#">
			, SOenviada = 0
			, BMusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where SOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SOid#" null="#Len(Arguments.SOid) Is 0#">
	</cfquery>
</cffunction>


<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="SOid" type="numeric" required="Yes"  displayname="ID solicitud">  
	<cfquery datasource="#session.dsn#">
		delete ISBsolicitudes
		where SOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SOid#" null="#Len(Arguments.SOid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  	<cfargument name="SOfechasol" type="string" required="yes" displayname="Fecha_de_solicitud">
  	<cfargument name="SOtipo" type="string" required="yes" displayname="Tipo">
  	<cfargument name="SOestado" type="string" required="yes" default="" displayname="Estado">
  	<cfargument name="SOtiposobre" type="string" required="no" displayname="Tipo de Sobre">
  	<cfargument name="SOcantidad" type="numeric" required="no" displayname="Cantidad">
	<cfargument name="SOgenero" type="string" required="no" displayname="Genero">
	<cfargument name="SOPrefijo" type="string" required="no" displayname="Prefijo">	
	<cfargument name="SOobservaciones" type="string" required="no" displayname="Observaciones">	
	
	<cfquery name="rsAlta" datasource="#session.dsn#">
		insert ISBsolicitudes 
			(AGid, SOfechasol, SOtipo, SOestado, SOfechapro, SOtiposobre, SOgenero, SOcantidad
				, SOPrefijo, SOobservaciones, SOenviada, BMusucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.saci.agente.id#">
			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.SOfechasol#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOtipo#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOestado#">
			, null
			<cfif isdefined('Arguments.SOtipo') and Arguments.SOtipo EQ 'P'>
				, null
				, null
			<cfelse>
				, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOtiposobre#" null="#Len(Arguments.SOtiposobre) Is 0#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOgenero#" null="#Len(Arguments.SOgenero) Is 0#">
			</cfif>
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SOcantidad#" null="#Len(Arguments.SOcantidad) Is 0#">
			<cfif isdefined('Arguments.SOtipo') and Arguments.SOtipo EQ 'S'>
				, null
			<cfelse>
				, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SOPrefijo#" null="#Len(Arguments.SOPrefijo) Is 0#">
			</cfif>
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SOobservaciones#" null="#Len(Arguments.SOobservaciones) Is 0#">
			, 0
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			
			<cf_dbidentity1 conexion="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 conexion="#Session.DSN#" name="rsAlta" verificar_transaccion="false">
			
	<cfif isdefined("rsAlta.identity") and len(trim(rsAlta.identity))>
		<cfreturn rsAlta.identity>
	<cfelse>
		<cfset retorna = -1>
		<cfreturn retorna>
	</cfif>
		
</cffunction>

</cfcomponent>

