<cfsetting enablecfoutputonly="yes">
<cfparam name="url.tipoimg" default="gif">
<cfparam name="url.codigo" default="temp">

<cfdump var="#url#">
<cfif url.tipoimg is 'jpg'>
	<cfset content_type = "image/jpeg">
<cfelse>
	<cfset content_type = "image/" & url.tipoimg>
</cfif>
<cfif REFindNoCase('^[A-Z0-9-_.]+(.[A-Z0-9]{1,3})?$', url.codigo, 1, false) neq 0>
<cfcontent 
   type = "#content_type#" 
   file = "#gettempdirectory()##url.codigo#.#url.tipoimg#" 
   deleteFile = "yes">
<cfelse>
	<!--- apelar a cache del browser --->
	<cfheader statuscode="304" statustext="Not modified">
</cfif>
