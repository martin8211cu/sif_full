<!--- Ventas para la Direccion ( incluye impuesto ) --->
<cfif rsVentas.recordcount GT 0>
	<cfchart
		format = "flash"
		chartwidth = "420" 
		chartheight="200"
		scalefrom = "0"
		scaleto = "0"
		showxgridlines = "yes"
		showygridlines = "yes"
		gridlines = "5"
		seriesplacement = "default"
		showborder = "no"
		font = "Arial"
		fontsize = "10"
		fontbold = "no"
		fontitalic = "no"
		labelformat = "number"
		xaxistitle = "Mes"
		yaxistitle = "Monto"
		sortxaxis = "no"
		show3d = "yes"
		rotated = "no"
		showlegend = "no"
		tipstyle = "MouseOver"
		showmarkers = "yes"
		markersize = "50"
		url = "" 
		title="Historico de Ventas"
		>
			<cfchartseries 
				type="Line" 
				query="rsVentas" 
				valuecolumn="Total"
				itemcolumn="PeriodoMes">
				<cfchartdata item="#rsVentas.Periodomes#" value="#rsVentas.Total#">
			</cfchartseries>
	</cfchart>
<cfelse>
	<p>No hay datos para Graficar</p>
</cfif>
