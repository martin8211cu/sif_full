<!--- Comparativo por Mes para el Servicio Seleccionado --->
<cfset LvarNombreConcepto = "">
<cfif rsCompServicio.recordcount GT 0>
	<cfset LvarNombreConcepto = rsCompServicio.Concepto>
	<cfif rsCompServicio.recordcount GT 3>
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
			title="Comparativo de Ventas #LvarNombreConcepto#"
			>
				<cfchartseries 
					type="line" 
					query="rsCompServicio" 
					valuecolumn="Total"
					itemcolumn="PeriodoMes"
					>
					<cfchartdata item="#rsCompServicio.PeriodoMes#" value="#rsCompServicio.Total#">
				</cfchartseries>
		</cfchart>
	<cfelse>
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
			title="Comparativo de Ventas #LvarNombreConcepto#"
			>
				<cfchartseries 
					type="bar" 
					query="rsCompServicio" 
					valuecolumn="Total"
					itemcolumn="PeriodoMes"
					>
					<cfchartdata item="#rsCompServicio.PeriodoMes#" value="#rsCompServicio.Total#">
				</cfchartseries>
		</cfchart>
	</cfif>

<cfelse>
	<p>No hay Datos para Graficar</p>
</cfif>
