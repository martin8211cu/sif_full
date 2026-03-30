																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_EquipoDivision"
Default="EquipoDivision"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_EquipoDivision"/>

<cf_web_portlet_start titulo="#LB_EquipoDivision#">
	<cfinclude template="../catalogo/equipo-division-form.cfm">
<cf_web_portlet_end>