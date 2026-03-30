																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Tipo_de_Equipo"
Default="Tipo de Equipo"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Tipo_de_Equipo"/>

<cf_web_portlet_start titulo="#LB_Tipo_de_Equipo#">
	<cfinclude template="../catalogo/TiposEquipo-form.cfm">
<cf_web_portlet_end>