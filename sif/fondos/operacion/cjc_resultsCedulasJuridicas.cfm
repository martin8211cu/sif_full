<html>
<head><title> Estado de la Importaci&oacute;n </title></head>
<script>
function Atras(){
document.location = "cjc_CedulasJuridicas.cfm";
}
</script>
</body>
 <a href='javascript:Atras();'>Regresar</a>
<table border="1" width="100%" cellspacing="0" cellpadding="0">
  <tr>
  		<td width="100%" bgcolor="#CCccff"><p align='center'><b>Resultados de la Actualizacion</b></p></td>
  </tr>
  <cfoutput query="rs1">
  <tr>
  		<td width="100%">
			<p align='center'>
				<b>#rs1.Msg#</b>
			</p>
		</td>
  </tr>
  </cfoutput>	
</table>
 <a href='javascript:Atras();'>Regresar</a>
</body>
</html>
