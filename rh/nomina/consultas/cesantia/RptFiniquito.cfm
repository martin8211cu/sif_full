<!--- OPARRALES 2019-01-23
	- Reporte para mostrar conceptos aplicables en Liquidacion/Finiquitos
	- Filtrados por Empleado y/o Fecha de cesantia.
 --->

<cfinvoke key="LB_Finiquitos" default="Reporte de Finiquito" xmlfile="/rh/RptFiniquitos.xml" returnvariable="LB_Finiquitos" component="sif.Componentes.Translate" method="Translate"/>

<cf_templateheader title="#LB_Finiquitos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" titulo="LB_Finiquitos">
			<cfinclude template="RptFiniquito_form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>