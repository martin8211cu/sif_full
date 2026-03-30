<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte','Documentos.xml')>
<cfset LB_Resumido 		= t.Translate('LB_Resumido','Resumido','Documentos.xml')>
<cfset LB_Detallado 	= t.Translate('LB_Detallado','Detallado por Documento','Documentos.xml')>
<cfset LB_USUARIO		= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset BTN_Filtrar = t.Translate('BTN_Filtrar','Filtrar','/sif/generales.xml')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Formato = t.Translate('LB_Formato','Formato','/sif/generales.xml')>                    
<cfset LB_Consulta 		= t.Translate('LB_Consulta','Consulta')>
<cfset LB_SocioNegocioI = t.Translate('LB_SocioNegocioI','Socio de Negocios Inicial')>
<cfset LB_SocioNegocioF = t.Translate('LB_SocioNegocioF','Socio de Negocios Final')>
<cfset LB_OficinaInicial = t.Translate('LB_OficinaInicial','Oficina Inicial')>
<cfset LB_OficinaFinal = t.Translate('LB_OficinaFinal','Oficina Final')>
<cfset LB_Fecha_Inicial = t.Translate('LB_Fecha_Inicial','Fecha Inicial','/sif/generales.xml')>
<cfset LB_Fecha_Final 	= t.Translate('LB_Fecha_Final','Fecha Final','/sif/generales.xml')>
<cfset LB_MonedaFinal = t.Translate('LB_MonedaFinal','Moneda Final')>
<cfset LB_MonedaInicial = t.Translate('LB_MonedaInicial','Moneda Inicial')>
<cfset LB_TransaccFinal = t.Translate('LB_TransaccFinal','Transacción Final')>
<cfset LB_TransaccInicial = t.Translate('LB_TransaccInicial','Transacción Inicial')>
<cfset Tit_PagosinAplicar = t.Translate('Tit_PagosinAplicar','Pagos&nbsp;sin&nbsp;Aplicar')>

<cf_templateheader title="SIF - Cuentas por Cobrar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cfoutput>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#Tit_PagosinAplicar#'>
</cfoutput>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select distinct a.Mcodigo, b.Mnombre 
	from Monedas b
		inner join Pagos a
			on b.Mcodigo = a.Mcodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	   order by Mnombre
</cfquery> 

<form name="form1" method="get" action="PagosSinAplicarRes.cfm">
<input type="hidden" name="btnFiltrar" 	value="#BTN_Filtrar#">
   
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><cfoutput><legend>#LB_DatosReporte#</legend></cfoutput>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
                <cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td nowrap width="10%"><strong>#LB_Consulta#:&nbsp;</strong> 
						<input type="radio" name="tipoResumen" value="1" checked tabindex="1" onClick="this.form.action = 'PagosSinAplicarRes.cfm';">#LB_Resumido#&nbsp;
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="tipoResumen" value="2" tabindex="1" onClick="this.form.action = 'PagosSinAplicarDet.cfm';">#LB_Detallado#
					</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_SocioNegocioI#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_SocioNegocioF#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 tabindex="1" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_OficinaInicial#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_OficinaFinal#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifoficinas tabindex="1"></td>
					 <td align="left"><cf_sifoficinas tabindex="1" Ocodigo="Ocodigo2" Oficodigo="Oficodigo2" Odescripcion="Odescripcion2"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Fecha_Inicial#:</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_Fecha_Final#:</strong></td>
					<td colspan="3">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario tabindex="1" name="fechaDes" value="#DateFormat(now(),'dd/mm/yyyy')#"></td>
					<td nowrap align="left"><cf_sifcalendario tabindex="1" name="fechaHas" value="#DateFormat(now(),'dd/mm/yyyy')#"></td>
					<td colspan="3">&nbsp;</td>					
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td align="left"><strong>#LB_MonedaInicial#:</strong></td>
					<td align="left"><strong>#LB_MonedaFinal#:</strong></td>					
				</tr>
                </cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap><select name="Moneda" tabindex="1">
										<cfoutput query="rsMonedas"> 
											<option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
										</cfoutput> </select> </td>
					<td align="left" nowrap><select name="Moneda2" tabindex="1">
										<cfoutput query="rsMonedas"> 
											<option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
										</cfoutput> </select> </td>
				</tr>
                <cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>#LB_TransaccInicial#:</strong>
					<td align="left" width="10%"><strong>#LB_TransaccFinal#:</strong>
					<td colspan="3">&nbsp;</td>
				</tr>	
                </cfoutput>
				<tr>
					<cfset tipo = 'C'>
					<td>&nbsp;</td>

					<td> 
						<cfquery name="rsTransacciones" datasource="#Session.DSN#">
							select distinct a.CCTcodigo, b.CCTdescripcion 
							from CCTransacciones b , Pagos a 
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and a.Ecodigo = b.Ecodigo 
							  and a.CCTcodigo = b.CCTcodigo 
							  and b.CCTtipo = '#tipo#' 
							  and coalesce(b.CCTpago,0) = 1
							order by a.CCTcodigo desc 
						</cfquery> 
						<select name="Transaccion" tabindex="1">
							<cfoutput query="rsTransacciones"> 
								<option value="#rsTransacciones.CCTcodigo#">#rsTransacciones.CCTdescripcion#</option>
							</cfoutput> 
						</select> 
					</td>
					<td>
					<select name="Transaccion2" tabindex="1">
							<cfoutput query="rsTransacciones"> 
								<option value="#rsTransacciones.CCTcodigo#">#rsTransacciones.CCTdescripcion#</option>
							</cfoutput> 
						</select> 
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
				<cfoutput>					
					<td >&nbsp;</td>
					<td align="left" width="10%"><strong>#LB_USUARIO#:&nbsp;</strong>
					<td colspan="4">&nbsp;</td>
				</cfoutput>				
                </tr>
				<tr>
					
					<cfquery name="rsUsuarios" datasource="#Session.DSN#">
						select distinct Pusuario, Pusuario as PusuarioDESC 
						from Pagos where Ecodigo = 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and CCTcodigo in (select CCTcodigo from CCTransacciones 
						where CCTtipo = '#tipo#' and coalesce(CCTpago, 0) = 1) 
						order by Pusuario asc 
					</cfquery>
					<td>&nbsp;</td>
					<td>
						<select name="Usuario" tabindex="1">
							<option value="-1"><cfoutput>(#LB_Todos#)</cfoutput></option>
							<cfoutput query="rsUsuarios"> 
								<option value="#rsUsuarios.Pusuario#">#rsUsuarios.PusuarioDESC#</option>
							</cfoutput> 
						</select>
					</td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
                    <cfoutput>
					<td align="left" width="10%" nowrap><strong>#LB_Formato#:&nbsp;</strong>
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
					</select>
					</td>
					</cfoutput> 
					<td colspan="3">&nbsp;</td>
				</tr>
				
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar, Regresar" names="Generar, Regresar" tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>
	<cfoutput>
	<input name="tipo" value="#tipo#" type="hidden">
	</cfoutput>
</form>
<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	document.form1.SNnumero.focus();
	
	function funcRegresar(){
		document.form1.method='post';
		document.form1.action='../operacion/ListaPagos.cfm';
	}
</script>



