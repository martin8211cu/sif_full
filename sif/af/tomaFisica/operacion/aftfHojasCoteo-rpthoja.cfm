<cfinclude template="aftfHojasCoteo-common.cfm">

<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	irA="aftfHojasCoteo.cfm?AFTFid_hoja=#Form.AFTFid_hoja#&#Gvar_navegacion_Lista1#&#Gvar_navegacion_Lista2#"
	title="Reporte para Toma Física de Activos Fijos" 
	filename="ReporteTomaFisicaAF-#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfinclude template="../consultas/aftfHojasCoteoRpt-impr.cfm">