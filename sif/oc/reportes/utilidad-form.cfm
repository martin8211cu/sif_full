<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfquery name="rsPeriodos" datasource="#session.dsn#">
	select distinct Speriodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Speriodo
</cfquery>
<cfquery name="rsMeses" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="vi.VSvalor"> as Valor, vi.VSdesc as Meses
	from Idiomas i
		inner join VSidioma vi
		on vi.Iid = i.Iid
		and vi.VSgrupo = 1
	where i.Icodigo = '#session.Idioma#'
	order by 1
</cfquery>
<cfset mesanterior = DateAdd('d', -1, CreateDate(Year(Now()), Month(Now()), 1))>
			<form name="form1" action="utilidad.cfm" method="post" onsubmit="return submitting(this)">
				<table width="732" border="0" align="center" cellpadding="0" cellspacing="3">
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td width="198" align="right"><strong>Ventas desde:</strong></td>
						<td width="35" align="left">&nbsp;</td>
						<td width="144" align="left"><select name="mesini" id="mesini" style="width:100%" onchange="re_enable(this.form)" >
                          <cfoutput query="rsMeses">
                            <option value="#Valor#" <cfif Valor is Month(mesanterior)>selected</cfif>>#Meses#</option>
                          </cfoutput>
                        </select></td>
					    <td width="20" align="right">&nbsp;</td>
					    <td width="209" align="left"><select name="perini" id="perini" style="width:100%" onchange="re_enable(this.form)" >
                          <cfoutput query="rsPeriodos">
                            <option value="#Speriodo#" <cfif Speriodo is Year(mesanterior)>selected</cfif>>#Speriodo#</option>
                          </cfoutput>
                        </select></td>
					    <td width="105" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><strong>Ventas hasta:</strong></td>
						<td nowrap align="left">&nbsp;</td>
						<td nowrap align="left"><select name="mesfin" id="mesfin" style="width:100%" onchange="re_enable(this.form)" >
                          <cfoutput query="rsMeses">
                            <option value="#Valor#" <cfif Valor is Month(mesanterior)>selected</cfif>>#Meses#</option>
                          </cfoutput>
                        </select></td>
					    <td nowrap align="right">&nbsp;</td>
					    <td nowrap align="left"><select name="perfin" id="perfin" style="width:100%" onchange="re_enable(this.form)" >
                          <cfoutput query="rsPeriodos">
                            <option value="#Speriodo#" <cfif Speriodo is Year(mesanterior)>selected</cfif>>#Speriodo#</option>
                          </cfoutput>
                        </select></td>
					    <td nowrap align="left">&nbsp;</td>
					</tr>
					<tr>
					  <td align="right"><strong>Orden comercial de ventas:</strong> </td>
				      <td>&nbsp;</td>
				      <td><input type="text" name="OC" onchange="re_enable(this.form)" /></td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				  </tr>
					<tr>
					  <td align="right">&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
				  </tr>
					<tr>
					  <td align="right"><strong>Desglose del reporte </strong> </td>
					  <td>&nbsp;</td>
					  <td><label><input type="radio" value="1" name="resumido" checked="checked" onchange="re_enable(this.form)" /> Resumido </label></td>
					  <td>&nbsp;</td>
					  <td><label><input type="radio" value="0" name="resumido" onchange="re_enable(this.form)" /> Detallado </label></td>
					  <td>&nbsp;</td>
				  </tr>
					
					<tr>
					  <td align="right">&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
					  <td>&nbsp;</td>
				  </tr>
					<tr>
					  <td align="right"><strong>Tipo de comparación </strong> </td>
					  <td>&nbsp;</td>
					  <td><label><input type="radio" value="costo"   name="comparar" checked="checked" onchange="re_enable(this.form)" /> Costo de ventas </label></td>
					  <td>&nbsp;</td>
					  <td><label><input type="radio" value="compras" name="comparar" onchange="re_enable(this.form)" /> Ventas vs Compras </label></td>
					  <td>&nbsp;</td>
				  </tr>
					<tr>
					  <td align="right">&nbsp;</td>
					  <td>&nbsp;</td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				      <td>&nbsp;</td>
				  </tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="6" align="center">
						<input name="btnGenerar" type="hidden" value="" />
						<input name="generar" id="generar" value="Generar reporte" type="submit"></td>
					</tr>
					<tr>
						<td colspan="6" align="center">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="6" align="Center"><!---(*) El periodo y mes corresponden con el mes de contabilización del documento---></td>
					</tr>
				</table>
			</form>
			
			<script type="text/javascript">
			function submitting(f)
			{
				f.generar.disabled = true;
				f.generar.value = "Generando reporte ...";
				return true;
			}
			function re_enable(f)
			{
				f.generar.disabled = false;
				f.generar.value = "Generar reporte";
				return true;
			}
			</script>
			
		<cf_web_portlet_end>
<cf_templatefooter>

