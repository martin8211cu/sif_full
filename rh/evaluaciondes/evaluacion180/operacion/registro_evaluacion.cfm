<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/evaluaciondes/evaluacion180/operacion/registro_evaluacion.xml"
	returnvariable="LB_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	XmlFile="/rh/evaluaciondes/evaluacion180/operacion/registro_evaluacion.xml"
	returnvariable="LB_Estado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CantidadEmpleados"
	Default="Cantidad de Empleados"
	XmlFile="/rh/evaluaciondes/evaluacion180/operacion/registro_evaluacion.xml"
	returnvariable="LB_CantidadEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeRelacionesDeEvaluacionDelDesempenoDeJefaturas"
	Default="Registro de Relaciones de Evaluaci&oacute;n del Desempeño de Jefaturas"
	returnvariable="LB_RegistroDeRelacionesDeEvaluacionDelDesempenoDeJefaturas"/>


<cfif isdefined("url.REid") and not isdefined("form.REid")>
	<cfset form.REid = url.REid >	
</cfif>
<cfif isdefined("url.sel") and not isdefined("form.sel")>
	<cfset form.sel = url.sel >
</cfif>

	﻿<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		
		<cfinclude template="registro_evaluacion_params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" titulo="#LB_RegistroDeRelacionesDeEvaluacionDelDesempenoDeJefaturas#" skin="#Session.Preferences.Skin#">
						<cfparam name="form.sel" default="1" type="numeric">
						<cfif (form.sel gt 0) and (isdefined("form.Nuevo") or (isdefined("form.REid") and len(trim(form.REid)) gt 0))>
							<cfinclude template="../../../portlets/pNavegacion.cfm">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="2%" rowspan="3">&nbsp;</td>
									<td width="74%">&nbsp;</td>
									<td width="2%">&nbsp;</td>
									<td width="20%">&nbsp;</td>
									<td width="2%" rowspan="3">&nbsp;</td>
								</tr>
								<tr>
									<td valign="top" align="center">
										<cfinclude template="registro_evaluacion_header.cfm">
										<cfswitch expression="#sel#">						
											<cfcase value="1"><cfinclude template="registro_evaluacion_form.cfm"></cfcase>
											<cfcase value="2"><cfinclude template="registro_evaluacion_indicaciones.cfm"></cfcase>	
											<cfcase value="3"><cfinclude template="conceptos_evaluacion.cfm"></cfcase>											
											<cfcase value="4"><cfinclude template="registro_evaluacion_grupos.cfm"></cfcase>
											<cfcase value="5"><cfinclude template="listaEmpl_evaluacion.cfm"></cfcase>
											<cfcase value="6"><cfinclude template="GeneraEmpl_evaluacion.cfm"></cfcase>
											<cfcase value="7"><cfinclude template="registro_evaluacion_publicar.cfm"></cfcase>
										</cfswitch>
									</td>
									<td>&nbsp;</td>
									<td valign="top" align="center">
										<cfinclude template="registro_evaluacion_pasos.cfm">
										<cfif isdefined("EVAL_RIGHT")>
											<br><cfoutput>#EVAL_RIGHT#</cfoutput>
										</cfif>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
						<cfelse>
							<cfinclude template="../../../portlets/pNavegacion.cfm"><br>
							<cfinclude template="registro_evaluacion_filtro.cfm"><br>
							<cfinclude template="registro_evaluacion_lista.cfm">
						</cfif>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>