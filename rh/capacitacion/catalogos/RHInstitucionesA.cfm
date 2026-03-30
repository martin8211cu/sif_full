<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MantenimientoDeInstitucionesAcademicas"
	Default="Mantenimiento de Instituciones Acad&eacute;micas"
	returnvariable="LB_MantenimientoDeInstitucionesAcademicas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Institucion"
	Default="Instituci&oacute;n"
	returnvariable="LB_Institucion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<!--- FIN VARIABLES DE TRADUCCION --->
﻿<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_web_portlet_start border="true" titulo="#LB_MantenimientoDeInstitucionesAcademicas#" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellspacing="6">
				<tr>
					<td valign="top" width="50%">
					
					<table width="100%" border="0" cellspacing="6">
				</tr>
				
				<tr>

				<cfset filtro = "Ecodigo = #Session.Ecodigo#">	              
				<cfset filtro = filtro & "order by RHIAcodigo">    
				
				<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet"
						tabla="RHInstitucionesA"
						columnas="RHIAid,RHIAcodigo,RHIAnombre"
						desplegar="RHIAcodigo,RHIAnombre"
						etiquetas="#LB_Codigo#,#LB_Institucion#"
						formatos="S,S"
						filtro="#filtro#"
						align="left, left"
						form_method="get"
						ajustar="N,N"
						checkboxes="N"
						MaxRows="10"
						filtrar_automatico="true"
						mostrar_filtro="true"												
						keys="RHIAid"
						irA="RHInstitucionesA.cfm"
						showEmptyListMsg="true">
					</cfinvoke>
						
					<td valign="top" width="50%">
						<cfinclude template="RHInstitucionesA-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>


