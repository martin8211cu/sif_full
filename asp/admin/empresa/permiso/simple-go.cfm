<cfparam name="form.action" default="">
<cfparam name="url.action" default="#form.action#">
<cfif ListFind('pset,uadd,udel,loginok', url.action)>
	<cfinclude template="simple-go-#url.action#.cfm">
<cfelse>
	<cfthrow message="<em>action</em> inválido">
</cfif>