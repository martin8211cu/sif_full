<cfset Lvar_Err_Sec = 0>
<cf_dbtemp name="IMP_ERRORES" returnvariable="Tabla_Error" datasource="#session.dsn#">
	<cf_dbtempcol name="LVL"		type="varchar(7)"	mandatory="yes">
	<cf_dbtempcol name="MSG"		type="varchar(255)"	mandatory="yes">
	<cf_dbtempcol name="SEC"		type="integer" 	   	mandatory="yes">
</cf_dbtemp >

<cffunction name="sbError" access="private">
	<cfargument name="LprmTipo"	type="string"  required="yes">
	<cfargument name="LprmMsg" 	type="string"  required="yes">
	
	<cfset LprmMsg = mid(LprmMsg,1,255)>
	
	<cfset Lvar_Err_Sec = Lvar_Err_Sec + 1>
	<cfif LprmTipo EQ "TOTAL">
		<cfset LvarSec = 0>
	<cfelse>
		<cfset LvarSec = Lvar_Err_Sec>
	</cfif>
	<cfquery datasource="#session.dsn#">
		insert into #Tabla_Error#
			(LVL, MSG, SEC)
			values (
						<cfqueryparam cfsqltype="cf_sql_char" value="#LprmTipo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#LprmMsg#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSec#">
					)
	</cfquery>
</cffunction>

<cffunction name="fnVerificaErrores" access="private" returntype="query">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select LVL, MSG 
		  from #Tabla_Error#
	</cfquery>

	<cfquery name="rsERR" dbtype="query">
		select count(1) as cantidad 
		  from rsSQL
		 where LVL = 'FATAL'
	</cfquery>
	
	<cfif rsERR.cantidad GT 0>
		<cfset sbError ("TOTAL", "SE GENERARON ERRORES FATALES POR LO QUE NO SE EJECUTO LA IMPORTACION")>
	<cfelseif rsSQL.recordCount GT 0>
		<cfset sbError ("TOTAL", "SE GENERARON MENSAJES INFORMATIVOS PERO SE EJECUTO LA IMPORTACION PARCIALMENTE")>
	</cfif>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select LVL, MSG, SEC from #Tabla_Error#
		ORDER BY SEC
	</cfquery>
		
	<cfif rsERR.cantidad GT 0>
		<cftransaction action="rollback"/>
	</cfif>	
	<cfreturn rsSQL>
</cffunction>

<cffunction name="sbExecute" access="private">
	<cfargument name="LprmSQL" type="string" required="yes">
	<cfargument name="LprmSTOP" type="boolean" required="no" default="no">
	
<cftry>
	<cfquery datasource="#session.dsn#">
		#preserveSingleQuotes(LprmSQL)#
		<cfif LprmSTOP><cfabort></cfif>
	</cfquery>
<cfcatch>
	<cfoutput>
		ERROR:<BR><BR>#cfcatch.Message#<BR><BR><BR>
		#LprmSQL#<BR><BR>
		<cfdump var="#cfcatch#">
	</cfoutput>
	<cfabort>
</cfcatch>
</cftry>
</cffunction>

<cffunction name="fnQuery" returntype="query" access="private">
	<cfargument name="LprmSQL" type="string" required="yes">
	<cfargument name="LprmSTOP" type="boolean" required="no" default="no">
	
	<cfquery name="rsQuery" datasource="#session.dsn#">
		#preserveSingleQuotes(LprmSQL)#
		<cfif LprmSTOP><cfabort></cfif>
	</cfquery>
	<cfreturn rsQuery>
</cffunction>

