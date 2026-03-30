<!---
	Autor: Eduardo Gonzalez Sarabia
	Fecha: 11/10/2018
	Proceso: Muestra la informaci�n complemento de pago generado.
 --->

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','Cancelaci&oacute;n de Complementos de Pago')>

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

<!-- Querys AFGM-SPR CONTROL DE VERSIONES-->
<cfquery name="rsVersionCFDI" datasource = "#Session.DSN#">
	select Pvalor 
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 	and Pcodigo = '17200'
</cfquery>

<cfset value = "#rsVersionCFDI.Pvalor#">

<cfif #getInfoComplemento.RecordCount# GT 0>
	<cfquery name="getInfoBcoOrdenante" datasource="#session.dsn#">
		SELECT RFC, Bdescripcion
		FROM Bancos
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  AND Bid = <cfqueryparam cfsqltype="cf_sql_integer" value="#getInfoComplemento.BcoOrdenante#">
	</cfquery>

	<!--- Parseo de XML --->
	<cfset xmltimbrado = XmlParse(getInfoComplemento.xmlTimbrado)>
	<cfset vXmlTimbrado = xmltimbrado["cfdi:Comprobante"].XmlAttributes>

	<!--- Obtención de la versión --->
	<cfset versionXml = xmltimbrado["cfdi:Comprobante"].XmlAttributes.Version>

	<!--- VARIABLES XML --->
	<cfif versionXml eq '3.3'>
		<cfset nodeArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"]>
		<cfset pagoAtt = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago10:Pagos"]["pago10:Pago"].XmlAttributes>
	<cfelseif versionXml eq '4.0'>
		<cfset nodeArray = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago20:Pagos"]["pago20:Pago"]>
		<cfset pagoAtt = xmltimbrado["cfdi:Comprobante"]["cfdi:Complemento"]["pago20:Pagos"]["pago20:Pago"].XmlAttributes>
	</cfif>

	<cf_templateheader title="#LB_Titulo#">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
			<form action="CancelarCP-sql.cfm" method="post" name="form1">
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
								#getInfoBcoOrdenante.RFC#
							</td>
							<td><strong>N&uacute;m. Cuenta Ordenante:</strong>&nbsp;</td>
							<td>
								#getInfoComplemento.CtaOrdenante#
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
						                <td align="center"><strong>Tipo de cambio</strong></td>
						                <td align="center"><strong>Parcialidad</strong></td>
						                <td align="center"><strong>Saldo anterior</strong></td>
						                <td align="center"><strong>Importe pagado</strong></td>
						                <td align="center"><strong>Saldo insoluto</strong></td>
						            </tr>
									
									<cfif trim(vXmlTimbrado.Version) eq '3.3'>
										<cfset varArrayLen = #ArrayLen(nodearray.XmlChildren)#>
									<cfelseif trim(vXmlTimbrado.Version) eq '4.0'>
										<cfset varArrayLen = #ArrayLen(nodearray.XmlChildren)# - 1>
									</cfif>
									
							          <cfloop index="i" from = "1" to = #varArrayLen#>
						                <cfset att = nodearray.XmlChildren[i].XmlAttributes>

						                <tr>
						                  <td><cfif isdefined('att.IdDocumento')>#att.IdDocumento#</cfif></td>
						                  <td><cfif isdefined('att.Serie')>#att.Serie#</cfif><cfif isdefined('att.Folio')>#att.Folio#</cfif></td>
						                  <td align="right"><cfif isdefined('att.TipoCambioDR')>#att.TipoCambioDR#<cfelse><cfif isdefined('att.MonedaDR') && att.MonedaDR eq 'MXN'>1.00</cfif></cfif></td>
						                  <td align="center"><cfif isdefined('att.NumParcialidad')>#att.NumParcialidad#</cfif></td>
						                  <td align="right"><cfif isdefined('att.ImpSaldoAnt')>#LSNumberFormat(att.ImpSaldoAnt,',9.00')#</cfif></td>
						                  <td align="right"><cfif isdefined('att.ImpPagado')>#LSNumberFormat(att.ImpPagado,',9.00')#</cfif></td>
						                  <td align="right"><cfif isdefined('att.ImpSaldoInsoluto')>#LSNumberFormat(att.ImpSaldoInsoluto,',9.00')#</cfif></td>
						              </tr>
						              </cfloop>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="4" align="center">
								<input type="submit" name="CancelarFC" id="CancelarFC" value="Cancelar por Doc. Incorrecto" class="btnEliminar" onclick="return confirm('\u00BFDesea cancelar el complemento de pago\n por aplicaci\u00F3n de documentos incorrecta?');">
								<input type="submit" name="CancelarMB" id="CancelarMB" value="Cancelar por Mov. Bancario" class="btnEliminar" onclick="return confirm('\u00BFDesea cancelar el complemento de pago\n por error en Movimiento Bancario?');">
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
		alert('No existe informaci\u00F3n para el complemento de pago!');
		document.location = 'CancelarCP-list.cfm';
	</script>
</cfif>
