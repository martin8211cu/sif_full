<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBbitacoraLogin">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="BLid" type="numeric" required="Yes"  displayname="Anotación">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="LGlogin" type="string" required="Yes"  displayname="Login">
  <cfargument name="BLautomatica" type="boolean" required="Yes"  displayname="Automática">
  <cfargument name="BLobs" type="string" required="Yes"  displayname="Observación">
  <cfargument name="BLfecha" type="string" required="No"  displayname="Fecha de registro">
  <cfargument name="BLusuario" type="string" required="No" default="#session.usuario#" displayname="Usuario que modifica">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">
  <cfargument name="BLpasswordHash" type="string" required="No" displayname="Password actual">
  
	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
					table="ISBbitacoraLogin"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="BLid"
					type1="numeric"
					value1="#Arguments.BLid#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBbitacoraLogin
		set LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		, LGlogin = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGlogin#" null="#Len(Arguments.LGlogin) Is 0#">
		, BLautomatica = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.BLautomatica#" null="#Len(Arguments.BLautomatica) Is 0#">
		
		, BLobs = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.BLobs#" null="#Len(Arguments.BLobs) Is 0#">
		, BLfecha = <cfif isdefined("Arguments.BLfecha") and Len(Trim(Arguments.BLfecha))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BLfecha#"><cfelse>null</cfif>
		, BLusuario = <cfif isdefined("Arguments.BLusuario") and Len(Trim(Arguments.BLusuario))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.BLusuario#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		, BLpasswordHash = <cfif isdefined("Arguments.BLpasswordHash") and Len(Trim(Arguments.BLpasswordHash))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Hash(Arguments.LGnumero&'-'&Arguments.BLpasswordHash)#"><cfelse>null</cfif>
		where BLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BLid#" null="#Len(Arguments.BLid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="BLid" type="numeric" required="Yes"  displayname="Anotación">

	<cfquery datasource="#session.dsn#">
		delete ISBbitacoraLogin
		where BLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BLid#" null="#Len(Arguments.BLid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Desasignar" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes">

	<cfquery datasource="#session.dsn#">
	delete ISBbitacoraLogin
			where exists (
		select 1
			from ISBcuenta z
				inner join ISBproducto x
					on x.CTid = z.CTid
					and x.CTcondicion = 'C'
				inner join ISBlogin y
					on y.Contratoid = x.Contratoid
					and y.LGnumero = ISBbitacoraLogin.LGnumero
			where z.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
					)
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="LGlogin" type="string" required="Yes"  displayname="Login">
  <cfargument name="BLautomatica" type="boolean" required="Yes"  displayname="Automática">
  <cfargument name="BLobs" type="string" required="Yes"  displayname="Observación">
  <cfargument name="BLfecha" type="string" required="No"  displayname="Fecha de registro">
  <cfargument name="BLusuario" type="string" required="No" default="#session.usuario#" displayname="Usuario que modifica">
  <cfargument name="BLpasswordHash" type="string" required="No" displayname="Password actual">

	<cfquery datasource="#session.dsn#">
		insert into ISBbitacoraLogin (
			LGnumero,
			LGlogin,
			BLautomatica,
			
			BLobs,
			BLfecha,
			BLusuario,
			BMUsucodigo,
			BLpasswordHash)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.LGlogin#" null="#Len(Arguments.LGlogin) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.BLautomatica#" null="#Len(Arguments.BLautomatica) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.BLobs#" null="#Len(Arguments.BLobs) Is 0#">,
			<cfif isdefined("Arguments.BLfecha") and Len(Trim(Arguments.BLfecha))>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BLfecha#">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			</cfif>,
			<cfif isdefined("Arguments.BLusuario") and Len(Trim(Arguments.BLusuario))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.BLusuario#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfif isdefined("Arguments.BLpasswordHash") and Len(Trim(Arguments.BLpasswordHash))><cfqueryparam cfsqltype="cf_sql_varchar" value="#Hash(Arguments.LGnumero &'-'& Arguments.BLpasswordHash)#"><cfelse>null</cfif>
			)
	</cfquery>
</cffunction>

</cfcomponent>

