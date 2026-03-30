<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBparametros">

<cfset This.encryptedList = '526'>
<cfset This.encryptionKey = '0gYpY0KZt84soVn2HLWssA=='>

<cffunction name="Get" output="false" returntype="string" access="remote">
  <cfargument name="Pcodigo" type="numeric" required="Yes"  displayname="Parámetro">

	<cfset result = "">
	<cfquery name="rs" datasource="#session.dsn#">
		select coalesce(rtrim(Pvalor), '') as Pvalor
		from ISBparametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
	</cfquery>
	
	<cfif rs.recordCount GT 0>
		<cfset result = rs.Pvalor>
	</cfif>
	<cfif Len(result) and ListFind(This.encryptedList, Arguments.Pcodigo)>
		<cfset result = Decrypt(result, This.encryptionKey, 'AES', 'Base64')>
	</cfif>
	<cfreturn result>
	
</cffunction>

<cffunction name="Alta_Cambio" output="false" returntype="void" access="remote">
  <cfargument name="Pcodigo" type="numeric" required="Yes"  displayname="Parámetro">
  <cfargument name="Pdescripcion" type="string" required="Yes"  displayname="Descripción">
  <cfargument name="Pvalor" type="string" required="No" default="" displayname="Valor">
  <cfargument name="ts_rversion" type="string" required="No" default="" displayname="ts_rversion">

	<cfif ListFind(This.encryptedList, Arguments.Pcodigo)>
		<cfif Arguments.Pvalor is '- secreto -'>
			<!--- password, no viene: salir --->
			<cfreturn>
		<cfelseif Len(Arguments.Pvalor)>
			<cfset Arguments.Pvalor = Encrypt(Arguments.Pvalor, This.encryptionKey, 'AES', 'Base64')>
		</cfif>
	</cfif>

	<cfquery name="chkExists" datasource="#session.dsn#">
		select count(1) as cantidad
		from ISBparametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
	</cfquery>

	<cfif chkExists.cantidad GT 0>
		<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="ISBparametros"
							redirect="metadata.code.cfm"
							timestamp="#Arguments.ts_rversion#"
							field1="Ecodigo"
							type1="integer"
							value1="#session.Ecodigo#"
							field2="Pcodigo"
							type2="integer"
							value2="#Arguments.Pcodigo#">
		</cfif>
		
		<cfquery datasource="#session.dsn#">
			update ISBparametros
			set Pdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pdescripcion#" null="#Len(Arguments.Pdescripcion) Is 0#">
			, Pvalor = <cfif isdefined("Arguments.Pvalor") and Len(Trim(Arguments.Pvalor))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pvalor#"><cfelse>null</cfif>
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#" null="#Len(Arguments.Pcodigo) Is 0#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.dsn#">
			insert into ISBparametros (
				Ecodigo,
				Pcodigo,
				Pdescripcion,
				Pvalor,
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#" null="#Len(Arguments.Pcodigo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pdescripcion#" null="#Len(Arguments.Pdescripcion) Is 0#">,
				<cfif isdefined("Arguments.Pvalor") and Len(Trim(Arguments.Pvalor))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pvalor#"><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
		</cfquery>
		
	</cfif>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Pcodigo" type="numeric" required="Yes"  displayname="Parámetro">

	<cfquery datasource="#session.dsn#">
		delete ISBparametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#" null="#Len(Arguments.Pcodigo) Is 0#">
	</cfquery>
	
</cffunction>

</cfcomponent>

