<cfif isdefined('url.WidID') and len(trim(url.WidID)) GT 0>
	<cfset varWidID = #url.WidID#>
</cfif>

<cfset varCarpeta = ''>

<!---Valida si es copia u original--->
<cfquery name="rsValidaOriginal" datasource = "asp">
	SELECT ltrim(rtrim(WidParentId)) as WidParentId, WidCodigo
	FROM Widget
	WHERE WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">
</cfquery>

<cfif isdefined('rsValidaOriginal') and rsValidaOriginal.WidParentId EQ ''>
	<cfset varCarpeta = #rsValidaOriginal.WidCodigo#>
<cfelse>
	<cfset varWidParentId = #rsValidaOriginal.WidParentId#>

	<cfquery name="rsValidaOriginal" datasource = "asp">
		SELECT ltrim(rtrim(WidParentId)) as WidParentId, WidCodigo
		FROM Widget
		WHERE WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidParentId#">
	</cfquery>

	<cfset varCarpeta = #rsValidaOriginal.WidCodigo#>
</cfif>

<cfinclude template="../../../commons/widgets/#varCarpeta#/config.cfm">