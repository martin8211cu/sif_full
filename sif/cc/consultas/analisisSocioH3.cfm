<!--- Ventas por Servicios --->
<cfif rsVentasServicio.recordcount GT 0>
	<cfif LvarCodArtCon EQ -1>
		<cfset LvarCodArtCon = rsVentasServicio.DDcodartcon>
	</cfif>
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
		xaxistitle = "Servicio"
		yaxistitle = "Monto"
		sortxaxis = "no"
		show3d = "yes"
		rotated = "no"
		showlegend = "no"
		tipstyle = "MouseOver"
		showmarkers = "yes"
		markersize = "50"
		url = "#Lvardireccionurl#&tipo=S&DDcodartcon=$ITEMLABEL$" 
		title="Ventas por Servicio"
		>
			<cfchartseries 
				type="bar" 
				query="rsVentasServicio" 
				valuecolumn="Total"
				itemcolumn="Concepto"
				colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
				<cfchartdata item="#rsVentasServicio.Concepto#" value="#rsVentasServicio.Total#">
			</cfchartseries>
	</cfchart>
<cfelse>
	<p>No hay Datos para Graficar</p>
</cfif>
