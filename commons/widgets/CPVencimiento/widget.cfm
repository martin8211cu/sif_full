
<!--- leer configuracion --->
<cfhtmlhead text="<script src='/cfmx/jquery/librerias/jquery.canvasjs.min.js'></script>">

<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Fisica 	= t.Translate('LB_Fisica','Física')>
<cfset LB_Juridica 	= t.Translate('LB_Juridica','Jurídica')>
<cfset LB_Extranjero = t.Translate('LB_Extranjero','Extranjero')>
<cfset LB_Hoy = t.Translate('LB_Hoy','Hoy')>

<div id="chart_<cfoutput>#request.WidCodigo#</cfoutput>" style="height: 170px; width: 100%"></div>


<cfif request.WidCodigo EQ 'CPVencimiento'>
	
	<cfset venc1 = Trim(get_val(310).Pvalor)>
	<cfset venc2 = Trim(get_val(320).Pvalor)>
	<cfset venc3 = Trim(get_val(330).Pvalor)>
	<cfset venc4 = Trim(get_val(340).Pvalor)>

	<cf_dbfunction name="now" returnvariable="now">
	<cf_dbfunction name="datediff" args="a.Dfechavenc, #now#" returnvariable="DiasVencimiento">
	<cfquery name="rsGraficoBar" datasource="#session.dsn#">
		select 
	 		coalesce(sum(case when #PreserveSingleQuotes(DiasVencimiento)# < 0
				 		 then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end) else 0.00 end * coalesce(Dtipocambio,1)),00)   as SinVencer,
	 		coalesce(sum(case when #PreserveSingleQuotes(DiasVencimiento)#  =0
				 		 then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end) else 0.00 end * coalesce(Dtipocambio,1)),00) as Hoy,
			coalesce(sum(case when
				  #PreserveSingleQuotes(DiasVencimiento)#  between 1 and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc1#">
			  then (EDsaldo* case when c.CPTtipo = 'C' then 1 else -1 end)   else 0.00 end * coalesce(Dtipocambio,1)),00 )  caso01,
			coalesce(sum(case when
				  #PreserveSingleQuotes(DiasVencimiento)#  between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc1+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc2#">
			  then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end)  else 0.00 end  * coalesce(Dtipocambio,1) ),00)  as caso02,
			coalesce(sum(case when
				  #PreserveSingleQuotes(DiasVencimiento)# between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc2+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc3#">
			  then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end)   else 0.00 end * coalesce(Dtipocambio,1)),00 )   as caso03,
			coalesce(sum(case when
				 #PreserveSingleQuotes(DiasVencimiento)#  between <cfqueryparam cfsqltype="cf_sql_integer" value="#venc3+1#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#venc4#">
			  then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end)  else 0.00 end * coalesce(Dtipocambio,1)),00) as caso04,	
			coalesce(sum(case when
				  #PreserveSingleQuotes(DiasVencimiento)#  > <cfqueryparam cfsqltype="cf_sql_integer" value="#venc4#">
			  then (EDsaldo * case when c.CPTtipo = 'C' then 1 else -1 end)   else 0.00 end * coalesce(Dtipocambio,1)),00) as mayores,
		  round(sum(a.EDsaldo  * a.EDtcultrev * case when c.CPTtipo = 'C' then 1.00 else -1.00 end), 2) as Saldo
		from EDocumentosCP a
			inner join CPTransacciones c
				on c.Ecodigo = a.Ecodigo
				and c.CPTcodigo = a.CPTcodigo
		where a.Ecodigo = #session.Ecodigo#
		  and a.EDsaldo > 0
		<cfif isdefined("Form.SNcodigo")  and len(trim(form.SNcodigo)) and form.SNcodigo neq '-1'>
			and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		</cfif>
		<cfif isdefined("Form.Ocodigo")  and len(trim(form.Ocodigo)) and form.Ocodigo neq '-1'>
			and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
		</cfif>			
	</cfquery>

	<cfif not isdefined("Form.Ocodigo") OR len(trim(form.Ocodigo)) EQ 0>
		<cfparam name="Form.Ocodigo" default="-1">
	</cfif>

	<cfset LB_SinVenc = t.Translate('LB_SinVenc','Sin Vencer')>
	<cfset LB_Masde = t.Translate('LB_Masde','Mas de')>

	<cfset rsGrafico = QueryNew("Monto, Venc,Inicio,Fin")>
	<cfset QueryAddRow(rsGrafico,1)>
	<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.SinVencer,rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Venc','#LB_SinVenc#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Inicio','-1',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Fin','-1',rsGrafico.RECORDCOUNT)>
	<cfset QueryAddRow(rsGrafico,1)>
	<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.Hoy,rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Venc','#LB_Hoy#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Inicio','0',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Fin','0',rsGrafico.RECORDCOUNT)>
	<cfset QueryAddRow(rsGrafico,1)>
	<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.caso01,rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Venc','1 - #Venc1#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Inicio','1',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Fin','#Venc1#',rsGrafico.RECORDCOUNT)>
	<cfset QueryAddRow(rsGrafico,1)>
	<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.caso02,rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Venc','#Venc1+1# - #Venc2#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Inicio','#Venc1+1#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Fin','#Venc2#',rsGrafico.RECORDCOUNT)>

	<cfset QueryAddRow(rsGrafico,1)>
	<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.caso03,rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Venc','#Venc2+1# - #Venc3#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Inicio','#Venc2+1#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Fin','#Venc3#',rsGrafico.RECORDCOUNT)>
	<cfset QueryAddRow(rsGrafico,1)>
	<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.caso04,rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Venc','#Venc3+1# - #Venc4#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Inicio','#Venc3+1#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Fin','#Venc4#',rsGrafico.RECORDCOUNT)>
	<cfset QueryAddRow(rsGrafico,1)>
	<cfset QuerySetCell(rsGrafico,'Monto',rsGraficoBar.mayores,rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Venc','#LB_Masde# #Venc4#',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Inicio','-2',rsGrafico.RECORDCOUNT)>
	<cfset QuerySetCell(rsGrafico,'Fin','#Venc4#',rsGrafico.RECORDCOUNT)>

	<cffunction name="get_val" access="public" returntype="query">
		<cfargument name="valor" type="numeric" required="true" default="">
			<cfquery datasource="#Session.DSN#" name="rsget_val">
				select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
				where Ecodigo =  #Session.Ecodigo# 
				and Pcodigo = #valor#
			</cfquery>
		<cfreturn #rsget_val#>
	</cffunction>

	<script type="text/javascript"> 
		$("#chart_<cfoutput>#request.WidCodigo#</cfoutput>").CanvasJSChart({ 
			backgroundColor: "#ffffff",
			axisY: { 
				title: "Monto Vencimiento", 
				titleFontSize: 15,
				includeZero: false 
			}, 
			data: [ 
			{ 
				type: "column", 
				toolTipContent: "{label}: {y}", 
				dataPoints: [ 
					<cfoutput>
						<cfset strU = ''>
						<cfloop query="rsGrafico">
						    #strU#{ label: '#rsGrafico.Venc#', y: #rsGrafico.Monto# }
						    <cfset strU = ','>
					    </cfloop>
					</cfoutput>
				] 
			} 
			] 
		}); 
	</script> 

<cfelse>
	<script type="text/javascript">
		var dps = []; // dataPoints

		var chart = new CanvasJS.Chart("chart_<cfoutput>#request.WidCodigo#</cfoutput>",{
			title :{
				text: "Monitor"
			},			
			data: [{
				type: "line",
				dataPoints: dps 
			}]
		});

		var xVal = 0;
		var yVal = 100;	
		var updateInterval = 100;
		var dataLength = 500; // number of dataPoints visible at any point

		var updateChart = function (count) {
			count = count || 1;
			// count is number of times loop runs to generate random dataPoints.
			
			for (var j = 0; j < count; j++) {	
 				yVal = yVal +  Math.round(5 + Math.random() *(-5-5));
 				dps.push({
 					x: xVal,
 					y: yVal
 				});
 				xVal++;
 			};
 			if (dps.length > dataLength)
			{
				dps.shift();				
			}
			
			chart.render();		

		};

		// generates first set of dataPoints
		updateChart(dataLength); 

		// update chart after specified time. 
		setInterval(function(){updateChart()}, updateInterval);
	</script>
</cfif>