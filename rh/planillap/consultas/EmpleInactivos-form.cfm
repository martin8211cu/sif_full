<SCRIPT SRC="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.form1.CFid.value = '';
		document.form1.CFcodigo.value = '';
		document.form1.CFdescripcion.value = '';
		document.form1.CumpleHasta.value = '';
	}
</script>
<cfoutput>
	<form method="post" name="form1" action="EmpleInactivos-SQL.cfm">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr valign="top">
				<td width="50%">
					<table width="100%">
						<tr>
							<td height="173" valign="top">	
								<cf_web_portlet_start border="true" titulo="Empleados Inactivos" skin="info1">
									<div align="justify">
									  <p>En &eacute;ste reporte 
									  muestra una lista de empleados inactivos a hoy o por fecha. El filtro de fecha desde, si se utiliza sacará los inactivos a esa fecha. Se ordena por: Centro Funcional y fecha.</p>
								</div>
							  <cf_web_portlet_end></td>
						</tr>
					</table>  
				</td>
				<td width="50%" valign="top">
					<table width="100%" cellpadding="0" cellspacing="0" align="center">
						
						
					  <tr>
						<td><strong>Centro Funcional:</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					   
						<tr>
							<td align="left" nowrap>
							  	<cf_rhcfuncional tabindex="1">
							</td>
							<td align="center">&nbsp;</td>
							<td align="center">
								
							</td>
						</tr>
												
						<tr>
						  <td><strong>Fecha Hasta:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>	
						<tr>
							<td>
								<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>

								<cf_sifcalendario tabindex="2" name="CumpleHasta" value="#fecha#">
							</td>
							<td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>
						<tr>
						  <td><strong>Formato:</strong></td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
							
						</tr>	
						<tr>
							<td>
								<select name="formato" tabindex="3">
                                	<option value="FlashPaper">FlashPaper</option>
                                	<option value="pdf">Adobe PDF</option>
                                	<option value="Excel">Microsoft Excel</option>
                              	</select>
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="3" align="center">&nbsp;</td>
						</tr>																						
						<tr>
							<td align="center" colspan="3"><input type="submit" value="Generar" name="Reporte" tabindex="4">
							<input type="reset" name="Limpiar" value="Limpiar" tabindex="5" onClick="javascript:limpiar();"></td>
							</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	</cfoutput>
