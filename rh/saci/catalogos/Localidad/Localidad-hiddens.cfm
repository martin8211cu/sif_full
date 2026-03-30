<cfoutput>
	<input type="hidden" name="modoLoc" value="<cfif isdefined("form.modoLoc") and Len(Trim(form.modoLoc))>#form.modoLoc#</cfif>" />
	<input type="hidden" name="Pagina" value="<cfif isdefined("form.Pagina") and Len(Trim(form.Pagina))>#form.Pagina#</cfif>" />
	<input type="hidden" name="Ppais" value="#session.saci.pais#">
	<input type="hidden" name="MaxRows" value="<cfif isdefined("form.MaxRows") and Len(Trim(form.MaxRows))>#form.MaxRows#</cfif>" />		
	<input type="hidden" name="filtro_LCcod" value="<cfif isdefined("form.filtro_LCcod") and Len(Trim(form.filtro_LCcod))>#form.filtro_LCcod#</cfif>" />
	<input type="hidden" name="filtro_DPnombre" value="<cfif isdefined("form.filtro_DPnombre") and Len(Trim(form.filtro_DPnombre))>#form.filtro_DPnombre#</cfif>" />
	<input type="hidden" name="filtro_LCnombre" value="<cfif isdefined("form.filtro_LCnombre") and Len(Trim(form.filtro_LCnombre))>#form.filtro_LCnombre#</cfif>" />	
	<input type="hidden" name="LCid" value="<cfif isdefined("form.LCid") and Len(Trim(form.LCid))>#form.LCid#</cfif>" />
	<input type="hidden" name="LCidPadre" value="<cfif isdefined("form.LCidPadre") and Len(Trim(form.LCidPadre))>#form.LCidPadre#</cfif>"/>
	<input type="hidden" name="btnNuevo" value=""/>	
	<input type="hidden" name="Pagina2" value="<cfif isdefined("form.Pagina2") and Len(Trim(form.Pagina2))>#form.Pagina2#</cfif>"/>		
	<input type="hidden" name="filtro_LCcodb" value="<cfif isdefined("form.filtro_LCcodb") and Len(Trim(form.filtro_LCcodb))>#form.filtro_LCcodb#</cfif>" />
	<input type="hidden" name="filtro_LCnombreb" value="<cfif isdefined("form.filtro_LCnombreb") and Len(Trim(form.filtro_LCnombreb))>#form.filtro_LCnombreb#</cfif>" />	
</cfoutput>
