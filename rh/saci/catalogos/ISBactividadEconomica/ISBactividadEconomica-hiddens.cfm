<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_AEactividad" value="<cfif isdefined("form.filtro_AEactividad") and Len(Trim(form.filtro_AEactividad))>#form.filtro_AEactividad#</cfif>" />	
	<input type="hidden" name="filtro_AEnombre" value="<cfif isdefined("form.filtro_AEnombre") and Len(Trim(form.filtro_AEnombre))>#form.filtro_AEnombre#</cfif>" />		
</cfoutput>