<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_EvaluacionDelDesempeno"
			Default="Evaluaci&oacute;n del Desempe&ntilde;o"
			returnvariable="LB_EvaluacionDelDesempeno"/>
			
		<cf_web_portlet_start titulo="#LB_EvaluacionDelDesempeno#">
			<cfinclude template="/rh/evaluaciondes/indexEvalDesempenoCont.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>