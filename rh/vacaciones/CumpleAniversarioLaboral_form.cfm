<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Aniversario" Default="Aniversario Laboral" returnvariable="LB_Aniversario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Generar" Default="Generar" returnvariable="BTN_Generar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<SCRIPT SRC="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.form1.CFid.value = '';
		document.form1.CFcodigo.value = '';
		document.form1.CFdescripcion.value = '';
	}
</script>
<cfoutput>
	<form method="get" name="form1" action="CumpleAniversarioLaboral_sql.cfm">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr valign="top">
				<td width="50%">
					<table width="100%">
						<tr>
							<td height="173" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_Aniversario#" skin="info1">
									<div align="justify">
									  <p>
									  <cf_translate  key="LB_EnEsteReporteMuestraUnaListaDeEmpleadosQueCumplenAnnosHoy">
									  En &eacute;ste reporte
									  muestra una lista de empleados que cumplen un a&ntilde;o m&aacute;s dentro de la empresa, en esta semana o este mes.
									  Se ordena por: Centro Funcional y fecha de ingreso.
									  </cf_translate>
									  </p>
								</div>
							  <cf_web_portlet_end></td>
						</tr>
					</table>
				</td>
				<td width="50%" valign="top">
					<table width="100%" cellpadding="2" cellspacing="0" align="center">
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td align="left" nowrap><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>: &nbsp;</strong>							  							</td>
							<td align="center"><cf_rhcfuncional tabindex="1"></td>
						</tr>
						<tr>
							<td nowrap="nowrap"><strong><cf_translate  key="LB_Ingreso">Ingreso</cf_translate>: </strong>						  </td>
							<td nowrap="nowrap" ><strong>
								<input type="radio" name="optCumple" value="0" tabindex="2"  title="A Hoy" checked="checked" />
								<cf_translate  key="RAD_AHoy">A Hoy</cf_translate> &nbsp; &nbsp;
								<input type="radio" name="optCumple" value="1" tabindex="3"  title="Esta Semana" />
								<cf_translate  key="RAD_EstaSemana">Esta Semana</cf_translate>  &nbsp; &nbsp;
								<input type="radio" name="optCumple" value="2" tabindex="4"  title="Del Mes" />
								<cf_translate  key="RAD_Mes">Mes</cf_translate>  </strong>
							</td>
						</tr>
						<tr>
							<td><strong><cf_translate  key="LB_Mes">Mes</cf_translate>:</strong></td>
							<td >
								<select name="mes" tabindex="5">
									<option value="1"  <cfif datepart('m',now()) EQ 1>selected</cfif>><cf_translate  key="CMB_Enero">Enero</cf_translate></option>
									<option value="2"  <cfif datepart('m',now()) EQ 2>selected</cfif>><cf_translate  key="CMB_Febrero">Febrero</cf_translate></option>
									<option value="3"  <cfif datepart('m',now()) EQ 3>selected</cfif>><cf_translate  key="CMB_Marzo">Marzo</cf_translate></option>
									<option value="4"  <cfif datepart('m',now()) EQ 4>selected</cfif>><cf_translate  key="CMB_Abril">Abril</cf_translate></option>
									<option value="5"  <cfif datepart('m',now()) EQ 5>selected</cfif>><cf_translate  key="CMB_Mayo">Mayo</cf_translate></option>
									<option value="6"  <cfif datepart('m',now()) EQ 6>selected</cfif>><cf_translate  key="CMB_Junio">Junio</cf_translate></option>
									<option value="7"  <cfif datepart('m',now()) EQ 7>selected</cfif>><cf_translate  key="CMB_Julio">Julio</cf_translate></option>
									<option value="8"  <cfif datepart('m',now()) EQ 8>selected</cfif>><cf_translate  key="CMB_Agosto">Agosto</cf_translate></option>
									<option value="9"  <cfif datepart('m',now()) EQ 9>selected</cfif>><cf_translate  key="CMB_Setiembre">Septiembre</cf_translate></option>
									<option value="10" <cfif datepart('m',now()) EQ 10>selected</cfif>><cf_translate  key="CMB_Octubre">Octubre</cf_translate></option>
									<option value="11" <cfif datepart('m',now()) EQ 11>selected</cfif>><cf_translate  key="CMB_Noviembre">Noviembre</cf_translate></option>
									<option value="12" <cfif datepart('m',now()) EQ 12>selected</cfif>><cf_translate  key="CMB_Diciembre">Diciembre</cf_translate></option>
								</select>
							</td>
						</tr>
						<tr>
							<td><strong><cf_translate  key="LB_Formato">Formato</cf_translate>:</strong></td>
							<td >
								<select name="formato" tabindex="6">
									<option value="pdf"><cf_translate  key="CMB_PDF">PDF</cf_translate></option>
									<option value="FlashPaper"><cf_translate  key="CMB_FlashPaper">FlashPaper</cf_translate></option>
									<option value="Excel"><cf_translate  key="CMB_Excel">Excel</cf_translate></option>
								</select>
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td align="center" colspan="2">
								<input type="submit" value="#BTN_Generar#" name="Reporte" tabindex="7" />
								<input type="reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="8" onClick="javascript:limpiar();">
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</cfoutput>
