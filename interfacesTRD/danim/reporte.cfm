<cfset titulo = "Reporte nuevo">

<cf_templateheader titulo="#titulo#">

<cf_web_portlet_start titulo="#titulo#">

<table width="380" border="1">
  <tr>
    <td>&nbsp;</td>
    <td>Periodo</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><cf_periodos></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><cf_meses></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><cf_botones Names="Imprimir"></td>
  </tr>
</table>



<cf_web_portlet_end titulo="#titulo#">

<cf_templatefooter>