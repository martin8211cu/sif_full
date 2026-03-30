<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start titulo="Consulta de Plazas Presupuestarias " border="true" skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfinvoke 
			component="rh.Componentes.pListas" 
			method="pListaRH"
			returnvariable="rsLista"
			columnas="RHPPid,RHPPcodigo,RHPPdescripcion"
			etiquetas="C&oacute;digo,Descripci&oacute;n"
			tabla="RHPlazaPresupuestaria"
			keys="RHPPid"
			filtro="Ecodigo=#Session.Ecodigo# order by RHPPcodigo, RHPPdescripcion"
			mostrar_filtro="true"
			filtrar_automatico="true"
			desplegar="RHPPcodigo,RHPPdescripcion"
			filtrar_por="RHPPcodigo,RHPPdescripcion"
			align="left,left"				
			formatos="S,S"
			ira="ConsultaPlazaPP_linfo.cfm"
			maxrows="20"
			showemptylistmsg="true"
		/>		
	<cf_web_portlet_end>
<cf_templatefooter>	



