<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Clasificaci&oacute;n de Conceptos de Servicio'>
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfinclude template="formatos-form.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>