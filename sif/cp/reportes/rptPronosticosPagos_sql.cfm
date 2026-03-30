<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">

<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','rptPronosticosPagos.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','rptPronosticosPagos.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','rptPronosticosPagos.xml')>
<cfset LB_FechaVencimiento = t.Translate('LB_FechaVencimiento','Fecha Vencimiento','rptPronosticosPagos.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','rptPronosticosPagos.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','rptPronosticosPagos.xml')>
<cfset varSNinicial = "">
<cfset varSNfinal = "">
<cfset varMonedaFiltro = "">
<cfset lVarTipoSem = 1> <!--- Configurables --->

<!--- SEMANA ACTUAL --->
<cfset lVarSemanaActual = WEEK(NOW())>

<!--- Asignacion de rango de semanas --->
<cfset lVarSinicio = 1>
<cfset lVarSfin = 54>
<cfif isdefined("form.chkSemNat") AND #form.chkSemNat# EQ 1>
	<cfset lVarSfin = WEEK(CreateDate(YEAR(NOW()), 12, 31))>
</cfif>
<cfif isdefined("form.cboSInicial") AND #form.cboSInicial# NEQ -1>
	<cfset lVarSinicio = #form.cboSInicial#>
</cfif>
<cfif isdefined("form.cboSFinal") AND #form.cboSFinal# NEQ -1>
	<cfset lVarSfin = #form.cboSFinal#>
</cfif>

<cfif isdefined("form.cboTransaccion") AND TRIM(form.cboTransaccion) NEQ -1>
	<cfquery name="rsTransaccionInfo" datasource="#session.DSN#">
		SELECT RTRIM(LTRIM(COALESCE(CPTdescripcion, ''))) AS CPTdescripcion
		FROM CPTransacciones
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  AND CPTtipo = 'C'
		  AND CPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboTransaccion#">
		ORDER BY CPTcodigo
	</cfquery>
	<cfif rsTransaccionInfo.RecordCount GT 0>
		<cfset lVarTransaccion = #rsTransaccionInfo.CPTdescripcion#>
	</cfif>
</cfif>

<cfif isdefined("form.cboMoneda") AND #form.cboMoneda# NEQ -1>
	<cfquery name="rsGetMonedaF" datasource="#session.dsn#">
		SELECT Mnombre
		FROM Monedas
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  AND Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboMoneda#">
	</cfquery>
	<cfif #rsGetMonedaF.RecordCount# GT 0>
		<cfset varMonedaFiltro = #rsGetMonedaF.Mnombre#>
	</cfif>
</cfif>

<cfif isdefined("form.SNcodigo1") AND TRIM(form.SNcodigo1) NEQ "">
	<cfquery name="rsGetInfoSNini" datasource="#session.dsn#">
		SELECT CONCAT(RTRIM(LTRIM(SNidentificacion)), ' - ', RTRIM(LTRIM(SNnombre))) AS nombreSN
		FROM SNegocios
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#">
	</cfquery>
	<cfif #rsGetInfoSNini.RecordCount# GT 0>
		<cfset varSNinicial = #rsGetInfoSNini.nombreSN#>
	</cfif>
</cfif>

<cfif isdefined("form.SNcodigo2") AND TRIM(form.SNcodigo2) NEQ "">
	<cfquery name="rsGetInfoSNfin" datasource="#session.dsn#">
		SELECT CONCAT(RTRIM(LTRIM(SNidentificacion)), ' - ', RTRIM(LTRIM(SNnombre))) AS nombreSN
		FROM SNegocios
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  AND SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo2#">
	</cfquery>
	<cfif #rsGetInfoSNfin.RecordCount# GT 0>
		<cfset varSNfinal = #rsGetInfoSNfin.nombreSN#>
	</cfif>
