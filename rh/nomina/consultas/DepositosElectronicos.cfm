<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ReporteDeDepositosElectronicos" Default="Reporte de Dep&oacute;sitos Electr&oacute;nicos" returnvariable="LB_ReporteDeDepositosElectronicos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ReporteDeDepositosCheques" Default="Reporte de Dep&oacute;sitos Cheques" returnvariable="LB_ReporteDeDepositosCheques" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_TipodeNomina" Default="Tipo de Nómina" returnvariable="MSG_TipodeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaAplicada" Default="Nómina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaNoAplicada" Default="Nómina no Aplicada" returnvariable="MSG_NominaNoAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_ElTipoDeCambioDebeSerMayorACero" Default="El tipo de cambio debe ser mayor a cero" returnvariable="MSG_ElTipoDeCambioDebeSerMayorACero" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_TipoDeNomina" Default="Tipo de N&oacute;mina" returnvariable="MSG_TipoDeNomina" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="MSG_NominaAplicada" Default="N&oacute;mina Aplicada" returnvariable="MSG_NominaAplicada" component="sif.Componentes.Translate" method="Translate"/> 
<!--- FIN VARIABLES DE TRADUCCION --->


<cfif isdefined('Lvar_tipo') and Lvar_tipo EQ 1>
	<cfset titulo = LB_ReporteDeDepositosCheques>
<cfelse>
	<cfset Lvar_tipo = 0>
	<cfset titulo = LB_ReporteDeDepositosElectronicos>
</cfif>

<cf_templateheader title="#titulo#">
		<cf_web_portlet titulo="#titulo#" >
			<cfinclude template="/rh/portlets/pNavegacion.cfm">	
			<form name="form1" method="post" action="DepositosElectronicos-form.cfm" style="margin:0;">
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
		</cf_web_portlet>
<cf_templatefooter>
<cf_qforms form="form1">
	<cf_qformsrequiredfield args="Tcodigo,#MSG_TipoDeNomina#">
    <cf_qformsrequiredfield args="CPcodigo,#MSG_NominaAplicada#">
</cf_qforms>
