<cfoutput>
	<input type="hidden" name="pq" value="<cfif isdefined("form.pq") and Len(Trim(form.pq))>#form.pq#<cfelseif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#</cfif>"/>
	<input type="hidden" name="paso" value="<cfif isdefined("form.paso") and Len(Trim(form.paso))>#form.paso#</cfif>" />
	<input type="hidden" name="cue" value="<cfif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#<cfelseif isdefined("form.CTid") and Len(Trim(form.CTid))>#form.CTid#</cfif>" />
	<input type="hidden" name="ag" value="<cfif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#<cfelseif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#</cfif>" />
	
	<input type="hidden" name="filtro_CUECUE" value="<cfif isdefined("form.filtro_CUECUE") and Len(Trim(form.filtro_CUECUE))>#form.filtro_CUECUE#</cfif>"/>	
	<input type="hidden" name="hfiltro_CUECUE" value="<cfif isdefined("form.filtro_CUECUE") and Len(Trim(form.filtro_CUECUE))>#form.filtro_CUECUE#</cfif>"/>		
	<input type="hidden" name="filtro_dueno" value="<cfif isdefined("form.filtro_dueno") and Len(Trim(form.filtro_dueno))>#form.filtro_dueno#</cfif>"/>	
	<input type="hidden" name="hfiltro_dueno" value="<cfif isdefined("form.filtro_dueno") and Len(Trim(form.filtro_dueno))>#form.filtro_dueno#</cfif>"/>		
	<input type="hidden" name="filtro_CTcondicion" value="<cfif isdefined("form.filtro_CTcondicion") and Len(Trim(form.filtro_CTcondicion))>#form.filtro_CTcondicion#</cfif>"/>	
	<input type="hidden" name="hfiltro_CTcondicion" value="<cfif isdefined("form.filtro_CTcondicion") and Len(Trim(form.filtro_CTcondicion))>#form.filtro_CTcondicion#</cfif>"/>		
	<input type="hidden" name="filtro_PQnombre" value="<cfif isdefined("form.filtro_PQnombre") and Len(Trim(form.filtro_PQnombre))>#form.filtro_PQnombre#</cfif>"/>	
	<input type="hidden" name="hfiltro_PQnombre" value="<cfif isdefined("form.filtro_PQnombre") and Len(Trim(form.filtro_PQnombre))>#form.filtro_PQnombre#</cfif>"/>		
	
	<input type="hidden" name="pagina" value="<cfif isdefined("form.pagina") and Len(Trim(form.pagina))>#form.pagina#</cfif>"/>		
	
</cfoutput>
