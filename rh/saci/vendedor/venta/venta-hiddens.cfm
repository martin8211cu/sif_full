<cfoutput>
	<input type="hidden" name="tab" value="<cfif isdefined("form.tab") and Len(Trim(form.tab))>#form.tab#</cfif>" />
	<input type="hidden" name="paso" value="<cfif isdefined("form.paso") and Len(Trim(form.paso))>#form.paso#</cfif>" />
	<input type="hidden" name="pq" value="<cfif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#</cfif>" />
	<input type="hidden" name="cue" value="<cfif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#</cfif>" />
</cfoutput>
