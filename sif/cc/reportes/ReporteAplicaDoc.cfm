<cf_templateheader title="SIF - Cuentas por Cobrar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aplicaci&oacute;n de Documentos'>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select distinct a.Mcodigo, a.Mnombre 
	from Monedas a 
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and (select count(1) 
				from EFavor b 
					where a.Mcodigo = b.Mcodigo 
					and a.Ecodigo = b.Ecodigo
			 ) > 0
	  order by a.Mnombre desc
</cfquery> 

<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select Edescripcion 
		from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<form name="form1" method="get" action="AplicaDocSQL.cfm">
	<input type="hidden" name="btnFiltrar" 	value="Filtrar">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
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
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;Inicial:</strong></td>
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;Final:</strong></td>
					<td colspan="3">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario tabindex="1" name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#"></td>
					<td nowrap align="left"><cf_sifcalendario tabindex="1" name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#"></td>
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
											<option value="#rsMonedas.Mcodigo#"<cfif isdefined ("form.Moneda") and len(trim(form.Moneda)) and form.Moneda eq rsMonedas.Mcodigo>selected</cfif>>#rsMonedas.Mnombre#</option>
                      </cfoutput>  </select> </td>
					<td align="left" nowrap><select name="Moneda2" tabindex="1">
										<cfoutput query="rsMonedas"> 
											<option value="#rsMonedas.Mcodigo#"<cfif isdefined ("form.Moneda") and len(trim(form.Moneda)) and form.Moneda eq rsMonedas.Mcodigo>selected</cfif>>#rsMonedas.Mnombre#</option>
                      </cfoutput>  </select> </td>
				</tr>
				
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>Transacción Inicial:</strong>
					<td align="left" width="10%"><strong>Transacción Final:</strong>
					<td colspan="3">&nbsp;</td>
				</tr>	
				<tr>
					<cfset tipo = 'C'>
					<td>&nbsp;</td>

					<td> 
					  <cfquery name="CCTransacciones" datasource="#Session.DSN#">
			 	select distinct a.CCTcodigo, b.CCTdescripcion
                from EFavor a, CCTransacciones b 
                where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and a.Ecodigo 	= b.Ecodigo
                  and a.CCTcodigo 	= b.CCTcodigo
				  and b.CCTtipo     = 'C'
				  and coalesce(b.CCTpago,0) != 1
                order by a.CCTcodigo desc
            </cfquery>
			
			<select name="Transaccion" tabindex="1">
                      <cfoutput query="CCTransacciones"> 
                        <option value="#CCTransacciones.CCTcodigo#" <cfif isdefined ("form.Transaccion") and len(trim(form.Transaccion)) and form.Transaccion eq CCTransacciones.CCTcodigo>selected</cfif>>#CCTransacciones.CCTcodigo# - #CCTransacciones.CCTdescripcion#</option>
                      </cfoutput> 
                    </select>
					</td>
					
					<td>
						<select name="Transaccion2" tabindex="1">
                      <cfoutput query="CCTransacciones"> 
                        <option value="#CCTransacciones.CCTcodigo#" <cfif isdefined ("form.Transaccion") and len(trim(form.Transaccion)) and form.Transaccion eq CCTransacciones.CCTcodigo>selected</cfif>>#CCTransacciones.CCTcodigo# - #CCTransacciones.CCTdescripcion#</option>
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
						select distinct EFusuario
						from EFavor
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						 order by EFusuario desc 
					</cfquery>
					
					<td>&nbsp;</td>
					<td>
						<select name="Usuario" tabindex="1">
							<option value="-1">(Todos)</option>
							<cfoutput query="rsUsuarios"> 
								<option value="#rsUsuarios.EFusuario#"<cfif isdefined ("form.usuario") and len(trim(form.usuario)) and form.usuario eq rsUsuarios.EFusuario>selected</cfif>>#rsUsuarios.EFusuario#</option>
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
<cf_qforms>
            <cf_qformsRequiredField name="Moneda" description="Moneda Inicial">
			<cf_qformsRequiredField name="Moneda2" description="Moneda Final">
			<cf_qformsRequiredField name="Transaccion" description="Transaccion Inicial">
			<cf_qformsRequiredField name="Transaccion2" description="Transaccion Final">
</cf_qforms>
<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	document.form1.SNnumero.focus();
	
	function funcRegresar(){
		deshabilitarValidacion();
		document.form1.method='post';
		document.form1.action='../operacion/listaDocsAfavorCC.cfm';
	}
	
</script>




