<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_Pid" value="<cfif isdefined("form.filtro_Pid") and Len(Trim(form.filtro_Pid))>#form.filtro_Pid#</cfif>" />
	<input type="hidden" name="hfiltro_Pid" value="<cfif isdefined("form.hfiltro_Pid") and Len(Trim(form.hfiltro_Pid))>#form.hfiltro_Pid#</cfif>" />	
	<input type="hidden" name="filtro_Nombre" value="<cfif isdefined("form.filtro_Nombre") and Len(Trim(form.filtro_Nombre))>#form.filtro_Nombre#</cfif>" />	
	<input type="hidden" name="hfiltro_Nombre" value="<cfif isdefined("form.hfiltro_Nombre") and Len(Trim(form.hfiltro_Nombre))>#form.hfiltro_Nombre#</cfif>" />	
</cfoutput>
