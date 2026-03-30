<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RegistroDePlanDeAccion"
Default="Registro de Plan de Acción"
returnvariable="LB_RegistroDePlanDeAccion"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
	
<cfif isdefined("form.PROCESAR")>
	<cfquery name="rsRHEEvaluacionDes" datasource="#session.DSN#">
		select RHEEid, RHEEdescripcion, RHEEfdesde as inicio, RHEEfhasta as fin
		from RHEEvaluacionDes
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and RHEEestado=3
		 and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
	</cfquery>

	<cfquery name="rsRHListaEvalDes" datasource="#session.DSN#">
		select  RHLEobservacion
		from RHListaEvalDes
		where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
		and DEid =     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>
﻿<cf_templateheader title="#LB_RecursosHumanos#">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_RegistroDePlanDeAccion#">
				<form name="form1" method="post" action="RegistroPlanAccion.cfm" style="margin:0; " onSubmit="javascript: return validardatos();">
				<cfoutput>
				<cfif isdefined ('form.DEID') and len(trim(form.DEID)) gt 0>
				<input type="hidden" name="DEID" id="DEID" value="#form.DEID#">
				</cfif>
				<cfif isdefined ('form.RHEEID') and len(trim(form.RHEEID)) gt 0>
				<input type="hidden" name="RHEEID" id="RHEEID" value="#form.RHEEID#">
				</cfif>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td width="5%">&nbsp;</td>
						<td width="30%" align="center" valign="top">
							<cf_web_portlet_start border="true" titulo="#LB_RegistroDePlanDeAccion#" skin="info1">
								<table width="100%" align="center">
									<tr><td><p>
									<cf_translate  key="AYUDA_RegistroDePlanDeAccion">
									 	En esta pantalla se captura el plan de acción a tomar para un determinado empleado desp&uacute;es de realizar una evaluaci&oacute;n
									</cf_translate>
									</p></td></tr>
								</table>
							<cf_web_portlet_end>
						</td>
						<td colspan="2" valign="top">
							<table width="90%" align="center" cellpadding="2" cellspacing="0">
								<cfif isdefined("form.PROCESAR")>
								<tr>
									<td colspan="2" align="right"> 
										<a  href="javascript: reporte();" ><cf_translate  key="LB_VerResultadoDeLaEvaluacion">Ver resultado de la evaluación</cf_translate></a>
									</td>
								</tr>
								</cfif>
								<tr>
									<td width="10%" align="right"  valign="top" nowrap ><strong><cf_translate  key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate></strong>:&nbsp;</td>
									<cfif isdefined("form.PROCESAR")>
										<td >#rsRHEEvaluacionDes.RHEEdescripcion#  
										<br><strong><cf_translate  key="LB_Inicio">Inicio</cf_translate></strong> :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_locale name="date" value="#rsRHEEvaluacionDes.inicio#"/>&nbsp;
										<br><strong><cf_translate  key="LB_Finalizacion">Finalización</cf_translate></strong> :&nbsp;<cf_locale name="date" value="#rsRHEEvaluacionDes.fin#"/></td>
									
									<cfelse>
										<td ><cf_rhevaluacion size="60"></td>
									</cfif>
								</tr>
								<tr>
									<td width="10%" align="right" nowrap ><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate></strong>:&nbsp;</td>
									<cfif isdefined("form.PROCESAR")>
										<td >#form.DEIDENTIFICACION#&nbsp;&nbsp;&nbsp;#form.NOMBREEMP#</td>
										
									<cfelse>
										<td ><cf_rhempleadoscap></td>
									</cfif>
								</tr>
								<cfif isdefined("form.PROCESAR")>
									<tr>
										<td width="10%" align="right"  valign="top" nowrap ><strong><cf_translate  key="LB_PlanDeAccion">Plan de Acción</cf_translate></strong>:&nbsp;</td>
										<td >
											<cfset miHTML = "">
											<cfif not isdefined("rsRHListaEvalDes") or len(trim(rsRHListaEvalDes.RHLEobservacion)) gt 0>
												<cfset miHTML = rsRHListaEvalDes.RHLEobservacion>
											</cfif>
											<cf_rheditorhtml name="RHLEobservacion" value="<cfoutput>#miHTML#</cfoutput>" height="300">
											
											<!--- <textarea name="RHLEobservacion" 
											id="RHLEobservacion" 
											rows="10" style="width: 100%;">#miHTML#</textarea> --->
											
										</td>
									</tr>
								</cfif>
								
								<tr>
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Procesar"
									Default="Procesar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Procesar"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Aceptar"
									Default="Aceptar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Aceptar"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Nuevo"
									Default="Nuevo"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Nuevo"/>
									<cfif isdefined("form.PROCESAR")>
										<td colspan="2" align="center">
											<input type="submit" value="#BTN_Aceptar#" name="Aceptar" onclick="javascript: modificar();">
											<input type="submit" value="#BTN_Nuevo#"   name="Nuevo">
										</td>	
									<cfelse>
										<td colspan="2" align="center"><input type="submit" name="Procesar" value="#BTN_Procesar#"></td>
									</cfif>
									
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
				</cfoutput>
				<input name="DEIDENTIFICACION2" 	type="hidden" value="<cfif isdefined("form.DEIDENTIFICACION")><cfoutput>#form.DEIDENTIFICACION#</cfoutput></cfif>">	
				<input name="NOMBREEMP2" 		type="hidden" value="<cfif isdefined("form.NOMBREEMP")><cfoutput>#form.NOMBREEMP#</cfoutput></cfif>">	
				</form>
				<!--- VARIABLES DE TRADUCCION --->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_ElCampoEvaluacionEsRequerido"
					Default="El campo Evaluación es requerido."
					returnvariable="MSG_ElCampoEvaluacionEsRequerido"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_ElCampoEmpleadoEsRequerido"
					Default="El campo Empleado es requerido."
					returnvariable="MSG_ElCampoEmpleadoEsRequerido"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_SePresentaronLosSiguientesErrores"
					Default="Se presentaron los siguientes errores"
					returnvariable="MSG_SePresentaronLosSiguientesErrores"/>

				<script language="javascript1.2" type="text/javascript">
					function modificar(){
						document.form1.action ="RegistroPlanAccion-sql.cfm";
					}
					
					function validardatos(){
						var mensaje = '';
						 if ( document.form1.RHEEID.value == '' ){
							mensaje += ' - <cfoutput>#MSG_ElCampoEvaluacionEsRequerido#</cfoutput>\n';
						} 
						if ( document.form1.DEid.value == '' ){
							mensaje += ' - <cfoutput>#MSG_ElCampoEmpleadoEsRequerido#</cfoutput>\n';
						}

						if ( mensaje != '' ){
							mensaje = '<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n' + mensaje;
							alert(mensaje);
							return false;
						}
						return true;
					}
					
					function reporte(){
						
						var valores ="RHEEID="+ document.form1.RHEEID.value + "&DEID=" + document.form1.DEID.value + "&formato=HTML";
						var PARAM  = "RepResultadoEvaluacion.cfm?"+ valores
						open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
						
					}
					
				</script>
				
				
			<cf_web_portlet_end>
		</td></tr>
	</table>
<cf_templatefooter>