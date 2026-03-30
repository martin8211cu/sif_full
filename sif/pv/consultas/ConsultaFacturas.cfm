<!--- QUERY PARA el tag de Oficinas--->
<cfquery name = "rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
    from Oficinas
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name = "rsCajas" datasource="#session.DSN#">
	Select Ocodigo,FAM01CODD,FAM01DES
    from FAM001
    where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cf_templateheader title="Punto de Venta - Consulta de Facturas">
	<cf_templatecss>
		
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Consulta de Facturas">
				<cfinclude template="../../portlets/pNavegacion.cfm">
					<cfoutput>
						<form method="get" name="form1" action="ConsultaFacturas-sql.cfm">
							<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
								  <td width="50%" valign="middle">
										<cf_web_portlet_start border="true" titulo="Facturas" skin="info1">
											<div align="justify">En &eacute;ste reporte 
											  se detalla la informaci&oacute;n de todas las facturas.
											  Encontraremos varios clasificaciones del
											  reporte, dependiendo por medio de que 
											  aspectos se desea detallar.
											  Este reporte se puede generar en varios
											  formatos, aumentando as&iacute; su utilidad 
											  y eficiencia en el traslado de datos.
											</div>
										<cf_web_portlet_end>
									</td>
									<td width="50%" valign="top">
										<table width="100%"  border="0" cellspacing="2" cellpadding="0">
										  <tr>
										   	<td align="right"><strong>Fecha Inicial:</strong></td>
											<td>
												<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaI"> 												
											</td>
										  </tr>
										  <tr>
										   	<td align="right"><strong>Fecha Final:</strong></td>
											<td>
												<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaF">
											</td>
										  </tr>										  
										  <tr>
										   	<td align="right"><strong>Oficina</strong></td>
											<td>
												<cf_sifoficinas form="form1">							
											</td>
										  </tr>
										  <tr>
										   	<td align="right"><strong>Moneda</strong></td>
											<td>
												 <cf_sifmonedas CrearMoneda = 'false' Conlis = 'S'>							
											</td>
										  </tr>
										  <tr>
											<td align="right"><strong>Caja</strong></td>
											<td><cf_sifcajasPV name="FAM01CODD" Ocodigo="Ocodigo2" form="form1"></td>
									  	   </tr>
										  <tr>
											<td align="right"><strong>Factura Inicial:</strong></td>
											<td><input type="text" name="FAX11DOCI" size="20" maxlength="15" ></td>
									  	   </tr>
										  <tr>
											<td align="right"><strong>Factura Final:</strong></td>
											<td>
												<input type="text" name="FAX11DOCF" size="20" maxlength="15" >
											</td>
									  	   </tr>
										  <tr>
										  <tr>
										  <tr>
											<td align="right"><strong>Formato</strong></td>
											<td><select name="formato">
											  <option value="html">HTML</option>
											  <option value="flashpaper">Flash Paper</option>
											  <option value="pdf">Adobe PDF</option>
											</select></td>
										  </tr>
										  <tr>
											<td colspan="2" align="center">&nbsp;</td>
										  </tr>
										  <tr>
											<td colspan="2" align="center"><input type="submit" value="Generar" name="Reporte"></td>
										  </tr>
										</table>
								  </td>
								</tr>
							</table>
						</form>
					</cfoutput>
				<cf_web_portlet_end>
<cf_templatefooter>	  
