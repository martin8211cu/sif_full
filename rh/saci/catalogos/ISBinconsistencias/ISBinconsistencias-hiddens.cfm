<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>"/>
	<input type="hidden" name="filtro_Inombre" value="<cfif isdefined("form.filtro_Inombre") and Len(Trim(form.filtro_Inombre))>#form.filtro_Inombre#</cfif>"/>
	<input type="hidden" name="filtro_Idescripcion" value="<cfif isdefined("form.filtro_Idescripcion") and Len(Trim(form.filtro_Idescripcion))>#form.filtro_Idescripcion#</cfif>"/>
</cfoutput>