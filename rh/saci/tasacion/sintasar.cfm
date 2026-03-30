<cf_templateheader title="Consola de tasación">
<cf_web_portlet_start titulo="Consulta de eventos sin tasar">
<cfoutput>
<cfparam name="url.mp" type="numeric" default="30">
<form action="sintasar-group.cfm" method="get"><table width="545" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="43">&nbsp;</td>
    <td width="139">&nbsp;</td>
    <td width="351">&nbsp;</td>
    </tr>
  <tr>
    <td colspan="3"><p>Averigüe porqué hay tráfico sin tasar.</p>
      <p>El tráfico se tasa según tres criterios distintos:</p>
      <ul>
        <li>Acceso a medios ( línea 900 ). Utiliza rango de direcciones según el servidor de acceso utilizado.</li>
        <li>Tarjetas de prepago. Utiliza nombres de usuario especiales que corresponden a las tarjetas de prepago.</li>
        <li>Cuentas contratadas. Las identifica según el nombre del usuario.</li>
        </ul>
      <p>Cuando una llamada no encaja en ninguno de estos tres criterios, queda reportada en esta bitácora de tráfico sin tasar.</p></td>
    </tr>
  
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" class="subTitulo">Periodo de consulta </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><input name="cantidad" type="text" onFocus="this.select()" value="#url.mp#" size="6" maxlength="2">
      <select name="unidad" id="unidad">
        <option value="1">minutos</option>
        <option value="60">horas</option>
        <option value="1440">días</option>
      </select>      </td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><input type="submit" name="Submit" value="Consultar" class="btnSiguiente"></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2"><p><em><strong>Nota: </strong></em>Esta consulta accederá una gran cantidad de información, y podría colapsar el servidor. Se permite consultar un máximo de 24 horas de información. </p>      
      <p>Úsela con discreción. </p></td>
    </tr>
</table>
</form></cfoutput>
<cf_web_portlet_end> 
<cf_templatefooter>