<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Tabla Salarial'>
		<table width="100%" border="0" cellspacing="0">
		  <tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		  <tr>
			<td valign="top">		
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="RHTTid,RHTTcodigo,RHTTdescripcion"
					etiquetas="C&oacute;digo,Descripci&oacute;n"
					tabla="RHTTablaSalarial"
					keys="RHTTid"
					filtro="Ecodigo=#Session.Ecodigo# order by RHTTcodigo, RHTTdescripcion"
					mostrar_filtro="true"
					filtrar_automatico="true"
					desplegar="RHTTcodigo,RHTTdescripcion"
					filtrar_por="RHTTcodigo,RHTTdescripcion"
					align="left,left"				
					formatos="S,S"
					ira="RHTTablaSalarial.cfm"
					maxrows="20"
					showemptylistmsg="true"
				/>		
			</td>
			<td valign="top"  width="55%">
				<cfinclude template="RHTTablaSalarial-form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


