<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_SOfechasol" value="<cfif isdefined("form.filtro_SOfechasol") and Len(Trim(form.filtro_SOfechasol))>#form.filtro_SOfechasol#</cfif>" />	
	<input type="hidden" name="filtro_SOtipo" value="<cfif isdefined("form.filtro_SOtipo") and Len(Trim(form.filtro_SOtipo))>#form.filtro_SOtipo#</cfif>" />
	<input type="hidden" name="filtro_SOestado" value="<cfif isdefined("form.filtro_SOestado") and Len(Trim(form.filtro_SOestado))>#form.filtro_SOestado#</cfif>" />	
	<input type="hidden" name="filtro_SOtipoSobre" value="<cfif isdefined("form.filtro_SOtipoSobre") and Len(Trim(form.filtro_SOtipoSobre))>#form.filtro_SOtipoSobre#</cfif>" />		
	<input type="hidden" name="filtro_SOcantidad" value="<cfif isdefined("form.filtro_SOcantidad") and Len(Trim(form.filtro_SOcantidad))>#form.filtro_SOcantidad#</cfif>" />		
</cfoutput>