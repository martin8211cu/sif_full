<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_TScodigo" value="<cfif isdefined("form.filtro_TScodigo") and Len(Trim(form.filtro_TScodigo))>#form.filtro_TScodigo#</cfif>" />	
	<input type="hidden" name="filtro_TSnombre" value="<cfif isdefined("form.filtro_TSnombre") and Len(Trim(form.filtro_TSnombre))>#form.filtro_TSnombre#</cfif>" />
	<input type="hidden" name="filtro_TSdescripcion" value="<cfif isdefined("form.filtro_TSdescripcion") and Len(Trim(form.filtro_TSdescripcion))>#form.filtro_TSdescripcion#</cfif>" />	
</cfoutput>