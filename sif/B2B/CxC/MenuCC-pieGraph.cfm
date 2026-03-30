<cfif rsGraficoBar2.recordcount GT 0 and (rsGraficoBar2.SinVencer NEQ "" and rsGraficoBar2.Corriente NEQ "")>
	<cfset rsPieGraph = QueryNew("Monto, Venc")>
	<cfset QueryAddrow(rsPieGraph,2)>
	<cfset QuerySetCell(rsPieGraph,"Monto",rsGraficoBar2.SinVencer + rsGraficoBar2.Corriente,1)>
	<cfset QuerySetCell(rsPieGraph,"Venc","Corriente",1)>
	<cfset QuerySetCell(rsPieGraph,"Monto",rsGraficoBar2.Morosidad,2)>
	<cfset QuerySetCell(rsPieGraph,"Venc","Morosidad",2)>
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td class="smenu56" align="center"><strong>An&aacute;lisis Morosidad&nbsp;
			<cfif isdefined("form.OCODIGO_F") and form.OCODIGO_F gt -1>
				<cfquery dbtype="query" name="rsO">
					select Odescripcion as O
					from rsOficinas
					where Ocodigo = #form.OCODIGO_F#
				</cfquery>
				<cfoutput>#rsO.O#</cfoutput>
			</cfif></strong>
		</td>
	  </tr>
	  <tr align="center">
		<td>
			<cfchart
				format = "flash"
				chartwidth = "350"
				scalefrom = "0"
				scaleto = "0"
				showxgridlines = "yes"
				showygridlines = "yes"
				gridlines = "5"
				seriesplacement = "stacked"
				showborder = "no"
				font = "Arial"
				fontsize = "10"
				fontbold = "no"
				fontitalic = "no"
				labelformat = "number"
				xaxistitle = "Vencimiento en Das"
				yaxistitle = "Monto Vencimiento"
				sortxaxis = "no"
				show3d = "yes"
				rotated = "no"
				showlegend = "yes"
				tipstyle = "MouseOver"
				showmarkers = "yes"
				markersize = "50"
				pieslicestyle="sliced">
				<cfchartseries 
					type="pie" 
					query="rsPieGraph" 
					valuecolumn="monto" 
					itemcolumn="venc"
					colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
			</cfchart>
		</td>
	  </tr>
	</table>
<cfelse>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td> *** No se encontraron datos para realizar el Gr&aacute;fico *** </td>
	  </tr>
	</table>
</cfif>
