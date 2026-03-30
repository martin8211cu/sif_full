																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Personas"
Default="Personas"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Personas"/>

<cf_web_portlet_start titulo="#LB_Personas#">
	<cfinclude template="../usuarios/persona-lista.cfm">
<cf_web_portlet_end>
