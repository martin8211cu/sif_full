<cfoutput>
	<cfif isdefined("Form.PageNum_lista")>
		<input type="hidden" name="PageNum_lista" value="#Form.PageNum_lista#">
	</cfif>
	<cfif isdefined("Form.filtro_OficodigoM")>
		<input type="hidden" name="filtro_OficodigoM" value="#Form.filtro_OficodigoM#">
	</cfif>
	<cfif isdefined("Form.filtro_Cmayor")>
		<input type="hidden" name="filtro_Cmayor" value="#Form.filtro_Cmayor#">
	</cfif>
	<cfif isdefined("Form.filtro_PCRregla")>
		<input type="hidden" name="filtro_PCRregla" value="#Form.filtro_PCRregla#">
	</cfif>
	<cfif isdefined("Form.filtro_PCRvalida")>
		<input type="hidden" name="filtro_PCRvalida" value="#Form.filtro_PCRvalida#">
	</cfif>
	<cfif isdefined("Form.filtro_PCRdesde")>
		<input type="hidden" name="filtro_PCRdesde" value="#Form.filtro_PCRdesde#">
	</cfif>
	<cfif isdefined("Form.filtro_PCRhasta")>
		<input type="hidden" name="filtro_PCRhasta" value="#Form.filtro_PCRhasta#">
	</cfif>
</cfoutput>
