	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Plazas Presupuestarias">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<cfinvoke 
						component="rh.Componentes.pListas" 
						method="pListaRH"
						returnvariable="rsLista"
						columnas="RHPPid,RHPPcodigo,RHPPdescripcion"
						etiquetas="C&oacute;digo,Descripci&oacute;n"
						tabla="RHPlazaPresupuestaria"
						keys="RHPPid"
						filtro="Ecodigo=#Session.Ecodigo# Order by RHPPcodigo, RHPPdescripcion"
						mostrar_filtro="true"
						filtrar_automatico="true"
						desplegar="RHPPcodigo,RHPPdescripcion"
						filtrar_por="RHPPcodigo,RHPPdescripcion"
						align="left,left"
						botones="Nuevo"
						formatos="S,S"
						ira="RHPlazaPres.cfm"
						maxrows="20"
						showemptylistmsg="true"
					/>		
				</td>
			  </tr>
			</table>		
		<cf_web_portlet_end>
	<cf_templatefooter>
