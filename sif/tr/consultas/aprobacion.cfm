<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_AprobacionDeTramites"
Default="Aprobaci&oacute;n de Tr&aacute;mites"
returnvariable="LB_AprobacionDeTramites"/> 

<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkload" returnvariable="workload">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>
<cf_templateheader title = "#LB_AprobacionDeTramites#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_AprobacionDeTramites#">
		<cfinclude template="lista_actividades.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>
