<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Consulta de Gastos" 
returnvariable="LB_Titulo" xmlfile = "gastos-filtro.xml"/>
<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Consultar" 		default="Consultar"			returnvariable="BTN_Consultar"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

	<cf_templateheader title="#LB_Titulo#">
	
		<cfquery name="periodo_actual" datasource="#session.DSN#">
			select p.Pvalor
			from Parametros p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and p.Pcodigo = 30
		</cfquery>	

		<cfquery name="mes_actual" datasource="#session.DSN#">
			select p.Pvalor
			from Parametros p
			where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and p.Pcodigo = 40
		</cfquery>
		 <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="#LB_Titulo#">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="50%" valign="top">
						<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						  <tr>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td>
								<cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="info1">
									<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
									  <tr>
										<td>
											<div align="justify" style="font-size:12px;">
												<br /><cf_translate key=LB_Reporte>
												En &eacute;ste reporte se detallan los gastos 
											  	incurridos durante un per&iacute;odo contable
												y en un centro funcional.
												Puede escoger el nivel de resumen y nivel para totalizar
												y se puede generar en varios formatos, aumentando así 
												su utilidad y eficiencia en el traslado de datos.
                                                </cf_translate>
												<br />
												<br />
											</div>
										</td>
									  </tr>
									</table>
								<cf_web_portlet_end>
							</td>
						  </tr>
						</table>
					</td>
					<td width="50%" valign="top">
						<cfoutput>
						<form name="form1" method="post" action="gastos.cfm" style="margin:0;" onSubmit="return validar();">
						<table border="0" align="center" cellpadding="3" cellspacing="0">
							<tr><td colspan="2" nowrap="nowrap"><strong><cf_translate key=LB_CentroF>Centro Funcional</cf_translate></strong></td>
							</tr>
							<tr><td colspan="2"><cf_rhcfuncional></td>
							</tr>
							<tr><td nowrap="nowrap"><strong><cf_translate key=LB_Periodo>Per&iacute;odo</cf_translate></strong></td>
							  <td nowrap="nowrap"><strong><cf_translate key=LB_Mes>Mes</cf_translate></strong></td>
							</tr>
							<tr><td>
								<select name="periodo">
									<option value="#periodo_actual.Pvalor#">#periodo_actual.Pvalor#</option>
									<cfloop step="-1" from="#periodo_actual.Pvalor-1#" to="#periodo_actual.Pvalor-3#" index="i"  >
										<option value="#i#" >#i#</option>
									</cfloop>
								</select>
							</td>
							  <td><select name="mes">
								  <!--- <option value="">-seleccionar-</option> --->
								  <option value="1" >#CMB_Enero#</option>
								  <option value="2" >#CMB_Febrero#</option>
								  <option value="3" >#CMB_Marzo#</option>
								  <option value="4" >#CMB_Abril#</option>
								  <option value="5" >#CMB_Mayo#</option>
								  <option value="6" >#CMB_Junio#</option>
								  <option value="7" >#CMB_Julio#</option>
								  <option value="8" >#CMB_Agosto#</option>
								  <option value="9" >#CMB_Setiembre#</option>
								  <option value="10" >#CMB_Octubre#</option>
								  <option value="11" >#CMB_Noviembre#</option>
								  <option value="12" >#CMB_Diciembre#</option>
								</select></td>
							</tr>
							<tr>
                              <td nowrap="nowrap"><strong><cf_translate key=LB_NivelR>Nivel de Resumen</cf_translate></strong></td>
							  <td nowrap="nowrap"><strong><cf_translate key=LB_NivelT>Nivel para Totalizar</cf_translate></strong></td>
							</tr>
							<tr>
								<td>
									<select name="nivel_resumen">
										<option value="0"><cf_translate key=LB_CuentaM>Cuenta de Mayor</cf_translate></option>
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
										<option value="6">6</option>
									</select>									</td>
								<td><select name="nivel_totalizar">
									<option value="0">0</option>
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
								  </select>                                    </td>
							</tr>
							<tr><td nowrap="nowrap"><strong><cf_translate key=LB_IncluirD>Incluir dependencias</cf_translate></strong></td>
							  <td nowrap="nowrap"><!--- <strong>Formato</strong> ---></td>
							</tr>
							<tr>
							  <td nowrap="nowrap"><input type="checkbox" name="dependencias" /></td>
							  <td nowrap="nowrap"><!--- <select name="formato">
								<option value="html">Html</option>
								<option value="flashpaper">Flashpaper</option>
								<option value="pdf">Pdf</option>
							  </select> ---></td>
						  </tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr><td colspan="2" align="center"><input type="submit" value="#BTN_Consultar#" name="Consultar"></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</table> 
						</form>
						</cfoutput>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>

		<script language="javascript1.2" type="text/javascript">
			function validar(){
				var mensaje = '';
				if ( document.form1.CFid.value == '' ){
					mensaje += ' - El campo Centro Funcional es requerido.\n';
				}
				if ( document.form1.mes.value == '' ){
					mensaje += ' - El campo Mes es requerido.\n';
				}

				if ( mensaje != '' ){
					alert('Se presentaron los siguientes errores:\n' + mensaje)
					return false;
				}
				sinbotones();
				return true;
			}
		</script>


	<cf_templatefooter>
