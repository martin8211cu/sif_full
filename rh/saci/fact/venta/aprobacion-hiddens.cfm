<cfoutput>
	<input type="hidden" name="pq" value="<cfif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#<cfelseif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#</cfif>"/>
	<input type="hidden" name="paso" value="<cfif isdefined("form.paso") and Len(Trim(form.paso))>#form.paso#</cfif>" />
	<input type="hidden" name="cue" value="<cfif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#<cfelseif isdefined("form.CTid") and Len(Trim(form.CTid))>#form.CTid#</cfif>" />
	<input type="hidden" name="contra" value="<cfif isdefined("form.contra") and Len(Trim(form.contra))>#form.contra#<cfelseif isdefined("form.Contratoid") and Len(Trim(form.Contratoid))>#form.Contratoid#</cfif>" />
	<input type="hidden" name="ag" value="<cfif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#<cfelseif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#</cfif>" />
	<input type="hidden" name="fact" value="<cfif isdefined("form.fact") and Len(Trim(form.fact))>#form.fact#<cfelseif isdefined("form.CTidFactura") and Len(Trim(form.CTidFactura))>#form.CTidFactura#</cfif>" />
	<input type="hidden" name="paq" value="<cfif isdefined("form.paq") and Len(Trim(form.paq))>#form.paq#<cfelseif isdefined("form.PQcodigo") and Len(Trim(form.PQcodigo))>#form.PQcodigo#</cfif>" />
</cfoutput>