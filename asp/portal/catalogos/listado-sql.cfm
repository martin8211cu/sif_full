<cfparam name="url.SScodigo" default=" ">
<cfparam name="url.SMcodigo" default=" ">
<cfparam name="url.mostrar"  default="comp">

<cfif url.mostrar is "comp">
	<cfset JASPER_FILE="asp_listado.cfr">
<cfelseif url.mostrar is "menu">
	<cfset JASPER_FILE="asp_menu.cfr">
<cfelse>
	<cfset JASPER_FILE="asp_roles.cfr">
</cfif>

<cfreport template="#JASPER_FILE#" format="flashpaper">
<cfreportparam name="SScodigo" value="#url.SScodigo#">
<cfreportparam name="SMcodigo" value="#url.SMcodigo#">
</cfreport>

