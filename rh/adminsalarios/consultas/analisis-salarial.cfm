<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<!--- FIN VARIABLES DE TRADUCCION --->
﻿<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinclude template="analisis-salarial-form.cfm">
<cf_templatefooter>
