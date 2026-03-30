<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CuentasInventario" Default="Cuentas de Inventario" returnvariable="LB_CuentasInventario"/>
<cf_templateheader title="#LB_CuentasInventario#">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_CuentasInventario#">
			<form action="CuentasInventario-sql.cfm" method="post" name="consulta">
				<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
					<tr><td colspan="4">&nbsp;</td></tr>
					<!--- Almacen --->
					<tr>
                    	<td width="40%" align="right" valign="baseline">Art&iacute;culo Inicial:&nbsp;</td>
						<td valign="baseline" nowrap><cf_sifarticulos form="consulta" id="AidI" name="AcodigoI" desc="AdescripcionI"></td>
						<td width="40%" align="right" valign="baseline">Art&iacute;culo Final:&nbsp;</td>
						<td valign="baseline" nowrap> <cf_sifarticulos form="consulta" id="AidF" name="AcodigoF" desc="AdescripcionF"></td>
					</tr>
					<tr>
						<td align="right" valign="baseline" nowrap>Formato:&nbsp;</td>
						<td valign="baseline" nowrap colspan="3">
							<select name="Formato" id="Formato" tabindex="1">
                                <option value="3">EXCEL</option>
                            </select>
						</td>
					</tr>
					<td colspan="4" align="center"> 
						<input name="btnConsultar" type="submit" value="Consultar">
						<input type="reset" name="Reset" value="Limpiar"> </td>
					</tr>
				</table>
			</form>
	<cf_web_portlet_end>	
<cf_templatefooter>