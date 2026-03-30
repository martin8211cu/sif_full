<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBtarjeta">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="MTid" type="numeric" required="Yes"  displayname="Marca">
  <cfargument name="MTnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="MTmascara" type="string" required="Yes"  displayname="Mascara">  
  <cfargument name="MTlogo" type="binary" required="No" default="" displayname="Logo">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBtarjeta"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="MTid"
				type1="numeric"
				value1="#Arguments.MTid#">
				
	<cfquery datasource="#session.dsn#">
		update ISBtarjeta
		set MTnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MTnombre#" null="#Len(Arguments.MTnombre) Is 0#">
		<cfif Len(Arguments.MTlogo)>
		, MTlogo = <cfqueryparam cfsqltype="cf_sql_blob" value="#Arguments.MTlogo#" null="#Len(Arguments.MTlogo) Is 0#">
		</cfif>
		, MTmascara = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MTmascara#" null="#Len(Arguments.MTmascara) Is 0#">
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where MTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MTid#" null="#Len(Arguments.MTid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="MTid" type="numeric" required="Yes"  displayname="Marca">

	<cfquery datasource="#session.dsn#">
		delete ISBtarjeta
		where MTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MTid#" null="#Len(Arguments.MTid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="MTnombre" type="string" required="Yes"  displayname="Nombre">
  <cfargument name="MTmascara" type="string" required="Yes"  displayname="Mascara"> 
  <cfargument name="MTlogo" type="binary" required="No" default="" displayname="Logo">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">

	<cfquery datasource="#session.dsn#">
		insert into ISBtarjeta (
			MTnombre,
			MTlogo,
			Habilitado,
			MTmascara,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MTnombre#" null="#Len(Arguments.MTnombre) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_blob" value="#Arguments.MTlogo#" null="#Len(Arguments.MTlogo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MTmascara#" null="#Len(Arguments.MTmascara) Is 0#">,			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

