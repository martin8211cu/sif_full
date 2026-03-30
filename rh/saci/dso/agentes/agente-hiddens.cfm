<cfoutput>
	<input type="hidden" name="PageNum_listaroot" value="<cfif isdefined("form.PageNum_listaroot") and Len(Trim(form.PageNum_listaroot))>#form.PageNum_listaroot#</cfif>" />
	<input type="hidden" name="Filtro_Ppersoneria" value="<cfif isdefined("form.Filtro_Ppersoneria") and Len(Trim(form.Filtro_Ppersoneria))>#form.Filtro_Ppersoneria#</cfif>" />
	<input type="hidden" name="Filtro_Pid" value="<cfif isdefined("form.Filtro_Pid") and Len(Trim(form.Filtro_Pid))>#form.Filtro_Pid#</cfif>" />
	<input type="hidden" name="Filtro_nom_razon" value="<cfif isdefined("form.Filtro_nom_razon") and Len(Trim(form.Filtro_nom_razon))>#form.Filtro_nom_razon#</cfif>" />
	<input type="hidden" name="Filtro_Habilitado" value="<cfif isdefined("form.Filtro_Habilitado") and Len(Trim(form.Filtro_Habilitado))>#form.Filtro_Habilitado#</cfif>" />
	<input type="hidden" name="tab" value="<cfif isdefined("form.tab") and Len(Trim(form.tab))>#form.tab#</cfif>" />
	<input type="hidden" name="ag" value="<cfif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />
	<input type="hidden" name="cue" value="<cfif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#</cfif>" />
	<input type="hidden" name="paso" value="<cfif isdefined("form.paso") and Len(Trim(form.paso))>#form.paso#</cfif>" />
	<input type="hidden" name="tipo" value="<cfif isdefined("form.tipo") and Len(Trim(form.tipo))>#form.tipo#</cfif>" />
</cfoutput>
