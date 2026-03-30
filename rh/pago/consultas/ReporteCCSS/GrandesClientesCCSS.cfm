<cfset rsPeriodo = QueryNew("Pvalor")>
<cfset temp = QueryAddRow(rsPeriodo,3)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now())-2,1)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now())-1,2)>
<cfset temp = QuerySetCell(rsPeriodo,"Pvalor",Year(Now()),3)>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeGrandesClientesDelSeguroSocialX"
	Default="Reporte de Grandes Clientes del Seguro Social"
	returnvariable="LB_ReporteDeGrandesClientesDelSeguroSocial"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Verificacion_de_datos"
	Default="Verificaci&oacute;n de datos"
	returnvariable="LB_Verificacion_de_datos"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_area_de_filtros"
	Default="Area de Filtros"
	returnvariable="LB_area_de_filtros"/> 	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ayuda"
	Default="Ayuda"
	returnvariable="LB_Ayuda"/> 

<cf_templateheader title="#LB_ReporteDeGrandesClientesDelSeguroSocial#">
	<cf_web_portlet_start titulo="#LB_ReporteDeGrandesClientesDelSeguroSocial#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="40%" valign="top">
							<fieldset style="height:455px"><legend>#LB_area_de_filtros#</legend>
								<form action="GrandesClientesCCSS-sql.cfm" method="post" name="form1">
									<table width="100%" border="0" cellspacing="1" cellpadding="1">
										<tr>
											<td width="10%"><cf_translate  key="LB_Periodo">Periodo</cf_translate></td>
											<td width="1%">:</td>
											<td><select name="CPperiodo"><cfloop query="rsPeriodo"><option value="#Pvalor#" <cfif Year(Now()) eq Pvalor>selected</cfif>>#Pvalor#</option></cfloop></select></td>
											
										</tr>
										<tr>
											<td><cf_translate  key="LB_Mes">Mes</cf_translate></td>
											<td>:</td>
											<td><select  name="CPmes"><cfloop query="rsMeses"><option value="#Pvalor#" <cfif Month(Now()) eq Pvalor>selected</cfif>>#Pdescripcion#</option></cfloop></select></td>
										</tr>
										<tr>
											<td nowrap="nowrap"><cf_translate  key="LB_GrupoDePlanillas">Grupo de Planillas</cf_translate></td>
											<td>:</td>
											<td><input name="GrupoPlanilla" type="text" id="GrupoPlanilla" size="6" maxlength="5" value="" onFocus="javascript:this.select();"></td>
										</tr>
										
										<tr>
											<td colspan="3">
												<input type="checkbox" name="Pvez" tabindex="1"><cf_translate  key="LB_Reporte_generado_por_primera_vez">Reporte generado por primera vez</cf_translate>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												<input type="checkbox" name="Cierre" tabindex="1"><cf_translate  key="LB_Cierre_de_mes">Cierre de mes</cf_translate>
											</td>
										</tr>
	
										<tr>
											<td colspan="3" align="center">&nbsp;</td>
										</tr>	
										<tr>
											<td colspan="3" align="center">
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Consultar"
											Default="Consultar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Consultar"/>
											<input name="BTN_Consultar" id="BTN_Consultar" type="button"   onclick="javascript: validarcheck();"value="#BTN_Consultar#">

											</td>
										</tr>
										<tr>
											<td colspan="3" align="center">
												<fieldset style="height:300px"><legend>#LB_Ayuda#</legend>
													<table width="100%" border="0" cellspacing="1" cellpadding="1">
														<tr>
															<td>
																<li><cf_translate  key="LB_EsteProcesoSeEncargaDeLlenarElReporteDeLaCajaParaGrandesClientes">
																	Este proceso se encarga de llenar el reporte de la caja para grandes clientes, generando un archivo de formato tipo ASCII.
																</cf_translate>
																</li>
															</td>
														</tr>
														<tr>		
															<td>
																<li>
																	<font style="color:##0000FF">
																	<cf_translate  key="Recomendacion">
																		Se recomienda verificar los datos antes de ejecutar el reporte.
																	</cf_translate>
																	</font>
																	</li>
															</td>
														</tr>
														<tr>		
															<td>
																<li>
																<cf_translate  key="Recomendacion2">
																	<b>Reporte generado por primera vez :</b>Cuando se va generar por primera vez el reporte de grandes clientes es necesario marcar
																	esta opci&oacute;n
																</cf_translate>
																</li>
															</td>
														</tr>
														<tr>		
															<td>
																<li><cf_translate  key="Recomendacion2">
																	<b>Cierre de mes :</b>Esta opci&oacute;n se debe marcar cuando se va a generar el reporte definitivo para la caja.<br>
																	Si no se encuentra marcarda se puede utilizar para revisar el reporte antes de enviarse al CCSS  y realizar aquellos ajustes que sean necesarios.
																</cf_translate>
																</li>
															</td>
														</tr>
													</table>
												</fieldset>
											</td>
										</tr>
									</table>
								</form>
							 </fieldset>
						</td>
						<td width="60%" valign="top">
						<fieldset><legend>#LB_Verificacion_de_datos#</legend>
							<iframe 
								id="validacion" 
								name="validacion" 
								marginheight="0" 
								marginwidth="0" 
								frameborder="2"   
								height="455px" 
								width="570px" style="border:none"  scrolling="no" 
								src="ValidacionDatos.cfm">                   
							 </iframe>						
						</fieldset>
						</td>
					</tr>		
				</table>
			</cfoutput>
	<cf_web_portlet_end>			
<cf_templatefooter>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_realizar_el_cierre_de_mes"
	Default="¿ Esta seguro de realizar el cierre de mes ?"
	returnvariable="LB_Esta_seguro_de_realizar_el_cierre_de_mes"/> 	
	
<script language="JavaScript1.2">
	function validarcheck(){
		if(document.form1.Cierre.checked)
		{
			if ( confirm("<cfoutput>#LB_Esta_seguro_de_realizar_el_cierre_de_mes#</cfoutput>") ){
				document.form1.submit();
			}
		}
		else{
			document.form1.submit();
		}
	}	

</script>