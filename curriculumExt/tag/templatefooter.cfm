<cfsilent>
<cfparam name="Attributes.template" type="string" default="">

<cfif ThisTag.ExecutionMode IS 'End' OR ThisTag.HasEndTag IS 'YES'>
	<cfthrow message="cf_templatefooter no debe tener tag de cierre">
</cfif>

<cfif Not IsDefined('Request.templatefooterdata')>
	<cfthrow message="cf_templateheader debe preceder a cf_templatefooter">
</cfif>
</cfsilent>
<cfoutput>#Request.templatefooterdata#</cfoutput>

<cfset session.porlets ="">
