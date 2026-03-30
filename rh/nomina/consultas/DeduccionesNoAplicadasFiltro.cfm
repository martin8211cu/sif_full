<!--- ReporteLibroSalariosFiltro.cfm --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CalendarioPago" Default="Calendario de Pago" returnvariable="LB_CalendarioPago"/>
<cfoutput>
<table width="90%" align="center">
	<tr>
    	<td width="80%" valign="top">
			<cf_web_portlet_start style="box" titulo="#LB_nav__SPdescripcion#">
        		<table width="100%" align="center">
                	<tr>
                    	<td>
                          	<form action="DeduccionesNoAplicadas.cfm" method="get" name="form1" style="margin:0">
                           		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="margin:0">
              						<tr>
                                        <td scope="col" colspan="2" class="fileLabel" valign="middle" height="60" align="left">
                                        &nbsp;<strong><cf_translate key="IndicacionesReporte">Favor indicar el calendario de pagos a consultar.</cf_translate></strong>&nbsp;
                                        </td>
                            		</tr>
                                    <tr>
                                        <td nowrap align="right"> <strong><cf_translate  key="LB_Nominas">N&oacute;mina</cf_translate> :&nbsp;</strong></td>
                                        <td><cf_rhcalendariopagos form="form1" historicos="false" tcodigo="true" size="20" descsize="50"></td>
                                    </tr>
                                    <tr>
                                        <th scope="row"  colspan="2" class="fileLabel"><cf_botones values="Ver">&nbsp;</th>
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
    <cf_qformsrequiredfield name="CPid" description="#LB_CalendarioPago#">
	</cf_qforms>
</cfoutput>