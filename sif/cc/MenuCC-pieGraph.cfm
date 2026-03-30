<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_AnMor = t.Translate('LB_AnMor','An&aacute;lisis Morosidad')>
<cfset LB_Morosidad = t.Translate('LB_Morosidad','Morosidad')>
<cfset LB_Corriente = t.Translate('LB_Corriente','Corriente')>
<cfset LB_VencDias = t.Translate('LB_VencDias','Vencimiento en Días')>
<cfset LB_MontoVenc = t.Translate('LB_MontoVenc','Monto Vencimiento')>

<cfif rsGraficoBar2.recordcount GT 0 and (rsGraficoBar2.SinVencer NEQ "" and rsGraficoBar2.Corriente NEQ "")>
	<cfoutput>
	<cfset rsPieGraph = QueryNew("Monto, Venc")>
	<cfset QueryAddrow(rsPieGraph,2)>
	<cfset QuerySetCell(rsPieGraph,"Monto",rsGraficoBar2.SinVencer + rsGraficoBar2.Corriente,1)>
	<cfset QuerySetCell(rsPieGraph,"Venc","#LB_Corriente#",1)>
	<cfset QuerySetCell(rsPieGraph,"Monto",rsGraficoBar2.Morosidad,2)>
	<cfset QuerySetCell(rsPieGraph,"Venc","#LB_Morosidad#",2)>
    </cfoutput>
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td class="smenu56" align="center"><strong><cfoutput>#LB_AnMor#&nbsp;</cfoutput>
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
      <cfoutput>
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
				xaxistitle = "#LB_VencDias#"
				yaxistitle = "#LB_MontoVenc#"
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
      </cfoutput>
	</table>
<cfelse>
	<cfset MSG_SinDatos = t.Translate('MSG_SinDatos','No se encontraron datos para realizar el Gr&aacute;fico')>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<td> *** No se encontraron datos para realizar el Gr&aacute;fico *** </td>
	  </tr>
	</table>
</cfif>

