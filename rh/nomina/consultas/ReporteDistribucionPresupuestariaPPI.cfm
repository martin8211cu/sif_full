
<cfset t = createObject("component", "sif.Componentes.Translate")>

<!--- Etiquetas de traduccion --->
<cfset LB_TotalGanado = t.translate('LB_TotalGanado','Total Ganado')>
<cfset MSG_TipoNomina = t.translate('MSG_TipoNomina','Debe seleccionar el tipo de nómina que desea agregar a la consulta')>
<cfset MSG_CalendarPagos = t.translate('MSG_CalendarPagos','Debe seleccionar el calendario de pago que desea agregar a la consulta')>
<cfset MSG_FechaDesde = t.translate('MSG_FechaDesde','Debe seleccionar la fecha inicial del rango de la consulta')>
<cfset MSG_FechaHasta = t.translate('MSG_FechaHasta','Debe seleccionar la fecha final del rango de la consulta')>
<cfset MSG_NominaSelect = t.translate('MSG_NominaSelect','Debe seleccionar al menos una nómina y un calendario de pagos para realizar esta acción')>

<cf_templateheader> 
	<cf_web_portlet_start>
		<div class="row">
			<div class="col-sm-10 col-sm-offset-2">
				<cfinclude template="ReporteDistribucionPresupuestariaPPI-form.cfm">
			</div>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>