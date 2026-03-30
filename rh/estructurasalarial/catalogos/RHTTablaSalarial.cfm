<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Codigo" Default="Código" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripción" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion"/>

<cf_templateheader  template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center"  >
		<table width="100%" border="0" cellspacing="0">
		  <tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		  <tr>
			<td valign="top">	
				<cf_translatedata name="get" col="RHTTdescripcion" tabla="RHTTablaSalarial"	returnvariable="LvarRHTTdescripcion">
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="RHTTid,RHTTcodigo,#LvarRHTTdescripcion# as RHTTdescripcion"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					tabla="RHTTablaSalarial"
					keys="RHTTid"
					filtro="Ecodigo=#Session.Ecodigo# order by RHTTcodigo, RHTTdescripcion"
					mostrar_filtro="true"
					filtrar_automatico="true"
					desplegar="RHTTcodigo,RHTTdescripcion"
					filtrar_por="RHTTcodigo,RHTTdescripcion"
					align="left,left"				
					formatos="S,S"
					translatedatacols="RHTTdescripcion"
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


