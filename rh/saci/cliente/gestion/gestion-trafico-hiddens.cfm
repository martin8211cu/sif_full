<cfoutput>
	<input type="hidden" name="traf" value="<cfif isdefined("form.traf") and Len(Trim(form.traf))>#form.traf#</cfif>"/>				<!--- consulta de tráfico--->
</cfoutput>