<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("form.SNcodigo") AND #form.SNcodigo# NEQ "">
	<cfset form.SNcodigo = #form.SNcodigo#>
	<cfquery name="rsGetSN" datasource="#session.dsn#">
		SELECT CONCAT(COALESCE(SNnumero, ''), ' - ', COALESCE(SNnombre, '')) AS Socio
		FROM SNegocios
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfquery>
</cfif>
<cfif isdefined("form.cboBanco") AND #form.cboBanco# NEQ -1>
	<cfset form.cboBanco = #form.cboBanco#>
</cfif>
<cfif isdefined("form.cboMoneda") AND #form.cboMoneda# NEQ -1>
	<cfset form.cboMoneda = #form.cboMoneda#>
</cfif>
<cfif isdefined("form.Usucodigo") AND #form.Usucodigo# NEQ "">
	<cfset form.Usucodigo = #form.Usucodigo#>
	<cfquery name="rsGetUser" datasource="#session.dsn#">
		SELECT u.Usucodigo,
		       u.Usulogin ,
		       dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usunombre
		FROM Usuario u
		INNER JOIN DatosPersonales dp ON dp.datos_personales = u.datos_personales
		WHERE Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	</cfquery>
</cfif>

<cfquery name="rsGetInfoReporte" datasource="#session.dsn#">
	SELECT RTRIM(LTRIM(COALESCE(sn.SNnombre, ''))) AS Proveedor,
	       sn.SNcodigo,
	       RTRIM(LTRIM(COALESCE(b.Bdescripcion, ''))) AS BancoProveedor,
	       cb.CBdescripcion as CuentaBanco,
	       b.Bid as IdBancoProveedor,
	       e.TESSPnumero AS SolPago,
	       RTRIM(LTRIM(COALESCE(d.TESDPdocumentoOri, ''))) AS Factura,
	       cp.Dfecha AS FechaDocto,
	       d.TESDPmontoSolicitadoOri AS ImportePago,
	       m.Miso4217 AS DivisaPago,
	       d.TESDPmontoVencimientoOri AS ImporteDocto
	FROM TESdetallePago d
	INNER JOIN TESsolicitudPago e ON e.TESSPid = d.TESSPid
	INNER JOIN SNegocios sn ON sn.SNcodigo = e.SNcodigoOri
	AND sn.Ecodigo = e.EcodigoOri
	INNER JOIN CuentasBancos cb ON cb.CBid = e.CBidPago
	AND cb.Ecodigo = e.EcodigoOri
	INNER JOIN Bancos b ON b.Bid = cb.Bid
	AND b.Ecodigo = e.EcodigoOri
	INNER JOIN Monedas m ON m.Mcodigo = cb.Mcodigo
	AND m.Ecodigo = cb.Ecodigo
	INNER JOIN EDocumentosCP cp ON cp.IDdocumento = d.TESDPidDocumento
	AND cp.Ecodigo = e.EcodigoOri
	WHERE d.TESDPestado = 0 <!--- En Preparación --->
	  AND e.EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.SNcodigo") AND #form.SNcodigo# NEQ "">
		AND sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
	</cfif>
	<cfif isdefined("form.cboBanco") AND #form.cboBanco# NEQ -1>
		AND b.Bid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboBanco#">
	</cfif>
	<cfif isdefined("form.cboMoneda") AND #form.cboMoneda# NEQ -1>
		AND m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboMoneda#">
	</cfif>
	<cfif len(trim(form.Usucodigo))>
		AND e.UsucodigoSolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	</cfif>
	  AND e.CBidPago IS NOT NULL
	ORDER BY RTRIM(LTRIM(COALESCE(b.Bdescripcion, ''))), m.Miso4217, RTRIM(LTRIM(COALESCE(sn.SNnombre, ''))), e.TESSPnumero, cp.Dfecha
</cfquery>

