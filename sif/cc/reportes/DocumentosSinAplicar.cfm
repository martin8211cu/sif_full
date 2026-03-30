<!---     Modificado por: Rebeca Corrales Alfaro
		  Fecha: 01/06/05
		  Motivo: Se modifica el diseño de la pantalla y  de los
		  		  filtros, se deja un solo filtro para monedas,
				  transaccion, oficina y socio de negocios
				  para generar el reporte Documentos sin Aplicar
--->
<cf_templateheader title="SIF - Cuentas por Cobrar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Documentos&nbsp;sin&nbsp;Aplicar'>

<!--- Sin Aplicar --->
	<cfif isdefined("url.tipoResumen") and url.tipoResumen eq 1>
		<cfset LvarNombreReporte = 'Documentos sin Aplicar (Resumido)'>
	<cfelse>
		<cfset LvarNombreReporte = 'Documentos sin Aplicar (Detallado)'>
	</cfif>
<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select distinct a.Mcodigo, b.Mnombre
		from Monedas b
			inner join EDocumentosCxC a
				on b.Mcodigo = a.Mcodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Mnombre
</cfquery>
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select distinct a.CCTcodigo, b.CCTdescripcion
		from CCTransacciones b
			inner join EDocumentosCxC a
			  on a.Ecodigo = b.Ecodigo
			  and a.CCTcodigo = b.CCTcodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and coalesce(b.CCTpago,0) != 1
	order by a.CCTcodigo desc
</cfquery>
<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select '-1' as EDusuario,
		   'Todos' as EDusuarioDESC
				from dual
	union all
	select distinct EDusuario,
		   EDusuario as EDusuarioDESC
				from EDocumentosCxC
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CCTcodigo in (
									select CCTcodigo
									from CCTransacciones
									where coalesce(CCTpago, 0) != 1)
		order by EDusuario asc
</cfquery>
<form name="form1" method="get" action="DocumentosInfo.cfm">
	<input name="reporte" type="hidden" value="1" />
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<fieldset>
					<legend>
						Datos del Reporte
					</legend>
					<table  width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td colspan="5">&nbsp;

							</td>
						</tr>
						<tr>
							<td width="19%" align="right">
								<strong>Fecha&nbsp;Inicial:</strong>
							</td>
							<td width="23%">
								<cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1">
							</td>
							<td width="1%">&nbsp;

							</td>
							<td width="13%" align="right" nowrap>
								<strong>&nbsp;Fecha&nbsp;Final:</strong>
							</td>
							<td width="41%">
								<cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1">
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Oficina:</strong>
							</td>
							<td>
								<cf_sifoficinas tabindex="1">
							</td>
							<td nowrap align="left">&nbsp;

							</td>
							<td nowrap align="right">
								<strong>Transacción:</strong>
							</td>
							<td align="left">
								<select name="Transaccion" tabindex="1">
									<option value="-1">
										Todas
									</option>
									<cfoutput query="rsTransacciones">
										<option value="#rsTransacciones.CCTcodigo#">
											#rsTransacciones.CCTdescripcion#
										</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Socio&nbsp;de&nbsp;Negocios:</strong>
							</td>
							<td>
								<cf_sifsociosnegocios2 tabindex="1">
							</td>
							<td align="left">&nbsp;

							</td>
							<td nowrap align="right">
								<strong>Usuario:</strong>
							</td>
							<td nowrap align="left">
								<select name="Usuario" tabindex="1">
								  <cfoutput query="rsUsuarios">
									<option value="#rsUsuarios.EDusuario#">
										#rsUsuarios.EDusuarioDESC#
									</option>
								  </cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Moneda:</strong>
							</td>
							<td colspan="4">
								<select name="Moneda" tabindex="1">
									<option value="-1">Todas</option>
									<cfoutput query="rsMonedas">
										<option value="#rsMonedas.Mcodigo#">
											#rsMonedas.Mnombre#
										</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="5">&nbsp;

							</td>
						</tr>
						<tr>
							<td align="right">
								<strong>Formato:</strong>
							</td>
							<td>
								<select name="Formato" id="Formato" tabindex="1">
									<option value="1">FLASHPAPER</option>
									<option value="2">PDF</option>
									<option value="4">EXCEL</option>
								</select>
							</td>
							<td align="left">&nbsp;

							</td>
							<td align="right">
								<strong>Consulta:</strong>
							</td>
							<td align="left">
								<input type="radio" name="tipoResumen" id="tipoResumen1" value="1" tabindex="1">
									<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal">Resumido</label>
								 <input type="radio" name="tipoResumen" id="tipoResumen2" value="2"  tabindex="1">
									<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal">Detallado por Documento</label>
							</td>
						</tr>
						<tr>
							<td colspan="5">&nbsp;</td>
						</tr>
						<tr><td colspan="5">&nbsp;</td></tr>
						<tr>
							<td colspan="5">
								<cfif isdefined("url.Docs") and url.Docs eq 1>
									<cf_botones values="Generar, Limpiar, Regresar" names="Generar, Limpiar, Regresar" tabindex="1" >
								<cfelse>
									<cf_botones values="Generar, Limpiar" names="Generar, Limpiar" tabindex="1" >
								</cfif>
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
	</table>
</form>

<cf_web_portlet_end>
<cf_templatefooter>

<cfif isDefined("url.tipo") and len(Trim(url.tipo)) gt 0>
	<cfset form.tipo = url.tipo>
</cfif>
<cfset params = '' >
<cfif isdefined('form.tipo')>
	<cfset params = params & 'tipo=#form.tipo#'>
</cfif>
<script language="javascript" type="text/javascript">
	function funcLimpiar(){
		objForm2.obj.reset();
		return false;
	}
	function funcRegresar(){
		<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'D'> //<!--- Facturas --->
			location.href = '../operacion/RegistroFacturas.cfm?<cfoutput>#params#</cfoutput>';
		<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'C'> //<!--- Notas de Crédito --->
			location.href = '../operacion/RegistroNotasCredito.cfm?<cfoutput>#params#</cfoutput>';
		</cfif>
		return false;
	}
</script>



