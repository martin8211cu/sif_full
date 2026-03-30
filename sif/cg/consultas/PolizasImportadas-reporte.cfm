<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Inicio. --->

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<!--- Tags para la traduccion --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default= "Reporte de P&oacute;lizas Transferidas y Aplicadas" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Poliza" Default= "P&oacute;liza" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_Poliza"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_fechaInicio" Default= "Fecha Inicio" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_fechaInicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_fechaFin" Default= "Fecha Fin" XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_fechaFin"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescripcionProceso" Default= "Esta consulta entrega un reporte de p&oacute;lizas transferidas desde la empresa PEMEX Internacional España, S.A." XmlFile="consultaPolizasTransferidas.xml" returnvariable="LB_DescripcionProceso"/>

<!--- Form --->
<cf_templateheader title="#LB_titulo#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#LB_titulo#</cfoutput>">
		<br/>
		<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
				<td valign="top">
					<table width="90%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="300">
								<cf_web_portlet_start border="true" titulo="<cfoutput>#LB_titulo#</cfoutput>" skin="info1">
									<p align="justify"> <cfoutput>#LB_DescripcionProceso#</cfoutput> </p>
								<cf_web_portlet_end>
						  </td>
						</tr>
				  </table>
				</td>
				<td valign="top">
					<form name="form1" method="post" action="PolizasImportadas-reporte-frame.cfm">
						<table>
							<tr>
								<td align="left" valign="baseline" nowrap><strong><cfoutput>#LB_Poliza#:</cfoutput></strong></td>
								<td align="left" valign="baseline" nowrap>
								<cf_inputNumber name="Poliza" value="" enteros="4" negativos="false" comas="no"></td>
							</tr>
							<tr>
								<td valign="baseline" nowrap><strong><cfoutput>#LB_fechaInicio#:</cfoutput></strong></td>
								<td valign="baseline" nowrap>
									<cf_sifcalendario name="fechaInicio" value="" form="form1"  tabindex="1">
								</td>
							</tr>
							<tr>
								<td valign="baseline" nowrap><strong><cfoutput>#LB_fechaFin#:</cfoutput></strong></td>
								<td valign="baseline" nowrap>
									<cf_sifcalendario name="fechaFin" value="" form="form1"  tabindex="1">
								</td>
							</tr>
						</table>
						<br />
						<table>
						</table>
						<br />
						<table>
							
						</table>
						<br />
						<table>
							
						</table>
						<br />
						<cf_botones values="Consultar" tabindex="1">
					</form>
				</td>
		  </tr>
	  </table>
	<cf_web_portlet_end>
<cf_templatefooter>

<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Fin. --->
