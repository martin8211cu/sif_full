<!--- 
	CREAR TABLAS PERMANENTES
	
	EJEMPLO 
	<cf_dbcreate name="TT_MAYORIZA" returnvariable="temp_table" datasource="#Attributes.datasource#">
		<cf_dbcreatecol name="Ecodigo" type="numeric">
		<cf_dbcreatecol name="Ecodigo" type="varchar(20)">
		<cf_dbcreatecol name="Ecodigo" type="numeric">
		<cf_dbcreatecol name="Ecodigo" type="numeric">
		
		<cf_dbcreatekey cols="Ecodigo,Cuenta">
	</cf_dbtemp>
---->
<cfif ThisTag.ExecutionMode is 'start'>
	<cfset Attributes.dbcreate = true>
	<cfset Attributes.temp = false>
	<cfinclude template="dbtemp.cfm">
</cfif>

<cfif ThisTag.ExecutionMode is 'end'>
	<cfif not isdefined("ThisTag.Columns") or ArrayLen(ThisTag.Columns) Is 0>
		<cf_errorCode	code = "50649" msg = "Debe incluir columnas al cf_dbtemp. Use al menos un cf_dbtempcol para definir las columnas de la tabla temporal.">
	</cfif>
	<cfif not isdefined("ThisTag.keys")>
		<cfset ThisTag.keys = ArrayNew(1)>
	</cfif>
	<cfif not isdefined("ThisTag.Indexes")>
		<cfset ThisTag.Indexes = ArrayNew(1)>
	</cfif>
	<cfset dbtype = Application.dsinfo[Attributes.datasource].type>
	<cfset dbCharType = Application.dsinfo[Attributes.datasource].CharType>
	<cfset fnProcesaTabla(dbtype,Attributes.temp,Attributes.jdbc,Attributes.name)>
	<cfset Caller[Attributes.returnvariable] = #Attributes.name#>
</cfif>
