<cfset rsPieGraph = QueryNew("Monto, Venc")>
<cfset QueryAddrow(rsPieGraph,2)>
<cfset QuerySetCell(rsPieGraph,"Monto",rsGraficoBar.SinVencer + rsGraficoBar.Corriente,1)>
<cfset QuerySetCell(rsPieGraph,"Venc","Corriente",1)>
<cfset QuerySetCell(rsPieGraph,"Monto",rsGraficoBar.Morosidad,2)>
<cfset QuerySetCell(rsPieGraph,"Venc","Morosidad",2)>
<cfchart
	format = "flash"
	chartWidth = "350"
	scaleFrom = "0"
	scaleTo = "0"
	showXGridlines = "yes"
	showYGridlines = "yes"
	gridlines = "5"
	seriesPlacement = "stacked"
	showBorder = "no"
	font = "Arial"
	fontSize = "10"
	fontBold = "no"
	fontItalic = "no"
	labelFormat = "currency"
	xAxisTitle = "Vencimiento en Días"
	yAxisTitle = "Monto Vencimiento"
	sortXAxis = "no"
	show3D = "yes"
	rotated = "no"
	showLegend = "yes"
	tipStyle = "MouseOver"
	showMarkers = "yes"
	markerSize = "50"
	url = "/cfmx/sif/admin/Consultas/AntigSaldosDetCxC.cfm?venc=$ITEMLABEL$"
	pieslicestyle="sliced">
	<cfchartseries 
		type="pie" 
		query="rsPieGraph" 
		valuecolumn="monto" 
		itemcolumn="venc"
		colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
</cfchart>