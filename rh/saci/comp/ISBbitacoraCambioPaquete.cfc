<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBbitacoraCambioPaquete">


<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" default="" required="No"  displayname="Código de Login en el Cambio de Paquete">
  <cfargument name="Contratoid" type="numeric" default="" required="No" displayname="Código de Contrato">
  <cfargument name="Paqdestino" type="numeric" required="Yes"  displayname="Código Paquete Destino">
  
  <cfargument name="PQfileconfigura" type="string" default="N">
	
	<cfquery  name="rsAlta" datasource="#session.dsn#">
		insert into ISBbitacoraCambioPaquete (
			
			LGnumero,
			Contratoid,
			BCfecha,
			BCpaqdestino,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Paqdestino#" null="#Len(Arguments.Paqdestino) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
	
</cffunction>



</cfcomponent>

