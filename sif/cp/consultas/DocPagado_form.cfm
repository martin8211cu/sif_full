<!---
	Creado por Gustavo Fonseca H.
		Fecha: 20-4-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_DocxSoc = t.Translate('TIT_DocxSoc','Saldo de Documentos por Socio')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_Desde = t.Translate('LB_Desde','Desde','/sif/generales.xml')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_Fecha_Vencimiento = t.Translate('LB_Fecha_Vencimiento','Fecha Vencimiento','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_SocioNegocioDesde = t.Translate('LB_Socio_de_Negocio_Desde','Socio de Negocios Desde','/sif/generales.xml')>
<cfset LB_SocioNegocioHasta = t.Translate('LB_Socio_de_Negocio_Hasta','Socio de Negocios Hasta','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/generales.xml')>
<cfset LB_DocCS = t.Translate('LB_DocCS','Documentos con Saldo')>

<!--- Se obtienen Monedas --->
<cfquery name="rsGetMonedas" datasource="#session.DSN#">
	SELECT Mcodigo, Mnombre
	FROM Monedas
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Se obtienen las transacciones de tipo --->
<cfquery name="rsGetTransacciones" datasource="#session.DSN#">
	SELECT RTRIM(LTRIM(COALESCE(CPTcodigo, ''))) AS CPTcodigo,
	       RTRIM(LTRIM(COALESCE(CPTdescripcion, ''))) AS CPTdescripcion
	FROM CPTransacciones
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	AND CPTtipo = 'C'
	ORDER BY CPTcodigo
</cfquery>


<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_DocxSoc#'>

<cfif isdefined("url.formatos") and not isdefined("form.formatos")>
	<cfset form.formatos = url.formatos>
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>

<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>

<cfif isdefined("url.LvarRecibo") and not isdefined("form.LvarRecibo")>
	<cfset form.LvarRecibo = url.LvarRecibo>
</cfif>

<cfif isdefined("url.chk_DocSaldo") and not isdefined("form.chk_DocSaldo")>
	<cfset form.chk_DocSaldo = url.chk_DocSaldo>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="DocPagado_sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>#LB_DatosReporte#</legend>
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td nowrap align="right" width="47%"><strong>#LB_SocioNegocioDesde#:</strong></td>
						<td>
							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" tabindex="1" idquery="#form.SNcodigo#">
							<cfelse>
								<cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap align="right" width="47%"><strong>#LB_SocioNegocioHasta#:</strong></td>
						<td>
							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo2" SNnombre="SNnombre2" SNnumero="SNnumero2" tabindex="1" idquery="#form.SNcodigo#">
							<cfelse>
								<cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo2" SNnombre="SNnombre2" SNnumero="SNnumero2" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap align="right" width="47%"><strong>#LB_Documento#:</strong></td>
						<td>
							<input type="text" id="Documento" name="Documento" maxlenght="50" value="#(isdefined('form.Documento')) ? '#form.Documento#' : ''#">
						</td>
					</tr>
					<tr>
					  <td align="right"><strong>Transacción:&nbsp;</strong></td>
					  <td align="left" colspan="4">
						  <select id="cboTransaccion" name="cboTransaccion" default="-1">
							  <option value="-1">--- Seleccione ---</option>
							  <cfloop query="#rsGetTransacciones#">
								  <cfoutput>
									  <cfif isDefined("form.cboTransaccion") AND #form.cboTransaccion# eq #rsGetTransacciones.CPTcodigo#>
										  <option value="#rsGetTransacciones.CPTcodigo#" selected="true">#rsGetTransacciones.CPTcodigo# - #rsGetTransacciones.CPTdescripcion#</option>
									  <cfelse>
									  	  <option value="#rsGetTransacciones.CPTcodigo#">#rsGetTransacciones.CPTcodigo# - #rsGetTransacciones.CPTdescripcion#</option>
									  </cfif>
							      </cfoutput>
							  </cfloop>
						  </select>
                      </td>
				    </tr>
					<tr>
						<td align="right"><strong>#LB_Fecha_Desde#:</strong></td>
						<td>
							<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
								<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1">
							<cfelse>
								<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaI" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Fecha_Hasta#:</strong></td>
						<td>
							<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
								<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1">
							<cfelse>
								<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaF" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Fecha_Vencimiento#:</strong></td>
						<td>
							<cfif isdefined("form.FechaV") and len(trim(form.FechaV))>
								<cf_sifcalendario form="form1" value="#form.FechaV#" name="FechaV" tabindex="1">
							<cfelse>
								<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaV" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Moneda#:</strong></td>
						<td>
							<select id="cboMoneda" name="cboMoneda" default="-1">
								<option value="-1">--- Seleccione ---</option>
								<cfloop query="#rsGetMonedas#">
									<cfoutput>
										<option value="#rsGetMonedas.Mcodigo#">#rsGetMonedas.Mnombre#</option>
									</cfoutput>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><input type="checkbox" name="chk_DocSaldo" <cfif isdefined('form.chk_DocSaldo')>checked</cfif>   value="1" tabindex="1">&nbsp;</td>
						<td colspan="1" align="left">
							<strong>#LB_DocCS#</strong>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
					<tr id="imgLoading2" style="visibility: hidden"><td colspan="2">&nbsp;</td></tr>
					<tr id="imgLoading" style="visibility: hidden"><td colspan="2" align="center">&nbsp;<img src="/cfmx/sif/imagenes/large-loading.gif" title="Espere..."  alt="Generando reporte..."></td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
				</fieldset>
			</td>
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">
	// objForm.SNcodigo.required=true;
	// objForm.SNcodigo.description='Socio de Negocios';
	// objForm.FechaI.required=true;
	// objForm.FechaI.description='Fecha Desde';
	// objForm.FechaF.required=true;
	// objForm.FechaF.description='Fecha Hasta';
	// objForm.FechaV.required=true;
	// objForm.FechaV.description='Fecha Vencimiento';

	document.form1.SNnumero.focus();

	function funcGenerar(){
		document.getElementById('imgLoading').style.visibility = "visible";
		document.getElementById('imgLoading2').style.visibility = "visible";
	}
</script>
