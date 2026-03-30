<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 03-01-2006.
		Motivo: Nueva consulta de Pagos con Cheques y Tarjetas.
--->

<cf_templateheader title="Punto de Venta - Consulta de Pagos con Cheques y Tarjetas">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
					<form action="PagosCKTC_sql.cfm" method="get" name="form1">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td colspan="1" width="45%">&nbsp;</td>
								<td colspan="5">&nbsp;</td>					
							</tr>
							<tr>
								<td colspan="1">&nbsp;</td>
								<td align="right" nowrap="nowrap"><strong>Tipo de Pago:&nbsp;</strong></td>
								<td colspan="4">
									<select name="FAX12TIP">
										<option value="-1">--&nbsp;Todos&nbsp; --</option>
										<option value="TC">Tarjetas&nbsp;de&nbsp;Cr&eacute;dito</option>
										<option value="CK">Ch&eacute;ques</option>
									</select>
								</td>					
							</tr>
							<tr>
								<td colspan="1">&nbsp;</td>
								<td align="right" nowrap="nowrap"><strong>Fecha&nbsp;Inicial:&nbsp;</strong></td>
								<td>
									<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="fechaDes">
								</td>
								<td align="right" nowrap="nowrap"><strong>Fecha&nbsp;Final:&nbsp;</strong></td>
								<td colspan="2">
									<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="fechaHas">
								</td>
							</tr>
							<tr>
								<td colspan="1">&nbsp;</td>
								<td align="right" nowrap="nowrap"><strong>Caja:&nbsp;</strong></td>
								<td>
									<cf_sifcajasPV name="FAM01CODD" Ocodigo="Ocodigo2" form="form1">
								</td>
								<td colspan="3">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="1">&nbsp;</td>
								<td align="right"><strong>Formato:&nbsp;</strong></td>
								<td>
									<select name="formato">
									  <option value="flashpaper">Flashpaper</option>
									  <option value="pdf">Adobe PDF</option>
									</select>
								</td>
							</tr>
							
							<tr>
								<td colspan="6">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="6" align="center"><input type="submit" name="Consultar" value="Consultar"></td>
							</tr>
							
						</table>
					</form>
					</cfoutput>
				<cf_web_portlet_end>
<cf_templatefooter>	 

<cf_qforms>
<script language="javascript" type="text/javascript">
<!--
	objForm.fechaDes.required = true;
	objForm.fechaDes.description = "Fecha Inicial";
	objForm.fechaHas.required = true;
	objForm.fechaHas.description = "Fecha Final";
	objForm.FAM01DES.required = true;
	objForm.FAM01DES.description = "Caja";
		

//-->
</script> 