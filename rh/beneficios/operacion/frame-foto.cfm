<cfoutput>
<table border="1" cellspacing="0" cellpadding="0">
  <tr> 
	<td>
		<cf_sifleerimagen autosize="false" border="false" tabla="RHImagenEmpleado" campo="foto" condicion="DEid = #rsEmpleado.DEid#" conexion="#Session.DSN#" width="75" height="100">
	</td>
  </tr>
</table>
</cfoutput>
