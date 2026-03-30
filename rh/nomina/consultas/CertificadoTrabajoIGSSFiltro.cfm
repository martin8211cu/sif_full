<!--- CertificadoTrabajoIGSSFiltro.cfm --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado" returnvariable="LB_Empleado"/>
<cfoutput>
<table width="90%" align="center"><tr><td width="30%" align="center" valign="top">
    <cf_web_portlet_start style="box" titulo="Ayuda">
        <table width="200" align="center"><tr><td>
            <cf_Translate Key="Ayuda_Certificado_de_Trabajo_IGSS">Este reporte emite un Certificado de Trabajo para el IGSS Instituto Guatemalteco de Seguridad Social, Para los programas de Accidentes, Enfermedad Y Maternidad. Debe proporcionar la identificación del Empleado.</cf_Translate>
        </td></tr></table>
    <cf_web_portlet_end>
</td><td width="1%"></td><td width="69%" valign="top">
    <cf_web_portlet_start style="box" titulo="Filtro">
        <table width="600" align="center"><tr><td>
            <form action="CertificadoTrabajoIGSS.cfm" method="get" name="form1" style="margin:0">
            <table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" style="margin:0">
              <tr>
                <th scope="col" colspan="2" class="fileLabel" valign="middle" height="60" align="left">&nbsp;<cf_translate key="Indicacion_Empleado">Favor indicar el Empleado para el que se requiere el certificado.</cf_translate>&nbsp;</th>
              </tr>
              <tr>
                <th width="100" scope="row" class="fileLabel" valign="top" align="right">#LB_Empleado#&nbsp;:&nbsp;</th>
                <td width="500" valign="top"><cf_rhempleado>&nbsp;</td>
              </tr>
              <tr>
                <th scope="row"  colspan="2" class="fileLabel"><cf_botones values="Ver">&nbsp;</th>
              </tr>
            </table>
            </form>
        </td></tr></table>
    <cf_web_portlet_end>
</td></tr></table>
<cf_qforms>
	<cf_qformsrequiredfield name="DEid" description="#LB_Empleado#">
</cf_qforms>
</cfoutput>