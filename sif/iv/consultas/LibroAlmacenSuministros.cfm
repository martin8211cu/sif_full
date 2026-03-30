<!--- 
	Modificado por Gustavo Fonseca H.
	Fecha: 27-7-2006.
	Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
		rendimiento de la pantalla. 
 --->

<cf_templateheader title="Libro de Almacen y Suministros de Consumo">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
        <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Libro de Almacen y Suministros de Consumo'>
			<cfquery name="rsPeriodos" datasource="#Session.DSN#">
				select distinct Speriodo as Kperiodo
				from CGPeriodosProcesados
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
				select Pvalor from Parametros where Pcodigo=60 and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			</cfquery>
			<!--- Rodolfo Jimenez Jara, 14/01/2004, SOIN, CentroAmerica --->
			<cfquery datasource="#session.DSN#" name="rsPeriodosAux">
				select Pvalor as Kperiodo
				from Parametros
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo=50
			</cfquery> 
            
            <!--- Almacen --->
            <cfquery datasource="#session.DSN#" name="rsAlmacen">
                select  Aid, Bdescripcion 
                from Almacen 
                where Ecodigo = #session.Ecodigo#
            </cfquery> 

			<form action="LibroAlmacenSuministrosSQL.cfm" method="get" name="consulta">
				<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
					<tr><td><cfinclude template="../../portlets/pNavegacionIV.cfm"></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td> 
						<table width="80%" border="0" cellpadding="0" cellspacing="1" align="center" class="areaFiltro">
							<tr><td colspan="6">&nbsp;</td></tr>
							<tr>
							  	<td width="3%" rowspan="10" valign="baseline" nowrap align="center">&nbsp;</td>
							  	<td nowrap><div align="right"><strong>Per&iacute;odo: &nbsp;</strong></div></td>
								<td nowrap>
                                	<select name="Periodo">
									  	<cfoutput query="rsPeriodos">
                                        	<option value="#rsPeriodos.Kperiodo#"<cfif rsPeriodos.Kperiodo EQ rsPeriodosAux.Kperiodo>selected</cfif>>#rsPeriodos.Kperiodo#</option>
                                      	</cfoutput>
                                    </select>
                              	</td>
                                <td><div align="right"><strong>Mes:&nbsp;</strong></div></td>
								<td>
                                	<select name="Mes">
                                  	<cfoutput query="rsMes">
                                    	<option value="#rsMes.VSvalor#"<cfif #rsMes.VSvalor# EQ #rsMesAux.Pvalor#>selected</cfif>>#rsMes.VSdesc#</option>
                                  	</cfoutput>
                                	</select>
                              	</td>
                                <td width="3%" rowspan="10" valign="baseline" nowrap align="center">&nbsp;</td>
							</tr>
                                   <!--- Almacen --->
					<tr>
						<td valign="baseline" align="right" nowrap><cf_translate  key="LB_AlmacenDesde"><strong>Almac&eacute;n Desde</strong></cf_translate>:&nbsp;&nbsp;&nbsp;</td>
						<td valign="baseline" nowrap>
							<select name="almini">
								<cfoutput query="rsAlmacen">
									<option value="#rsAlmacen.Aid#">#rsALmacen.Bdescripcion#</option>
								</cfoutput>
							</select>							
						</td>
						<td valign="baseline" align="right" nowrap><cf_translate  key="LB_AlmacenHasta"><strong>Almac&eacute;n Hasta</strong></cf_translate>:&nbsp;&nbsp;&nbsp;</td>
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
                      <!--- Clasificacion --->
                    <tr> 
						<td width="25%" align="right" valign="middle" nowrap >
							<cf_translate  key="LB_ClasificacionInicial"><strong>Clasificaci&oacute;n Desde</strong></cf_translate>:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<cf_sifclasificacion form="consulta" frame="cli" id="Ccodigo" name="Ccodigoclas" desc="Cdescripcion">
						</td>
						<td width="40%" align="right" valign="middle" nowrap>&nbsp;
							<cf_translate  key="LB_ClasificacionFinal"><strong>Clasificaci&oacute;n Hasta</strong></cf_translate>:&nbsp;
						</td>
						<td valign="baseline" nowrap> 
							<cf_sifclasificacion form="consulta" frame="clf" id="CcodigoF" name="CcodigoclasF" desc="CdescripcionF">
						</td>
					</tr>
                            <tr>
							 	<td nowrap><div align="right"><strong>Oficina Inicial:&nbsp;</strong></div></td>
								<td nowrap>
                                	<cf_conlis 
                                        title="Oficina Inicial" 
                                        campos = "OficodigoI, OdescripcionI" 
                                        desplegables = "S,S" 
                                        modificables = "S,N"
                                        size = "10,30"
                                        columnas="Oficodigo as OficodigoI, Odescripcion as OdescripcionI"
                                        tabla="Oficinas"
                                        filtro="Ecodigo = #Session.Ecodigo# order by OficodigoI, OdescripcionI"
                                        desplegar="OficodigoI, OdescripcionI"
                                        etiquetas="C&oacute;digo, Descripci&oacute;n"
                                        formatos="S,S"
                                        align="left,left"
                                        asignar="OficodigoI, OdescripcionI"
                                        asignarformatos="S,S"
                                        form="consulta"
                                        filtrar_por="Oficodigo, Odescripcion"
                                        funcion="limpia_consulta_OcodigoF">	
                              	</td>
                                <td><div align="right"><strong>Oficina Final:&nbsp;</strong></div></td>
								<td>
                                	<cf_conlis 
                                        title="Oficina Final" 
                                        campos = "OficodigoF, OdescripcionF" 
                                        desplegables = "S,S" 
                                        modificables = "S,N"
                                        size = "10,30"
                                        columnas="Oficodigo as OficodigoF, Odescripcion as OdescripcionF"
                                        tabla="Oficinas"
                                        filtro="Ecodigo = #Session.Ecodigo# order by OficodigoF, OdescripcionF"
                                        desplegar="OficodigoF, OdescripcionF"
                                        etiquetas="C&oacute;digo, Descripci&oacute;n"
                                        formatos="S,S"
                                        align="left,left"
                                        asignar="OficodigoF, OdescripcionF"
                                        asignarformatos="S,S"
                                        form="consulta"
                                        filtrar_por="Oficodigo, Odescripcion">	
                              	</td>
							</tr>
                            <tr>
							 	<td nowrap><div align="right"><strong>Cuenta Inicial:&nbsp;</strong></div></td>
								<td nowrap colspan="3">
                                	<cf_cuentas Ccuenta="CcuentaI" form="consulta">
                              	</td>
                          	</tr>
                            <tr>
                                <td><div align="right"><strong>Cuenta Final:&nbsp;</strong></div></td>
								<td nowrap colspan="3"><cf_cuentas Ccuenta="CcuentaF" form="consulta"></td>
							</tr>
                            <tr>
