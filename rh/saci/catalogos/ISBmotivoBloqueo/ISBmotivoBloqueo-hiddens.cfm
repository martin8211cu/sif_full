<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_MBdescripcion" value="<cfif isdefined("form.filtro_MBdescripcion") and Len(Trim(form.filtro_MBdescripcion))>#form.filtro_MBdescripcion#</cfif>" />	
	<input type="hidden" name="filtro_HabilitadoDesc" value="<cfif isdefined("form.filtro_HabilitadoDesc") and Len(Trim(form.filtro_HabilitadoDesc))>#form.filtro_HabilitadoDesc#</cfif>" />
	<input type="hidden" name="filtro_MBconCompromisoImg" value="<cfif isdefined("form.filtro_MBconCompromisoImg") and Len(Trim(form.filtro_MBconCompromisoImg))>#form.filtro_MBconCompromisoImg#</cfif>" />	
	<input type="hidden" name="filtro_MBautogestionImg" value="<cfif isdefined("form.filtro_MBautogestionImg") and Len(Trim(form.filtro_MBautogestionImg))>#form.filtro_MBautogestionImg#</cfif>" />		
</cfoutput>