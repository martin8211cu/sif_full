<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteCotizacionesFactDir" Default="Reporte del Pago Mensual de Cotizaciones con Facturaci&oacute;n Directa " returnvariable="LB_ReporteCotizacionesFactDir"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" XmlFile="/rh/generales.xml"returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Periodo" Default="Periodo" returnvariable="LB_Periodo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Bimestre" Default="Bimestre" returnvariable="LB_Bimestre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nomina" Default="Nomina" returnvariable="LB_Nomina"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TipoReporte" Default="Tipo reporte" returnvariable="LB_TipoReporte"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo_de_Nomina" Default="Tipo de N&oacute;mina" returnvariable="LB_Tipo_de_Nomina"/>

<cfquery name="rsRegistro" datasource="#session.dsn#">
	select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300
</cfquery>

<cfset RegistroPatronal1 = #rsRegistro.Pvalor#>


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
                        <select name="mes">
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
					<tr>

						<td nowrap align="right"><strong>Registro Patronal:&nbsp;</strong></td>
				<td>
					<cfif RegistroPatronal1 eq "">
						<cfquery name="rsRegistro" datasource="#session.dsn#">
							select o.Ocodigo, o.Oficodigo, o.Onumpatronal from oficinas o where o.Ecodigo = #session.Ecodigo# and o.Onumpatronal is not null
						</cfquery>
						<cfoutput>
							<select name="RegPat" onchange="Archivo();">
								<option value="" >-- Seleccione una opci&oacute;n --</option>
								<cfloop query="rsRegistro">
								 	<option value="#Onumpatronal#" ><cf_translate key="CMB_RegistrPatronalOficina">#Onumpatronal#</cf_translate></option>
								</cfloop>
							</select>

							<input type="hidden" name="rePatOfi" value="1"> <!--- Esta variable me sirve para validar si el registro patronal es por oficina --->
						</cfoutput>
						<cfelse>
							<cfoutput>
								<select name="RegPat" >
									 <option value="#RegistroPatronal1#" ><cf_translate key="CMB_RegistroPatronalEmpresa">#RegistroPatronal1#</cf_translate></option>
								</select>
								<input type="hidden" name="rePatOfi" value="0">
							</cfoutput>
					</cfif>
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
							<input type="button" <!---type="submit"--->  onclick = "javascript:ConfirmarIDSE();" name="btnConsultar" value="Generar" class="BTNAplicar"></td>
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

	function ConfirmarIDSE(){

	var PeriodoIndexSelect = document.form1.periodo.selectedIndex ;
	var PeriodoidSelec = document.form1.periodo.options[PeriodoIndexSelect].value ;
	var PeriododescSelec = document.form1.periodo.options[PeriodoIndexSelect].text;


	var BimestreIndexSelect = document.form1.mes.selectedIndex ;
	var BimestreidSelec = document.form1.mes.options[BimestreIndexSelect].value ;
	var BimestredescSelec = document.form1.mes.options[BimestreIndexSelect].text;

		if(document.form1.RegPat.value != "" &&
			document.form1.periodo.value != "" &&
			document.form1.mes.value != "" &&
			document.form1.Tcodigo.value != "")
		{
			if (confirm("¿Desea Generar el archivo IDSE del PERIODO: " +  PeriododescSelec +  " y BIMESTRE: " + BimestredescSelec +"?"))
			{
				document.form1.action = 'RepImpIDSE_B-form.cfm';
				document.form1.submit()
				return true;
			}
		}

		alert("Es necesario llenar todo el formulario");
		return false;
	}
</script>
