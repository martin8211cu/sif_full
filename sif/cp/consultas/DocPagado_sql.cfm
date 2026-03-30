<!---
	Eduardo González
	APH - 2017
	Nueva generación del reporte, incluye totales y sepación por monedas.
 --->
<cfif isdefined("url.SNcodigo1") and not isdefined("form.SNcodigo1")>
	<cfset form.SNcodigo1 = url.SNcodigo1>
</cfif>

<cfif isdefined("url.SNcodigo2") and not isdefined("form.SNcodigo2")>
	<cfset form.SNcodigo2 = url.SNcodigo2>
</cfif>

<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>

<cfif isdefined("url.chk_DocSaldo") and not isdefined("form.chk_DocSaldo")>
	<cfset form.chk_DocSaldo = url.chk_DocSaldo>
</cfif>

<cfif isdefined("url.cboMoneda") and not isdefined("form.cboMoneda")>
	<cfset form.cboMoneda = url.cboMoneda>
</cfif>

<cfif isDefined("form.cboTransaccion") AND #form.cboTransaccion# NEQ -1>
	<cfset form.cboTransaccion = form.cboTransaccion>
</cfif>

<cfif isDefined("form.SNcodigo1") AND TRIM(form.SNcodigo1) NEQ "">
	<cfquery name="rsGetSN1" datasource="#session.DSN#">
		SELECT TOP 1 CONCAT(COALESCE(SNnumero,''),' - ',COALESCE(SNnombre,'')) AS nombreSocio
		FROM SNegocios
		WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#">
		  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfif isDefined("form.SNcodigo2") AND TRIM(form.SNcodigo2) NEQ "">
	<cfquery name="rsGetSN2" datasource="#session.DSN#">
		SELECT TOP 1 CONCAT(COALESCE(SNnumero,''),' - ',COALESCE(SNnombre,'')) AS nombreSocio
		FROM SNegocios
		WHERE SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo2#">
		  AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfquery name="rsProc" datasource="#session.DSN#">
	SELECT 
		CASE
			WHEN b.CPTtipo = 'D' THEN (sum(he.Dtotal)*-1)
			ELSE sum(he.Dtotal)
		END AS MontoOrigen,
		CASE
			WHEN b.CPTtipo = 'D' THEN (sum(he.Dtotal * he.Dtipocambio)*-1)
			ELSE sum(he.Dtotal * he.Dtipocambio)
		END AS MontoLocal,
		min(he.Dtipocambio) AS TC,
		m.Mcodigo AS Mcodigo,
		min(m.Mnombre) AS Mnombre,
		s.SNcodigo AS SNcodigo,
		min(s.SNnombre) AS SNnombre,
		SUBSTRING (min(s.SNnumero), 1, 9) AS SNnumero,
		min(s.SNidentificacion) AS SNidentificacion,
		he.IDdocumento AS IDdocumento,
		he.Ddocumento AS Recibo,
		he.CPTcodigo AS CPTcodigo,
		min(he.Ecodigo) AS Ecodigo,
		he.Dfecha AS Fecha,
		he.Dfechavenc AS FechaVenc,
		min(he.EDusuario) EDusuario,
		min(o.Oficodigo) AS Oficina,
		(coalesce(
					(SELECT min(ee.Cconcepto)
					FROM HEContables ee
					WHERE ee.IDcontable = bm.IDcontable),
					(SELECT min(e.Cconcepto)
					FROM EContables e
					WHERE e.IDcontable = bm.IDcontable))) AS Lote,
		(coalesce(
					(SELECT min(h.Edocumento)
					FROM HEContables h
					WHERE h.IDcontable = bm.IDcontable ),
					(SELECT min(bb.Edocumento)
					FROM EContables bb
					WHERE bb.IDcontable = bm.IDcontable ))) AS Asiento,
		CASE WHEN b.CPTtipo = 'D' THEN (min(coalesce(ed.EDsaldo, 0.00))*-1)
			ELSE min(coalesce(ed.EDsaldo, 0.00))
		END AS EDsaldo,
		min(COALESCE (ds.direccion1, ds.direccion2, 'N/A')) AS direccion,
		b.CPTcodigo,
		b.CPTtipo
	FROM HEDocumentosCP he
	INNER JOIN SNegocios s ON s.SNcodigo = he.SNcodigo
	AND s.Ecodigo = he.Ecodigo
	LEFT OUTER JOIN SNDirecciones sd
	INNER JOIN DireccionesSIF ds ON ds.id_direccion = sd.id_direccion ON sd.id_direccion = he.id_direccion
	AND sd.SNid = s.SNid
	INNER JOIN Monedas m ON m.Mcodigo = he.Mcodigo
	INNER JOIN Oficinas o ON o.Ecodigo = he.Ecodigo
	AND o.Ocodigo = he.Ocodigo
	LEFT OUTER JOIN BMovimientosCxP bm ON bm.SNcodigo = he.SNcodigo
	AND bm.Ddocumento = he.Ddocumento
	AND bm.CPTcodigo = he.CPTcodigo
	AND bm.Ecodigo = he.Ecodigo
	AND bm.CPTRcodigo = he.CPTcodigo
	AND bm.DRdocumento = he.Ddocumento
	INNER JOIN CPTransacciones b ON b.Ecodigo = he.Ecodigo
	AND b.CPTcodigo =he.CPTcodigo
	<cfif isdefined("form.chk_DocSaldo")>
		INNER
	<cfelse>
		LEFT OUTER
	</cfif>
	JOIN EDocumentosCP ed ON ed.IDdocumento = he.IDdocumento
	WHERE he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.Documento") and trim(form.DOcumento) neq "">
		and he.Ddocumento like '%#trim(form.documento)#%'
	</cfif>
	<cfif isdefined("form.FechaI") and trim(form.FechaI) neq "">
		and he.Dfecha >= #lsparsedatetime(form.FechaI)#
	</cfif>
	<cfif isdefined("form.FechaF") and trim(form.FechaF) neq "">
		and he.Dfecha <= #lsparsedatetime(form.FechaF)#
	</cfif>
	<cfif isdefined("form.FechaV") and trim(form.FechaV) neq "">
		AND he.Dfechavenc <= #lsparsedatetime(form.FechaV)#
	</cfif>
	<cfif isDefined("form.SNcodigo1") AND TRIM(form.SNcodigo1) NEQ "" AND isDefined("form.SNcodigo2") AND TRIM(form.SNcodigo2) NEQ "">
		AND he.SNcodigo BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo2#">
	<cfelseif isDefined("form.SNcodigo1") AND TRIM(form.SNcodigo1) NEQ "">
		AND he.SNcodigo >=  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#">
	<cfelseif isDefined("form.SNcodigo2") AND TRIM(form.SNcodigo2) NEQ "">
		AND he.SNcodigo <=  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo2#">
	</cfif>
	<cfif isDefined("form.cboMoneda") AND #form.cboMoneda# NEQ -1>
	AND m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboMoneda#">
	</cfif>
	<cfif isdefined("form.chk_DocSaldo")>
		AND ed.EDsaldo >  0
	</cfif>
	<cfif isDefined("form.cboTransaccion") AND #form.cboTransaccion# NEQ -1>
		AND b.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboTransaccion#">
	</cfif>
	GROUP BY m.Mcodigo,
	         s.SNcodigo,
	         he.IDdocumento,
	         he.Ddocumento,
	         he.CPTcodigo,
	         he.Dfecha,
	         he.Dfechavenc,
	         bm.IDcontable,
			 s.SNnombre,
			 b.CPTcodigo,
			 b.CPTtipo
	ORDER BY min(o.Oficodigo), s.SNnombre, he.Dfechavenc
