<!--- datos --->	
<cfquery name="rsVendedores" datasource="#Session.DSN#">
	select convert(varchar,FVid) as FVid, FVnombre from FVendedores 
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cf_templateheader title="#Request.Translate('ModuloFA','Facturación','/sif/Utiles/Generales.xml')#">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Consulta de Comisiones por Vendedor">
			<form action="repComisiones.cfm" method="post" name="form1">
				<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td align="right"><STRONG>Vendedor:&nbsp;</STRONG></td>
						<td>
							<select name="FVid" tabindex="1">
								<option value=""> -- Todos  -- </option>
								<cfoutput query="rsVendedores"> 
									<option value="#rsVendedores.FVid#">#rsVendedores.FVnombre#</option>
								</cfoutput>
							</select>
						</td>
						<td align="right"><STRONG>Fecha Inicial:&nbsp;</STRONG></td>
						<td>
							<cf_sifcalendario name="fechai">
						</td>
						<td align="right"><STRONG>Fecha Inicial:&nbsp;</STRONG></td>
						<td>
							<cf_sifcalendario name="fechaf">
						</td>
	
						<td align="right"><STRONG>Ver:&nbsp;</STRONG></td>
						<td>
							<select name="Cpagada" tabindex="1">
								<option value="0"> -- Todos  -- </option>
								<option value="1">Pagadas</option>
								<option value="2">No Pagadas</option>
							</select>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="8" align="center">
							<input type="submit" name="Consultar" value="Consultar">
							<input type="button" name="Limpiar" value="Limpiar" onClick="limpiar();">
						</td>
					</tr>
				</table>
			</form>
		<script type="text/javascript" language="javascript1.2">
			function limpiar(){
				document.form1.FVid.value='';
				document.form1.fechai.value='';
				document.form1.fechaf.value='';
				document.form1.Cpagada.value=0;
			}
		</script>
		<cf_web_portlet_end>
<cf_templatefooter> 