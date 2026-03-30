<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cfif isdefined("Url.RHIAid") and Len(Trim(Url.RHIAid))>
			<cfparam name="Form.RHIAid" default="#Url.RHIAid#">
		</cfif>
	
		<cfset filtro = "Ecodigo = #Session.Ecodigo#">
		<cfset adicionalCols = "">
		<cfset navegacion = "">
		<cfset filtro = filtro & "order by RHTAcodigo">

	  <cfinvoke component="sif.Componentes.TranslateDB"
		method="Translate"
		VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
		Default="Incidencias Reporte Aguinaldo"
		VSgrupo="103"
		returnvariable="nombre_proceso"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Concepto_Incidente"
		Default="Concepto Incidente"
		returnvariable="LB_Concepto"/>	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Comportamiento"
		Default="Comportamiento"
		returnvariable="LB_Comportamiento"/>	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Excluir"
		Default="Excluir"
		returnvariable="LB_Excluir"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Aplicar_factor"
		Default="Aplicar factor"
		returnvariable="LB_AplicarFactor"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Factor"
		Default="Factor"
		returnvariable="LB_Factor"/>

		<cf_web_portlet_start titulo="#nombre_proceso#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif''>" >
			<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif''>" >
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr> 
					<td width="50%" valign="top">
 						<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="RHIncidenciasAguinaldo ia, CIncidentes ci"/>
							<cfinvokeargument name="columnas" value="ia.RHIAid, 
																	 ia.CIid, 
																	 {fn concat({fn concat(ci.CIcodigo, '-' )}, ci.CIdescripcion)} as concepto, 
																	 case ia.RHIAexcluir when 1 then '#preservesinglequotes(checked)#' else '#preservesinglequotes(unchecked)#'end as RHIAexcluir, 
																	 case ia.RHIAaplicarFactor when 1 then '#preservesinglequotes(checked)#' else '#preservesinglequotes(unchecked)#'end as RHIAaplicarFactor"/>
							<cfinvokeargument name="desplegar" value="concepto,RHIAexcluir,RHIAaplicarFactor"/>
							<cfinvokeargument name="etiquetas" value="#LB_Concepto#,#LB_Excluir#,#LB_AplicarFactor#"/>
							<cfinvokeargument name="formatos" value="V,V,V"/>
							<cfinvokeargument name="filtro" value="ci.CIid=ia.CIid and ci.Ecodigo=#session.Ecodigo#"/>
							<cfinvokeargument name="align" value="left, center,center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="IncidenciasAguinaldo.cfm"/>
							<cfinvokeargument name="keys" value="RHIAid"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="maxRows" value="20"/>
						</cfinvoke>
					</td>
 					<td width="50%" valign="top">
						<cfinclude template="IncidenciasAguinaldo-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>

