<cfoutput>
	<input type="hidden" name="Snumero" value="<cfif isdefined("form.Snumero") and Len(Trim(form.Snumero))>#form.Snumero#</cfif>">
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="filtro_Snumero" value="<cfif isdefined("form.filtro_Snumero") and Len(Trim(form.filtro_Snumero))>#form.filtro_Snumero#</cfif>" />
	<input type="hidden" name="filtro_Sdonde" value="<cfif isdefined("form.filtro_Sdonde") and Len(Trim(form.filtro_Sdonde))>#form.filtro_Sdonde#</cfif>" />
	<input type="hidden" name="filtro_LGlogin" value="<cfif isdefined("form.filtro_LGlogin") and Len(Trim(form.filtro_LGlogin))>#form.filtro_LGlogin#</cfif>" />	
	<input type="hidden" name="filtro_nombreAgente" value="<cfif isdefined("form.filtro_nombreAgente") and Len(Trim(form.filtro_nombreAgente))>#form.filtro_nombreAgente#</cfif>" />		
	<input type="hidden" name="filtro_Sestado" value="<cfif isdefined("form.filtro_Sestado") and Len(Trim(form.filtro_Sestado))>#form.filtro_Sestado#</cfif>" />			
</cfoutput>
