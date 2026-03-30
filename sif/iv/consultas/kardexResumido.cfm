<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_KardexResumido"
	Default="Kardex Resumido "
	returnvariable="LB_KardexResumido"/>
	
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

<!--- Rodolfo Jimenez Jara, 14/01/2004, SOIN, CentroAmerica --->
<cfquery datasource="#session.DSN#" name="rsPeriodosAux">
	select Pvalor as Kperiodo
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=50
</cfquery> 

<cf_templateheader title="#LB_KardexResumido#">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_KardexResumido#">
			<form action="SQLKardexResumido.cfm" method="post" name="consulta">
				<table width="80%" border="0" cellpadding="0" cellspacing="0" align="center">
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
                    <!--- Clasificacion --->
                    <tr> 
						<td width="25%" align="right" valign="middle" nowrap >
							<cf_translate  key="LB_ClasificacionInicial">Clasificaci&oacute;n Desde</cf_translate>:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<cf_sifclasificacion form="consulta" frame="cli" id="Ccodigo" name="Ccodigoclas" desc="Cdescripcion">
						</td>
						<td width="40%" align="right" valign="middle" nowrap>&nbsp;
							<cf_translate  key="LB_ClasificacionFinal">Clasificaci&oacute;n Hasta</cf_translate>:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<cf_sifclasificacion form="consulta" frame="clf" id="CcodigoF" name="CcodigoclasF" desc="CdescripcionF">
						</td>
					</tr>
					<!--- Periodo/Mes Inicial --->
					<tr>
						<td valign="baseline" align="right" nowrap><cf_translate  key="LB_PeriodoInicial">Per&iacute;odo Inicial</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
						<td valign="baseline" nowrap>
							<select name="perini">
								<cfoutput query="rsPeriodos">
									<option value="#rsPeriodos.Kperiodo#"<cfif #rsPeriodos.Kperiodo# EQ #rsPeriodosAux.Kperiodo#>selected</cfif>>#rsPeriodos.Kperiodo#</option>
								</cfoutput>
							</select>							
						</td>
						<td valign="baseline" align="right" nowrap><cf_translate  key="LB_MesInicial">Mes Inicial</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
						<td valign="baseline" nowrap>
							<select name="mesini">
								<cfoutput query="rsMes">
										<option value="#rsMes.VSvalor#"<cfif #rsMes.VSvalor# EQ #rsMesAux.Pvalor#>selected</cfif>>#rsMes.VSdesc#</option>
								</cfoutput>
							</select>							
						</td>
					</tr>
					<!--- Periodo/Mes Final --->
					<tr>
						<td valign="baseline" align="right" nowrap><cf_translate  key="LB_PeriodoFinal">Per&iacute;odo Final</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
						<td valign="baseline" nowrap>
							<select name="perfin">
								<cfoutput query="rsPeriodos">
										<option value="#rsPeriodos.Kperiodo#"<cfif #rsPeriodos.Kperiodo# EQ #rsPeriodosAux.Kperiodo#>selected</cfif>>#rsPeriodos.Kperiodo#</option>
								</cfoutput>
							</select>							
						</td>
						<td valign="baseline" align="right" nowrap><cf_translate  key="LB_MesFinal">Mes Final</cf_translate>:&nbsp;&nbsp;&nbsp;</td>
						<td valign="baseline" nowrap>
							<select name="mesfin">
								<cfoutput query="rsMes">
										<option value="#rsMes.VSvalor#"<cfif #rsMes.VSvalor# EQ #rsMesAux.Pvalor#>selected</cfif>  >#rsMes.VSdesc#</option>
								</cfoutput>
							</select>							
						</td>
					</tr>
					<tr> 
						<td  align="right" valign="bottom" nowrap ><input type="checkbox" name="toExcel"/></td>
						<td  colspan="1" valign="bottom" nowrap> 
							<cf_translate  key="LB_ExpotarAExcel">Exportar a Excel</cf_translate>
						</td>
						<td  align="right" valign="bottom" nowrap ><input type="checkbox" name="sinMovimientos"/></td>
						<td  colspan="1" valign="bottom" nowrap> 
							<cf_translate  key="LB_ExpotarAExcel">Excluir articulos sin movimientos</cf_translate>
						</td>
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
			<cf_qforms form="consulta">
				<cf_qformsRequiredField name="perini" description="Periodo Inicial">
				<cf_qformsRequiredField name="perfin" description="Periodo Final">
				<cf_qformsRequiredField name="mesini" description="Mes Inicial">
				<cf_qformsRequiredField name="mesfin" description="Mes Final">
				<cf_qformsRequiredField name="almini" description="Almacén Inicial">
				<cf_qformsRequiredField name="almfin" description="Almacén Final">
			</cf_qforms>
		 <cf_web_portlet_end>
<cf_templatefooter>
