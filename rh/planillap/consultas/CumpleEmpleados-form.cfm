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
	}
</script>
<cfoutput>
	<form method="post" name="form1" action="CumpleEmpleados-SQL.cfm">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr valign="top">
				<td width="50%">
					<table width="100%">
						<tr>
							<td height="173" valign="top">	
								<cf_web_portlet_start border="true" titulo="Cumpleaños de Empleados" skin="info1">
									<div align="justify">
									  <p>En &eacute;ste reporte 
									  muestra una lista de empleados que cumplen años hoy , en esta semana o este mes. 
									  Se ordena por: Centro Funcional y fecha de cumpleaños.</p>
								</div>
							  <cf_web_portlet_end></td>
						</tr>
					</table>  
				</td>
				<td width="50%" valign="top">
					<table width="100%" cellpadding="0" cellspacing="0" align="center">
						
						
					  <tr>
						<td ></td>
						<td >&nbsp;</td>
						<td >&nbsp;</td>
					  </tr>
					   
						<tr>
							<td align="left" nowrap><strong>Centro Funcional: &nbsp;</strong>							  							</td>
							<td align="center"><cf_rhcfuncional tabindex="1"></td>
							<td align="center">							</td>
						</tr>
												
						<tr>
						  	<td>&nbsp;</td>
						  	<td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>	
						<tr>
						  <td nowrap="nowrap"><strong>Cumpleaños: </strong>						  </td>
						  <td nowrap="nowrap" ><strong>
						    <input type="radio" name="optCumple" value="0" tabindex="2"  title="A Hoy" checked="checked" />
A Hoy &nbsp; &nbsp;
<input type="radio" name="optCumple" value="1" tabindex="3"  title="Esta Semana" />
Esta Semana  &nbsp; &nbsp;
<input type="radio" name="optCumple" value="2" tabindex="4"  title="Del Mes" />
 Mes </strong></td>
						  <td >&nbsp;</td>
					  </tr>
					  <tr>
						  <td>&nbsp;</td>
						  <td >&nbsp;</td>
							<td >&nbsp;</td>
						</tr>	
						<tr>
						  <td><strong>Mes:</strong></td>
						  <td ><select name="mes" tabindex="5">
                            <option value="1"  <cfif datepart('m',now()) EQ 1>selected</cfif>>Enero</option>
                            <option value="2"  <cfif datepart('m',now()) EQ 2>selected</cfif>>Febrero</option>
                            <option value="3"  <cfif datepart('m',now()) EQ 3>selected</cfif>>Marzo</option>
                            <option value="4"  <cfif datepart('m',now()) EQ 4>selected</cfif>>Abril</option>
                            <option value="5"  <cfif datepart('m',now()) EQ 5>selected</cfif>>Mayo</option>
                            <option value="6"  <cfif datepart('m',now()) EQ 6>selected</cfif>>Junio</option>
                            <option value="7"  <cfif datepart('m',now()) EQ 7>selected</cfif>>Julio</option>
                            <option value="8"  <cfif datepart('m',now()) EQ 8>selected</cfif>>Agosto</option>
                            <option value="9"  <cfif datepart('m',now()) EQ 9>selected</cfif>>Setiembre</option>
                            <option value="10" <cfif datepart('m',now()) EQ 10>selected</cfif>>Octubre</option>
                            <option value="11" <cfif datepart('m',now()) EQ 11>selected</cfif>>Noviembre</option>
                            <option value="12" <cfif datepart('m',now()) EQ 12>selected</cfif>>Diciembre</option>
                          </select></td>
						  <td >&nbsp;</td>
					  </tr>
						<tr>
						  <td>&nbsp;</td>
						  <td >&nbsp;</td>
						  <td >&nbsp;</td>
					  </tr>
						<tr>
						  <td><strong>Formato:</strong></td>
						  <td ><select name="formato" tabindex="6">
                            <option value="FlashPaper">FlashPaper</option>
                            <option value="pdf">Adobe PDF</option>
                            <option value="Excel">Microsoft Excel</option>
                          </select></td>
							<td >&nbsp;</td>
						</tr>	
						<tr>
							<td>&nbsp;</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="3" align="center">&nbsp;</td>
						</tr>																						
						<tr>
							<td align="center" colspan="3"><input type="submit" value="Generar" name="Reporte" tabindex="7">
							<input type="reset" name="Limpiar" value="Limpiar" tabindex="8" onClick="javascript:limpiar();"></td>
							</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
	</cfoutput>
