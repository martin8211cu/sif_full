<!--- Saldos en los últimos meses.. Grafico No 1 --->
<cfif rsSaldos.RecordCount GT 0>
	<cfif rsSaldos.RecordCount LT 2>
		<cfset LvarTipo = "Bar">
		<cfset Lvarformat = "flash">
	<cfelse>
		<cfset LvarTipo = "Line">
		<cfset Lvarformat = "flash">
	</cfif>

	<cfchart
		format = "#LvarFormat#"
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
		title="Historico de Saldos"
		>
			<cfchartseries 
				type="#LvarTipo#" 
				query="rsSaldos" 
				serieslabel="Saldo"
				valuecolumn="Saldo"
				itemcolumn="PeriodoMes">
				<cfchartdata item="#rsSaldos.Periodomes#" value="#rsSaldos.Saldo#">
			</cfchartseries>
			<cfchartseries 
				type="#LvarTipo#" 
				query="rsSaldos"
				serieslabel="Morosidad"
				valuecolumn="Morosidad"
				itemcolumn="PeriodoMes">
				<cfchartdata item="#rsSaldos.Periodomes#" value="#rsSaldos.Morosidad#">
			</cfchartseries>
	</cfchart>
<cfelse>
	<p>No Hay Datos para Graficar</p>
</cfif>
