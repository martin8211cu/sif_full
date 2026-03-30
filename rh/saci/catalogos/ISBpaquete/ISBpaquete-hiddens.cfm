<cfoutput>
	<input type="hidden" name="PageNum_listaroot" value="<cfif isdefined("form.PageNum_listaroot") and Len(Trim(form.PageNum_listaroot))>#form.PageNum_listaroot#</cfif>" />
	<input type="hidden" name="Filtro_PQnombre" value="<cfif isdefined("form.Filtro_PQnombre") and Len(Trim(form.Filtro_PQnombre))>#form.Filtro_PQnombre#</cfif>" />
	<input type="hidden" name="Filtro_PQdescripcion" value="<cfif isdefined("form.Filtro_PQdescripcion") and Len(Trim(form.Filtro_PQdescripcion))>#form.Filtro_PQdescripcion#</cfif>" />
	<input type="hidden" name="tab" value="<cfif isdefined("form.tab") and Len(Trim(form.tab))>#form.tab#</cfif>" />
</cfoutput>
