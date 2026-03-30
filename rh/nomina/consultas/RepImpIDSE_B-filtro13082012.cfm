<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteCotizacionesFactDir" Default="Reporte del Pago Mensual de Cotizaciones con Facturaci&oacute;n Directa " returnvariable="LB_ReporteCotizacionesFactDir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Periodo" returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Bimestre" Default="Bimestre" returnvariable="LB_Bimestre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nomina" Default="Nomina" returnvariable="LB_Nomina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoReporte" Default="Tipo reporte" returnvariable="LB_TipoReporte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo_de_Nomina" Default="Tipo de N&oacute;mina" returnvariable="LB_Tipo_de_Nomina"/>



<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte Modificacion SDI para IDSE">

		<!---<cfinclude template="/rh/portlets/pNavegacion.cfm">		--->
		<form name="form1" method="post" action="RepImpIDSE_B-form.cfm">
		<cfoutput>
		<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
			<td width="45%" valign="top">
					<table width="100%" >
						<tr>
							<td valign="top">
								<cf_web_portlet_start border="true" titulo="Descripci&oacute;n" skin="info1">
									<div align="justify">
										<p>
										<cf_translate  key="LB_Reporte">
										Archivo generado para importar información relacionada al SDI para el IDSE para el periodo y bimestre.
										</cf_translate>
										</p>
									</div>
								<cf_web_portlet_end>									  
							</td>
						</tr>
					</table>  
				</td>
			<td>
				<table cellpadding="3" cellspacing="0" align="center" border="0">								
					<tr  id="TR_Periodo">
						<td width="272" align="right"><b>#LB_Periodo#:&nbsp;</b></td>
						<td width="238"><select name="periodo">
	                        <option value=""></option>
							<cfloop index="i" from="-6" to="0">
								<cfset vn_anno = year(DateAdd("yyyy", i, now()))>
								<option value="#vn_anno#">#vn_anno#</option>
							</cfloop>
					  </select></td>
					  <cfset paso = 1>	
					</tr>
						
					<tr id="TR_Mes">
						<td align="right"><b>#LB_Bimestre#:&nbsp;</b></td>
						<td>
                        <select name="mes"  >
                        	<option value="">Seleccionar</option>
                            <option value="1">
                                <cf_translate key="CMB_Bimestre01">01 Ene - Feb</cf_translate>
                            </option>
                            <option value="3">
                                <cf_translate key="CMB_Bimestre02">02 Mar - Abr</cf_translate>	
                            </option>
                            <option value="5">
                                <cf_translate key="CMB_Bimestre03">03 May - Jun</cf_translate>
                            </option>
                            <option value="7">
                                <cf_translate key="CMB_Bimestre04">04 Jul - Ago</cf_translate>
                            </option>
                            <option value="9">
                                <cf_translate key="CMB_Bimestre05">05 Sep - Oct</cf_translate>
                            </option>
                            <option value="11">
                                <cf_translate key="CMB_Bimestre06">06 Nov - Dic</cf_translate>
                            </option>
                        </select>
                    </td>
                    </tr> 
                    <tr>
                        <td align="right"><b>#LB_Tipo_de_Nomina#:&nbsp;</b></td>
                        <td colspan="2" align="left">
                        	<cf_rhtiponominaCombo index="0">
                        </td>
                    </tr>
                    
                    <!---<tr>
                    	<td align="right"><b>#LB_TipoReporte#:&nbsp;</b></td>
                        <td colspan="2" align="left">
                        	<!---<input type="radio" name="tReporte" value="1"/> <cf_translate  key="RAD_Resumido">Resumido</cf_translate>--->
                           	<input type="radio" name="tReporte" value="2"/> <cf_translate  key="RAD_Detallado">Detallado</cf_translate>
                        </td>
                    </tr>--->
					<tr>				
						<td colspan="4" align="center">
							<input type="submit" name="btnConsultar" value="Generar" class="BTNAplicar"></td>
					</tr>
				</table>
		</td></tr>	
		<input type="hidden" name="LastOneCalendario" id="LastOneCalendario" value="ListaNon" tabindex="1">
		<input type="hidden" name="TDidlist" id="TDidlist" value="" tabindex="1">
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">
		</cfoutput>
		</form>
		<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->
	<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	objForm.periodo.required = true;
	objForm.periodo.description = '#LB_Periodo#';
	objForm.mes.required = true;
	objForm.mes.description = '#LB_Bimestre#'	
	objForm.tReporte.required = true;
	objForm.tReporte.description = '#LB_TipoReporte#'	
	objForm.Tcodigo.required = true;
	objForm.Tcodigo.description = '#LB_Tipo_de_Nomina#'	
	</cfoutput>	
</script>
