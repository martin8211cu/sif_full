<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
﻿	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Calificaciones por Colaborador'>
							
			<cfset navBarItems[1]  = "Calificaciones del Empleado">
			<cfset navBarLinks[1]  = "/cfmx/home/menu/pNavegacion.cfm">
			<cfset navBarStatusText[1]  = "Calificaciones del Empleado">
			
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<form name="form1" id="form1">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="center" colspan="2" nowrap>
							<font size="+2"><cf_translate key="LB_CalificacionesPorColaborador">Calificaciones por Colaborador</cf_translate></font>
						</td>
				  	</tr>
				  	<tr>
						<td align="center"><cf_translate key="SeleccioneLaRelacionQueDeseaImprimir">Seleccione la relaci&oacute;n que desea imprimir</cf_translate></td>
				  	</tr>
				  	<tr><td>&nbsp;</td></tr>
				  	<tr>
					<td  align="center">
						<strong><cf_translate key="LB_Formato">Formato</cf_translate>:</strong>
						<select name="format" id="format">
							<option value="html"><cf_translate key="LB_EnLineaHTML">En l&iacute;nea (HTML)</cf_translate></option>
							<option value="pdf"><cf_translate key="LB_AdobePDF">Adobe PDF</cf_translate></option>
						</select>
						
					</td>
					<td  align="center">
						<cfoutput>
							<strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong>
							<cf_rhcfuncional  id="id_centro" tabindex="1">
						</cfoutput>
					</td>
				  </tr>
				</table>
			</form>
			<!--- VARIABLES DE TRADUCCION --->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Fecha"
				Default="Fecha"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Fecha"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripción"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Descripcion"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_NOSEHAREGISTRADONINGUNAEVALUACION"
				Default="NO SE HA REGISTRADO NINGUNA EVALUACION"
				returnvariable="MSG_NOSEHAREGISTRADONINGUNAEVALUACION"/>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3">
						<cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaRH"
							 returnvariable="pListaRHRet">
								<cfinvokeargument name="tabla" value="RHEEvaluacionDes a"/>
								<cfinvokeargument name="columnas" value="a.RHEEid, a.RHEEdescripcion, convert(varchar,a.RHEEfecha,103) as RHEEfecha "/>
								<cfinvokeargument name="desplegar" value="RHEEdescripcion, RHEEfecha "/>
								<cfinvokeargument name="etiquetas" value="#LB_Descripcion#,#LB_Fecha#"/>
								<cfinvokeargument name="formatos" value="S, S"/>
								<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# and a.RHEEestado in (3)"/>
								<cfinvokeargument name="align" value="left, center"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="funcion" value="reporte"/>
								<cfinvokeargument name="fparams" value="RHEEid"/>
								<cfinvokeargument name="checkboxes" value="N">
								<cfinvokeargument name="showEmptyListMsg" value="true">
								<cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOSEHAREGISTRADONINGUNAEVALUACION# ***">
					  </cfinvoke>
					</td>
				</tr>
			
				
			</table>
			<script type="text/javascript">
				function reporte(RHEEid){
					location.href='calificaciones-rep.cfm?format='+document.form1.format.value+'&RHEEid='+RHEEid+'&id_centro='+document.form1.id_centro.value;
				}
			</script>
		<cf_web_portlet_end>	
<cf_templatefooter>