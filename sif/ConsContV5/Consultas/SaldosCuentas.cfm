<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
    	Contabilidad - Consulta de Saldos por Cuenta Contable
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Consulta de Saldos por Cuenta Contable">
		
		<script language="JavaScript" type="text/javascript">					
			function ConsultaReporte(){
				alert("Randall Colomer");
				
			}	
		</script>
		
		<link href="STYLE.CSS" rel="stylesheet" type="text/css">
		<input type="image" id="imgDel" src="../imagenes/Borrar01_S.gif" title="Eliminar" style="display:none;">

		<form name="form1" method="post" action="SaldosCuentas.cfm">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
				</tr>
			
				<tr>					
				  <td align="center" valign="top">
						<table width="100%" cellpadding="2" cellspacing="0" align="center">
							<tr>
								<td nowrap>&nbsp;</td>
								<td nowrap colspan="4"><cfinclude template="CajaNegra/CajaNegraCuentas.cfm"></td>
								<td nowrap>&nbsp;</td>
							</tr>
							
							<tr><td nowrap colspan="6">&nbsp;</td></tr>
							<tr><td align="center" colspan="6" nowrap bgcolor="#CCCCCC"><strong>Criterios para Filtrar</strong></td></tr>
						
							<tr>
								<td nowrap>&nbsp;</td>
								<td nowrap colspan="4"><cfinclude template="SaldosFiltrosConNiveles.cfm"></td>
								<td nowrap>&nbsp;</td>
							</tr>
									
							<tr><td nowrap colspan="6">&nbsp;</td></tr>
							<tr><td align="center" colspan="6" nowrap bgcolor="#CCCCCC"><strong>Listas de Asientos Contables </strong></td></tr>
						
							<tr>
								<td nowrap colspan="2">&nbsp;</td>
								<td nowrap align="center" valign="top" colspan="2"><cfinclude template="ListaAsientosContables.cfm"></td>
								<td nowrap colspan="2">&nbsp; </td>
							</tr>
							
							<tr><td nowrap colspan="6"> <cfinclude template="ImprimeReporte.cfm"> </td></tr>
							<tr><td nowrap colspan="6">&nbsp;</td></tr>
						
							<tr>
								<td align="center" colspan="6">
									<input type="submit" name="Reporte" value="Consultar" onClick="javascript: ConsultaReporte()">
									<input type="reset" name="Limpiar" value="Limpiar">
									<input type="button" name="Regresar" value="Regresar" onClick="history.back();">
								</td>
						  	</tr>
			  		  </table>
			  		</td>
				</tr>
			</table>
		</form>
		
		<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
		<br>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
