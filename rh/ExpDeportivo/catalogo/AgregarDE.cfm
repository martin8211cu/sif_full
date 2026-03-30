																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Divisiones"
Default="Divisiones"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Divisiones"/>

<cf_web_portlet_start titulo="#LB_divisiones#">
	<cfinclude template="/rh/ExpDeportivo/catalogo/DivisionEquipo-form.cfm">
<cf_web_portlet_end>