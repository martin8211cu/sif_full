<!---
	Autor: Eduardo Gonzalez Sarabia
	Fecha: 24/09/2018
	Proceso: Mostrar los complementos de pago generados,
	         para permitir la edicion y posteriormente la
	         regeneracion del mismo
 --->

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','Regeneraci&oacute;n de Complementos de Pago')>

<cfif isDefined("form.datos") AND LEN(form.datos)>
	<cfset arreglo = ListToArray(Form.datos,"|")>
	<cfset idHEfavor = Trim(arreglo[1])>
	<cfset nameMoneda = Trim(arreglo[2])>
</cfif>

<!--- QUERYS --->
<cfquery name="getInfoComplemento" datasource="#session.dsn#">
	SELECT he.idHEfavor,
	       he.CCTcodigo,
	       he.NombreComplemento,
	       sn.SNnombre,
	       sn.SNidentificacion,
	       RTRIM(LTRIM(he.Ddocumento)) AS Ddocumento,
	       m.Mnombre,
	       he.EFtotal,
	       he.EFfecha,
		   CONCAT(em.Serie, em.Folio) AS serieFolio,
		   em.timbre,
		   hm.EMdescripcionOD AS CtaOrdenante,
		   hm.EMBancoIdOD AS BcoOrdenante,
		   hm.EMRfcBcoOrdenante,
		   em.xmlTimbrado,
		   he.Regenerado,
		   he.UUIDHistorico
	FROM HEFavor he
	INNER JOIN SNegocios sn ON sn.Ecodigo = he.Ecodigo AND sn.SNcodigo = he.SNcodigo
	INNER JOIN FA_CFDI_Emitido em ON em.Ecodigo = he.Ecodigo
	AND RTRIM(LTRIM(em.DocPago)) = RTRIM(LTRIM(he.Ddocumento))
	AND RTRIM(LTRIM(CONCAT(Serie,Folio,'_',DocPago))) = RTRIM(LTRIM(he.NombreComplemento))
	INNER JOIN Monedas m ON m.Mcodigo = he.Mcodigo AND m.Ecodigo = he.Ecodigo
	INNER JOIN HEMovimientos hm ON he.Ecodigo = hm.Ecodigo AND RTRIM(LTRIM(he.Ddocumento)) = hm.EMdocumento
	AND hm.SNcodigo = he.SNcodigo AND he.CCTcodigo = hm.TpoTransaccion
	WHERE he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isDefined("form.datos") AND LEN(form.datos)>
		AND he.idHEfavor = <cfqueryparam cfsqltype="cf_sql_integer" value="#idHEfavor#">
	</cfif>
</cfquery>

