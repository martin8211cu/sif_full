<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Reporte de vouchers </cf_templatearea>
<cf_templatearea name="header">
<cfinclude template="header.cfm"></cf_templatearea>
<cf_templatearea name="body">



<cfinclude template="/home/menu/pNavegacion.cfm">
		
		<cf_web_portlet titulo="Reporte de vouchers">
		<form name="form1" action="vouchers2.cfm" method="get">
		
		  <table width="371" border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
              <td colspan="3">Seleccione el rango de fechas para el cual desea generar el reporte de vouchers </td>
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
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr align="center">
              <td colspan="3"><input name="submit" type="submit" value="Generar Reporte"></td>
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
