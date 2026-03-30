
<cfif isdefined("form.action") and form.action EQ "delete">
	<cftry>
	    <cfquery datasource="#session.dsn#" name="rsTimbre">
	        select timbre from CERepositorio
	        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and IdRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idrep#">
	    </cfquery>
		<cfquery name="existeCFDIrep" datasource="#Session.Dsn#">
	        delete from CERepositorio
	        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        and IdRep = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idrep#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
	        delete CERepositorio
	        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        	and timbre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTimbre.timbre#">
		</cfquery>
		<cfoutput>TRUE</cfoutput>
	    <cfcatch>
	    	<cfthrow errorCode = "-1" message = "No hay repositorio disponible">
	    </cfcatch>
	</cftry>
</cfif>



