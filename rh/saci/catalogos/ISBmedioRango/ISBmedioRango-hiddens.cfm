<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_access_server" value="<cfif isdefined("form.filtro_access_server") and Len(Trim(form.filtro_access_server))>#form.filtro_access_server#</cfif>" />	
	<input type="hidden" name="filtro_MRdesde" value="<cfif isdefined("form.filtro_MRdesde") and Len(Trim(form.filtro_MRdesde))>#form.filtro_MRdesde#</cfif>" />		
	<input type="hidden" name="filtro_MRhasta" value="<cfif isdefined("form.filtro_MRhasta") and Len(Trim(form.filtro_MRhasta))>#form.filtro_MRhasta#</cfif>" />			
</cfoutput>