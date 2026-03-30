<cfoutput>
<table border="1" cellspacing="0" cellpadding="0">
  <tr> 
	<td>
		<!--- <cf_sifleerimagen autosize="false" border="false" tabla="RHImagenEmpleado" campo="foto" condicion="DEid = #rsEmpleado.DEid#" conexion="#Session.DSN#" width="75" height="100"> --->
			<img src="../../nomina/consultas/jerarquia_cf/foto_responsable.cfm?s=#URLEncodedFormat(rsEmpleado.DEid)#" border="0" width="55" height="73">
	</td>
  </tr>
</table>
</cfoutput>
