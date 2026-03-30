<cf_templateheader title="Asignaci&oacute;n de Reportes por Estructura Programática">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Asignaci&oacute;n de Reportes por Estructura Programática">
        <cfinclude template="/home/menu/pNavegacion.cfm">
        <cfset modo = "ALTA">
		<cfset currentPage = GetFileFromPath(GetTemplatePath())>
        <cfset navegacion = "">
        <table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tr>
                <td colspan="4" class="tituloAlterno" align="center" style="text-transform: uppercase; ">
                    Relaci&oacute;n de reporte - Estructuras Program&aacute;ticas
                </td>
            </tr>
            <tr>
                <td align="center" valign="top" height="600">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2">
                        <tr>
                            <td><cfinclude template="ReporteEstrProg-form.cfm"></td>
                        </tr>
                        <tr> 
                            <td><cfinclude template="ReporteEstrProg-lista.cfm"></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

    <cf_web_portlet_end>
<cf_templatefooter>
