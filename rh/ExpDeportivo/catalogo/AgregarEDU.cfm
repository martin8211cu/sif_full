																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Unidades_de_Medida"
Default="Unidades de Medida"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Unidades_de_Medida"/>

<cf_web_portlet_start titulo="#LB_Unidades_de_Medida#">
	<cfinclude template="../catalogo/formUnidades.cfm">
<cf_web_portlet_end>