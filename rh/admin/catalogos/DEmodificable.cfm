<cfinvoke Key="LB_DatosEmpleadoModificables" Default="Datos de Empleado Modificables" XmlFile="/rh/generales.xml" returnvariable="LB_DatosEmpleadoModificables" component="sif.Componentes.Translate" method="Translate"/>

<cf_templateheader title="#LB_DatosEmpleadoModificables#"> 
 <cf_web_portlet_start border="true" titulo="#LB_DatosEmpleadoModificables#" skin="#Session.Preferences.Skin#">
 		<cfinclude template="DEmodificable_form.cfm">
  <cf_web_portlet_end>
<cf_templatefooter>
	