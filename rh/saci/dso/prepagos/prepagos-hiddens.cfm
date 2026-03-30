<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_TJlogin" value="<cfif isdefined("form.filtro_TJlogin") and Len(Trim(form.filtro_TJlogin))>#form.filtro_TJlogin#</cfif>" />	
	<input type="hidden" name="filtro_descTJestado" value="<cfif isdefined("form.filtro_descTJestado") and Len(Trim(form.filtro_descTJestado))>#form.filtro_descTJestado#</cfif>" />
	<input type="hidden" name="filtro_nombreAgente" value="<cfif isdefined("form.filtro_nombreAgente") and Len(Trim(form.filtro_nombreAgente))>#form.filtro_nombreAgente#</cfif>" />	
	<input type="hidden" name="filtro_TJuso" value="<cfif isdefined("form.filtro_TJuso") and Len(Trim(form.filtro_TJuso))>#form.filtro_TJuso#</cfif>" />		
	<input type="hidden" name="filtro_TJvigencia" value="<cfif isdefined("form.filtro_TJvigencia") and Len(Trim(form.filtro_TJvigencia))>#form.filtro_TJvigencia#</cfif>" />		
</cfoutput>
