<cfinvoke key="LB_Titulo" default="Solicitudes de Pago a Aprobar"	returnvariable="LB_Titulo"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="solicitudesAprobar.xml"/>

<cfset titulo = '#LB_Titulo#'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cf_SP_lista aprobacionSP="yes" ParentEntrancePoint="Aprobar" irA="solicitudesAprobar.cfm">
<cf_web_portlet_end>
