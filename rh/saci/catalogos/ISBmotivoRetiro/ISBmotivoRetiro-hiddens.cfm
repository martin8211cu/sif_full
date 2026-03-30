<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_MRcodigo" value="<cfif isdefined("form.filtro_MRcodigo") and Len(Trim(form.filtro_MRcodigo))>#form.filtro_MRcodigo#</cfif>" />		
	<input type="hidden" name="filtro_MRnombre" value="<cfif isdefined("form.filtro_MRnombre") and Len(Trim(form.filtro_MRnombre))>#form.filtro_MRnombre#</cfif>" />		
</cfoutput>