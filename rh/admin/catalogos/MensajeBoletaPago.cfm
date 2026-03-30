<cfparam name="ruta" default="">

<cfset modo = "ALTA">
<cfif isdefined("url.modo") and len(trim(url.modo))>
	<cfset modo = url.modo>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MensajeEnBoletaPago"
	Default="Mensaje en Boleta de Pago"
	returnvariable="LB_MensajeEnBoletaPago"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
    	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_MensajeEnBoletaPago#'>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<cfinclude template="/rh/portlets/pNavegacion.cfm">					
						</td>
					</tr>
				</table>					
				<table width="100%"  border="0">
					<tr>
						<td>
							<!--- Consultas --->
							<cfquery name="rsMensaje" datasource="#session.DSN#">
								select Mensaje									
								from MensajeBoleta A
								where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 								 
							</cfquery>
							
							<cfif isdefined("rsMensaje") and len(trim(rsMensaje.Mensaje))>
								<cfset modo = 'CAMBIO'>
							</cfif>
							
							<script src="/cfmx/sif/js/qForms/qforms.js"></script> 
							<script src="/cfmx/rh/js/utilesMonto.js"></script>
							<script language="JavaScript1.2" type="text/javascript">
								<!--//
								// specify the path where the "/qforms/" subfolder is located
								qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
								// loads all default libraries
								qFormAPI.include("*");
								//-->
								function validar(f){
									f.obj.mensaje.disabled = false;
									return true;
								}
								
								function deshabilitarValidacion() {
									objForm.mensaje.required = false;
								}
								
								function funcRegresar(){                             									
									<cfoutput>										
										location.href= '#ruta#';
									</cfoutput>
								}
							</script>
							
							<form name="form1" method="post" action="SQL_MensajeBoletaPago.cfm">
								<cfoutput>
									<table width="100%" border="0" cellspacing="1" cellpadding="1">										  
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td width="40%" align="right" valign="top"><cf_translate key="LB_Mensaje"><strong>Mensaje</strong></cf_translate>:</td>
											<td width="60%">
												<textarea name="mensaje" cols="50" rows="5"><cfif modo neq 'ALTA'>#rsMensaje.Mensaje#</cfif></textarea>
											</td>
										</tr>											
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td colspan="2" align="center">
												<cfif modo eq 'ALTA'>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="BTN_Agregar"
														Default="Agregar"
														XmlFile="/rh/generales.xml"
														returnvariable="BTN_Agregar"/>
													<input type="submit" name="alta" value="<cfoutput>#BTN_Agregar#</cfoutput>">												
												<cfelse>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="BTN_Modificar"
														Default="Modificar"
														XmlFile="/rh/generales.xml"
														returnvariable="BTN_Modificar"/>
													<input type="submit" name="cambio" value="<cfoutput>#BTN_Modificar#</cfoutput>">
												</cfif>
												<cfif isdefined("ruta") and len(trim(ruta))>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="BTN_Regresar"
														Default="Regresar"
														XmlFile="/rh/generales.xml"
														returnvariable="BTN_Regresar"/>
													<input type="button" name="regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript: funcRegresar();">	
													<input type="hidden" name="ruta" value="#ruta#">
												</cfif>	
											</td>
										</tr>	  
									</table>
								</cfoutput>
							</form>
							
							<script language="JavaScript1.2" type="text/javascript">
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Mensaje"
								Default="Mensaje"
								returnvariable="LB_Mensaje"/>	
								
								<!---qFormAPI.errorColor = "#FFFFCC";
								objForm = new qForm("form1");
								objForm.mensaje.required = true;
								objForm.mensaje.description="<cfoutput>#LB_Mensaje#</cfoutput>";--->
							</script>
						</td>
					</tr>
				</table>
				<cf_web_portlet_end>
			</td>
	  	</tr>
	</table>
<cf_templatefooter>
