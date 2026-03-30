<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_AnMor = t.Translate('LB_AnMor','An&aacute;lisis Morosidad','/commons/widgets/publico/MenuCC.xml')>
<cfset LB_Morosidad = t.Translate('LB_Morosidad','Morosidad','/commons/widgets/publico/MenuCC.xml')>
<cfset LB_Corriente = t.Translate('LB_Corriente','Corriente','/commons/widgets/publico/MenuCC.xml')>
<cfset LB_VencDias = t.Translate('LB_VencDias','Vencimiento en Días','/commons/widgets/publico/MenuCC.xml')>
<cfset LB_MontoVenc = t.Translate('LB_MontoVenc','Monto Vencimiento','/commons/widgets/publico/MenuCC.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/commons/widgets/publico/MenuCC.xml')>

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

			<script src="/cfmx/jquery/librerias/Highcharts/js/highcharts.js"></script>
			<script src="/cfmx/jquery/librerias/Highcharts/js/modules/data.js"></script>

			<script>
				$(function () {

				    $(document).ready(function () {

				        $('##containerTable1').highcharts({
				            chart: {
				                plotBackgroundColor: null,
				                plotBorderWidth: null,
				                plotShadow: false,
				                type: 'pie'
				            },
				            title: {
				                text: ''
				            },
				            plotOptions: {
				                pie: {
				                    allowPointSelect: true,
				                    cursor: 'pointer',
				                    dataLabels: {
				                        enabled: false
				                    },
				                    showInLegend: true
				                }
				            },
				            data: {
								    table: 'datatable1'
								  }
				        });
				    });
				});
			</script>

			<div id="containerTable1" style="min-width:200px; height:275px; margin: 0 auto"></div>
		    
		    <table id="datatable1" style="display: none;">
		    	<thead>
			        <tr>
			            <th></th>
			            <th><cfoutput>#LB_Monto#</cfoutput></th>
			        </tr>
			    </thead>
				<cfloop query="rsPieGraph">
					<cfoutput>
						<tr>
							<th>#venc#</th>
							<td>#monto#</td>
						</tr>
					</cfoutput>
				</cfloop>
			</table>

		</td>
	  </tr>
      </cfoutput>
	</table>
<cfelse>
	<cfset MSG_SinDatos = t.Translate('MSG_SinDatos','No se encontraron datos para realizar el Gr&aacute;fico','/commons/widgets/publico/MenuCC.xml')>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
	  <tr>
		<th scope="col">  *** <cfoutput>#MSG_SinDatos#</cfoutput> ***  </th>
	  </tr>
	</table>
</cfif>

