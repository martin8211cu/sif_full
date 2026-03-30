<cfoutput>
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_interfaz" value="<cfif isdefined("form.filtro_interfaz") and Len(Trim(form.filtro_interfaz))>#form.filtro_interfaz#</cfif>" />		
	<input type="hidden" name="filtro_S02ACC" value="<cfif isdefined("form.filtro_S02ACC") and Len(Trim(form.filtro_S02ACC))>#form.filtro_S02ACC#</cfif>" />		
	<input type="hidden" name="filtro_nombreInterfaz" value="<cfif isdefined("form.filtro_nombreInterfaz") and Len(Trim(form.filtro_nombreInterfaz))>#form.filtro_nombreInterfaz#</cfif>" />			
	<input type="hidden" name="filtro_componente" value="<cfif isdefined("form.filtro_componente") and Len(Trim(form.filtro_componente))>#form.filtro_componente#</cfif>" />				
	<input type="hidden" name="filtro_metodo" value="<cfif isdefined("form.metodo") and Len(Trim(form.metodo))>#form.metodo#</cfif>" />					
</cfoutput>