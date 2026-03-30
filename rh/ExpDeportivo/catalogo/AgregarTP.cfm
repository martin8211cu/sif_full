																
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Roles_de_Persona"
Default="Roles de Persona"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="LB_Roles_de_Persona"/>

<cf_web_portlet_start titulo="#LB_Roles_de_Persona#">
	<cfinclude template="../catalogo/RolPersona-form.cfm">
<cf_web_portlet_end>
