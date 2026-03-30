<cfinclude template="aftfHojasCoteoRpt-common.cfm">

<!--- Pintado de los botones de regresar, impresión y exportar a excel. --->
<cf_htmlreportsheaders
	irA="aftfHojasCoteoRpt.cfm?#Gvar_navegacion_Lista1#"
	title="Reporte para Toma Física de Activos Fijos" 
	filename="ReporteTomaFisicaAF-#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfinclude template="aftfHojasCoteoRpt-impr.cfm">