<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Picking List</cf_templatearea>
<cf_templatearea name="header"><cfinclude template="header.cfm"></cf_templatearea>
<cf_templatearea name="body">



<cfinclude template="/home/menu/pNavegacion.cfm">
		<cf_web_portlet titulo="Picking list">
		<form name="form1" action="picking2.cfm" method="get" target="_blank">
		
		<table width="371" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td colspan="3">Seleccione el rango de fechas para el cual desea generar el Picking List </td>
    </tr>
  <tr>
    <td width="96">&nbsp;</td>
    <td width="58">&nbsp;</td>
    <td width="205">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Desde</td>
    <td><cf_sifcalendario value="#DateFormat(Now(),'dd/mm/yyyy')#" name="desde"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Hasta</td>
    <td><cf_sifcalendario value="#DateFormat(Now(),'dd/mm/yyyy')#" name="hasta"></td>
  </tr>
  <tr align="center">
    <td colspan="3"><input name="page" type="checkbox" id="page" checked value="1">
      Imprimir cada pedido en una p&aacute;gina separada </td>
    </tr>
  <tr align="center">
    <td colspan="3"><input type="submit" value="Generar"></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

		</form>
		</cf_web_portlet>


</cf_templatearea>
</cf_template>
