<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ComparativoDeInventarioVrsPrecioMercado"
	Default="Comparativo de inventario vrs precio mercado"
	returnvariable="LB_Comparativo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"
	returnvariable="BTN_Consultar"/>
	
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select  Aid, Bdescripcion 
	from Almacen 
	where Ecodigo = #session.Ecodigo#
</cfquery> 	

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select distinct Speriodo as Kperiodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Speriodo desc
</cfquery>

<cfquery name="rsMes" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and a.Iid = b.Iid
	and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfquery datasource="#session.DSN#" name="rsMesAux">
	select Pvalor 
	 from Parametros 
	where Pcodigo=60 
	and Ecodigo = #session.Ecodigo#		
</cfquery>

<cfquery datasource="#session.DSN#" name="rsPeriodosAux">
	select Pvalor as Kperiodo
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo=50
</cfquery> 

<cf_templateheader title="#LB_Comparativo#">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Comparativo#">
			<form action="SQLComparativoInventarios.cfm" method="post" name="consulta">
			<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr><td colspan="4">&nbsp;</td></tr>
				<!--- Almacen --->
				<tr>
					<td valign="baseline" align="right" nowrap><cf_translate  key="LB_AlmacenDesde">Almac&eacute;n Desde</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
					<td valign="baseline" nowrap>
						<select name="almini">
							<cfoutput query="rsAlmacen">
								<option value="#rsAlmacen.Aid#">#rsALmacen.Bdescripcion#</option>
							</cfoutput>
						</select>							
					</td>
					<td valign="baseline" align="right" nowrap><cf_translate  key="LB_AlmacenHasta">Almac&eacute;n Hasta</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
					<td valign="baseline" nowrap>
						<cfset ultimo = "">
						<select name="almfin">
							<cfoutput query="rsAlmacen">
								<cfset ultimo = #rsAlmacen.Aid# >
								<option value="#rsAlmacen.Aid#">#rsALmacen.Bdescripcion#</option>
							</cfoutput>
						</select>
						<script language="JavaScript1.2" type="text/javascript">
							document.consulta.almfin.value = '<cfoutput>#ultimo#</cfoutput>'
						</script>	 						
					</td>
				</tr>
				<!--- Articulo --->
				<tr>
					<td valign="baseline" align="right" nowrap><cf_translate  key="LB_ArticuloDesde">Art&iacute;culo Desde</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
					<td nowrap><cf_sifarticulos form="consulta" frame="fri" id="Aid1" name="Acodigo1" desc="Aidescripcion" ></td>
					<td valign="baseline" align="right" nowrap><cf_translate  key="LB_ArticuloHasta">Art&iacute;culo Hasta</cf_translate>:&nbsp;&nbsp;&nbsp;</td>						
			        <td nowrap><cf_sifarticulos form="consulta" frame="frf" id="Aid2" name="Acodigo2" desc="Afdescripcion" ></td>
				</tr>
				<!--- Periodo/Mes Inicial --->
				<tr>
					<td valign="baseline" align="right" nowrap><cf_translate  key="LB_Periodo">Per&iacute;odo </cf_translate>:&nbsp;&nbsp;&nbsp;</td>
					<td valign="baseline" nowrap>
						<select name="periodo">
							<cfoutput query="rsPeriodos">
								<option value="#rsPeriodos.Kperiodo#"<cfif #rsPeriodos.Kperiodo# EQ #rsPeriodosAux.Kperiodo#>selected</cfif>>#rsPeriodos.Kperiodo#</option>
							</cfoutput>
						</select>							
					</td>
					<!---<td valign="baseline" align="right" nowrap><cf_translate  key="LB_Mes">Mes </cf_translate>:&nbsp;&nbsp;&nbsp;</td>
					<td valign="baseline" nowrap>
						<select name="mes">
							<cfoutput query="rsMes">
									<option value="#rsMes.VSvalor#"<cfif #rsMes.VSvalor# EQ #rsMesAux.Pvalor#>selected</cfif>>#rsMes.VSdesc#</option>
							</cfoutput>
						</select>							
					</td>--->
					<td ><div align="right">Mes&nbsp;: &nbsp;</div></td>
								<td ><select name="Mes">
                                  <cfoutput query="rsMes">
                                    <option value="#rsMes.VSvalor#"<cfif #rsMes.VSvalor# EQ #rsMesAux.Pvalor#>selected</cfif>>#rsMes.VSdesc#</option>
                                  </cfoutput>
                                </select></td>
					
				</tr>
				<tr> 
					<td  align="right" valign="middle" nowrap ><input type="checkbox" name="toExcel"/></td>
					<td  colspan="3" valign="baseline" nowrap> <cf_translate  key="LB_ExpotarAExcel">Exportar a Excel</cf_translate></td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>	
				<tr>
					<td colspan="4" align="center" nowrap>
						<cfoutput>
							<input name="btnConsultar" type="submit" value="#BTN_Consultar#">
						</cfoutput>
					</td>	
				<tr>
			</table>
			</form>
		<cf_web_portlet_end>	
<cf_templatefooter>