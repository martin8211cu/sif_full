<cfinvoke 
	component="sif.Componentes.pListas" 
	method="pLista"
	tabla="AFTFHojaConteo a"
	columnas="a.AFTFid_hoja, a.AFTFdescripcion_hoja, a.AFTFfecha_hoja, a.AFTFfecha_conteo_hoja, 
		case a.AFTFestatus_hoja
			when 0 then 'En Generación de Hoja'
			when 1 then 'En Disposotivo Móvil'
			when 2 then 'En Proceso de Inventario'
			when 3 then 'Aplicada'
			when 9 then 'Cancelada'
		end as AFTFestatus_hoja,
		case a.AFTFestatus_hoja
			when 0 then null
			else a.AFTFid_hoja
		end as AFTFinactivar_checkbox,
		'' as AFTFespacio_en_blanco"
	filtro="a.CEcodigo = #session.CEcodigo# and a.Ecodigo = #session.Ecodigo# order by AFTFfecha_hoja desc"
	desplegar="AFTFdescripcion_hoja, AFTFfecha_hoja, AFTFfecha_conteo_hoja, AFTFestatus_hoja, AFTFespacio_en_blanco"
	etiquetas="Descripci&oacute;n, Fecha, Fecha Cierre, Condici&oacute;n, "
	formatos="S, D, D, S, U"
	align="left, center, center, left, right"
	ajustar="N, N, N, N, N"
	irA="aftfHojasCoteoRpt-sql.cfm"
	mostrar_filtro="true"
	filtrar_automatico="true"
	filtrar_por="a.AFTFdescripcion_hoja, a.AFTFfecha_hoja, a.AFTFfecha_conteo_hoja, a.AFTFestatus_hoja, ''"
	rsAFTFestatus_hoja="#rsAFTFestatus_hoja#"
	maxrows="15"
/>