<cfset Lvar_tipo = 1>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ReporteDeDepositosElectronicos" default="Reporte de Dep&oacute;sitos Electr&oacute;nicos" returnvariable="LB_ReporteDeDepositosElectronicos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ReporteDeDepositosCheques" default="Reporte de Dep&oacute;sitos Cheques" returnvariable="LB_ReporteDeDepositosCheques" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TipodeNomina" default="Tipo de Nómina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaAplicada" default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaNoAplicada" default="Nómina no Aplicada" returnvariable="MSG_NominaNoAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_ElTipoDeCambioDebeSerMayorACero" default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_TipoDeNomina" default="Tipo de N&oacute;mina" returnvariable="MSG_TipoDeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="MSG_NominaAplicada" default="N&oacute;mina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->


<cfif isdefined('Lvar_tipo') and Lvar_tipo EQ 1>
	<cfset titulo = LB_ReporteDeDepositosCheques>
<cfelse>
	<cfset Lvar_tipo = 0>
	<cfset titulo = LB_ReporteDeDepositosElectronicos>
</cfif>
<cf_templateheader title="#titulo#">
		<cf_web_portlet_start titulo="#titulo#" >
			<cfinclude template="/rh/portlets/pNavegacion.cfm">	
			<form name="form1" method="post" action="DepositosCheques-form.cfm" style="margin:0;">
            	<input name="chq" type="hidden" value="1">
				<table width="80%" cellpadding="2" cellspacing="0" border="0" align="center">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td nowrap align="right"> <strong><cf_translate  key="LB_NominasAplicadas">N&oacute;minas Aplicadas</cf_translate> :&nbsp;</strong></td>
						<td><cf_rhcalendariopagos form="form1" historicos="true" tcodigo="true"></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							<input name="chkTxt" type="checkbox" id="chkTxt"/>
							<label for="chkTxt" style="font-style:normal; font-variant:normal; font-weight:normal">
								<cf_translate key="CHK_GenerarARchivoDeExportacion">Generar Archivo de Exportaci&oacute;n</cf_translate>
							</label>
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
