<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Otras Partidas'>
		<table width="100%" border="0" cellspacing="0">
		  <tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		  <tr>
			<td valign="top">		
				<cfinvoke 
					component="rh.Componentes.pListas" 
					method="pListaRH"
					returnvariable="rsLista"
					columnas="RHPOPid,CPdescripcion,CPformato"
					etiquetas="Descripci&oacute;n,Formato"
					tabla="RHPOtrasPartidas "
					keys="RHPOPid"
					filtro="Ecodigo=#Session.Ecodigo#"
					mostrar_filtro="true"
					filtrar_automatico="true"
					desplegar="CPdescripcion,CPformato"
					filtrar_por="CPdescripcion,CPformato"
					align="left,left"				
					formatos="S,S"
					ira="RHPOtrasPartidas.cfm"
					maxrows="20"
					showemptylistmsg="true"
				/>		
			</td>
			<td valign="top"  width="55%">
				<cfinclude template="RHPOtrasPartidas-form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>



