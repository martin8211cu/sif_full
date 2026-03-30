<cfset Lvar_tipo = 1>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ReporteDeValesDespensa" default="Reporte de Vales de Despensa" returnvariable="LB_ReporteDeValesDespensa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TipodeNomina" default="Tipo de Nómina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaAplicada" default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ElTipoDeCambioDebeSerMayorACero" default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_TipoDeNomina" default="Tipo de Nómina" returnvariable="MSG_TipoDeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaAplicada" default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->

<cfset titulo = LB_ReporteDeValesDespensa>

<cf_templateheader title="#titulo#">
		<cf_web_portlet_start titulo="#titulo#" >
			<cfinclude template="/rh/portlets/pNavegacion.cfm">	
			<form name="form1" method="post" action="ReporteDetalleEspecie-form.cfm" style="margin:0;">
				<table width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td nowrap align="right"> <strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate> :&nbsp;</strong></td>
						<td><cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<!---<input name="chkTxt" type="checkbox" id="chkTxt"/>
							<label for="chkTxt" style="font-style:normal; font-variant:normal; font-weight:normal">
								<cf_translate key="CHK_GenerarARchivoDeExportacion">Generar Archivo de Exportaci&oacute;n</cf_translate>
							</label>--->
						</td>
					</tr>
					<tr><td align="center" colspan="2"><cf_botones values="Generar" tabindex="1"></td></tr>
				</table>
			</form>
		<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form="form1">
	<cf_qformsrequiredfield args="Tcodigo,#MSG_TipoDeNomina#">
    <cf_qformsrequiredfield args="CPcodigo,#MSG_NominaAplicada#">
</cf_qforms>
