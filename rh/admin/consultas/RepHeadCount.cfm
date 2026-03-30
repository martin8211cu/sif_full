<!--- 	VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteHEADCOUNT"
	Default="Reporte HEAD COUNT"
	returnvariable="LB_ReporteHEADCOUNT"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ReporteHEADCOUNT#'>		
		<!--- Inicia el pintado de la pantalla --->
		<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="40%" valign="top"><cfinclude template="RepHeadCount-Arbol.cfm"></td>
					<td width="60%" valign="top"><cfinclude template="RepHeadCount-Form.cfm"></td>
				</tr>
			</table>
	 	</cfoutput>
		<!--- Finaliza el pintado de la pantalla --->
	<cf_web_portlet_end>
<cf_templatefooter>
