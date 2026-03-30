<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBpaqueteCambio">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="PQcodDesde" type="string" required="Yes"  displayname="Paqdesde">
  <cfargument name="PQcodHacia" type="string" required="Yes"  displayname="Paqhacia">
  <cfargument name="BMusucodigo" type="numeric" required="Yes"  displayname="BMusucodigo">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBpaqueteCambio"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="PQcodDesde"
				type1="char"
				value1="#Arguments.PQcodDesde#"
				field2="PQcodHacia"
				type2="char"
				value2="#Arguments.PQcodHacia#">
	<cfquery datasource="#session.dsn#">
		update ISBpaqueteCambio
		set BMusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where PQcodDesde = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodDesde#" null="#Len(Arguments.PQcodDesde) Is 0#">
		  and PQcodHacia = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodHacia#" null="#Len(Arguments.PQcodHacia) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="PQcodDesde" type="string" required="Yes"  displayname="Paqdesde">
  <cfargument name="PQcodHacia" type="string" required="Yes"  displayname="Paqhacia">

	<cfquery datasource="#session.dsn#">
		delete ISBpaqueteCambio
		where PQcodDesde = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodDesde#" null="#Len(Arguments.PQcodDesde) Is 0#">  and PQcodHacia = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodHacia#" null="#Len(Arguments.PQcodHacia) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="PQcodDesde" type="string" required="Yes"  displayname="Paqdesde">
  <cfargument name="PQcodHacia" type="string" required="Yes"  displayname="Paqhacia">
  
	<cfquery datasource="#session.dsn#">
		insert into ISBpaqueteCambio (
			
			PQcodDesde,
			PQcodHacia,
			BMusucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodDesde#" null="#Len(Arguments.PQcodDesde) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodHacia#" null="#Len(Arguments.PQcodHacia) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

