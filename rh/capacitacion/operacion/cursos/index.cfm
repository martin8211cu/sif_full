<cfinclude template="url_params.cfm">
﻿<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ProgramacionDeCursos"
	Default="Programaci&oacute;n de Cursos"
	returnvariable="LB_ProgramacionDeCursos"/>
<!--- FIN VARIABLES DE TRADUCCION --->

﻿<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start titulo="#LB_ProgramacionDeCursos#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<table width="100%">
			<tr>
				<td align="left" valign="top" width="50%">
					<cfinclude template="lista.cfm">
				</td>
				<td width="50%" align="left" valign="top">  
					<cfif Len(url.RHCid)>
						<cfinclude template="RHCursos-form.cfm">
					<cfelse>
						<cfinclude template="buscar.cfm">
					</cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