</cfquery>


<!--- PROVEEDORES EN PESOS --->
<cfquery name="getProvPesos" dbtype="query">
	SELECT * FROM rsProc
	WHERE rsProc.Mcodigo = 1
</cfquery>
<!--- PROVEEDORES EN MONEDA EXTRANJERA --->
<cfquery name="getProvMonExt" dbtype="query">
	SELECT * FROM rsProc
	WHERE rsProc.Mcodigo > 1
</cfquery>

<cfif isdefined("rsProc") and rsProc.recordcount gt 0>
	<!--- TAGS --->
	<cf_importLibs>
	<cf_htmlreportsheaders title="Saldo de documentos por Socio" filename="Saldo_documentos_por_Socio.xls" ira="DocPagado_form.cfm">

	<!--- VARIABLES --->
	<cfset varColorTDEnc = "##A7ADAC">
	<cfset varColorMOD = "##E8F8F5">
	<cfset varStyleTDEnc = "font-weight: bold; font-size: 105%;padding-left: 5px;padding-right: 5px;">
	<cfset varContColor = 1>

	<cfoutput>
		<!--- TABLA ENCABEZADOS --->
		<table  width="100%" cellpadding="5" align="center" border="0">
			<tr>
				<td style="padding-left: 25px;" width="25%" rowspan="7" colspan="2"><img border='0' src="/cfmx/home/public/logo_empresa.cfm?id=#session.Ecodigo#" width="175px" height="100px" style='cursor:pointer;'></td>
				<td width="50%" colspan="2">&nbsp;</td>
				<td width="25%" colspan="2" style="font-size: 70%;" align="right">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" colspan="2" align="center" style="font-size: 120%;">&nbsp;<strong><i>#session.enombre#</i></strong></td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" colspan="2" align="center"><strong>Saldo de documentos por Socio</strong></td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<cfif isDefined("rsGetSN1") AND #rsGetSN1.RecordCount# GT 0>
					<td width="50%" colspan="2" align="center"><strong>&nbsp;SOCIO INICIAL:</strong>&nbsp;#rsGetSN1.nombreSocio#&nbsp;</td>
					<td width="25%" colspan="2">&nbsp;</td>
				<cfelse>
					<td colspan="4">&nbsp;</td>
				</cfif>
			</tr>
			<tr>
				<cfif isDefined("rsGetSN2") AND #rsGetSN2.RecordCount# GT 0>
					<td width="50%" colspan="2" align="center"><strong>&nbsp;SOCIO FINAL:</strong>&nbsp;#rsGetSN2.nombreSocio#&nbsp;</td>
					<td width="25%" colspan="2">&nbsp;</td>
				<cfelse>
					<td colspan="4">&nbsp;</td>
				</cfif>
			</tr>
			<tr>
				<td width="50%" colspan="2" align="center">&nbsp;
					<cfif isdefined("form.FechaI") AND  #form.FechaI# NEQ "">
						<strong>FECHA DESDE:&nbsp;</strong>#form.FechaI# &nbsp;
					</cfif>
					<cfif isdefined("form.FechaF") AND  #form.FechaF# NEQ "">
						<strong>FECHA HASTA:&nbsp;</strong>#form.FechaF# &nbsp;
					</cfif>
					<cfif isdefined("form.FechaV") AND  #form.FechaV# NEQ "">
						<strong>FECHA VENCIMIENTO:&nbsp;</strong>#form.FechaV#
					</cfif>
				</td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
		</table>
		<cfset varContNum = 1>
		<!--- TABLA CONTENIDO REPORTE --->
		<table  width="99%" cellpadding="5" align="center" border="0">
			<tr>
				<td align="left" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">RFC</td>
				<td align="left" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Nombre del Socio de Negocio</td>
				<td align="left" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Documento</td>
				<td align="left" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Oficina</td>
				<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Tipo</td>
				<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Fecha<br>documento</td>
				<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Fecha<br>vencimiento</td>
				<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">TC</td>
				<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Monto Origen</td>
				<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Monto Local</td>
				<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Saldo</td>
			</tr>
			<!--- LINEAS DETALLE --->
			<cfset varStyleTdLinea = "padding-left: 3px; padding-right: 3px; font-size: 90%;">
			<cfset varStyleTdLineaEnc = "padding-left: 4px; padding-right: 3px; font-size: 120%;">
			<cfset varStyleTdLineaTotMoneda = "padding-left: 4px; padding-right: 3px; font-size: 105%;">
			<cfset varsizeFont = 1>
			<cfset varSNnombre = "">
			<cfset varSNid = "">
			<!--- DIVISION POR MONEDA --->
			<cfif #getProvPesos.RecordCount# GT 0>
				<tr><td style="#varStyleTdLineaEnc#" bgcolor="##DEE7E5" colspan="11" align="left"><strong>MONEDA: #getProvPesos.Mnombre#</strong></td></tr>
			</cfif>
			<!--- LINEAS PESOS --->
			<cfloop query="#getProvPesos#">
				<cfset varContColor = varContColor + 1>
				<tr <cfif varContColor MOD 2>bgcolor="#varColorMOD#"</cfif>>
					<cfset varSNnombre = #getProvPesos.SNnombre#>
					<cfset varSNid = #getProvPesos.SNidentificacion#>
					<td style="#varStyleTdLinea#" align="left">#varSNid#</td>
					<td style="#varStyleTdLinea#" align="left">#varSNnombre#</td>
					<td style="#varStyleTdLinea#" align="left">#getProvPesos.Recibo#</td>
					<td style="#varStyleTdLinea#" align="left">#getProvPesos.Oficina#</td>
					<td style="#varStyleTdLinea#" align="center">#getProvPesos.CPTcodigo#</td>
					<td style="#varStyleTdLinea#" align="center">#DateFormat(getProvPesos.Fecha, "dd/mm/yyyy")#</td>
					<td style="#varStyleTdLinea#" align="center">#DateFormat(getProvPesos.FechaVenc, "dd/mm/yyyy")#</td>
					<td style="#varStyleTdLinea#" align="center">&nbsp;</td>
					<td style="#varStyleTdLinea#" align="right">#LSNumberFormat(getProvPesos.MontoOrigen,',9.00')#</td>
					<td style="#varStyleTdLinea#" align="right">#LSNumberFormat(getProvPesos.MontoLocal,',9.00')#</td>
					<td style="#varStyleTdLinea#" align="right">#LSNumberFormat(getProvPesos.EDsaldo,',9.00')#</td>
				</tr>
				<!--- TOTAL POR PROVEEDOR (PESOS) --->
				<cfif varSNid NEQ getProvPesos.SNidentificacion[CurrentRow+1]>
					<cfquery name="getTotales" dbtype="query">
						SELECT SUM(MontoOrigen) AS totalMO,
						SUM(MontoLocal) AS totalML,
						SUM(EDsaldo) AS totalMS
						FROM getProvPesos
						WHERE SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varSNid#">
					</cfquery>
					<cfif #getTotales.recordcount# GT 0>
						<cfset varContColor = varContColor + 1>
						<tr <cfif varContColor MOD 2>bgcolor="#varColorMOD#"</cfif>>
							<td style="#varStyleTdLinea#" colspan="8" align="right"><strong>Total:&nbsp;</strong></td>
							<td style="#varStyleTdLinea#" align="right"><strong>#LSNumberFormat(getTotales.totalMO,',9.00')#</strong></td>
							<td style="#varStyleTdLinea#" align="right"><strong>#LSNumberFormat(getTotales.totalML,',9.00')#</strong></td>
							<td style="#varStyleTdLinea#" align="right"><strong>#LSNumberFormat(getTotales.totalMS,',9.00')#</strong></td>
						</tr>
					</cfif>
				</cfif>
				<!--- TOTAL POR MONEDA (PESOS) --->
				<cfif getProvPesos.RecordCount EQ getProvPesos.CurrentRow>
					<cfquery name="getTotales" dbtype="query">
						SELECT SUM(MontoOrigen) AS totalMOF,
						SUM(MontoLocal) AS totalMLF,
						SUM(EDsaldo) AS totalMSF
						FROM getProvPesos
					</cfquery>
					<cfif #getTotales.recordcount# GT 0>
						<cfset varContColor = varContColor + 1>
						<tr <cfif varContColor MOD 2>bgcolor="#varColorMOD#"</cfif>>
							<td style="#varStyleTdLineaTotMoneda#" colspan="8" align="right"><strong>Total por Moneda (#getProvPesos.Mnombre#):&nbsp;</strong></td>
							<td style="#varStyleTdLineaTotMoneda#" align="right"><strong>#LSNumberFormat(getTotales.totalMOF,',9.00')#</strong></td>
							<td style="#varStyleTdLineaTotMoneda#" align="right"><strong>#LSNumberFormat(getTotales.totalMLF,',9.00')#</strong></td>
							<td style="#varStyleTdLineaTotMoneda#" align="right"><strong>#LSNumberFormat(getTotales.totalMSF,',9.00')#</strong></td>
						</tr>
						<tr><td colspan="10">&nbsp;</td></tr>
					</cfif>
				</cfif>
			</cfloop>
			<!--- DIVISION POR MONEDA --->
			<cfif #getProvMonExt.RecordCount# GT 0>
				<tr><td style="#varStyleTdLineaEnc#" bgcolor="##DEE7E5" colspan="11" align="left"><strong>MONEDA: #getProvMonExt.Mnombre#</strong></td></tr>
				<cfloop query="#getProvMonExt#">
					<cfset varContColor = varContColor + 1>
					<tr <cfif varContColor MOD 2>bgcolor="#varColorMOD#"</cfif>>
						<cfset varSNnombre = #getProvMonExt.SNnombre#>
						<cfset varSNid = #getProvMonExt.SNidentificacion#>
						<td style="#varStyleTdLinea#" align="left">&nbsp;#varSNid#</td>
						<td style="#varStyleTdLinea#" align="left">&nbsp;#varSNnombre#</td>
						<td style="#varStyleTdLinea#" align="left">&nbsp;#getProvMonExt.Recibo#</td>
						<td style="#varStyleTdLinea#" align="left">&nbsp;#getProvMonExt.Oficina#</td>
					    <td style="#varStyleTdLinea#" align="center">#getProvPesos.CPTcodigo#</td>
						<td style="#varStyleTdLinea#" align="center">&nbsp;#DateFormat(getProvMonExt.Fecha, "dd/mm/yyyy")#</td>
						<td style="#varStyleTdLinea#" align="center">&nbsp;#DateFormat(getProvMonExt.FechaVenc, "dd/mm/yyyy")#</td>
						<td style="#varStyleTdLinea#" align="center">&nbsp;#getProvMonExt.TC#</td>
						<td style="#varStyleTdLinea#" align="right">#LSNumberFormat(getProvMonExt.MontoOrigen,',9.00')#</td>
						<td style="#varStyleTdLinea#" align="right">#LSNumberFormat(getProvMonExt.MontoLocal,',9.00')#</td>
						<td style="#varStyleTdLinea#" align="right">#LSNumberFormat(getProvMonExt.EDsaldo,',9.00')#</td>
					</tr>
					<!--- TOTAL POR PROVEEDOR (MONEDA EXTRANJERA) --->
					<cfif varSNid NEQ getProvMonExt.SNidentificacion[CurrentRow+1]>
						<cfquery name="getTotales" dbtype="query">
							SELECT SUM(MontoOrigen) AS totalMO,
							SUM(MontoLocal) AS totalML,
							SUM(EDsaldo) AS totalMS
							FROM getProvMonExt
							WHERE SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varSNid#">
						</cfquery>
						<cfif #getTotales.recordcount# GT 0>
							<cfset varContColor = varContColor + 1>
							<tr <cfif varContColor MOD 2>bgcolor="#varColorMOD#"</cfif>>
								<td style="#varStyleTdLinea#" colspan="8" align="right"><strong>Total:&nbsp;</strong></td>
								<td style="#varStyleTdLinea#" align="right"><strong>#LSNumberFormat(getTotales.totalMO,',9.00')#</strong></td>
								<td style="#varStyleTdLinea#" align="right"><strong>#LSNumberFormat(getTotales.totalML,',9.00')#</strong></td>
								<td style="#varStyleTdLinea#" align="right"><strong>#LSNumberFormat(getTotales.totalMS,',9.00')#</strong></td>
							</tr>
						</cfif>
					</cfif>
					<!--- TOTAL POR MONEDA (MONEDA EXTRANJERA) --->
					<cfif getProvMonExt.RecordCount EQ getProvMonExt.CurrentRow>
						<cfquery name="getTotales" dbtype="query">
							SELECT SUM(MontoOrigen) AS totalMOF,
							SUM(MontoLocal) AS totalMLF,
							SUM(EDsaldo) AS totalMSF
							FROM getProvMonExt
						</cfquery>
						<cfif #getTotales.recordcount# GT 0>
							<cfset varContColor = varContColor + 1>
							<tr <cfif varContColor MOD 2>bgcolor="#varColorMOD#"</cfif>>
								<td style="#varStyleTdLineaTotMoneda#" colspan="8" align="right"><strong>Total por Moneda (#getProvMonExt.Mnombre#):&nbsp;</strong></td>
								<td style="#varStyleTdLineaTotMoneda#" align="right"><strong>#LSNumberFormat(getTotales.totalMOF,',9.00')#</strong></td>
								<td style="#varStyleTdLineaTotMoneda#" align="right"><strong>#LSNumberFormat(getTotales.totalMLF,',9.00')#</strong></td>
								<td style="#varStyleTdLineaTotMoneda#" align="right"><strong>#LSNumberFormat(getTotales.totalMSF,',9.00')#</strong></td>
							</tr>
							<tr><td colspan="10">&nbsp;</td></tr>
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</table>
	</cfoutput>
<cfelse>
	<!--- EN CASO DE NO OBTENER REGISTROS, SE ENVIA ALERTA Y SE REGRESA A LA PAG. PRINCIPAL --->
	<script language="javascript">
		alert('No existe información para generar el reporte');
		document.location = 'DocPagado_form.cfm';
	</script>
</cfif>
