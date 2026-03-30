<cf_templateheader title="Revisar bitácora">
<cfinclude template="../mapa.cfm">
<cf_web_portlet_start titulo="Revisar bitácora" width="700">

	<cfset Request.continuar = 'ejecuta.cfm'>
	<cfinclude template="../ver-log.cfm">

<cf_web_portlet_end>
<cf_templatefooter>
