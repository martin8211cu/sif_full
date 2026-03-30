<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBcambioLogin">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="LGloginAnterior" type="string" required="Yes"  displayname="Login Anterior">
  <cfargument name="LGfechaCambio" type="date" required="Yes"  displayname="Fecha del cambio">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBcambioLogin"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="LGnumero"
				type1="numeric"
				value1="#Arguments.LGnumero#"
				field2="LGloginAnterior"
				type2="char"
				value2="#Arguments.LGloginAnterior#">
	<cfquery datasource="#session.dsn#">
		update ISBcambioLogin
		set LGfechaCambio = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.LGfechaCambio#" null="#Len(Arguments.LGfechaCambio) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		  and LGloginAnterior = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGloginAnterior#" null="#Len(Arguments.LGloginAnterior) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="LGloginAnterior" type="string" required="Yes"  displayname="Login Anterior">

	<cfquery datasource="#session.dsn#">
		delete ISBcambioLogin
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">  and LGloginAnterior = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGloginAnterior#" null="#Len(Arguments.LGloginAnterior) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="LGloginAnterior" type="string" required="Yes"  displayname="Login Anterior">
  <cfargument name="LGfechaCambio" type="date" required="Yes"  displayname="Fecha del cambio">
	
	<cfquery datasource="#session.dsn#">
		insert into ISBcambioLogin (
			
			LGnumero,
			LGloginAnterior,
			LGfechaCambio,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGloginAnterior#" null="#Len(Arguments.LGloginAnterior) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.LGfechaCambio#" null="#Len(Arguments.LGfechaCambio) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

