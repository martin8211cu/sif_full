<cfinvoke component="sif.Componentes.Workflow.Management" method="getOpenProcessesByRequester" returnvariable="workload">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ProgresoDeTramitesSolicitados"
	Default="Progreso de Tr&aacute;mites Solicitados"
	returnvariable="LB_ProgresoDeTramitesSolicitados"/> 
	
<cf_templateheader title="#LB_ProgresoDeTramitesSolicitados#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ProgresoDeTramitesSolicitados#">
			<cfinclude template="lista_actividades.cfm">
		</<cf_web_portlet_end>
<cf_templatefooter>
