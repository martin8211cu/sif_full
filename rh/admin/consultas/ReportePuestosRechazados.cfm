 <!--- variables de traduccion--->
<cfinvoke component="sif.Componentes.Translate"
			method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate" Key="LB_ReportedePuestoRechazado" Default="Reporte de Puesto Rechazado" returnvariable="LB_ReportedePuestoRechazado"/>
<!--- Fin variables de traduccion--->	


<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start border="true" titulo="#LB_ReportedePuestoRechazado#" skin="#Session.Preferences.Skin#">
			<form name="form1" action="ConsultaPuestoRechazado.cfm" method="post">
					<table width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr><td> </td>
							<td width="15%" align="right">
								<cf_botones values="Regresar" names="Regresar">
							</td>
						</tr>
						<tr>
							<td valign="top" colspan="2">
							<iframe id="ReporteP" frameborder="0" name="ReporteP" width="950"  height="600" 
							style="visibility:visible;border:none; vertical-align:top" 
							src="../catalogos/formPuestosReport.cfm?RHPcodigo=<cfoutput>#form.Codigo#</cfoutput>&Formato=HTML&CRechazo=1">
							</iframe>
							</td>	
						</tr>
					</table>			
			</form>
	 <cf_web_portlet_end>		
<cf_templatefooter>	