</cfif>
<!--- GET INFO PRONOSTICOS --->
<cfquery name="rsGetInfoPronosticos" datasource="#session.dsn#">
	SELECT sn.SNcodigo,
	       sn.SNnombre,
	       DATEPART(YEAR, a.Dfechavenc) AS anio,
	       a.Dfechavenc,
           <cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
			   <cfif isdefined("form.chkSemNat") AND #form.chkSemNat# EQ 1>
					CASE WHEN DATEPART(WEEK, a.Dfechavenc) < #lVarSinicio# THEN SUM(a.EDsaldo)
			   <cfelse>
			   	   CASE
			       WHEN a.Dfechavenc BETWEEN spr.FechaInicio AND spr.FechaFin AND
				      spr.Anio = DATEPART(YEAR, a.Dfechavenc) AND
				      spr.NoSemana < #lVarSinicio# THEN SUM(a.EDsaldo)
			   </cfif>
		   		ELSE 0
		   END AS SaldoResumido,
		   </cfif>
	       <cfif isdefined("form.chkSemNat") AND #form.chkSemNat# EQ 1>
		       <cfset lVarTipoSem = 2> <!--- Naturales --->
		       <!--- SEMANAS NATURALES DE SQL --->
		       <cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
					CASE WHEN DATEPART(WEEK, a.Dfechavenc) = #i# THEN SUM(a.EDsaldo) ELSE 0 END AS Sem#i#,
			   </cfloop>
		   <cfelse>
		   	   <!--- SEMANAS CONFIGURADAS POR USUARIO --->
		   	   <cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
					CASE WHEN a.Dfechavenc BETWEEN spr.FechaInicio AND spr.FechaFin AND spr.Anio = DATEPART(YEAR, a.Dfechavenc) AND spr.NoSemana = #i# THEN SUM(a.EDsaldo) ELSE 0  END AS Sem#i#,
			   </cfloop>
		   </cfif>
		   m.Mcodigo,
		   m.Mnombre
	FROM EDocumentosCP a
	INNER JOIN SNegocios sn ON a.SNcodigo = sn.SNcodigo
	AND a.Ecodigo = sn.Ecodigo
	INNER JOIN CPTransacciones ct ON ct.CPTcodigo = a.CPTcodigo
	AND ct.Ecodigo = a.Ecodigo
	INNER JOIN Monedas m ON m.Mcodigo = a.Mcodigo
	AND m.Ecodigo = a.Ecodigo
	INNER JOIN Oficinas o ON o.Ocodigo = a.Ocodigo
	AND o.Ecodigo = a.Ecodigo
	<cfif not isdefined("form.chkSemNat")>
		INNER JOIN CPSemanaPronostico spr ON spr.Ecodigo = a.Ecodigo
	</cfif>
	WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  AND ct.CPTtipo = 'C'
	  AND a.EDsaldo > 0
	<cfif isdefined("form.cboTransaccion") AND TRIM(form.cboTransaccion) NEQ -1>
	  	AND ct.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboTransaccion#">
	</cfif>
	<cfif isdefined("form.SNcodigo1") AND TRIM(form.SNcodigo1) NEQ "">
		AND sn.SNcodigo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo1#">
	</cfif>
	<cfif isdefined("form.SNcodigo2") AND TRIM(form.SNcodigo2) NEQ "">
		AND sn.SNcodigo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo2#">
	</cfif>
	<cfif isdefined("form.cboMoneda") AND #form.cboMoneda# NEQ -1>
		AND m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboMoneda#">
	</cfif>
	<cfif isdefined("form.cboPeriodo") AND #form.cboPeriodo# NEQ -1>
		AND DATEPART(YEAR, a.Dfechavenc) = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboPeriodo#">
	</cfif>
	GROUP BY sn.SNcodigo,
		     sn.SNnombre,
	         a.Dfechavenc,
			 m.Mcodigo,
			 m.Mnombre
			 <cfif not isdefined("form.chkSemNat")>
				 ,spr.FechaInicio
				 ,spr.FechaFin
				 ,spr.Anio
				 ,spr.NoSemana
			 </cfif>
	ORDER BY DATEPART(YEAR, a.Dfechavenc),
	         m.Mcodigo,
	         sn.SNnombre ASC
