																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Equipos"
Default="Equipos"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Equipos"/>

<cf_web_portlet_start titulo="#LB_Equipos#">
	<cfinclude template="../Proyecto/equipos-form.cfm">
<cf_web_portlet_end>