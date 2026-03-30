<!--- Variables de Traducción --->
<cfinvoke Key="LB_CalendarioPago" Default="Calendario de Pago" returnvariable="LB_CalendarioPago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Deduccion" Default="Deducci&oacute;n" returnvariable="LB_Deduccion" component="sif.Componentes.Translate" method="Translate"/>
<!--- Pintado de la Pantalla de Filtros --->
<cfoutput>
<table width="100%" align="center" cellpadding="1" cellspacing="0">
	<tr>
		<td width="69%" align="center" valign="top">
    		<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
        		<table width="600" align="center">
					<tr>
						<td>
       						<form name="form1" method="get" action="ReporteDescuentosAplicados.cfm" style="margin:0">
								<table align="center" border="0" cellpadding="2" cellspacing="2" style="margin:0">
							  		<tr>
                                    	<td nowrap align="right"><strong>#LB_CalendarioPago#&nbsp;:&nbsp;</strong></td>
                                    	<td><cf_rhcalendariopagos historicos="true" tcodigo="true" descsize="50"></td>
                                    </tr>
                                    <tr>
                                    	<td nowrap align="right"><strong>#LB_Deduccion#&nbsp;:&nbsp;</strong></td>
                                    	<td><cf_rhtipodeduccion form="form1" size= "40" tabindex="1"></td>
                                    </tr>
									<tr><td colspan="2" nowrap><cf_botones values="Ver" tabindex="1"></td>
									</tr>					
								</table>
						  </form>
        				</td>
					</tr>
				</table>
    		<cf_web_portlet_end>
		</td>
	</tr>
</table>
<cf_qforms>
	<cf_qformsrequiredfield name="Tcodigo" description="#LB_CalendarioPago#">
    <cf_qformsrequiredfield name="CPid" description="#LB_CalendarioPago#">
</cf_qforms>
</cfoutput>
