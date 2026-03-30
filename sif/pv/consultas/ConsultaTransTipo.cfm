<!--- QUERY PARA el tag de Oficinas--->
<cfquery name = "rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
    from Oficinas
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<cf_templateheader title="Punto de Venta - Consulta de Transacciones por Tipo">

	
		<cf_templatecss>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Transacciones por Tipo">
				<cfinclude template="../../portlets/pNavegacion.cfm">
				<cfoutput>
					<form method="post" name="form1" action="ConsultaTransTipo-sql.cfm" style="margin: 0;">
						<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
							  	<td width="50%" valign="top">
									<cf_web_portlet_start border="true" titulo="Transacciones por Tipo" skin="info1">
										<div align="justify">En &eacute;ste reporte 
										  se detalla la informaci&oacute;n de todas 
										  las Transacciones por Tipo.
										  Encontraremos varios clasificaciones del
										  reporte, dependiendo por medio de qu&eacute; 
										  aspectos se desea detallar.
										  Este reporte se puede generar en varios
										  formatos, aumentando as&iacute; su utilidad 
										  y eficiencia en el traslado de datos.
										</div>
									<cf_web_portlet_end>
							  	</td>
								<td width="50%" valign="top">
									<table width="100%"  border="0" cellspacing="0" cellpadding="2">
									<!---
									  <tr>
										<td class="fileLabel" align="right">Moneda:</td>
										<td colspan="3">
											 <cf_sifmonedas CrearMoneda="false" Conlis="S">
										</td>
									  </tr>
									--->
									  <tr>
										<td class="fileLabel" align="right">Rango de Fechas:</td>
										<td width="1%">
											<cf_sifcalendario form="form1" name="Fdesde">
										</td>
									    <td align="center">a</td>
									    <td>
											<cf_sifcalendario form="form1" name="Fhasta">
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Caja Desde:</td>
										<td colspan="3">
											 <cf_sifcajasPV form="form1" FAM01CODD="FAM01CODD1" FAM01DES="FAM01DES1" Ocodigo="Ocodigo1" FAM01COD="FAM01COD1">
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Caja Hasta:</td>
										<td colspan="3">
											 <cf_sifcajasPV form="form1" FAM01CODD="FAM01CODD2" FAM01DES="FAM01DES2" Ocodigo="Ocodigo2" FAM01COD="FAM01COD2">
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Oficina:</td>
										<td colspan="3">
											<cf_sifoficinas form="form1">
										</td>
									  </tr>
									  <tr>
										<td class="fileLabel" align="right">Tipo de Transacci&oacute;n:</td>
										<td colspan="3">
											<select name="FAX01TIP">
												<option value="">-Seleccionar-</option>
												<option value="1">Factura </option>
												<option value="2">Recibo de CxC</option>
												<option value="4">Devoluciones</option>
												<option value="9">Adelantos</option>
												<option value="D">Recibos CxP</option>
											</select>
										</td>
									  </tr>
									 <!---
									   <tr>
										<td class="fileLabel" align="right">Estado:</td>
										<td colspan="3">
											<select name="estado">
												<option value="">-Seleccionar-</option>
												<option value="T" >Terminada </option>
												<option value="C" >Contabilizada</option>
												<option value="A">Anulada</option>
											</select>
										</td>
									  </tr>
									  --->
									  <tr>
										<td class="fileLabel" align="right">Formato:</td>
										<td colspan="3">
											<select name="formato">
											  <option value="flashpaper">Flash Paper</option>
											  <option value="pdf">Adobe PDF</option>
											  <option value="excel">Microsoft Excel</option>
											</select>
										</td>
									  </tr>
									  <tr>
										<td colspan="4" align="center">&nbsp;</td>
									  </tr>
									  <tr>
										<td colspan="4" align="center">
											<input type="submit" value="Generar" name="Reporte">
										</td>
									  </tr>
									</table>
							  </td>
							</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
					</table>
				</form>
			</cfoutput>
		<cf_web_portlet_end>
<cf_templatefooter>	  