</cfquery><!---
<cfdump var="#rsGetInfoPronosticos#"> --->
<!--- Agrupación por SN, Anio --->
<cfquery name="rsGetInfoPronosticos" dbtype="query">
	SELECT SNcodigo, SNnombre, anio, Mcodigo, Mnombre
	       <cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
		       ,SUM(Sem#i#) AS Sem#i#
		   </cfloop>
		   <cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
		       ,SUM(SaldoResumido) AS SaldoResumido
		   </cfif>
	FROM rsGetInfoPronosticos
	GROUP BY SNcodigo, SNnombre, anio, Mcodigo, Mnombre
	ORDER BY anio, Mcodigo, SNnombre
</cfquery>
<!--- Se quitan SOCIOS con montos vacios --->
<cfquery name="rsGetInfoPronosticos" dbtype="query">
	SELECT SNcodigo, SNnombre, anio, Mcodigo,
	       <cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
		       SaldoResumido,
		   </cfif>
	       <cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
		       Sem#i#,
		   </cfloop>
		   Mnombre
	FROM rsGetInfoPronosticos
	WHERE (
			<cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
		       Sem#i#<cfif #i# LT #lVarSfin#>+</cfif>
		   </cfloop>
	) > 0
	<cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
	  or SaldoResumido > 0
	</cfif>
	GROUP BY SNcodigo, SNnombre, anio, Mcodigo,
	       <cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
		       SaldoResumido,
		   </cfif>
		   <cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
		       Sem#i#,
		   </cfloop>
		   Mnombre
	ORDER BY anio, Mcodigo, SNnombre
</cfquery>

<cfif isdefined("rsGetInfoPronosticos") and rsGetInfoPronosticos.recordcount gt 0>
	<cfoutput>
		<!--- TAGS --->
		<cf_importLibs>
		<cf_htmlreportsheaders title="Pron&oacute;stico de Pagos" filename="RptPronosticoPago_#DateTimeFormat(now(), "dd-mm-yyyy_hh:nn:ss")#.xls" ira="rptPronosticosPagos_form.cfm">

		<!--- VARIABLES --->
		<cfset varColorTDEnc = "##A7ADAC">
		<cfset varColorMOD = "##E8F8F5">
		<cfset varStyleTDEnc = "font-weight: bold; font-size: 105%;padding-left: 5px;padding-right: 5px;">
		<cfset varContColor = 1>
		<cfset varStyleTdLineaEnc = "padding-left: 4px; padding-right: 3px; font-size: 120%;">

		<!--- TABLA ENCABEZADOS --->
		<table  width="100%" cellpadding="5" align="center" border="0">
			<tr>
				<td style="padding-left: 25px;" width="25%" rowspan="5" colspan="2"><img border='0' src="/cfmx/home/public/logo_empresa.cfm?id=#session.Ecodigo#" width="180px" height="110px" style='cursor:pointer;'></td>
				<td width="50%" colspan="2">&nbsp;</td>
				<td width="25%" colspan="2" style="font-size: 70%;" align="right">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" colspan="2" align="center" style="font-size: 120%;">&nbsp;<strong><i>#session.enombre#</i></strong></td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" colspan="2" align="center"><strong> - Pron&oacute;stico de Pagos - </strong></td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" colspan="2" align="center">
					<cfset varTodosSN = false>
					<cfif isdefined("form.SNcodigo1") AND TRIM(form.SNcodigo1) NEQ "">
						<strong>Socio Inicial:&nbsp;</strong>#varSNinicial#
						<cfset varTodosSN = true>
					</cfif>
					<cfif isdefined("form.SNcodigo2") AND TRIM(form.SNcodigo2) NEQ "">
						<br><strong>&nbsp;Socio Final:&nbsp;</strong>#varSNfinal#
						<cfset varTodosSN = true>
					</cfif>
					<cfif varTodosSN EQ false>
						<strong>&nbsp;Socio Negocio
							:&nbsp;</strong>Todos
					</cfif>
					<cfif isdefined("form.cboTransaccion") AND TRIM(form.cboTransaccion) NEQ -1>
						<br><strong>&nbsp;Transacci&oacute;n:&nbsp;</strong>#lVarTransaccion#
					</cfif>
					</td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td width="50%" colspan="2" align="center">
					<cfif isdefined("form.cboMoneda") AND TRIM(form.cboMoneda) NEQ -1>
						<strong>Moneda:&nbsp;</strong>#varMonedaFiltro#&nbsp;&nbsp;
					<cfelse>
						<strong>Moneda:&nbsp;</strong>Todas
					</cfif>
					<cfif isdefined("form.cboPeriodo") AND #form.cboPeriodo# NEQ -1>
						<br><strong>Periodo:&nbsp;</strong>#form.cboPeriodo#&nbsp;&nbsp;
					<cfelse>
						<br><strong>Periodo:&nbsp;</strong>Todos
					</cfif>
					<cfif isdefined("form.chkSemNat") AND #form.chkSemNat# EQ 1>
						<br><strong>Tipo de semanas:&nbsp;</strong>Naturales
					<cfelse>
						<br><strong>Tipo de semanas:&nbsp;</strong>Configurables
					</cfif>

					<cfif isdefined("form.cboSInicial") AND #form.cboSInicial# EQ -1 AND isdefined("form.cboSFinal") AND #form.cboSFinal# EQ -1>
						<br><strong>Rango de semanas:&nbsp;</strong>Todas
					</cfif>
					<cfif isdefined("form.cboSInicial") AND #form.cboSInicial# NEQ -1>
						<br><strong>Semana Inicial:&nbsp;</strong>#form.cboSInicial#&nbsp;&nbsp;
					</cfif>
					<cfif isdefined("form.cboSFinal") AND #form.cboSFinal# NEQ -1>
						<strong>Semana Final:&nbsp;</strong>#form.cboSFinal#
					</cfif>
					<cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
						<br><strong>Res&uacute;men Saldos Vencidos:&nbsp;</strong>SI&nbsp;&nbsp;
					</cfif>
				</td>
				<td width="25%" colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
		</table>

		<!--- LINEAS DETALLE --->
		<cfset varStyleTdLinea = "padding-left: 3px; padding-right: 3px; font-size: 90%;">
		<cfset varStyleTdLineaTotales = "padding-left: 3px; padding-right: 3px; font-size: 100%;">

		<!--- TABLA CONTENIDO REPORTE --->
		<div align="center" style="width:100%; height:90%; overflow:auto;">
			<table  width="98%" cellpadding="5" align="center" border="0">
				<cfsavecontent variable="strTHead"><!--- JARR encabezado --->
				<tr>
					<td align="left" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Nombre del Socio de Negocio</td>
					<cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
						<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Saldo Vencido</td>
				    </cfif>
					<cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
						<td align="center" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">S#i#</td>
					</cfloop>
					<td align="right" style="#varStyleTDEnc#" bgcolor="#varColorTDEnc#">Total General</td>
				</tr>
				</cfsavecontent>
				<cfoutput>#strTHead#</cfoutput>
				<cfset varSNnombre = "">
				<cfset varSNcodigo = "">
				<cfset varMoneda = "">
				<cfset varAnio = "">

				<cfset varCorte = false>

				<!--- Creacion de variables para saldos verticales --->
				<cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
					<cfset variables["varTotalGral#i#"] = 0>
				</cfloop>
				<cfset varTotalGralFinal = 0>
				<cfset varTotalResumido = 0>

				<cfloop query="#rsGetInfoPronosticos#">
					<cfset varContColor = varContColor + 1>
					<cfset varSNnombre = #rsGetInfoPronosticos.SNnombre#>
					<cfset varSNcodigo = #rsGetInfoPronosticos.SNcodigo#>

					<cfif varAnio NEQ rsGetInfoPronosticos.anio>
						<cfset varAnio = #rsGetInfoPronosticos.anio#>
						<cfset varMoneda = "">
						<tr><td style="#varStyleTdLineaEnc#" bgcolor="##DEE7E5" colspan="56" align="left"><strong>PERIODO: #varAnio#</strong></td></tr>
					</cfif>

					<cfif varMoneda NEQ rsGetInfoPronosticos.Mnombre>
						<cfset varCorte = true>
						<cfset varMoneda = #rsGetInfoPronosticos.Mnombre#>
						<tr><td style="#varStyleTdLineaEnc#" bgcolor="##DEE7E5" colspan="56" align="left"><strong>MONEDA: #varMoneda#</strong></td></tr>

						<!--- ES CAMBIO DE MONEDA, SE REINICIAN TOTALES --->
						<cfset varTotalGralFinal = 0>
						<cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
							<cfset variables["varTotalGral#i#"] = 0>
						</cfloop>
						<cfset varTotalResumido = 0>
					</cfif>
					<cfif isdefined("form.chkDetalle") AND #form.chkDetalle# EQ 1>
						<cfoutput>#strTHead#</cfoutput>
					</cfif>

					<tr <cfif varContColor MOD 2>bgcolor="#varColorMOD#"</cfif>>
						<td nowrap style="#varStyleTdLinea#" align="left">#varSNnombre#</td>

						<cfset varTotalGral = 0>

						<cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
							<td nowrap align="right" <cfif rsGetInfoPronosticos.SaldoResumido GT 0>style="#varStyleTdLinea#;cursor: pointer;" title="Detalle"  onclick="return openPopupResumido('#varSNcodigo#', '#rsGetInfoPronosticos.Mcodigo#', '#varAnio#', '#form.cboTransaccion#', 'Res');"<cfelse>style="#varStyleTdLinea#"</cfif>>
                            	<cfif rsGetInfoPronosticos.SaldoResumido GT 0>
									#LSNumberFormat(rsGetInfoPronosticos.SaldoResumido,',9.00')#
								<cfelse>
									&nbsp;
								</cfif>
                            </td>
							<cfset varTotalResumido = varTotalResumido + rsGetInfoPronosticos.SaldoResumido>
							<!--- Se agrega el monto resumido al total Horizontal --->
							<cfset varTotalGral = varTotalGral + rsGetInfoPronosticos.SaldoResumido>
					    </cfif>
						<cfset varSem = "Sem">
						<cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
							<cfset varSem = "Sem"&#i#>
							<cfset varSaldoOk = 0>

							<cfloop list="#ArrayToList(rsGetInfoPronosticos.getColumnNames())#" index="col">
								<cfset varSaldo = #rsGetInfoPronosticos[col][currentrow]#>
								<cfif col EQ varSem AND varSaldo GT 0>
									<cfset varSaldoOk = varSaldo>
									<cfset varTotalGral = varTotalGral + varSaldo>
									<cfset variables["varTotalGral#i#"] = #variables["varTotalGral#i#"]# + varSaldo>
								</cfif>
					        </cfloop>
							<td nowrap align="right" <cfif varSaldoOk GT 0>style="#varStyleTdLinea#;cursor: pointer;" title="Detalle"  onclick="return openPopup('#i#', '#varSNcodigo#', '#rsGetInfoPronosticos.Mcodigo#', '#varAnio#', '#form.cboTransaccion#');"<cfelse>style="#varStyleTdLinea#"</cfif>>
								<cfif varSaldoOk GT 0>#LSNumberFormat(varSaldoOk,',9.00')#</cfif>
							</td>
						</cfloop>

						<!--- Total General Horizontal --->
						<td nowrap style="#varStyleTdLineaTotales#" align="right"><strong>#LSNumberFormat(varTotalGral,',9.00')#</strong></td>

						<cfset varTotalGralFinal = varTotalGralFinal + varTotalGral>
					</tr>

					<!--- Con check de detalle --->
                    <cfif isdefined("form.chkDetalle") AND #form.chkDetalle# EQ 1>
					<tr>
						<td colspan="8">
							<cfquery name="rsGetInfoDocs" datasource="#Session.DSN#">
								SELECT a.IDdocumento,
								       a.CPTcodigo AS Transaccion,
								       a.Ddocumento AS Documento,
								       a.Dfecha AS Fecha,
								       a.Dfechavenc AS FechaVencimiento,
								       a.Dtotal AS Monto,
								       a.EDsaldo AS Saldo
								FROM EDocumentosCP a
								INNER JOIN SNegocios sn ON a.SNcodigo = sn.SNcodigo
								AND a.Ecodigo = sn.Ecodigo
								INNER JOIN CPTransacciones ct ON ct.CPTcodigo = a.CPTcodigo
								AND ct.Ecodigo = a.Ecodigo
								INNER JOIN Monedas m ON m.Mcodigo = a.Mcodigo
								AND m.Ecodigo = a.Ecodigo
								INNER JOIN Oficinas o ON o.Ocodigo = a.Ocodigo
								AND o.Ecodigo = a.Ecodigo
								<cfif isDefined("lVarTipoSem") AND #lVarTipoSem# EQ 1>
									<!--- Semanas configurables --->
									INNER JOIN CPSemanaPronostico spr ON spr.Ecodigo = a.Ecodigo
								</cfif>
								WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
								  AND ct.CPTtipo = 'C'
								  AND a.EDsaldo > 0
								  <cfif isDefined("varAnio") AND #varAnio# NEQ "">
									  AND DATEPART(YEAR, a.Dfechavenc) = <cfqueryparam cfsqltype="cf_sql_integer" value="#varAnio#">
								  </cfif>
								  <cfif isDefined("lVarTipoSem") AND #lVarTipoSem# EQ 1>
										  AND a.Dfechavenc BETWEEN spr.FechaInicio AND spr.FechaFin AND spr.Anio = DATEPART(YEAR, a.Dfechavenc) AND spr.NoSemana < <cfqueryparam cfsqltype="cf_sql_integer" value="#lVarSfin#">
								  <cfelse>
										  AND DATEPART(WEEK, a.Dfechavenc) < <cfqueryparam cfsqltype="cf_sql_integer" value="#lVarSfin#">
								  </cfif>
								  AND sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varSNcodigo#">
							</cfquery>

							<cfif rsGetInfoDocs.RecordCount GT 0>
								<table align="center" width="97%" border="0" style="font-family:arial;font-size:14px;" cellspacing="0" cellpadding="0">
									<tr class="encabReporte">
										<td align="center"><strong>#LB_Transaccion#</strong></td>
										<td align="center"><strong>#LB_Documento#</strong></td>
										<td align="center"><strong>#LB_Fecha#</strong></td>
										<td align="center"><strong>#LB_FechaVencimiento#</strong></td>
										<td align="center"><strong>#LB_Monto#</strong></td>
										<td align="center"><strong>#LB_Saldo#</strong></td>
									</tr>
									<!--- Info de Facturas --->
									<cfloop query="rsGetInfoDocs">
										<tr <cfif #rsGetInfoDocs.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
											<td align="center">#Transaccion#</td>
											<td align="center" >#Documento#</td>
											<td align="center">#DateFormat(Fecha,'dd/mm/yyyy')#</td>
											<td align="center">#DateFormat(FechaVencimiento,'dd/mm/yyyy')#</td>
											<td align="right">#LSNumberFormat(Monto,',9.00')#</td>
											<td align="right">#LSNumberFormat(Saldo,',9.00')#</td>
										</tr>
									</cfloop>
								</table>
							</cfif><!--- Reccordcount --->
						<td>
					</tr>
					</cfif>

					<cfif varMoneda NEQ rsGetInfoPronosticos.Mnombre[CurrentRow+1] OR varAnio NEQ rsGetInfoPronosticos.anio[CurrentRow+1]>
						<tr>
							<td nowrap style="#varStyleTdLineaTotales#" align="right"><strong>Total:&nbsp;</strong></td>
							<cfif isdefined("form.chkSalRes") AND #form.chkSalRes# EQ 1>
								<!--- Total para los montos resumidos Vertical --->
								<td nowrap align="right" style="#varStyleTdLineaTotales#"><strong>#LSNumberFormat(varTotalResumido,',9.00')#</strong></td>
							</cfif>
							<cfloop from="#lVarSinicio#" to="#lVarSfin#" index="i" step="1">
								<cfset varTempMontoSem = #variables["varTotalGral#i#"]#>
								<td nowrap align="right" style="#varStyleTdLineaTotales#" ><strong>#LSNumberFormat(varTempMontoSem,',9.00')#</strong></td>
							</cfloop>
							<td nowrap align="right" style="#varStyleTdLineaTotales#"><strong>#LSNumberFormat(varTotalGralFinal,',9.00')#</strong></td>
						</tr>
					</cfif>
				</cfloop>
				<tr><td colspan="55">&nbsp;</td></tr>
			</table>
		</div>
	</cfoutput>
<cfelse>
	<!--- EN CASO DE NO OBTENER REGISTROS, SE ENVIA ALERTA Y SE REGRESA A LA PAG. PRINCIPAL --->
	<script language="javascript">
		alert('No existe información para generar el reporte!');
		document.location = 'rptPronosticosPagos_form.cfm';
	</script>
</cfif>



<script language="javascript1.2" type="text/javascript">
	<!--- Abre popup por semana... --->
	function openPopup(semana, socio, moneda, periodo, transaccion){
		var popup =
	    window.open("/cfmx/sif/cp/reportes/popupDetalleDocsCxP-pronostico.cfm?Sem="+semana+"&TipoSem=<cfoutput>#lVarTipoSem#</cfoutput>&SN="+socio+"&Moneda="+moneda+"&Periodo="+periodo+"&tipoT="+transaccion, "Detalle Documentos CxP",
	    "location=no,menubar=no,titlebar=yes,resizable=no,toolbar=no,scrollbars=yes, menubar=no,top=85,left=250,width=950,height=550");
		return false;
	}


	function openPopupResumido(socio, moneda, periodo, transaccion, modo){
		var popup =
	    window.open("/cfmx/sif/cp/reportes/popupDetalleDocsCxP-pronostico.cfm?Sem=<cfoutput>#lVarSinicio#</cfoutput>&TipoSem=<cfoutput>#lVarTipoSem#</cfoutput>&SN="+socio+"&Moneda="+moneda+"&Periodo="+periodo+"&tipoT="+transaccion+"&modo="+modo, "Detalle Documentos CxP",
	    "location=no,menubar=no,titlebar=yes,resizable=no,toolbar=no,scrollbars=yes, menubar=no,top=85,left=250,width=950,height=550");
		return false;
	}
</script>