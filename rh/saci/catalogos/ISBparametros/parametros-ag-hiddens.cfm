<cfoutput>
	<input type="hidden" name="tab" value="<cfif isdefined("form.tab") and Len(Trim(form.tab))>#form.tab#</cfif>" />
	<input type="hidden" name="agente" value="1" />
</cfoutput>