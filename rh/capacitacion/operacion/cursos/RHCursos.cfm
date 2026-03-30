<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MantenimientoDeRHCursos"
	Default="Mantenimiento de RHCursos"
	returnvariable="LB_MantenimientoDeRHCursos"/>
<!--- FIN VARIABLES DE TRADUCCION --->

﻿<cf_templateheader title="Cursos">
	<cf_web_portlet_start titulo="#LB_MantenimientoDeRHCursos#">
	<table width="100%" border="0" cellspacing="6">
		<tr>
	    	<td valign="top">
				<cfquery datasource="#session.dsn#" name="lista">
					select RHCid
					from RHCursos
					<!--- falta el where --->
				</cfquery>
				<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar="RHCid"
					etiquetas="id de Curso"
					formatos="S"
					align="left"
					ira="RHCursos.cfm"
					form_method="get"
					keys="RHCid"
				/>		
		</td>
    	<td valign="top"><cfinclude template="RHCursos-form.cfm"></td>
	</tr>
</table>
<cf_templatefooter	>


