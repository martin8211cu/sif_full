<cfparam name="form.tab" default="">
<cfif form.tab is 'config'>
	<cfinclude template="config-apply.cfm">
</cfif>
<cflocation url="index.cfm?tab=#URLEncodedFormat(form.tab)#">