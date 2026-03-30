<cfinvoke component="sif.Componentes.Workflow.Management" method="getOpenProcessesBySubject" returnvariable="workload">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConsultaDeTramitePendientes"
	Default="X Consulta de Tr&aacute;mites Pendientes"
	returnvariable="LB_ConsultaDeTramitePendientes"/>

<cf_templateheader title="#LB_ConsultaDeTramitePendientes#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" 
				tituloalign="center" titulo="#LB_ConsultaDeTramitePendientes#">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cfinclude template="lista_actividades.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>
