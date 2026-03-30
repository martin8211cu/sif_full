<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="AnexoGOrigenDatos"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
				field1="GODid"
				type1="numeric"
				value1="#form.GODid#"
		>
	

	<cfquery datasource="#session.dsn#">
		update AnexoGOrigenDatos
		set GODdescripcion = <cfif isdefined("form.GODdescripcion") and Len(Trim(form.GODdescripcion))><cfqueryparam cfsqltype="cf_sql_char" value="#form.GODdescripcion#"><cfelse>null</cfif>
		
		where Ecodigo = #session.Ecodigo#
		  and GODid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GODid#" null="#Len(form.GODid) Is 0#">
	</cfquery>

	<cflocation url="AnexoGOrigenDatos.cfm?GODid=#URLEncodedFormat(form.GODid)#">

<cfelseif IsDefined("form.Baja")>

	<cfquery name="rsInsert" datasource="#session.dsn#">
		delete from AnexoGOrigenDatosDet
 		 where Ecodigo = #session.Ecodigo#
		   and GODid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GODid#" null="#Len(form.GODid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from AnexoGOrigenDatos
 		 where Ecodigo = #session.Ecodigo#
		   and GODid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GODid#" null="#Len(form.GODid) Is 0#">
	</cfquery>

	<cflocation url="AnexoGOrigenDatos.cfm">
<cfelseif IsDefined("form.Alta")>	

	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.dsn#">
			insert into AnexoGOrigenDatos (
				Ecodigo, GODdescripcion)
			values (
				#session.Ecodigo#,
				<cfif isdefined("form.GODdescripcion") and Len(Trim(form.GODdescripcion))><cfqueryparam cfsqltype="cf_sql_char" value="#form.GODdescripcion#"><cfelse>null</cfif>
				)
			<cf_dbidentity1 name="rsInsert" datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 name="rsInsert" datasource="#session.dsn#" returnvariable="LvarGODid">
	</cftransaction>
	<cflocation url="AnexoGOrigenDatos.cfm?GODid=#URLEncodedFormat(LvarGODid)#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="AnexoGOrigenDatos.cfm">
<cfelseif IsDefined("url.OPdet")>
	<cfheader name="Expires" value="0">
	<cfif url.OPdet EQ "A">
		<cfquery name="rsInsert" datasource="#session.dsn#">
			insert into AnexoGOrigenDatosDet (
				 Ecodigo,
				 GODid  ,
				 GEid   ,
				 GOid   ,
				 EcodigoCal,
				 Ocodigo
				)
			values (
				 #session.Ecodigo#
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GODid#">
				,<cfset LvarCampo="GEid">		<cfparam name="url.#LvarCampo#" default=""><cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate("url.#LvarCampo#")#" null="#evaluate("url.#LvarCampo#") EQ ""#">
				,<cfset LvarCampo="GOid">		<cfparam name="url.#LvarCampo#" default=""><cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate("url.#LvarCampo#")#" null="#evaluate("url.#LvarCampo#") EQ ""#">
				,<cfset LvarCampo="EcodigoCal">	<cfparam name="url.#LvarCampo#" default=""><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("url.#LvarCampo#")#" null="#evaluate("url.#LvarCampo#") EQ ""#">
				,<cfset LvarCampo="Ocodigo">	<cfparam name="url.#LvarCampo#" default=""><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("url.#LvarCampo#")#" null="#evaluate("url.#LvarCampo#") EQ ""#">
				)
		</cfquery>
	<cfelseif url.OPdet EQ "B">
		<cfquery name="rsInsert" datasource="#session.dsn#">
			delete from AnexoGOrigenDatosDet
			 where Ecodigo 	= #session.Ecodigo#
			   and GODid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GODid#">
			   and <cfset LvarCampo="GEid">		 <cfparam name="url.#LvarCampo#" default="">#LvarCampo# <cfif evaluate("url.#LvarCampo#") EQ "">IS NULL<cfelse>=<cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate("url.#LvarCampo#")#"></cfif>
			   and <cfset LvarCampo="GOid">		 <cfparam name="url.#LvarCampo#" default="">#LvarCampo# <cfif evaluate("url.#LvarCampo#") EQ "">IS NULL<cfelse>=<cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate("url.#LvarCampo#")#"></cfif>
			   and <cfset LvarCampo="EcodigoCal"><cfparam name="url.#LvarCampo#" default="">#LvarCampo# <cfif evaluate("url.#LvarCampo#") EQ "">IS NULL<cfelse>=<cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate("url.#LvarCampo#")#"></cfif>
			   and <cfset LvarCampo="Ocodigo">	 <cfparam name="url.#LvarCampo#" default="">#LvarCampo# <cfif evaluate("url.#LvarCampo#") EQ "">IS NULL<cfelse>=<cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluate("url.#LvarCampo#")#"></cfif>
		</cfquery>
	</cfif>
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="AnexoGOrigenDatos.cfm">
</cfif>



