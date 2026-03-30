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
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>	

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ReporteDetalladoDeSalarios"
Default="Reporte Detallado de Salarios"
returnvariable="LB_ReporteDetalladoDeSalarios"/>	

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDetalladoDeSalarios#" >
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			
			<cfoutput>
				<form method="post" name="form1" action="reporteSalariosCCSS.cfm" style="margin:0;" >
					<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
							<td width="45%" valign="top">
								<table width="100%" >
									<tr>
										<td valign="top">
											<cf_web_portlet_start border="true" titulo="#LB_ReporteDetalladoDeSalarios#" skin="info1">
										  		<div align="justify">
										  			<p>
													<cf_translate  key="LB_ReporteUtilizadoParaCorroborarLosMontosRegistradosEnElSicereContraLoEnviadoPorLaEmpresa">
													Reporte utilizado para corroborar los montos registrados en el sicere contra lo enviado por la empresa. Este reporte deber&aacute; ser coincidente con el reporte que entrega el Sicere.
													</cf_translate>
													</p>
												</div>
											<cf_web_portlet_end>									  
										</td>
									</tr>
								</table>  
							</td>
							<td valign="top">
								<table width="100%" cellpadding="2" cellspacing="2" align="center">

									<tr>
										<td align="right">
											<strong><cf_translate  key="LB_Periodo">Periodo</cf_translate>:&nbsp;</strong>
										</td>
										<td>
											<select name="periodo">
											<cfloop query="rsPeriodo">
												<option value="#Pvalor#" <cfif Year(Now()) eq Pvalor> selected </cfif>>#Pvalor#</option>
											</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<td align="right">
											<strong><cf_translate  key="LB_Mes">Mes</cf_translate>:&nbsp;</strong>
										</td>
										<td>
											<select name="mes">
											<cfloop query="rsMeses">
												<option value="#Pvalor#" <cfif Month(Now()) eq Pvalor>selected</cfif>>#Pdescripcion#</option>
											</cfloop>
											</select>
										</td>
									</tr>
									<tr>
										<td align="right">
											<strong><cf_translate  key="LB_GrupoDePlanillas">Grupo de Planillas</cf_translate>:&nbsp;</strong>
										</td>
										<td>
											<input name="GrupoPlanilla" type="text" id="GrupoPlanilla" size="6" maxlength="5" value="" onFocus="javascript:this.select();">
										</td>
									</tr>
									<tr>
										<td align="right">
											<strong><cf_translate  key="LB_ConsultarPor">Consultar por</cf_translate>:&nbsp;</strong>
										</td>
										<td>
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td>
														<input type="radio" name="masivo" value="0" checked >
													</td>
													<td>
														<strong><cf_translate  key="RAD_SalarioDetallado">Salario Detallado</cf_translate> </strong>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td>
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td>
												  		<input type="radio" name="masivo" value="1" >
													</td>
													<td>
														<strong><cf_translate  key="RAD_SalarioResumido">Salario Resumido</cf_translate> </strong>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="2">&nbsp;</td>
									</tr>
									<tr>
										<td align="center" colspan="2">
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Consultar"
											Default="Consultar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Consultar"/>
											
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Limpiar"
											Default="Limpiar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Limpiar"/>											
											<input type="submit" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
											<input type="reset" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>">
											
										</td>
									</tr>
									<tr>
										<td colspan="2">&nbsp;</td>
									</tr>
								</table>
							</td>	
						</tr>
					</table>
				</form>
			</cfoutput>				
		<cf_web_portlet_end>
	<cf_templatefooter>