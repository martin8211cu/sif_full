<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Código" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripción" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>

<cf_templateheader template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<cf_translatedata name="get" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" returnvariable="LvarRHMPPdescripcion">
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="RHMPPid,RHMPPcodigo,#LvarRHMPPdescripcion# as RHMPPdescripcion"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					tabla="RHMaestroPuestoP"
					keys="RHMPPid"
					filtro="Ecodigo=#Session.Ecodigo# Order by RHMPPcodigo, RHMPPdescripcion"
					mostrar_filtro="true"
					filtrar_automatico="true"
					desplegar="RHMPPcodigo,RHMPPdescripcion"
					filtrar_por="RHMPPcodigo,RHMPPdescripcion"
					align="left,left"
					botones="Nuevo"
					formatos="S,S"
					translatedatacols="RHMPPdescripcion"
					ira="RHMaestroPuestos.cfm"
					maxrows="20"
					showemptylistmsg="true"
				/>		
			</td>
		  </tr>
		</table>		
	<cf_web_portlet_end>
<cf_templatefooter>	
