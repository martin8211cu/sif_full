<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Categor&iacute;as de Pago'>
		<table width="100%" border="0" cellspacing="0">
		  <tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		  <tr>
			<td valign="top">		
				<cfinclude template="RHCategoriaArbol.cfm">	
			</td>
			<td valign="top"  width="55%">
				<cfinclude template="RHCategoria-form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


