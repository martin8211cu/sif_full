<cfsetting enablecfoutputonly="yes">
<cfheader name="Content-Disposition" value="Attachment; filename=#Application.spd2[url.token].ARCHIVO#.spd2">
<cfheader name="Expires" value="0">
<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
<cfcontent type="application/text">
<cfoutput>// SOIN Soluciones Integrales S.A.
// soinPrintDocs2
// Orden de Impresion
URL:#getHostName()##CGI.CONTEXT_PATH#/WS/spd2/soinPrintDocs2.cfc
TKN:#url.token#
VER:1.0
</cfoutput>

<cffunction name="getHostName" returnType="String" output="no">
	<cfif NOT isdefined("session.spd2_hostName")>
		<!--- Obtener el host --->
		<cfset LvarHostName = "">
		<cfif ucase(Right(CGI.SCRIPT_NAME,3)) neq 'CFC'>
			<cftry>
				<cfset httpRequestData = GetHTTPRequestData()>
				<cfcatch type="any">
					<!--- GetHTTPRequestData Da error si se invoca desde un web service --->
				</cfcatch>
			</cftry>
		</cfif>
		<cfif IsDefined('httpRequestData')>
			<cfset LvarRequest = httpRequestData.headers>
			
			<cfif StructKeyExists(LvarRequest,"X-Forwarded-Host")>
				<cfset LvarHostName = LvarRequest["X-Forwarded-Host"]>
			</cfif>
			<cfif Len(LvarHostName) EQ 0>
				<cfset LvarHostName = LvarRequest["Host"]>
			</cfif>
		<cfelse>
			<cfset LvarHostName = CGI.HTTP_HOST>
		</cfif>
		<cfif ListLen(LvarHostName) GT 1>
			<cfset LvarHostName = Trim(ListGetAt(LvarHostName, 1))>
		</cfif>

		<cfif findNoCase("HTTPS/", cgi.SERVER_PROTOCOL)>
			<cfset LvarHostName = "https://" & LvarHostName>
        <cfelse>
			<cfset LvarHostName = "http://" & LvarHostName>
		</cfif>

		<cfset session.spd2_hostName = LvarHostName>
	</cfif>

	<cfreturn session.spd2_hostName>
</cffunction>
