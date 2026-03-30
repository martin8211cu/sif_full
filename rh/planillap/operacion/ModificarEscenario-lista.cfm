<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_FechaDesde" Default="Fecha Desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_FechaHasta" Default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_NohayRegistros" Default="No hay Escenarios aprobados" returnvariable="LB_NohayRegistros" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="Modificaci&oacute;n de Escenarios" VSgrupo="103" returnvariable="nombre_proceso"/>
<!--- FIN VARIABLES DE TRADUCCION --->	
<cf_templateheader title="#nombre_proceso#" template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#nombre_proceso#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<cfoutput><!--- and RHEestado='V' --->
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="RHEid,RHEdescripcion,RHEfdesde,RHEfhasta"
					etiquetas="#LB_Descripcion#,#LB_FechaDesde#,#LB_FechaHasta#"
					tabla="RHEscenarios"
					keys="RHEid"
					filtro="Ecodigo=#Session.Ecodigo# and RHEestado = 'A'"
					mostrar_filtro="true"
					filtrar_automatico="true"
					desplegar="RHEdescripcion,RHEfdesde,RHEfhasta"
					filtrar_por="RHEdescripcion,RHEfdesde,RHEfhasta"
					align="left,left,left"
					formatos="S,D,D,D"
					ira="ModificarEscenario-form.cfm"
					maxrows="20"
					showemptylistmsg="true"
                    EmptyListMsg="#LB_NohayRegistros#"
                    />
				</cfoutput>
			</td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		</table>		
	<cf_web_portlet_end>
<cf_templatefooter>	


