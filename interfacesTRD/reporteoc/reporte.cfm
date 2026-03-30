<cfif origen is 'cc'>
<cfset titulo = "Reporte de ventas por OC">
<cfelse>
<cfset titulo = "Reporte de compras por OC">
</cfif>
<cf_templateheader titulo="#titulo#">

<cf_web_portlet_start titulo="#titulo#">

<form name="form1" method="post" action="<cfoutput>#archivo#</cfoutput>">
<table width="380" border="0" cellpadding="2" cellspacing="2" align="center">
    <tr>
      <td>
        <input type="radio" id="tipo_pend" name="tipo" value="pend" onClick="CambiaTipo()" checked="checked">
        <label for="tipo_pend">Documentos pendientes</label></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>
        <input type="radio" id="tipo_hist" name="tipo" value="hist" onClick="CambiaTipo()">
        <label for="tipo_hist">Documentos históricos</label></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Periodo</td>
      <td><cf_periodos name="Periodo" value=""></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Mes</td>
      <td><cf_meses name="Mes" value=""></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
       <td colspan="3" align="center"><cf_botones Names="btnGenerar" Values="Generar"></td>
 
    </tr>
  </table>
</form> 
</table>

<script type="text/javascript">
function CambiaTipo(){
	document.form1.Periodo.disabled = 
		document.form1.Mes.disabled = ! document.form1.tipo_hist.checked;
}
CambiaTipo()//ya que el tag no tiene como inhabilitarse
</script>

<cf_web_portlet_end titulo="#titulo#">

<cf_templatefooter>