<!---							 	<td nowrap><div align="right"><strong>Mostrar:&nbsp;</strong></div></td>
								<td nowrap>
                                	<select name="Mostrar" onchange="fnValidaCorte(this.value);">
									  	<option value="1">Resumido</option>
                                    </select>
                              	</td>--->
                                <td><div align="right"><strong>Formato:&nbsp;</strong></div></td>
							  	<td>
							      	<select name="Formato" id="Formato" tabindex="1">
                                    	<option value="1">FLASHPAPER</option>
                                    	<option value="2">PDF</option>
                                        <option value="3">Excel</option>
                                  	</select>
							 	</td>
							</tr>
							<td colspan="4">&nbsp;</td></tr>
							<tr>
							    <td colspan="4" align="center" nowrap><input name="btnConsultar" type="submit" value="Consultar"></td>
                           	</tr>
						    <tr><td colspan="4">&nbsp;</td></tr>
                            <td colspan="4" valign="baseline" align="justify">Suministre la información aqui solicitada , y presione el botón consultar para generar el reporte. El reporte se puede generar tanto en Flashpaper, como Macromedia Adobe Acrobat, para mayor tranportabilidad.</td>
						</table>
					</td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>
            <script type="text/javascript">
				function fnValidaCorte(v){
					document.consulta.Corte.checked = (v == 1 ? false : document.consulta.Corte.checked);
					document.consulta.Corte.disabled = (v == 1 ? true : false);
				}
				<!---fnValidaCorte(document.consulta.Mostrar.value);--->
			</script>
        <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>