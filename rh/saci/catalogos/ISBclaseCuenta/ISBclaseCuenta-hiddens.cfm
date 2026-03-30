<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_CCclaseCuenta" value="<cfif isdefined("form.filtro_CCclaseCuenta") and Len(Trim(form.filtro_CCclaseCuenta))>#form.filtro_CCclaseCuenta#</cfif>" />	
	<input type="hidden" name="filtro_CCnombre" value="<cfif isdefined("form.filtro_CCnombre") and Len(Trim(form.filtro_CCnombre))>#form.filtro_CCnombre#</cfif>" />		
</cfoutput>