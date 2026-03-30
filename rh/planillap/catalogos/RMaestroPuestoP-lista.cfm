<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Maestro de Puestos Presupuestarios">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="RHMPPid,RHMPPcodigo,RHMPPdescripcion"
					etiquetas="C&oacute;digo,Descripci&oacute;n"
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
					ira="RHMaestroPuestos.cfm"
					maxrows="20"
					showemptylistmsg="true"
				/>		
			</td>
		  </tr>
		</table>		
	<cf_web_portlet_end>
<cf_templatefooter>	
