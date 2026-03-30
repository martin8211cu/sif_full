<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CursosPorCompetencia"
	Default="Cursos por Competencia"
	returnvariable="LB_CursosPorCompetencia"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">

	<cf_web_portlet_start border="true" titulo="#LB_CursosPorCompetencia#" skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td valign="top" width="50%"><cfinclude template="ListaConocimientos.cfm"></td>
				<td valign="top"><cfinclude template="SeleccionMaterias.cfm"></td>
		  	</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>