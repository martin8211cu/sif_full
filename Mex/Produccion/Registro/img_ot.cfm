<cfquery datasource="#session.dsn#" name="rs">
	select e.AAcontenido
	from Prod_OTArchivo e
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.o#">
	  and AAconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.t#">
</cfquery>

<cfif isdefined('url.sd')>
	<cfquery datasource="#session.dsn#">
	update Prod_OTArchivo
    set AAdefaultpre =
    	case when AAconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.t#">
        	then 1
            else 0
        end
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.o#">
    </cfquery>
</cfif>

<!--- </cfif> --->
<cfif Len(rs.AAcontenido) LE 1>
	<cflocation url="not_avail.gif" addtoken="no">
<cfelse>
	<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
	<cffile action="write" file="#tempfile#" output="#rs.AAcontenido#" >
	<!--- nunca expira, invocar con ts_rversion como parte del url --->
	<cfset getPageContext().getResponse().setHeader("Expires","Thu, 31 Dec 2099 00:00:00 GMT")>
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
	<cfinclude template="../../../OnRequestEnd.cfm">
	<cfcontent type="image/gif" file="#tempfile#" deletefile="yes">
</cfif>
