<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBbitacoraMedio">
	<cffunction name="Alta" output="false" returntype="void" access="remote">
	  <cfargument name="MDref" type="string" required="Yes"  displayname="Referencia de medio">
	  <cfargument name="EMid" type="numeric" required="Yes"  displayname="Empresa medio">
	  <cfargument name="BTautomatica" type="boolean" required="No" default="false" displayname="Automática">  
	  <cfargument name="BTobs" type="string" required="Yes"  displayname="Observación">    
	  <cfargument name="BTfecha" type="string" required="No" default="#Now()#" displayname="Fecha de registro">
	  <cfargument name="BTusuario" type="string" required="No" default="#session.usuario#" displayname="Usuario que Inserta">
	  <cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">
	
		<cfquery datasource="#Arguments.conexion#">
			insert into ISBbitacoraMedio (
				MDref
				, EMid
				, BTautomatica			
				, BTobs			
				, BTfecha
				, BTusuario
				, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MDref#" null="#Len(Arguments.MDref) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#" null="#Len(Arguments.EMid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.BTautomatica#" null="#Len(Arguments.BTautomatica) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BTobs#" null="#Len(Arguments.BTobs) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BTfecha#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BTusuario#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		</cfquery>
	</cffunction>
</cfcomponent>

