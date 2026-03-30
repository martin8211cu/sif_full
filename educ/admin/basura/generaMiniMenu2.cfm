<cffunction name="fnUriBis" output="false" returntype="string">
	<cfargument name="pUri" type="string">
	<cfif mid(pUri, 1, 6) NEQ "/cfmx/">
		<cfif mid(pUri, 1, 1) EQ "/">
			<cfreturn "/cfmx" & pUri>
		<cfelse>
			<cfreturn "/cfmx/" & pUri>
		</cfif>
	</cfif>
</cffunction>
<cfquery name="rsProceso" datasource="#Session.DSN#">
	select 	p.SScodigo, p.SMcodigo, p.SPcodigo,
			p.SPhomeuri
	from asp..vUsuarioProcesos up, SProcesos p
	where up.Usucodigo = #Session.Usucodigo#
	  and up.Ecodigo = #Session.Ecodigosdc#
	  and up.SScodigo = p.SScodigo
	  and up.SMcodigo = p.SMcodigo
	  and up.SPcodigo = p.SPcodigo
	  and p.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	  and p.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
	  and p.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">
</cfquery>
<cfset session.menues.Sistema = rsProceso.SScodigo>
<cfset session.menues.Modulo  = rsProceso.SMcodigo>
<cflocation url="#fnUriBis(rsProceso.SPhomeuri)#">
