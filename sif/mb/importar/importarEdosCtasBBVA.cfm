<!--- <cf_dumptable var="#table_name#"> --->
<cfset lVarContinue = true>
<cfquery name="rsConsulta" datasource="#session.DSN#">
	select *
	from ECuentaBancaria
	where ECid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
</cfquery>

<cfif rsConsulta.recordcount EQ 0>
	<cfset lVarContinue = false>
	<cfquery name="ERR" datasource="#session.DSN#">
		select TOP 1 'N/A' as Documento, 'No existe encabezado para el Estado de Cuenta.' as Error, 'Encabezado' as Tipo, 'N/A' as Columna
		from #table_name#
	</cfquery>
</cfif>
<cfif rsConsulta.recordcount GT 0>
	<cfquery name="rsConsultaBanco" datasource="#session.DSN#">
		SELECT TOP 1 Bdescripcion
		FROM Bancos
		WHERE Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
	</cfquery>
</cfif>


<!--- Obtención de Transacciones para crédito y débito --->
<cfquery name="rsGetTranDebito" datasource="#session.DSN#">
	SELECT TOP 1 Bid,
	       RTRIM(LTRIM(COALESCE(BTEcodigo,''))) AS BTEcodigo,
	       BTEdescripcion,
	       BTEtipo,
	       BMUsucodigo
	FROM TransaccionesBanco
	WHERE BTEtipo = 'C'
	AND Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
</cfquery>

<cfif rsGetTranDebito.recordcount EQ 0>
	<cfset lVarContinue = false>
	<cfquery name="ERR" datasource="#session.DSN#">
		select TOP 1 'N/A' as Documento, 'No existe la Transacci&oacute;n de tipo D&eacute;bito, para el banco #rsConsultaBanco.Bdescripcion#.' as Error, 'Encabezado' as Tipo, 'N/A' as Columna
		from #table_name#
	</cfquery>
</cfif>

<cfquery name="rsGetTranCredito" datasource="#session.DSN#">
	SELECT TOP 1 Bid,
	       RTRIM(LTRIM(COALESCE(BTEcodigo,''))) AS BTEcodigo,
	       BTEdescripcion,
	       BTEtipo,
	       BMUsucodigo
	FROM TransaccionesBanco
	WHERE BTEtipo = 'D'
	AND Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsConsulta.Bid#">
</cfquery>

<cfif rsGetTranCredito.recordcount EQ 0>
	<cfset lVarContinue = false>
	<cfquery name="ERR" datasource="#session.DSN#">
		select TOP 1 'N/A' as Documento, 'No existe la Transacci&oacute;n de tipo Cr&eacute;dito, para el banco #rsConsultaBanco.Bdescripcion#.' as Error, 'Encabezado' as Tipo, 'N/A' as Columna
		from #table_name#
	</cfquery>
</cfif>

<cfquery name="rsValidaMontosCargo" datasource="#session.DSN#">
	SELECT COUNT(1) AS Cargos
	from #table_name#
	WHERE Cargo < 0
	AND Cargo <> ''
</cfquery>

<cfif rsValidaMontosCargo.recordcount GT 0 AND rsValidaMontosCargo.Cargos GT 0>
	<cfset lVarContinue = false>
	<cfquery name="ERR" datasource="#session.DSN#">
		select RTRIM(LTRIM(COALESCE(Concepto,''))) as Documento, 'El monto del cargo, debe ser superior a 0.00.' as Error, 'L&iacute;nea' as Tipo, '5' as Columna
		from #table_name#
		WHERE Cargo < 0
		AND Cargo <> ''
	</cfquery>
</cfif>

<cfquery name="rsValidaMontosAbono" datasource="#session.DSN#">
	SELECT COUNT(1) AS Abonos
	from #table_name#
	WHERE Abono < 0
	AND Abono <> ''
</cfquery>

<cfif rsValidaMontosAbono.recordcount GT 0 AND rsValidaMontosAbono.Abonos GT 0>
	<cfset lVarContinue = false>
	<cfquery name="ERR" datasource="#session.DSN#">
		select RTRIM(LTRIM(COALESCE(Concepto,''))) as Documento, 'El monto del abono, debe ser superior a 0.00.' as Error, 'L&iacute;nea' as Tipo, '6' as Columna
		from #table_name#
		WHERE Abono < 0
		AND Abono <> ''
	</cfquery>
</cfif>
<!---
<cfquery name="ERR" datasource="#session.DSN#">
	select RTRIM(LTRIM(COALESCE(Concepto,''))) as Documento, 'El documento no esta dentro del rango de fechas del Estado de Cuenta' as Error, 'L&iacute;nea' as Tipo, '1' as Columna
	from #table_name#
	where CONVERT(date, (RTRIM(LTRIM(COALESCE(FechaOperacion,'')))), 103) > <cfqueryparam cfsqltype="cf_sql_date" value="#rsConsulta.EChasta#">
</cfquery> --->

<cfif lVarContinue EQ true>
	<cftransaction>
		<cfquery name="rsInsertDCuentaBancaria" datasource="#session.DSN#">
			insert into DCuentaBancaria (ECid,
										 BTEcodigo,
										 Documento,
										 DCfecha,
										 DCmontoori,
										 DCmontoloc,
										 DCReferencia,
										 DCtipocambio,
										 DCtipo,
										 DCconciliado,
										 Ecodigo,
		                                 Bid)
			SELECT <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">,
			CASE
				WHEN a.Cargo > 0 THEN <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsGetTranDebito.BTEcodigo#">
				WHEN a.Abono > 0 THEN <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsGetTranCredito.BTEcodigo#">
			END AS BTEcodigo,
			SUBSTRING(RTRIM(LTRIM(COALESCE(a.Concepto,''))), 1, 20) AS Documento,
			CONVERT(date, (RTRIM(LTRIM(COALESCE(a.FechaOperacion,'')))), 103) AS DCfecha,
			CASE
				WHEN a.Cargo > 0 THEN a.Cargo
				WHEN a.Abono > 0 THEN a.Abono
			END AS DCmontoori,
			CASE
				WHEN a.Cargo > 0 THEN a.Cargo
				WHEN a.Abono > 0 THEN a.Abono
			END AS DCmontoloc,
			RTRIM(LTRIM(COALESCE(a.Referencia,''))) AS DCReferencia,
			1 AS DCtipocambio,
			CASE
				WHEN a.Cargo > 0 THEN <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsGetTranDebito.BTEtipo#">
				WHEN a.Abono > 0 THEN <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsGetTranCredito.BTEtipo#">
			END AS BTEtipo,
			'N',
			#session.Ecodigo#,
		    #rsConsulta.Bid#
			FROM #table_name# a
		</cfquery>

		<!--- ACTUALIZACION DE SALDOS --->
		<cfquery name="rsUpEstadoCta" datasource="#session.DSN#">
			update ECuentaBancaria
			set ECsaldofin = ECsaldoini + coalesce((select sum(DCmontoori * case when DCtipo = 'D' then 1 else -1 end)
								from DCuentaBancaria
								where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00),
				ECdebitos = coalesce((select sum(case when DCtipo = 'D' then DCmontoori else 0 end)
								from DCuentaBancaria
								where ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00),
				ECcreditos = coalesce((select sum(case when DCtipo = 'C' then DCmontoori else 0 end)
								from DCuentaBancaria
								where ECid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">),0.00)

			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.ImportarECuenta.ECid#">
		</cfquery>
	</cftransaction>
</cfif>
