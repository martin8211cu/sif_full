<cfoutput>
	<input type="hidden" name="Pagina" value="#form.Pagina#">

	<input type="hidden" name="Filtro_AFTFdescripcion_hoja" value="#form.Filtro_AFTFdescripcion_hoja#">
	<input type="hidden" name="Filtro_AFTFfecha_hoja" value="#form.Filtro_AFTFfecha_hoja#">
	<input type="hidden" name="Filtro_AFTFfecha_conteo_hoja" value="#form.Filtro_AFTFfecha_conteo_hoja#">
	<input type="hidden" name="Filtro_AFTFestatus_hoja" value="#form.Filtro_AFTFestatus_hoja#">

	<input type="hidden" name="HFiltro_AFTFdescripcion_hoja" value="#form.Filtro_AFTFdescripcion_hoja#">
	<input type="hidden" name="HFiltro_AFTFfecha_hoja" value="#form.Filtro_AFTFfecha_hoja#">
	<input type="hidden" name="HFiltro_AFTFfecha_conteo_hoja" value="#form.Filtro_AFTFfecha_conteo_hoja#">
	<input type="hidden" name="HFiltro_AFTFestatus_hoja" value="#form.Filtro_AFTFestatus_hoja#">

	<cfif isdefined("form.Filtro_FechasMayores")>
	<input type="hidden" name="Filtro_FechasMayores" value="#form.Filtro_FechasMayores#">
	</cfif>
</cfoutput>