<cfset varTitle = "Reporte de Documentos de CxP por Solicitud de Pago">
<cfif rsGetInfoReporte.recordCount GT 0>
	<!--- TAGS --->
	<cf_importLibs>
	<cf_htmlreportsheaders title="#varTitle#" filename="Reporte_Documentos_CxP_SP.xls" ira="rptDocsCxPSolPago.cfm">
	<cfoutput>
		<cfset varStyleParams = "font-weight: bold; font-size: 90%;padding-left: 5px;padding-right: 5px;">
		<cfset varStyleTitleReport = "font-weight: bold; font-size: 105%;padding-left: 5px;padding-right: 5px;">
		<!--- TABLA ENCABEZADOS --->
		<table  width="100%" cellpadding="5" align="center" border="0">
			<tr>
				<td style="padding-left: 25px;" width="25%" rowspan="6" colspan="2"><img border='0' src="/cfmx/home/public/logo_empresa.cfm?id=#session.Ecodigo#" width="170px" height="100px" style='cursor:pointer;'></td>
				<td width="50%" colspan="2">&nbsp;</td>
				<td width="25%" colspan="2" style="font-size: 70%;" align="right">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" colspan="2" align="center" style="font-size: 120%;">&nbsp;<strong><i>#session.enombre#</i></strong></td>
				<td width="25%" style="font-size: 75%;" align="right" colspan="2">Fecha Generaci&oacute;n:&nbsp;&nbsp;#DateTimeFormat(now(), "dd/mm/yyyy hh:nn:ss tt")#&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td style="#varStyleTitleReport#" width="50%" colspan="2" align="center">#varTitle#</td>
				<td width="25%" style="font-size: 75%;" align="right" colspan="2">
					<cfif isDefined("rsGetUser") and #rsGetUser.RecordCount# GT 0>
						Usuario Solicitante:&nbsp;&nbsp;#rsGetUser.Usunombre#&nbsp;&nbsp;
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			</tr>
			<tr>
				<td style="#varStyleParams#" width="50%" colspan="2" align="center">
					<cfif isDefined("form.SNcodigo") AND TRIM(form.SNcodigo) NEQ "">
						&nbsp;Socio de Negocio:&nbsp;#rsGetSN.Socio#
					<cfelse>
						&nbsp;Todos los Socios de Negocio
					</cfif>
				</td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" style="#varStyleParams#" colspan="2" align="center">&nbsp;
					<cfif isDefined("form.nameBanco") AND TRIM(form.nameBanco) NEQ "">
						&nbsp;Banco:&nbsp;#form.nameBanco#
					<cfelse>
						&nbsp;Todos los bancos
					</cfif>
			    </td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" style="#varStyleParams#" colspan="2" align="center">&nbsp;
					<cfif isDefined("form.nameMoneda") AND TRIM(form.nameMoneda) NEQ "">
						&nbsp;Moneda:&nbsp;#form.nameMoneda#
					<cfelse>
						&nbsp;Todas las monedas
					</cfif>
			    </td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
		</table>

		<cfset varStyleTDEnc = "font-weight: bold; font-size: 110%;padding-left: 5px;padding-right: 5px;">
		<cfset varColorTDEnc = "##A7ADAC">
		<!--- TABLA CONTENIDO REPORTE --->
		<table  width="99%" cellpadding="5" align="center" border="0">
			<!--- LINEAS DETALLE --->
			<cfset varStyleTdLinea = "padding-left: 3px; padding-right: 3px; font-size: 90%;">
			<cfset varStyleTdLineaTotal = "padding-left: 3px; padding-right: 3px; font-size: 90%; font-weight: bold;">
			<cfset varColorMOD = "##E8F8F5">
			<cfset varContColor = 2>
			<cfset varNombreBanco = "">
			<cfset varNombreMoneda = "">
			<cfset varNombreSN = "">
			<cfset varIdSN = "">
			<cfloop query="#rsGetInfoReporte#">
				<cfset varNombreSN = rsGetInfoReporte.Proveedor>
				<cfset varIdSN = rsGetInfoReporte.SNcodigo>
				<cfif varNombreBanco NEQ rsGetInfoReporte.BancoProveedor OR varNombreMoneda NEQ rsGetInfoReporte.DivisaPago>
					<cfset varContColor = 2>
					<cfset varNombreBanco = rsGetInfoReporte.BancoProveedor>
					<cfset varNombreMoneda = rsGetInfoReporte.DivisaPago>
					<tr>
						<td colspan="8" style="#varStyleTDEnc#">Banco:&nbsp;#varNombreBanco#</td>
					</tr>
					<tr>
						<td colspan="8" style="#varStyleTDEnc#">Moneda:&nbsp;#rsGetInfoReporte.DivisaPago#</td>
					</tr>
					<tr>
						<td align="left" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Proveedor</td>
						<td align="left" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Cuenta Banco Proveedor</td>
						<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Sol. Pago</td>
						<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Factura</td>
						<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Fecha Docto.</td>
						<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Importe Pago</td>
						<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Divisa Pago</td>
						<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Importe Docto.</td>
					</tr>
				</cfif>
				<cfset varContColor = varContColor + 1>
				<tr <cfif varContColor MOD 2>bgcolor="#varColorMOD#"</cfif>>
					<td style="#varStyleTdLinea#" align="left">&nbsp;#varNombreSN#</td>
					<td style="#varStyleTdLinea#" align="left">&nbsp;#rsGetInfoReporte.CuentaBanco#</td>
					<td style="#varStyleTdLinea#" align="center">&nbsp;#rsGetInfoReporte.SolPago#</td>
					<td style="#varStyleTdLinea#" align="center">&nbsp;#rsGetInfoReporte.Factura#</td>
					<td style="#varStyleTdLinea#" align="center">&nbsp;#DateFormat(rsGetInfoReporte.FechaDocto, "dd/mm/yyyy")#</td>
					<td style="#varStyleTdLinea#" align="right">#LSNumberFormat(rsGetInfoReporte.ImportePago,',9.00')#</td>
					<td style="#varStyleTdLinea#" align="center">&nbsp;#rsGetInfoReporte.DivisaPago#</td>
					<td style="#varStyleTdLinea#" align="right">#LSNumberFormat(rsGetInfoReporte.ImporteDocto,',9.00')#</td>
				</tr>
				<!--- TOTAL POR PROVEEDOR --->
				<cfif varIdSN NEQ rsGetInfoReporte.SNcodigo[CurrentRow+1]>
					<cfquery name="getTotalesPorSN" dbtype="query">
						SELECT SUM(ImportePago) AS TotalPagadoSN,
						       SUM(ImporteDocto) AS TotalDoctoSN
						FROM rsGetInfoReporte
						WHERE IdBancoProveedor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetInfoReporte.IdBancoProveedor#">
						AND DivisaPago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetInfoReporte.DivisaPago#">
						AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetInfoReporte.SNcodigo#">
					</cfquery>
					<tr>
						<td colspan="5" style="#varStyleTdLineaTotal#" align="right">Total Proveedor:&nbsp;</td>
						<td style="#varStyleTdLineaTotal#" align="right">#LSNumberFormat(getTotalesPorSN.TotalPagadoSN,',9.00')#</td>
						<td style="#varStyleTdLineaTotal#" align="right">&nbsp;</td>
						<td style="#varStyleTdLineaTotal#" align="right">#LSNumberFormat(getTotalesPorSN.TotalDoctoSN,',9.00')#</td>
					</tr>
				</cfif>

				<!--- TOTAL POR BANCO --->
				<cfif varNombreBanco NEQ rsGetInfoReporte.BancoProveedor[CurrentRow+1] OR varNombreMoneda NEQ rsGetInfoReporte.DivisaPago[CurrentRow+1]>
					<cfquery name="getTotalesPorBanco" dbtype="query">
						SELECT SUM(ImportePago) AS TotalPagado,
						       SUM(ImporteDocto) AS TotalDocto
						FROM rsGetInfoReporte
						WHERE IdBancoProveedor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetInfoReporte.IdBancoProveedor#">
						AND DivisaPago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGetInfoReporte.DivisaPago#">
					</cfquery>
					<tr>
						<td colspan="5" style="#varStyleTdLineaTotal#" align="right">Total Banco:&nbsp;</td>
						<td style="#varStyleTdLineaTotal#" align="right">#LSNumberFormat(getTotalesPorBanco.TotalPagado,',9.00')#</td>
						<td style="#varStyleTdLineaTotal#" align="right">&nbsp;</td>
						<td style="#varStyleTdLineaTotal#" align="right">#LSNumberFormat(getTotalesPorBanco.TotalDocto,',9.00')#</td>
					</tr>
					<tr>
						<td colspan="8">&nbsp;</td>
					</tr>
				</cfif>
			</cfloop>
		</table>
	</cfoutput>
<cfelse>
	<!--- EN CASO DE NO OBTENER REGISTROS, SE ENVIA ALERTA Y SE REGRESA A LA PAG. PRINCIPAL --->
	<script language="javascript">
		alert('No existe información para generar el reporte');
		document.location = 'rptDocsCxPSolPago.cfm';
	</script>
</cfif>