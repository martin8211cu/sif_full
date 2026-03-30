<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#"
	Default="Recursos Humanos"
	VSgrupo="103"
	returnvariable="nombre_sistema"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#"
	Default="Capacitaci&oacute;n y Desarrollo"
	VSgrupo="103"
	returnvariable="nombre_modulo"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Horas de Capacitaci&oacute;n por Centro Funcional"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Horas_de_Capacitacion_por_Centro_Funcional"
	Default="Horas de Capacitacion por Centro Funcional"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_titulo_grafico"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"	
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Centro_Funcional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Horas"
	Default="Horas"	
	returnvariable="LB_Horas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consultar_Empleados"
	Default="Consultar Empleados"	
	returnvariable="LB_Consultar_Empleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MGS_FinDelReporte"
	Default="Fin del Reporte"
	xmlfile="/rh/generales.xml"		
	returnvariable="LB_Fin_del_Reporte"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeEncontraronRegistros"
	Default="No se encontraron registros"
	xmlfile="/rh/generales.xml"		
	returnvariable="LB_no_hay_datos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	xmlfile="/rh/generales.xml"		
	returnvariable="LB_Empleado"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"
	xmlfile="/rh/generales.xml"		
	returnvariable="LB_Identificacion"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"	
	returnvariable="BTN_Consultar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>

<cf_web_portlet_start titulo="#nombre_proceso#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<!---<cf_rhimprime datos="/rh/capacitacion/consultas/BaseEntrenamiento/baseEntrenam-form.cfm" paramsuri="?DEid=#DEid#">--->

	<cfinclude template="horascap-form.cfm">

<cf_web_portlet_end>
<cf_templatefooter>