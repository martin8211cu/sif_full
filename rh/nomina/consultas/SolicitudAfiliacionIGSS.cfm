<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_SolicitudDeAfiliacionIGSS" Default="Solicitud de Afiliaci&oacute;n IGSS" returnvariable="LB_SolicitudDeAfiliacionIGSS" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>	
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

	<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="#LB_SolicitudDeAfiliacionIGSS#">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
						</tr>
                        <tr>
                        	<td width="50%" align="center">
                            	<cf_web_portlet_start titulo="#LB_SolicitudDeAfiliacionIGSS#" skin="info1">
                                    <table width="85%">
                                        <tr>
                                        	<td>
                                                <p>
                                                <cf_translate  key="LB_ReporteQueMuestraLosDatosNecesariosParaSolicitudDeAfiliacion">
                                                    Reporte que muestra los datos necesarios para la Solicitud de Afiliaci&oacute;n
                                                </cf_translate>
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                <cf_web_portlet_end>
                            </td>
							<td align="center">
								<form name="filtro" method="post" action="SolicitudAfiliacionIGSS-form.cfm">
									<table width="85%" border="0" cellpadding="1" cellspacing="1" align="center">
										<tr><td>&nbsp;</td></tr>
                                        <tr>
                                        	<td> <cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
                                            <td><cf_rhempleado form="filtro"></td>
                                        </tr>
										<tr><td nowrap align="center" colspan="2"><cf_botones values="Generar"></td></tr>
									</table>
								</form>
							</td>
						</tr>
					</table>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>
<cf_qforms form="filtro">
	<cf_qformsrequiredfield args="DEid,#LB_Empleado#">
</cf_qforms>