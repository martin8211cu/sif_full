<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_codMensaje" value="<cfif isdefined("form.filtro_codMensaje") and Len(Trim(form.filtro_codMensaje))>#form.filtro_codMensaje#</cfif>" />		
	<input type="hidden" name="filtro_mensaje" value="<cfif isdefined("form.filtro_mensaje") and Len(Trim(form.filtro_mensaje))>#form.filtro_mensaje#</cfif>" />		
</cfoutput>