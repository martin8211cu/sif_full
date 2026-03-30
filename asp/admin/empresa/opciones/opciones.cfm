<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset data = Politicas.trae_parametros_globales()>

<cf_templateheader title="Opciones para respaldo">
<cf_web_portlet_start titulo="Opciones para respaldo">
<cfoutput>
<form action="opciones-sql.cfm" method="post">
<table width="934" border="0" cellpadding="2" cellspacing="2">
  <tr>
    <td colspan="3" class="subTitulo">Opciones para el bulk copy usando bcp </td>
    </tr>
  <tr>
    <td width="230"><em><strong>Nombre</strong></em></td>
    <td width="404"><em><strong>Valor</strong></em></td>
    <td width="280"><em><strong>Valor ejemplo </strong></em></td>
  </tr>
  <tr>
    <td>Ruta completa del utilitario</td>
    <td><input type="text" name="respaldo_bcp_tool" value="#HTMLEditFormat( data.respaldo.bcp.tool )#" onfocus="this.select()" size="60" /></td>
    <td>/sybase/OCS-15_0/bin/bcp</td>
  </tr>
  <tr>
    <td>Opciones comunes </td>
    <td><input type="text" name="respaldo_bcp_opt" value="#HTMLEditFormat( data.respaldo.bcp.opt )#" onfocus="this.select()" size="60" /></td>
    <td>-c -t$@!\t$@! -r$@!\r\n -T 512000</td>
  </tr>
  
  <tr>
    <td>Opciones IN </td>
    <td><input type="text" name="respaldo_bcp_in" value="#HTMLEditFormat( data.respaldo.bcp.in )#" onfocus="this.select()" size="60" /></td>
    <td>-b1000</td>
  </tr>
  
  <tr>
    <td>Opciones OUT </td>
    <td><input type="text" name="respaldo_bcp_out" value="#HTMLEditFormat( data.respaldo.bcp.out )#" onfocus="this.select()" size="60" /></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>Opciones identity </td>
    <td><input type="text" name="respaldo_bcp_id" value="#HTMLEditFormat( data.respaldo.bcp.id )#" onfocus="this.select()" size="60" /></td>
    <td>-E</td>
  </tr>
  <tr>
    <td>Usuario y contraseña</td>
    <td><input type="text" name="respaldo_bcp_user" value="#HTMLEditFormat( data.respaldo.bcp.user )#" onfocus="this.select()" size="60"/></td>
    <td>-Usa -Pasp128 </td>
  </tr>
  <tr>
    <td>Servidor (-S) </td>
    <td><input type="text" name="respaldo_bcp_server" value="#HTMLEditFormat( data.respaldo.bcp.server )#" onfocus="this.select()" size="60" /></td>
    <td> MINISIF</td>
  </tr>
  <tr>
    <td>Ruta de los archivos </td>
    <td><input type="text" name="respaldo_path" value="#HTMLEditFormat( data.respaldo.path )#" onfocus="this.select()" size="60" /></td>
    <td>/tmp/aspweb-backup/</td>
  </tr>
  
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  
  <tr>
    <td>&nbsp;</td>
    <td colspan="2"><input type="submit" name="Submit" value="Aceptar" class="btnGuardar">
	<input name="regresar" type="button" id="regresar" value="Cancelar" class="btnLimpiar" onclick="this.disabled=true;window.open('../empresas.cfm','_self')"/></td>
    </tr>
</table>
</form></cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
