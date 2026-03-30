<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cliente" default = "Cliente" returnvariable="LB_Cliente" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CURP" default = "CURP" returnvariable="LB_CURP" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Observacion" default = "Observaciones" returnvariable="LB_Observacion" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Parcialidades" default = "Parcialidades" returnvariable="LB_Parcialidades" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TipoTransac" default = "Tipo Transacci&oacute;n" returnvariable="LB_TipoTransac" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Fecha" default = "Fecha" returnvariable="LB_Fecha" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Corte" default = "Corte" returnvariable="LB_Corte" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Monto" default = "Monto" returnvariable="LB_Monto" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoReq" default = "Monto Requerido" returnvariable="LB_MontoReq" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Pagado" default = "Pagado" returnvariable="LB_Pagado" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descuento" default = "Descuento" returnvariable="LB_Descuento" xmlfile = "tab_Transaccion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoPagar" default = "Monto A PAgar" returnvariable="LB_MontoPagar" xmlfile = "tab_Transaccion.xml">

<script src="/cfmx/jquery/librerias/Highcharts/js/highcharts.js"></script>
<script src="/cfmx/jquery/librerias/Highcharts/js/modules/data.js"></script>

<cfparam name="form.id">

<!--- variables para mayoristas --->
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.getParametro('30000706')>
<cfif trim(rsCuenta.Tipo) eq 'TM'>
	<cfset dia_fin = val>
	<cfif not isdefined("form.codigoCorte")>
		<cfset form.codigoCorte = month(now())>
	</cfif>
	<cfset mes_fin = form.codigoCorte>

	<cfset anno_fin = DateFormat(now(),"yyyy")>
	<cfset date_fin = createDate(anno_fin, mes_fin, dia_fin)>
	<cfset date_ini =  dateAdd('d',1,dateAdd('m', -1, date_fin))>

	<cfif month(date_ini) gt DateFormat(now(),"m")>
		<cfset anno_fin -= 1>
		<cfset date_fin = createDate(anno_fin, mes_fin, dia_fin)>
		<cfset date_ini =  dateAdd('d',1,dateAdd('m', -1, date_fin))>
	</cfif>

</cfif>

