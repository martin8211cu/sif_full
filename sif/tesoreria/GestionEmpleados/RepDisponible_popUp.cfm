

<cfif isdefined ('url.transac') and url.transac eq 'A'>
	<cflocation url="ReimpresionAnt_form.cfm?id=#url.id#">
<cfelse>
	<cflocation url="ReimpresionLiq_form.cfm?id=#url.id#">
</cfif>
