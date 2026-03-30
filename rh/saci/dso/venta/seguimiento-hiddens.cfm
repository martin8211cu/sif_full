<cfoutput>
	<input type="hidden" name="pq" value="<cfif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#<cfelseif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#</cfif>"/>
	<input type="hidden" name="paso" value="<cfif isdefined("form.paso") and Len(Trim(form.paso))>#form.paso#</cfif>" />
	<input type="hidden" name="cue" value="<cfif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#<cfelseif isdefined("form.CTid") and Len(Trim(form.CTid))>#form.CTid#</cfif>" />
	<input type="hidden" name="ag" value="<cfif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#<cfelseif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#</cfif>" />
	
	<input type="hidden" name="filtro_CUECUE" value="<cfif isdefined("form.filtro_CUECUE") and Len(Trim(form.filtro_CUECUE))>#form.filtro_CUECUE#</cfif>" />	
	<input type="hidden" name="hfiltro_CUECUE" value="<cfif isdefined("form.filtro_CUECUE") and Len(Trim(form.filtro_CUECUE))>#form.filtro_CUECUE#</cfif>" />		
	<input type="hidden" name="filtro_DUENO" value="<cfif isdefined("form.filtro_DUENO") and Len(Trim(form.filtro_DUENO))>#form.filtro_DUENO#</cfif>" />
	<input type="hidden" name="hfiltro_DUENO" value="<cfif isdefined("form.filtro_DUENO") and Len(Trim(form.filtro_DUENO))>#form.filtro_DUENO#</cfif>" />	
	<input type="hidden" name="filtro_VENDEDOR" value="<cfif isdefined("form.filtro_VENDEDOR") and Len(Trim(form.filtro_VENDEDOR))>#form.filtro_VENDEDOR#</cfif>" />		
	<input type="hidden" name="hfiltro_VENDEDOR" value="<cfif isdefined("form.filtro_VENDEDOR") and Len(Trim(form.filtro_VENDEDOR))>#form.filtro_VENDEDOR#</cfif>" />			
	<input type="hidden" name="filtro_CTCONDICION" value="<cfif isdefined("form.filtro_CTCONDICION") and Len(Trim(form.filtro_CTCONDICION))>#form.filtro_CTCONDICION#</cfif>" />		
	<input type="hidden" name="hfiltro_CTCONDICION" value="<cfif isdefined("form.filtro_CTCONDICION") and Len(Trim(form.filtro_CTCONDICION))>#form.filtro_CTCONDICION#</cfif>" />			
</cfoutput>
