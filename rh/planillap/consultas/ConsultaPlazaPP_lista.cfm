<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="Planificación de Jornadas" border="true" skin="#Session.Preferences.Skin#">
		
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
				ira="~ConsultaPlazaPP_linfo.cfm"
				maxrows="20"
				showemptylistmsg="true"
			/>		
						
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>