<cfif #getInfoComplemento.RecordCount# GT 0>
	<cfquery name="getInfoBcoOrdenante" datasource="#session.dsn#">
		SELECT RFC, Bdescripcion
		FROM Bancos
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  AND Bid = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoComplemento.BcoOrdenante#">
	</cfquery>

	<!--- Parseo de XML --->
	<cfset xmltimbrado = XmlParse(getInfoComplemento.xmlTimbrado)>

	<!--- VARIABLES XML --->
	<cfset nodeArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"]>
	<cfset pagoAtt = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"].XmlAttributes>

	<cf_templateheader title="#LB_Titulo#">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
			<form action="regeneraCP-sql.cfm" method="post" name="form1">
				<cfoutput>
					<input type="hidden" name="UUID" value="#getInfoComplemento.timbre#">
					<input type="hidden" name="idHeFavor" value="#getInfoComplemento.idHEfavor#">
					<table width="65%" cellpadding="1" cellspacing="1" align="center" border="0">
						<tr height="45"><td align="center" valign="midle" colspan="4"><strong>#getInfoComplemento.NombreComplemento#</strong></td></tr>
						<tr>
							<td><strong>Folio fiscal:</strong>&nbsp;</td>
							<td>#getInfoComplemento.timbre#</td>
							<td><strong>Serie y Folio interno:</strong>&nbsp;</td>
							<td>#getInfoComplemento.serieFolio#</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td><strong>Nombre:</strong>&nbsp;</td>
							<td>#getInfoComplemento.SNnombre#</td>
							<td><strong>RFC:</strong>&nbsp;</td>
							<td>#getInfoComplemento.SNidentificacion#</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td><strong>Forma de Pago:</strong>&nbsp;</td>
							<td>
								<cfif isdefined('pagoAtt.FormaDePagoP')>
			                      <cfquery name="q_formaPago" datasource="#session.dsn#">
			                        select nombre_TipoPago from FATipoPago where TipoPagoSAT = '#pagoAtt.FormaDePagoP#' and ecodigo = #session.ecodigo#;
			                      </cfquery>
			                      #pagoAtt.FormaDePagoP# #q_formaPago.nombre_TipoPago#
			                    </cfif>
							</td>
							<td><strong>Moneda:</strong>&nbsp;</td>
							<td><cfif isdefined('nameMoneda')>#nameMoneda#</cfif></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td><strong>RFC Banco Beneficiario:</strong>&nbsp;</td>
							<td><cfif isdefined('pagoAtt.RfcEmisorCtaBen')>#pagoAtt.RfcEmisorCtaBen#</cfif></td>
							<td><strong>N&uacute;m. Cuenta Beneficiario:</strong>&nbsp;</td>
							<td><cfif isdefined('pagoAtt.CtaBeneficiario')>#pagoAtt.CtaBeneficiario#</cfif></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td><strong>RFC Banco Ordenante:</strong>&nbsp;</td>
							<td>
								<input type="text" name="RFCOrdenante" id="RFCOrdenante" size="15" value="<cfif LEN(getInfoComplemento.EMRfcBcoOrdenante)>#getInfoComplemento.EMRfcBcoOrdenante#<cfelse>#getInfoBcoOrdenante.RFC#</cfif>">
								<!--- <cfif getInfoComplemento.Regenerado EQ 1>
									#getInfoBcoOrdenante.RFC#
								<cfelse>
									<input type="text" name="RFCOrdenante" id="RFCOrdenante" size="15" value="<cfif LEN(getInfoComplemento.EMRfcBcoOrdenante)>#getInfoComplemento.EMRfcBcoOrdenante#<cfelse>#getInfoBcoOrdenante.RFC#</cfif>">
								</cfif> --->
							</td>
							<td><strong>N&uacute;m. Cuenta Ordenante:</strong>&nbsp;</td>
							<td>
								<input type="text" name="CtaOrdenante" id="CtaOrdenante" size="15" value="#getInfoComplemento.CtaOrdenante#">
								<!--- <cfif getInfoComplemento.Regenerado EQ 1>
									#getInfoComplemento.CtaOrdenante#
								<cfelse>
									<input type="text" name="CtaOrdenante" id="CtaOrdenante" size="15" value="#getInfoComplemento.CtaOrdenante#">
								</cfif> --->
							</td>
						</tr>
						<cfif isDefined("getInfoComplemento.UUIDHistorico") AND #getInfoComplemento.UUIDHistorico# NEQ "">
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td><strong>Hist&oacute;rico de UUID:</strong>&nbsp;</td>
								<td>#getInfoComplemento.UUIDHistorico#</td>
								<td colspan="2">&nbsp;</td>
							</tr>
						</cfif>
						<tr height="45"><td>&nbsp;</td></tr>

						<!--- DETALLE DE DOCUMENTOS --->
						<tr>
							<td colspan="4">
								<table width="100%" cellpadding="1" cellspacing="1" align="center" border="0">
									<tr>
						                <td><strong>UUID</strong></td>
						                <td><strong>Serie y folio</strong></td>
						                <td><strong>Tipo de cambio</strong></td>
						                <td><strong>Parcialidad</strong></td>
						                <td><strong>Saldo anterior</strong></td>
						                <td><strong>Importe pagado</strong></td>
						                <td><strong>Saldo insoluto</strong></td>
						            </tr>
							          <cfloop index="i" from = "1" to = #ArrayLen(nodearray.XmlChildren)#>
						                <cfset att = nodearray.XmlChildren[i].XmlAttributes>
						                <tr>
						                  <td>#att.IdDocumento#</td>
						                  <td><cfif isdefined('att.Serie')>#att.Serie#</cfif><cfif isdefined('att.Folio')>#att.Folio#</cfif></td>
						                  <td><cfif isdefined('att.TipoCambioDR')>#att.TipoCambioDR#<cfelse><cfif isdefined('att.MonedaDR') && att.MonedaDR eq 'MXN'>1.00</cfif></cfif></td>
						                  <td>#att.NumParcialidad#</td>
						                  <td>#att.ImpSaldoAnt#</td>
						                  <td>#att.ImpPagado#</td>
						                  <td>#att.ImpSaldoInsoluto#</td>
						              </tr>
						              </cfloop>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="4" align="center">
								<input type="submit" name="Regenerar" id="Regenerar" value="Regenerar" class="btnGuardar" onclick="return confirm('¿Desea regenerar el complemento de pago?');">
								<input type="button" name="Regresar" id="Regresar" value="Regresar" class="btnLimpiar" onClick="window.history.go(-1); return false;">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</cfoutput>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>

<cfelse>
	<!--- NO EXISTEN DATOS --->
	<script language="javascript">
		alert('No existe información para el complemento de pago!');
		document.location = 'regeneraCP-list.cfm';
	</script>
</cfif>
