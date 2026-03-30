<cfparam name="ruta" default="">

<cfset modo = "ALTA">
<cfif isdefined("url.modo") and len(trim(url.modo))>
	<cfset modo = url.modo>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ParametrosCertificadosCFDI"
	Default="Parámetros Certificados CFDI"
	returnvariable="LB_ParametrosCertificadosCFDI"/>	

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
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ParametrosCertificadosCFDI#'>
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
							<cfquery name="rsRH_CFDI_Certificados" datasource="#session.DSN#">
								select NoCertificado,archivoKey,clave									
								from RH_CFDI_Certificados A
								where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">							 
							</cfquery>
							
							<cfif rsRH_CFDI_Certificados.RecordCount gt 0 >
								<cfset modo = 'CAMBIO'>
                                <cfset vNoCertificado = "#rsRH_CFDI_Certificados.NoCertificado#">
                                <cfset varchivoKey = "#rsRH_CFDI_Certificados.archivoKey#">
                            <cfelse>
                                <cfset vNoCertificado = ''>
                                <cfset varchivoKey = ''>
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
									f.obj.NoCertificado.disabled = false;
									return true;
								}
								
								function deshabilitarValidacion() {
									objForm.NoCertificado.required = false;
								}
								
								function funcRegresar(){                             									
									<cfoutput>										
										location.href= '#ruta#';
									</cfoutput>
								}
							</script>
							
							<form name="form1" method="post"  onSubmit="return validar();" action="SQL_RH_CFDI_Certificados.cfm">
								<cfoutput>
									<table width="100%">										  
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td><cf_translate key="LB_NoCertificado"><strong>Núm. Certificado</strong></cf_translate>:</td>
                                            <td>#vNoCertificado#</td>
                                            <td nowrap="nowrap">
                                                <input name="NoCertificado" type="file" size=70
                                                value="" 
                                                onchange="javascript:document.form1.nArchivoC.value=this.value;">
												<input type="hidden" name="nArchivoC" value="<cfif modo neq 'ALTA'> #rsRH_CFDI_Certificados.NoCertificado# </cfif>">
                                            </td>
										</tr>
										<tr>
                                        	<td><cf_translate key="LB_ArchivoKey"><strong>Archivo Key</strong></cf_translate>:</td>
                                            <td>#varchivoKey#</td>
                                            <td nowrap="nowrap">
                                                <input name="ArchivoKey" type="file" size=70
                                                value="" 
                                                onchange="javascript:document.form1.nArchivoK.value=this.value;">
												<input type="hidden" name="nArchivoK" value="<cfif modo neq 'ALTA'> #rsRH_CFDI_Certificados.archivoKey# </cfif>">
                                            </td>
                                        </tr>
										<tr>
                                        	<td><cf_translate key="LB_Clave"><strong>Clave</strong></cf_translate>:</td>
											<td>
												<input name="Clave" type="text" value ="<cfif modo neq 'ALTA'>#rsRH_CFDI_Certificados.Clave#</cfif>"/>
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
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="BTN_Eliminar"
														Default="Eliminar"
														XmlFile="/rh/generales.xml"
														returnvariable="BTN_Eliminar"/>
													<input type="submit" name="cambio" value="#BTN_Modificar#">
													<input type="submit" name="borrar" value="#BTN_Eliminar#" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
												</cfif>
											</td>
										</tr>	  
									</table>
								</cfoutput>
							</form>
							<script language="JavaScript1.2" type="text/javascript">
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_NoCertificado"
								Default="Núm. Certificado"
								returnvariable="LB_NoCertificado"/>	
							</script>
						</td>
					</tr>
				</table>
				<cf_web_portlet_end>
			</td>
	  	</tr>
	</table>
<cf_templatefooter>


<script language="JavaScript1.2" type="text/javascript">
	function validar(){
		var error   = false;
		var mensaje = 'Se presentaron los siguientes errores:\n';
		
		if ( trim(document.form1.NoCertificado.value) != '' ){
			var cert = trim(document.form1.NoCertificado.value);
			var cert =cert.substring(cert.length-3);
			if ( cert != 'cer' ){
				error = true;
				mensaje += ' - El archivo debe ser tipo cer.\n'
			}
		}
		
		if ( trim(document.form1.ArchivoKey.value) != '' ){
			var llave = trim(document.form1.ArchivoKey.value);
			var llave = llave.substring(llave.length-3);
			if ( llave != 'key' ){
				error = true;
				mensaje += ' - El archivo debe ser tipo key.\n'
			}
		}
		if ( error ){
			alert(mensaje);
			return false;
		}
		return true;
	}
</script>



