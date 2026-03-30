<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">
  <tr> 
	<td>
		<cf_sifleerimagen2 
			autosize="false" 
			border="false" 
			tabla="RHImagenOferente" 
			campo="foto" 
			condicion="Ecodigo = #session.Ecodigo# and RHOid = #form.RHOid#" 
			conexion="#Session.DSN#" width="75" height="100">
	</td>
  </tr>
</table>
</cfoutput>