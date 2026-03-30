<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">Recursos Humanos</cf_templatearea>
	
	<cf_templatearea name="body">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
					Default="Boletas de Excepciones(Inconsistencias)"
					VSgrupo="103"
					returnvariable="nombre_proceso"/>
					
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Consultar"
					Default="Consultar"
					returnvariable="BTN_Consultar"/>	
								
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Debe_elegir_una_fecha_valida_para_Fecha_Desde"
					Default="- Debe elegir una fecha válida para el campo: Fecha desde"	
					returnvariable="MSG_Debe_elegir_una_fecha_valida_para_Fecha_Desde"/>
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Debe_elegir_una_fecha_valida_para_Fecha_Hasta"
					Default="- Debe elegir una fecha válida para el campo: Fecha hasta"	
					returnvariable="MSG_Debe_elegir_una_fecha_valida_para_Fecha_Hasta"/>
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Se_presentaron_los_siguientes_errores"
					Default="Se presentaron los siguientes errores:"	
					returnvariable="MSG_Se_presentaron_los_siguientes_errores"/>										
					
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#nombre_proceso#">
					<form name="form1" method="get" action="BoletasExcepciones-form.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="50%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="Boletas de Excepciones(Inconsistencias)" skin="info1">
									<table width="100%" align="center">
										<tr><td><p><cf_translate key="AYUDA_EstaConsultaMuestraListadoDeExcepciones">Esta consulta muesta un listado de las Excepciones (Inconsistencias) según el  Empleado, el Centro Funcional, la Fecha desde y la Fecha hasta específicadas. De no especificarse el Empleado y/o el Centro Funcional, se listan todos los Empleados y/o Centros Funcionales.<br>El campo de Fecha desde y Fecha hasta son requeridos por la consulta.</cf_translate></p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="2" cellspacing="0">
									
									<tr>
										<td width="40%" align="right" nowrap ><cf_translate key="LB_Empleado">Empleado:</cf_translate>&nbsp;</td>
										<td>
											<cf_rhempleado>
										</td>
									</tr>
									
									<tr>
										<td width="40%" align="right" nowrap><cf_translate key="LB_Centro_Funcional">Centro Funcional:</cf_translate>&nbsp;</td>
										<td><cf_rhcfuncional></td>
									</tr>
									
									<tr>
									  	<td width="40%" align="right" nowrap><cf_translate key="LB_Fecha_desde">Fecha desde:</cf_translate>&nbsp;</td>
										<td nowrap>
											<cfif isdefined("url.fdesde")>
												<cfset fecha = url.fdesde>
												<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fdesde">
										</td>
									</tr>
									
									<tr>
									  <td width="40%" align="right" nowrap><cf_translate key="LB_Fecha_Hasta">Fecha hasta:</cf_translate>&nbsp;</td>
										<td nowrap>
											<cfif isdefined("url.fhasta")>
												<cfset fecha = url.fhasta>
												<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fhasta">
										</td>
									</tr>
									
									<tr>
										<td width="40%" align="right" nowrap ><cf_translate key="LB_Formato">Formato:</cf_translate>&nbsp;</td>
										<td>
											<select name="formato">
												<option value="flashpaper"><cf_translate key="LB_Flashpaper">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate key="LB_PDF">PDF</cf_translate></option>
												<option value="excel"><cf_translate key="LB_Excel">Excel</cf_translate></option>
											</select>
										</td>
									</tr>		
									<tr>
										<cfoutput><td colspan="2" align="center"><input type="submit" name="#BTN_Consultar#" value="Consultar"></td></cfoutput>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					
					<script language="javascript1.2" type="text/javascript">
						function validar(form){
							var mensaje = '';
							<cfoutput>
								if(document.form1.fdesde.value == "")
								{
									mensaje = '#MSG_Debe_elegir_una_fecha_valida_para_Fecha_Desde#'+'\n';
								}
								if(document.form1.fhasta.value == "")
								{
									mensaje = mensaje + '#MSG_Debe_elegir_una_fecha_valida_para_Fecha_Hasta#'+'\n';
								}
								
								if ( mensaje != '' ){
									mensaje = '#MSG_Se_presentaron_los_siguientes_errores#'+'\n' + mensaje;
									alert(mensaje);
									return false;
								}
								else 
									return true;
							</cfoutput>
						}
						
					</script>
					
				<cf_web_portlet_end>
			</td></tr>
		</table>
	</cf_templatearea>
</cf_template>