<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">Recursos Humanos</cf_templatearea>
	
	<cf_templatearea name="body">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<!----================= TRADUCCION ====================---->
				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
					Default="Justificaciones sin Marca Relacionada"
					VSgrupo="103"
					returnvariable="nombre_proceso"/>
				
				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
					Default="Justificación sin Marca Relacionada"
					VSgrupo="103"
					returnvariable="nombre_porlet"/>
					
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Consultar"
					Default="Consultar"
					returnvariable="BTN_Consultar"/>

				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Debe_elegir_una_fecha_valida_para_el_campo_Fecha_desde"
					Default="- Debe elegir una fecha válida para el campo: Fecha desde"
					returnvariable="MSG_Debe_elegir_una_fecha_valida_para_el_campo_Fecha_desde"/>
					
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Debe_elegir_una_fecha_valida_para_el_campo_Fecha_hasta"
					Default="- Debe elegir una fecha válida para el campo: Fecha hasta"
					returnvariable="MSG_Debe_elegir_una_fecha_valida_para_el_campo_Fecha_hasta"/>	
					
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Se_presentaron_los_siguientes_errores"
					Default="Se presentaron los siguientes errores:"
					returnvariable="MSG_Se_presentaron_los_siguientes_errores"/>		
					
					
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#nombre_proceso#">
					<form name="form1" method="get" action="JustificacionesSinMarca-form.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="50%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#nombre_porlet#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p><cf_translate key="AYUDA_ListaJustificacionesAdelantadasDelEmpleadoSinMarca">Esta consulta lista aquellas justificaciones adelantadas, hechas por el empleado y que nunca se relacionaron con una marca.</cf_translate></p></td></tr>
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
									  <td width="40%" align="right" nowrap><cf_translate key="LB_Fecha_hasta">Fecha hasta:</cf_translate>&nbsp;</td>
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
										<td width="40%" align="right" nowrap ><cf_translate key="LB_Formato" XmlFile="/rh/generales.xml">Formato:</cf_translate>&nbsp;</td>
										<td>
											<select name="formato">
												<option value="flashpaper"><cf_translate key="LB_Flashpaper" XmlFile="/rh/generales.xml">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate key="LB_PDF" XmlFile="/rh/generales.xml">PDF</cf_translate></option>
												<option value="excel"><cf_translate key="LB_Excel" XmlFile="/rh/generales.xml">Excel</cf_translate></option>
											</select>
										</td>
									</tr>		
									<tr>
										<cfoutput><td colspan="2" align="center"><input type="submit" name="Consultar" value="#BTN_Consultar#"></td></cfoutput>
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
									mensaje = '#MSG_Debe_elegir_una_fecha_valida_para_el_campo_Fecha_desde#'+'\n';
								}
								if(document.form1.fhasta.value == "")
								{
									mensaje = mensaje + '#MSG_Debe_elegir_una_fecha_valida_para_el_campo_Fecha_hasta#'+'\n';
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