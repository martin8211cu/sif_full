<cfif session.EcodigoSDC is 0>
	<cflocation url="index.cfm">
<cfelseif isdefined("url.n")>
	<cfquery name="rsPagina" datasource="asp">
		select 	up.SScodigo, up.SMcodigo, up.SPcodigo, mn.SMNcodigo,
				p.SPhomeuri as homeuri
		from vUsuarioProcesos up, SMenues mn, SProcesos p
		where mn.SMNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.n#">
		  and up.Usucodigo = #Session.Usucodigo#
		  and up.Ecodigo = #Session.Ecodigosdc#
		  and up.SScodigo = mn.SScodigo
		  and up.SMcodigo = mn.SMcodigo
		  and up.SPcodigo = mn.SPcodigo
		  and p.SScodigo = mn.SScodigo
		  and p.SMcodigo = mn.SMcodigo
		  and p.SPcodigo = mn.SPcodigo
	</cfquery>
	<cfif rsPagina.homeuri EQ "">
		<cfset session.menues.SPcodigo = "">
		<cfset session.menues.SMNcodigo = "-1">
		<cflocation url="modulo.cfm">
	</cfif>
	<cfset session.menues.SMNcodigo = url.n>
<cfelseif not isdefined("url.s")>
	<cflocation url="empresa.cfm">
<cfelseif not isdefined("url.m")>
	<cfquery name="rsPagina" datasource="asp">
		select 	DISTINCT
				up.SScodigo, '' as SMcodigo, '' as SPcodigo, -1 as SMNcodigo,
				s.SShomeuri as homeuri
		from vUsuarioProcesos up, SSistemas s
		where up.Usucodigo = #Session.Usucodigo#
		  and up.Ecodigo = #Session.Ecodigosdc#
		  and up.SScodigo = s.SScodigo
		  and s.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
	</cfquery>
	<cfif rsPagina.homeuri EQ "">
		<cflocation url="empresa.cfm">
	</cfif>
<cfelseif not isdefined("url.p")>
	<cfquery name="rsPagina" datasource="asp">
		select 	DISTINCT
				rtrim(ltrim(up.SScodigo)) as SScodigo,
				rtrim(ltrim(up.SMcodigo)) as SMcodigo,
				'' as SPcodigo, -1 as SMNcodigo,
				m.SMhomeuri as homeuri
		from vUsuarioProcesos up, SModulos m
		where up.Usucodigo = #Session.Usucodigo#
		  and up.Ecodigo = #Session.Ecodigosdc#
		  and up.SScodigo = m.SScodigo
		  and up.SMcodigo = m.SMcodigo
		  and m.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
		  and m.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
	</cfquery>
	<cfif rsPagina.homeuri EQ "">
		<cfset session.menues.Mcodigo = "">
		<cflocation url="sistema.cfm?s=#URLEncodedFormat(url.s)#">
	</cfif>
<cfelse>
	<cfquery name="rsPagina" datasource="asp">
		select 	rtrim(ltrim(up.SScodigo)) as SScodigo,
				rtrim(ltrim(up.SMcodigo)) as SMcodigo,
				rtrim(ltrim(up.SPcodigo)) as SPcodigo,
				-1 as SMNcodigo,
				p.SPhomeuri as homeuri
		from vUsuarioProcesos up, SProcesos p
		where up.Usucodigo = #Session.Usucodigo#
		  and up.Ecodigo = #Session.Ecodigosdc#
		  and rtrim(ltrim(up.SScodigo)) = rtrim(ltrim(p.SScodigo))
		  and rtrim(ltrim(up.SMcodigo)) = rtrim(ltrim(p.SMcodigo))
		  and rtrim(ltrim(up.SPcodigo)) = rtrim(ltrim(p.SPcodigo))
		  and rtrim(ltrim(p.SScodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
		  and rtrim(ltrim(p.SMcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.m#">
		  and rtrim(ltrim(p.SPcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.p#">
	</cfquery>
	<cfif rsPagina.homeuri EQ "">
		<cflocation url="modulo.cfm">
	</cfif>
</cfif>

<cfset session.menues.SScodigo = trim(rsPagina.SScodigo)>
<cfset session.menues.SMcodigo  = trim(rsPagina.SMcodigo)>
<cfset session.menues.SPcodigo  = trim(rsPagina.SPcodigo)>
<cfset session.menues.SMNcodigo  = trim(rsPagina.SMNcodigo)>
<cflocation url="#fnUriBis1(rsPagina.homeuri)#?_" addtoken="no">
<cfinclude template="#fnUriBis2(rsPagina.homeuri)#?_">
<cfexit>

<cffunction name="fnUriBis1" output="false" returntype="string">
	<cfargument name="pUri" type="string">
	<cfif mid(pUri, 1, 6) NEQ "/cfmx/">
		<cfif mid(pUri, 1, 1) EQ "/">
			<cfreturn "/cfmx" & pUri>
		<cfelse>
			<cfreturn "/cfmx/" & pUri>
		</cfif>
	<cfelse>
		<cfreturn pUri>
	</cfif>
</cffunction>

<cffunction name="fnUriBis2" output="false" returntype="string">
	<cfargument name="pUri" type="string">
	<cfif mid(pUri, 1, 6) NEQ "/cfmx/">
		<cfif mid(pUri, 1, 1) EQ "/">
			<cfreturn pUri>
		<cfelse>
			<cfreturn "/" & pUri>
		</cfif>
	<cfelse>
		<cfreturn mid(pUri, 6, 1000)>
	</cfif>
</cffunction>
