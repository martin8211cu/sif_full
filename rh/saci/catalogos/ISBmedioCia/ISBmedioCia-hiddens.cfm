<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_EMnombre" value="<cfif isdefined("form.filtro_EMnombre") and Len(Trim(form.filtro_EMnombre))>#form.filtro_EMnombre#</cfif>" />		
</cfoutput>