<cfoutput>
	<input type="hidden" name="cue" value="<cfif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#</cfif>" />
	<input type="hidden" name="pkg" value="<cfif isdefined("form.pkg") and Len(Trim(form.cue))>#form.pkg#</cfif>" />
	<input type="hidden" name="pqc" value="<cfif isdefined("form.pqc") and Len(Trim(form.pqc))>#form.pqc#</cfif>" />
	<input type="hidden" name="traf" value="<cfif isdefined("form.traf") and Len(Trim(form.traf))>#form.traf#</cfif>"/>
	<input type="hidden" name="logg" value="<cfif isdefined("form.logg") and Len(Trim(form.logg))>#form.logg#</cfif>"/>
	<input type="hidden" name="rol" value="<cfif isdefined("form.rol") and Len(Trim(form.rol))>#form.rol#</cfif>"/>
	<input type="hidden" name="cli" value="<cfif isdefined("form.cli") and Len(Trim(form.cli))>#form.cli#</cfif>"/>
	<input type="hidden" name="paso" value="<cfif isdefined("form.paso") and Len(Trim(form.paso))>#form.paso#</cfif>" />
	<input type="hidden" name="cpass" value="<cfif isdefined("form.cpass") and Len(Trim(form.cpass))>#form.cpass#</cfif>"/>
</cfoutput>
