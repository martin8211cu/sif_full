<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha Desde"
	returnvariable="LB_FechaDesde"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="LB_FechaHasta"/>		
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Escenarios">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<cfoutput>
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="RHEid,RHEdescripcion,RHEfdesde,RHEfhasta"
					etiquetas="#LB_Descripcion#,#LB_FechaDesde#,#LB_FechaHasta#"
					tabla="RHEscenarios"
					keys="RHEid"
					filtro="Ecodigo=#Session.Ecodigo# and RHEestado='P'"
					mostrar_filtro="true"
					filtrar_automatico="true"
					desplegar="RHEdescripcion,RHEfdesde,RHEfhasta"
					filtrar_por="RHEdescripcion,RHEfdesde,RHEfhasta"
					align="left,left,left"
					botones="Nuevo"
					formatos="S,D,D,D"
					ira="TrabajarEscenario.cfm"
					maxrows="20"
					showemptylistmsg="true"
				/>
				</cfoutput>
			</td>
		  </tr>
		  <tr><td>&nbsp;</td></tr>
		</table>		
	<cf_web_portlet_end>
<cf_templatefooter>	