<cfquery name="q_Fechas" datasource="#session.DSN#">
	select top(<cfif isdefined('form.monthSearch')>#form.monthSearch#<cfelse>3</cfif>) max(FechaFin) Fin, min(FechaInicio) Inicio from CRCCortes  
		where 
			FechaInicio < CURRENT_TIMESTAMP+(30*<cfif isdefined('form.monthSearch')>#form.monthSearch#<cfelse>3</cfif>)
			and Tipo = '#rsCuenta.Tipo#'
			and Ecodigo = #session.ecodigo#;
</cfquery>

<cfquery name="q_Transacciones" datasource="#session.DSN#">
	select 
		C.id CuentaId,
		ct.Codigo,
		A.TipoMov,
		sum(A.Monto) Monto
	from CRCTransaccion A
	inner join CRCCuentas C
	on A.CRCCuentasid = C.id
	right join CRCCortes ct
	on A.fecha between ct.FechaInicio and dateadd(day,1,ct.FechaFin)
	and C.Tipo = ct.Tipo
	where 
	convert(date,A.fecha) < dateAdd(day, 1, '#q_Fechas.Fin#')
	and A.CRCCuentasid = #form.id#
	group by 
		C.id,
		ct.Codigo,
		A.TipoMov
	order by ct.Codigo
		<!---
		select 
				A.Cliente
			,	A.id
			,	A.CURP
			,	A.Observaciones
			,	A.TipoTransaccion
			,	A.TipoMov
			,	convert(date,A.fecha) as Fecha
			,	A.Parciales
			,	A.Monto
		from CRCTransaccion A
		where 
		<cfif trim(rsCuenta.Tipo) eq 'TM'>
			convert(date,A.fecha) between #date_ini# and #date_fin#
		<cfelse>
			convert(date,A.fecha) < dateAdd(day, 1, '#q_Fechas.Fin#')
		</cfif>
			and A.CRCCuentasid = #form.id#
		--->	
</cfquery>

<cfif trim(rsCuenta.Tipo) eq 'TM'>
	<cfquery name="q_Cortes" dbtype="query">
		select distinct Fecha as Codigo from q_Transacciones
		order by Fecha desc;
	</cfquery>
</cfif>

<cfquery name="q_TipoMov" datasource="#session.DSN#">
	select  distinct(A.TipoMov) tipomov from CRCTransaccion A
	where A.Fecha between '#q_Fechas.Inicio#' and '#q_Fechas.Fin#'
	and A.CRCCuentasid = #form.id#
</cfquery>
<script>

	<cfoutput> var #toScript(rsCuenta.Tipo,'tipoCuenta')# </cfoutput>
	<cfoutput> var #toScript(q_Cortes,'cortesJSON')# </cfoutput>
	<cfoutput> var #toScript(q_TipoMov,'TipoMovJSON')# </cfoutput>
	<cfoutput> var #toScript(q_Transacciones,'transaccionJSON')# </cfoutput>

	var chartData1 = {};
	var chartDataSet1 = {};
	var chartDataSeries1 = [];
	var chartDataSeries1 = [];
	var listaCodigos = (cortesJSON.codigo) ? cortesJSON.codigo : [];
	var listaFechaFin = (cortesJSON.fechafin) ? cortesJSON.fechafin : [];
	var listaFechaInicio = (cortesJSON.fechainicio) ? cortesJSON.fechainicio : [];

	function WddxRecordset() {}

	function obtenerValorFecha(parametro) {
		return (parametro < 10) ? '0' + parametro : parametro;
	}

	function obtenerFechaConFormato(fechaSinFormato) {
		var fecha = new Date(fechaSinFormato);
		return obtenerValorFecha(fecha.getDate()) + '/' 
			+ obtenerValorFecha((fecha.getMonth() + 1)) + '/' + fecha.getFullYear();
	}

	for(var i = listaCodigos.length - 1; i >= 0; i--) {

		var codigo = listaCodigos[i];
		var indice = (tipoCuenta == 'TM') ? obtenerFechaConFormato(codigo) : codigo;

		chartData1[indice] = {
			'fin': (tipoCuenta == 'TM') ? codigo : listaFechaFin[i],
			'inicio': (tipoCuenta == 'TM') ? codigo : listaFechaInicio[i]
		};
	}

	for(var j in chartData1) {

		for(var i = 0; i < TipoMovJSON.tipomov.length; i++) {
			chartData1[j][TipoMovJSON.tipomov[i]] = 0;
		}
	}

	for(var j in chartData1) {

		for(var i = 0; i < transaccionJSON.codigo.length; i++) {
			if (j == transaccionJSON.codigo[i]){
				chartData1[j][transaccionJSON.tipomov[i]] = chartData1[j][transaccionJSON.tipomov[i]] || 0;
				chartData1[j][transaccionJSON.tipomov[i]] += transaccionJSON.monto[i];
			}else{
				chartData1[j]['C'] = chartData1[j]['C'] || 0;
				chartData1[j]['C'] += 0;
			}
			/*for(var j in chartData1){
				if(transaccionJSON.fecha[i] <= chartData1[j].fin && transaccionJSON.fecha[i] >= chartData1[j].inicio) {
						chartData1[j][transaccionJSON.tipomov[i]] = chartData1[j][transaccionJSON.tipomov[i]] || 0;
						chartData1[j][transaccionJSON.tipomov[i]] += transaccionJSON.monto[i];
				}
			}*/
		}
	}
	
	for(var i = 0; i < listaCodigos.length; i++) {
		if( chartData1[ listaCodigos[i]].C != 0 || chartData1[ listaCodigos[i]].D != 0 ){
			for(var j=0; j < TipoMovJSON.tipomov.length; j++) {
				var t = TipoMovJSON.tipomov[j];
				chartDataSet1[t] = chartDataSet1[t] || [];
				chartDataSet1[t].push(chartData1[listaCodigos[i]][t]);
			}	
		} else {
			for(var j=0; j < TipoMovJSON.tipomov.length; j++) {
				var t = TipoMovJSON.tipomov[j];
				chartDataSet1[t] = chartDataSet1[t] || [];
				chartDataSet1[t].push(0);
			}	
		}
		
	}
	
	for(var i in chartDataSet1) {
		var setname = (i == 'C') ?'Cargos' : 'Abonos';
		chartDataSeries1.push({name: setname, data: chartDataSet1[i]});
	}
</script>

<cfoutput>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr width="100%">
			<td width="100%" align="center">
				<cfif q_Transacciones.recordCount gt 0>
					<div width="100%" id="chart1">
				<cfelse>
					<font color="red"><b>&emsp;No existen transacciones registradas para este cliente</b></font>
				</cfif>
			</td>
		</tr>
	</table>
</cfoutput>

<script>
	$(function () {
		$(document).ready(function () {
			$('#chart1').highcharts({
				chart: { type: 'column' },
				title: { text: 'Cargos y Abonos del Corte' },
				subtitle: { text: '' },
				yAxis: {
					title: {
						text: 'Monto'
					}
				},
				xAxis: {
					title: {
					<cfif trim(rsCuenta.Tipo) eq 'TM'>
						text: 'Fecha'
					<cfelse>
						text: 'Corte'
					</cfif>	
					},
					categories: listaCodigos //Object.keys(chartData1)
				},
				legend: { layout: 'vertical', align: 'right', verticalAlign: 'middle' },
				plotOptions: {
					series: {
						label: {
							connectorAllowed: false
						},
						//pointStart: 2010
					}
				},
				series: chartDataSeries1,
				responsive: {
					rules: [{
						chartOptions: {
							legend: { layout: 'horizontal', align: 'center', verticalAlign: 'bottom' }
						}
					}]
				}
			});
		});
	});
</script>