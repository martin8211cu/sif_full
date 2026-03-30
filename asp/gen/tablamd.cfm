<cfsetting enablecfoutputonly="yes">
<cfinclude template="env.cfm">

<cfinvoke component="metadata" method="tabla_struct" pdm="#session.pdm.file#" tabla="#url.code#" returnvariable="ret">
<cfdump var="#ret#">

