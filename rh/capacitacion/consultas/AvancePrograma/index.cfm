<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="Avance del Programa de Capacitaci&oacute;n" skin="#Session.Preferences.Skin#"> 
	<cfinclude template="/home/menu/pNavegacion.cfm">
	
<form action="resumen.cfm" method="get" name="form1" id="form1">
	<table width="100%"  border="0">
  <tr>
    <td width="5%">&nbsp;</td>
    <td width="37%">&nbsp;</td>
    <td width="3%">&nbsp;</td>
    <td width="28%">&nbsp;</td>
    <td width="20%">&nbsp;</td>
    <td width="7%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td rowspan="7" valign="top"><cf_web_portlet_start border="true" titulo="Avance del programa de capacitación" skin="info1">
													<div align="justify" style="margin:12px ">
													  <p>En esta consulta se muestra el avance de la capacitaci&oacute;n del personal con respecto al plan de capacitaci&oacute;n de sus puestos. <br>
												      Seleccione los par&aacute;metros para los que desea realizar la consulta. </p>
		</div>
											  <cf_web_portlet_end></td>
    <td>&nbsp;</td>
    <td colspan="2"><strong>Consulta del avance del programa de capacitaci&oacute;n. </strong></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Centro Funcional </td>
    <td><cf_rhcfuncional></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Puesto</td>
    <td><cf_rhpuesto></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>Empleado</td>
    <td><cf_rhempleado></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><input type="submit" name="Submit" value="Consultar"> &nbsp;
      <input type="reset" name="ResetMe" value="Limpiar"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</form>
	<cf_web_portlet_end>
<cf_templatefooter>