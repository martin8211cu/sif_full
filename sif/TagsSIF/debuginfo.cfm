<cfparam name="Session.DebugInfo" default="false">
<cfparam name="Attributes.var" type="any" default="">
<cfparam name="Attributes.table" type="string" default="">
<cfparam name="Attributes.label" type="string" default="">
<cfif Session.DebugInfo>
	<cfif len(trim(Attributes.var)) GT 0>
		<cf_dump var="#Attributes.var#" label="#Attributes.label#">
	<cfelseif len(trim(Attributes.table)) GT 0>
		<cf_dumptable var="#Attributes.table#" abort="false" label="#Attributes.label#">
	</cfif>
</cfif>
