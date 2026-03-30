<cfparam name="Attributes.var" type="any" default=""> 
<cfparam name="Attributes.name" type="string" default="">
<cfif Attributes.name NEQ "">
	<cfset LvarVar = caller[Attributes.name]>
	<cfdump var="#LvarVar#">
<cfelse>
	<cfdump var="#Attributes.var#">
</cfif>
<cfabort>