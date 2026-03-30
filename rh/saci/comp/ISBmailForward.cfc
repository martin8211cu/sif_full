<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBmailForward">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="LGmailForward" type="string" required="Yes"  displayname="LGmailForward">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBmailForward"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="LGnumero"
						type1="numeric"
						value1="#Arguments.LGnumero#"
						field2="LGmailForward"
						type2="char"
						value2="#Arguments.LGmailForward#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBmailForward
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		  and LGmailForward = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGmailForward#" null="#Len(Arguments.LGmailForward) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="LGmailForward" type="string" required="Yes"  displayname="LGmailForward">

	<cfquery datasource="#session.dsn#">
		delete ISBmailForward
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		and LGmailForward = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGmailForward#" null="#Len(Arguments.LGmailForward) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="LGmailForward" type="string" required="Yes"  displayname="LGmailForward">

	<cfquery datasource="#session.dsn#">
		insert into ISBmailForward (
			LGnumero,
			LGmailForward,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGmailForward#" null="#Len(Arguments.LGmailForward) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
	</cfquery>

</cffunction>

</cfcomponent>
