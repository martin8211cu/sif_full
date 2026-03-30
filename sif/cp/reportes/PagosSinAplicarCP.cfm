<cf_templateheader title="SIF - Cuentas por Pagar">
<cfinclude template="../../portlets/pNavegacionCP.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pagos&nbsp;sin&nbsp;Aplicar'>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select Mcodigo,Mnombre 
	from Monedas 
	where Ecodigo =  #Session.Ecodigo# 
</cfquery> 

<form name="form1" method="get" action="PagosSinAplicarResCP.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap width="10%"><strong>Consulta:&nbsp;</strong> 
						<input type="radio" name="tipoResumen" value="1" checked onClick="this.form.action = 'PagosSinAplicarResCP.cfm';" tabindex="1">Resumido&nbsp;
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="tipoResumen" value="2" onClick="this.form.action = 'PagosSinAplicarDetCP.cfm';" tabindex="1">Detallado por Documento
					</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Inicial:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Final:&nbsp;</strong></td>
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
					<td nowrap align="left" width="10%"><strong>Oficina&nbsp;Inicial:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Oficina&nbsp;Final:&nbsp;</strong></td>
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
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;Inicial:</strong></td>
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;Final:</strong></td>
					<td colspan="3">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td nowrap align="left"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>					
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td align="left"><strong>Moneda&nbsp;Inicial:</strong></td>
					<td align="left"><strong>Moneda&nbsp;Final:</strong></td>					
				</tr>
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
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>Transacción&nbsp;Inicial:</strong>
					<td align="left" width="10%"><strong>Transacción&nbsp;Final:</strong>
					<td colspan="3">&nbsp;</td>
				</tr>	
				<tr>
					<cfset tipo = 'D'>
					<td>&nbsp;</td>

					<td> 
						<cfquery name="rsTransacciones" datasource="#Session.DSN#">
							select CPTcodigo, CPTdescripcion
							from CPTransacciones
							where Ecodigo =  #Session.Ecodigo# 
							  and CPTtipo = '#tipo#' 
							  and coalesce(CPTpago,0) = 1
							order by CPTcodigo desc 
						</cfquery> 
						<select name="Transaccion" tabindex="1">
							<cfoutput query="rsTransacciones"> 
								<option value="#rsTransacciones.CPTcodigo#">#rsTransacciones.CPTdescripcion#</option>
							</cfoutput> 
						</select> 
					</td>
					<td>
					<select name="Transaccion2" tabindex="1">
							<cfoutput query="rsTransacciones"> 
								<option value="#rsTransacciones.CPTcodigo#">#rsTransacciones.CPTdescripcion#</option>
							</cfoutput> 
						</select> 
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td >&nbsp;</td>
					<td align="left" width="10%"><strong>Usuario:&nbsp;</strong>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					
					<cfquery name="rsUsuarios" datasource="#Session.DSN#">
						select 'Todos' as EPusuario, 'Todos' as EPusuarioDESC from dual
						union all 
						select distinct EPusuario, EPusuario as EPusuarioDESC 
						 from EPagosCxP 
						where Ecodigo = #Session.Ecodigo# 
						and CPTcodigo in(select CPTcodigo 
						                   from CPTransacciones 
						                 where CPTtipo = '#tipo#' 
										 and coalesce(CPTpago, 0) = 1) 
						order by EPusuario asc 
					</cfquery>
					<td>&nbsp;</td>
					<td>
						<select name="Usuario" tabindex="1">
							<cfoutput query="rsUsuarios"> 
								<option value="#rsUsuarios.EPusuario#">#rsUsuarios.EPusuarioDESC#</option>
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
					<td align="left" width="10%" nowrap><strong>Formato:&nbsp;</strong>
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
					</select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar" tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>
	<cfoutput>
	<input name="tipo" value="#tipo#" type="hidden" tabindex="-1">
	</cfoutput>
</form>
<cf_web_portlet_end>
<cf_templatefooter>