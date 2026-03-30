																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Tipo_de_Expediente"
Default="Tipo de Expediente"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Tipo_de_Expediente"/>

<cf_web_portlet_start titulo="#LB_Tipo_de_Expediente#">
	<cfinclude template="../catalogo/formTiposExpediente.cfm">
<cf_web_portlet_end>
