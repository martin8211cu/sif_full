<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Pedido"
	Default="Sugerencia de Pedidos"
	returnvariable="LB_Pedido"/>

	<cfquery datasource="#session.DSN#" name="rsAlmacen">
		select  Aid, Bdescripcion 
		from Almacen 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by 2
	</cfquery> 


<cf_templateheader title="#LB_Pedido#">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Pedido#">
			<form action="ConsolidaExtArticulo_sql.cfm" method="post" name="consulta">
				<table width="86%" border="0" cellpadding="0" cellspacing="0" align="center">
				    <tr>
                	<td align="right">&nbsp;</td>
           		 <tr>
					 <tr>
						<td align="right" valign="baseline" nowrap><div align="right">Almac&eacute;n Desde:&nbsp;&nbsp;&nbsp;</div></td>
						<td valign="baseline">
							<select name="almini">
								<cfoutput query="rsAlmacen">
									<option value="#rsAlmacen.Aid#">#rsALmacen.Bdescripcion#</option>
								</cfoutput>
							</select>							
						</td>
						<td width="13%" align="right" valign="baseline" nowrap>&nbsp;</td>
						<td align="right" valign="baseline" nowrap><div align="right">Almac&eacute;n Hasta:&nbsp;&nbsp;&nbsp;</div></td>
						<td valign="baseline">
								<cfset ultimo = "">
								<select name="almfin">
									<cfoutput query="rsAlmacen">
										<cfset ultimo = #rsAlmacen.Aid# >
										<option value="#rsAlmacen.Aid#">#rsALmacen.Bdescripcion#</option>
									</cfoutput>
								</select>
								<script language="JavaScript1.2" type="text/javascript">
									//document.consulta.almfin.value = '<cfoutput>#ultimo#</cfoutput>'
								</script>	 						
							</td>
						</tr>
					
				    <tr>
                	<td align="right">&nbsp;</td>
           		 <tr>
					<!--- Articulo --->
					<tr> 
						<td valign="baseline" align="right"><div align="right">Art&iacute;culo Desde:&nbsp;&nbsp;&nbsp;</div></td>
						<td nowrap><cf_sifarticulos form="consulta" frame="fri" id="iAid" name="articuloi" desc="Aidescripcion"></td>
						<td width="13%" align="right" valign="baseline">&nbsp;</td>
						<td valign="baseline" align="right"><div align="right">Art&iacute;culo Hasta:&nbsp;&nbsp;&nbsp;</div></td>
						<td nowrap><cf_sifarticulos form="consulta" frame="frf" id="fAid" name="articulof" desc="Afdescripcion"></td>
					</tr>
				    <tr>
                	<td align="right">&nbsp;</td>
           		 <tr>
					
					<tr>
						<td colspan="5" align="center"> <input name="btnConsultar" type="submit" value="Consultar"></td>
					</tr>
				</table>
			</form>
		<cf_web_portlet_end>	
<cf_templatefooter>