<cfoutput>
	<input type="hidden" name="paso" value="<cfif isdefined("form.paso") and Len(Trim(form.paso))>#form.paso#</cfif>" />
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="Filtro_MDref" value="<cfif isdefined("form.Filtro_MDref") and Len(Trim(form.Filtro_MDref))>#form.Filtro_MDref#</cfif>" />	
	<input type="hidden" name="Filtro_Limite" value="<cfif isdefined("form.Filtro_Limite") and Len(Trim(form.Filtro_Limite))>#form.Filtro_Limite#</cfif>" />		
	<input type="hidden" name="Filtro_Saldo" value="<cfif isdefined("form.Filtro_Saldo") and Len(Trim(form.Filtro_Saldo))>#form.Filtro_Saldo#</cfif>" />			
	<input type="hidden" name="Filtro_Uso" value="<cfif isdefined("form.Filtro_Uso") and Len(Trim(form.Filtro_Uso))>#form.Filtro_Uso#</cfif>" />				
</cfoutput>
