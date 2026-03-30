<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_GCcodigo" value="<cfif isdefined("form.filtro_GCcodigo") and Len(Trim(form.filtro_GCcodigo))>#form.filtro_GCcodigo#</cfif>" />	
	<input type="hidden" name="filtro_GCnombre" value="<cfif isdefined("form.filtro_GCnombre") and Len(Trim(form.filtro_GCnombre))>#form.filtro_GCnombre#</cfif>" />		
</cfoutput>